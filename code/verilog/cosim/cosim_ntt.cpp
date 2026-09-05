// ============================================================================
//  cosim_ntt.cpp  -  HW/SW co-design demo: ML-KEM-512 offloading NTT to hardware
// ----------------------------------------------------------------------------
//  This is the software side of the co-design.  It runs the ordinary ML-KEM-512
//  polynomial-multiply pipeline "in sequence from general code", but wherever
//  the algorithm needs a forward NTT it OFFLOADS that step to the Verilog NTT
//  accelerator instead of calling the software ntt().
//
//  The offload primitive ntt_hw():
//      1. writes the 256 coefficients to accel_in.mem
//      2. invokes the hardware (xsim on tb_ntt_accel  ==  "call the FPGA")
//      3. reads the 256 transformed coefficients back from accel_out.mem
//
//  This is exactly the marshal / trigger / read-back a real FPGA driver does
//  over AXI or PCIe -- here the "bus" is a pair of files and the "board" is the
//  cycle-accurate RTL simulation, so the numbers are identical to silicon.
//
//  The demo then checks two things for every test:
//      (a) hardware NTT output  ==  software ntt()   (the accelerator is exact)
//      (b) full product using the HW transform  ==  schoolbook multiply
//          (the algorithm's final answer is unchanged by moving NTT to hardware)
//
//  BUILD:  g++ -std=c++17 -O2 cosim_ntt.cpp -o cosim_ntt
//  RUN:    ./cosim_ntt        (must run from code/verilog/cosim/)
// ============================================================================
#include "params.hpp"
#include "reduce.hpp"
#include "ntt.hpp"
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <random>
using namespace mlkem;

// ---- The hardware offload: replace software ntt() with a call to the RTL -----
static void ntt_hw(int16_t r[KYBER_N]) {
    // 1) marshal operands to the accelerator input file
    FILE* fi = fopen("accel_in.mem", "w");
    if (!fi) { perror("accel_in.mem"); exit(2); }
    for (int i = 0; i < KYBER_N; i++)
        fprintf(fi, "%04x\n", (uint16_t)r[i]);
    fclose(fi);

    // 2) trigger the hardware: run the pre-built xsim snapshot of tb_ntt_accel
    int rc = system("xsim --nolog accel_sim -runall >> accel.log 2>&1");
    if (rc != 0) { fprintf(stderr, "ERROR: accelerator run failed (rc=%d)\n", rc); exit(3); }

    // 3) read the transform back
    FILE* fo = fopen("accel_out.mem", "r");
    if (!fo) { perror("accel_out.mem"); exit(4); }
    for (int i = 0; i < KYBER_N; i++) {
        unsigned v;
        if (fscanf(fo, "%x", &v) != 1) { fprintf(stderr, "short accel_out\n"); exit(5); }
        r[i] = (int16_t)(uint16_t)v;
    }
    fclose(fo);
}

// ---- Ground-truth schoolbook negacyclic multiply in R_q ----------------------
static void schoolbook(int16_t c[KYBER_N], const int16_t a[KYBER_N], const int16_t b[KYBER_N]) {
    long long tmp[2 * KYBER_N] = {0};
    for (int i = 0; i < KYBER_N; i++)
        for (int j = 0; j < KYBER_N; j++)
            tmp[i + j] += (long long)a[i] * b[j];
    for (int i = 0; i < KYBER_N; i++) {
        long long v = tmp[i] - tmp[i + KYBER_N];
        v %= KYBER_Q; if (v < 0) v += KYBER_Q;
        c[i] = (int16_t)v;
    }
}

// ---- NTT-based multiply, but with BOTH forward NTTs done on the accelerator --
static void ntt_multiply_hw(int16_t c[KYBER_N], const int16_t a_in[KYBER_N],
                            const int16_t b_in[KYBER_N], int* hw_exact_fail) {
    int16_t a[KYBER_N], b[KYBER_N];
    for (int i = 0; i < KYBER_N; i++) { a[i] = a_in[i]; b[i] = b_in[i]; }

    // ---- forward NTT of a: OFFLOADED to hardware, and cross-checked in SW ----
    int16_t a_sw[KYBER_N]; for (int i=0;i<KYBER_N;i++) a_sw[i]=a[i]; ntt(a_sw);
    ntt_hw(a);
    for (int i = 0; i < KYBER_N; i++) if (a[i] != a_sw[i]) (*hw_exact_fail)++;
    for (int i = 0; i < KYBER_N; i++) a[i] = barrett_reduce(a[i]);

    // ---- forward NTT of b: OFFLOADED to hardware, and cross-checked in SW ----
    int16_t b_sw[KYBER_N]; for (int i=0;i<KYBER_N;i++) b_sw[i]=b[i]; ntt(b_sw);
    ntt_hw(b);
    for (int i = 0; i < KYBER_N; i++) if (b[i] != b_sw[i]) (*hw_exact_fail)++;
    for (int i = 0; i < KYBER_N; i++) b[i] = barrett_reduce(b[i]);

    // ---- pointwise multiply + inverse NTT stay in software (host side) -------
    for (int i = 0; i < KYBER_N / 4; i++) {
        basemul(&c[4*i],   &a[4*i],   &b[4*i],   zetas[64 + i]);
        basemul(&c[4*i+2], &a[4*i+2], &b[4*i+2], (int16_t)-zetas[64 + i]);
    }
    invntt(c);
    for (int i = 0; i < KYBER_N; i++) {
        int16_t t = barrett_reduce(c[i]);
        t += (int16_t)(((int16_t)t >> 15) & KYBER_Q);
        c[i] = t;
    }
}

int main() {
    printf("======================================================================\n");
    printf(" ML-KEM-512  HW/SW CO-SIMULATION  (K=%d, n=%d, q=%d)\n", KYBER_K, KYBER_N, KYBER_Q);
    printf("   software runs the algorithm; the forward NTT step runs on the RTL\n");
    printf("======================================================================\n\n");

    // fresh accelerator log
    FILE* lg = fopen("accel.log", "w"); if (lg) fclose(lg);

    std::mt19937 rng(2024);
    std::uniform_int_distribution<int> dq(0, KYBER_Q - 1);

    const int TESTS = 4;
    int prod_fail = 0, hw_exact_fail = 0, offloads = 0;

    for (int t = 0; t < TESTS; t++) {
        int16_t a[KYBER_N], b[KYBER_N], c_hw[KYBER_N], c_ref[KYBER_N];
        for (int i = 0; i < KYBER_N; i++) { a[i] = (int16_t)dq(rng); b[i] = (int16_t)dq(rng); }

        printf("[test %d] two forward NTTs on hardware ... ", t);
        fflush(stdout);
        ntt_multiply_hw(c_hw, a, b, &hw_exact_fail);
        offloads += 2;
        schoolbook(c_ref, a, b);

        int bad = 0;
        for (int i = 0; i < KYBER_N; i++) if (c_hw[i] != c_ref[i]) bad++;
        prod_fail += (bad != 0);
        printf("product %s (%d/%d coeffs match)\n",
               bad ? "MISMATCH" : "OK", KYBER_N - bad, KYBER_N);
    }

    printf("\n----------------------------------------------------------------------\n");
    printf(" hardware offloads performed        : %d NTTs\n", offloads);
    printf(" HW NTT == SW ntt() (bit-exact)     : %s\n", hw_exact_fail ? "FAIL" : "PASS");
    printf(" full product == schoolbook multiply: %s\n", prod_fail ? "FAIL" : "PASS");
    printf("----------------------------------------------------------------------\n");
    int fail = (hw_exact_fail != 0) || (prod_fail != 0);
    printf(" CO-SIMULATION RESULT: %s\n", fail ? "FAIL" : "ALL PASS -- output unchanged by moving NTT to hardware");
    printf("======================================================================\n");
    return fail ? 1 : 0;
}
