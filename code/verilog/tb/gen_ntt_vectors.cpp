// ============================================================================
//  gen_ntt_vectors.cpp  -  Golden vectors for the FULL forward NTT accelerator
// ----------------------------------------------------------------------------
//  Reuses the exact C++ reference ntt() (ntt.hpp) so the ntt_engine RTL can be
//  checked bit-for-bit over complete 256-coefficient transforms.
//
//  Output file  vectors/ntt_poly_vectors.mem :
//        <T>                       number of test polynomials
//        (per test) 256 input coeffs (hex16)  then  256 output coeffs (hex16)
//  where output = ntt(input), matching what the hardware engine must produce.
//
//  BUILD:  g++ -std=c++17 -O2 gen_ntt_vectors.cpp -o gen_ntt_vectors
//  RUN:    ./gen_ntt_vectors
// ============================================================================
#include "params.hpp"
#include "reduce.hpp"
#include "ntt.hpp"
#include <cstdio>
#include <cstdint>
#include <random>
#include <vector>
#include <functional>
using namespace mlkem;

int main() {
    FILE* f = fopen("vectors/ntt_poly_vectors.mem", "w");
    if (!f) { perror("fopen"); return 1; }

    std::mt19937 rng(0xBEEF);
    std::uniform_int_distribution<int> dq(0, KYBER_Q - 1);

    // A mix of structured edge cases and random polynomials.
    std::vector<std::function<void(int16_t*)>> makers = {
        [](int16_t* p){ for (int i=0;i<KYBER_N;i++) p[i]=0; },                 // zero poly
        [](int16_t* p){ for (int i=0;i<KYBER_N;i++) p[i]=0; p[0]=1; },         // impulse
        [](int16_t* p){ for (int i=0;i<KYBER_N;i++) p[i]=(int16_t)(KYBER_Q-1);},// all q-1
        [](int16_t* p){ for (int i=0;i<KYBER_N;i++) p[i]=(int16_t)(i % KYBER_Q);}, // ramp
        [](int16_t* p){ for (int i=0;i<KYBER_N;i++) p[i]=(int16_t)((i&1)?1:-1);},  // alternating
    };
    const int NRAND = 25;
    int T = (int)makers.size() + NRAND;
    fprintf(f, "%d\n", T);

    auto emit = [&](int16_t* in){
        int16_t r[KYBER_N];
        for (int i=0;i<KYBER_N;i++) r[i]=in[i];
        ntt(r);                                   // the reference transform
        for (int i=0;i<KYBER_N;i++) fprintf(f, "%04x\n", (uint16_t)in[i]);
        for (int i=0;i<KYBER_N;i++) fprintf(f, "%04x\n", (uint16_t)r[i]);
    };

    int16_t p[KYBER_N];
    for (auto& mk : makers) { mk(p); emit(p); }
    for (int t=0;t<NRAND;t++){ for (int i=0;i<KYBER_N;i++) p[i]=(int16_t)dq(rng); emit(p); }

    fclose(f);
    printf("Wrote vectors/ntt_poly_vectors.mem with %d full-transform test cases\n", T);
    return 0;
}
