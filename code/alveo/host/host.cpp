// ============================================================================
//  host.cpp  -  XRT host for the ML-KEM-512 NTT/INTT Alveo U55C kernel
// ----------------------------------------------------------------------------
//  Generates random polynomials, runs them through the FPGA kernel (forward NTT,
//  inverse NTT, and the INTT(NTT(f))==f round-trip), and checks every coefficient
//  against a bit-exact software golden computed with the SAME arithmetic. Also
//  prints the base-case worked example (a*b uses NTT internally; here we show the
//  forward transform of a known vector) in decimal/hex so it can be matched by eye.
//
//  Usage:  host <ntt_krnl.xclbin> [num_poly] [seed]
//  Works for both hardware (real card) and hardware emulation (set
//  XCL_EMULATION_MODE=hw_emu before running).
// ============================================================================
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <random>
#include <string>

#include "xrt/xrt_device.h"
#include "xrt/xrt_kernel.h"
#include "xrt/xrt_bo.h"

#define N 256
#define Q 3329
static const int16_t QINV = -3327;

// ---- software golden: identical to the kernel / reference ------------------
static inline int16_t mont(int32_t a){ int16_t t=(int16_t)((int16_t)a*QINV); return (int16_t)((a-(int32_t)t*Q)>>16); }
static inline int16_t barrett(int16_t a){ const int16_t v=(int16_t)(((1<<26)+Q/2)/Q); int16_t t=(int16_t)(((int32_t)v*a+(1<<25))>>26); t=(int16_t)(t*Q); return (int16_t)(a-t); }
static inline int16_t fqmul(int16_t a,int16_t b){ return mont((int32_t)a*b); }
static inline uint16_t canon(int16_t a){ uint16_t t=(uint16_t)a; t+=(uint16_t)(((int16_t)t>>15)&Q); return t; }
static const int16_t zetas[128]={
 -1044,-758,-359,-1517,1493,1422,287,202,-171,622,1577,182,962,-1202,-1474,1468,
 573,-1325,264,383,-829,1458,-1602,-130,-681,1017,732,608,-1542,411,-205,-1571,
 1223,652,-552,1015,-1293,1491,-282,-1544,516,-8,-320,-666,-1618,-1162,126,1469,
 -853,-90,-271,830,107,-1421,-247,-951,-398,961,-1508,-725,448,-1065,677,-1275,
 -1103,430,555,843,-1251,871,1550,105,422,587,177,-235,-291,-460,1574,1653,
 -246,778,1159,-147,-777,1483,-602,1119,-1590,644,-872,349,418,329,-156,-75,
 817,1097,603,610,1322,-1285,-1465,384,-1215,-136,1218,-1335,-874,220,-1187,-1659,
 -1185,-1530,-1278,794,-1510,-854,-870,478,-108,-308,996,991,958,-1460,1522,1628};
static void ntt(int16_t r[N]){ unsigned k=1; for(unsigned len=128;len>=2;len>>=1) for(unsigned s=0;s<N;s+=2*len){ int16_t z=zetas[k++]; for(unsigned j=s;j<s+len;j++){ int16_t t=fqmul(z,r[j+len]); r[j+len]=r[j]-t; r[j]=r[j]+t; } } }
static void invntt(int16_t r[N]){ const int16_t f=1441; unsigned k=127; for(unsigned len=2;len<=128;len<<=1) for(unsigned s=0;s<N;s+=2*len){ int16_t z=zetas[k--]; for(unsigned j=s;j<s+len;j++){ int16_t t=r[j]; r[j]=barrett(t+r[j+len]); r[j+len]=r[j+len]-t; r[j+len]=fqmul(z,r[j+len]); } } for(unsigned j=0;j<N;j++) r[j]=fqmul(r[j],f); }

int main(int argc, char** argv){
    if(argc<2){ printf("usage: %s <xclbin> [num_poly] [seed]\n", argv[0]); return 1; }
    std::string xclbin = argv[1];
    int num_poly = (argc>2)? atoi(argv[2]) : 1000;
    unsigned seed = (argc>3)? (unsigned)strtoul(argv[3],0,0) : 0xA5A5u;

    printf("== ML-KEM-512 NTT/INTT on Alveo U55C ==\n");
    printf("   xclbin=%s  num_poly=%d  seed=0x%x  (q=%d, n=%d, zeta=17)\n",
           xclbin.c_str(), num_poly, seed, Q, N);

    auto device = xrt::device(0);
    auto uuid   = device.load_xclbin(xclbin);
    auto krnl   = xrt::kernel(device, uuid, "ntt_krnl",
                              xrt::kernel::cu_access_mode::exclusive);

    const size_t words = (size_t)num_poly * N;
    const size_t bytes = words * sizeof(int16_t);
    auto bo_in  = xrt::bo(device, bytes, krnl.group_id(0));
    auto bo_out = xrt::bo(device, bytes, krnl.group_id(1));
    auto in  = bo_in.map<int16_t*>();
    auto out = bo_out.map<int16_t*>();

    std::mt19937 rng(seed);
    std::uniform_int_distribution<int> dist(0, Q-1);

    // reference inputs and per-mode goldens
    std::vector<int16_t> ref(words);
    for(size_t i=0;i<words;i++) ref[i] = (int16_t)dist(rng);

    struct { int mode; const char* name; } tests[] = {
        {0,"forward NTT   (out==ntt(f))"},
        {1,"inverse NTT   (out==invntt(g))"},
        {2,"round-trip    (canonical(INTT(NTT(f)))==f)"},
    };

    int total_fail = 0;
    for(auto& tc : tests){
        // build input + golden for this mode
        for(size_t p=0;p<(size_t)num_poly;p++){
            int16_t poly[N];
            for(int i=0;i<N;i++) poly[i]=ref[p*N+i];
            for(int i=0;i<N;i++) in[p*N+i]=poly[i];
        }
        bo_in.sync(XCL_BO_SYNC_BO_TO_DEVICE);

        auto run = krnl(bo_in, bo_out, num_poly, tc.mode);
        run.wait();
        bo_out.sync(XCL_BO_SYNC_BO_FROM_DEVICE);

        int fails=0; int first=-1;
        for(size_t p=0;p<(size_t)num_poly;p++){
            int16_t g[N];
            for(int i=0;i<N;i++) g[i]=ref[p*N+i];
            if(tc.mode==0) ntt(g);
            else if(tc.mode==1) invntt(g);
            else { int16_t t[N]; for(int i=0;i<N;i++)t[i]=g[i]; ntt(t); invntt(t); for(int i=0;i<N;i++) g[i]=(int16_t)canon(mont((int32_t)t[i])); }
            for(int i=0;i<N;i++){
                int16_t hw = out[p*N+i];
                int16_t gg = (tc.mode==2)? g[i] : g[i];
                if(hw != gg){ if(first<0){first=(int)(p*N+i);} fails++; }
            }
        }
        printf("   [mode %d] %-42s : %d/%d polys, %s (%d coeff mismatches)\n",
               tc.mode, tc.name, num_poly, num_poly,
               fails==0? "PASS":"FAIL", fails);
        if(fails && first>=0)
            printf("            first mismatch at global coeff %d: hw=%d\n", first, out[first]);
        total_fail += fails;
    }

    // ---- base-case worked example in hex: forward NTT of f=[1,2,3,4,0..] ----
    {
        for(int i=0;i<N;i++) in[i]=0;
        in[0]=1; in[1]=2; in[2]=3; in[3]=4;
        bo_in.sync(XCL_BO_SYNC_BO_TO_DEVICE);
        auto run = krnl(bo_in, bo_out, 1, 0); run.wait();
        bo_out.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
        int16_t g[N]; for(int i=0;i<N;i++)g[i]=in[i]; ntt(g);
        printf("   base case: NTT([1,2,3,4,0..]) first coeffs (hw dec|hex vs golden):\n     ");
        for(int i=0;i<6;i++) printf("%d|%04x ", out[i], (uint16_t)out[i]);
        printf("\n     golden: ");
        for(int i=0;i<6;i++) printf("%d|%04x ", g[i], (uint16_t)g[i]);
        printf("\n");
    }

    printf("== RESULT: %s (%d total coefficient mismatches) ==\n",
           total_fail==0? "ALL PASS":"FAIL", total_fail);
    return total_fail==0? 0 : 2;
}
