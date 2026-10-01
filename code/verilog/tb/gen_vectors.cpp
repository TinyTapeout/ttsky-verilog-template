// ============================================================================
//  gen_vectors.cpp  -  Golden test-vector generator for the Verilog NTT butterfly
// ----------------------------------------------------------------------------
//  Reuses the EXACT C++ reference arithmetic (reduce.hpp / ntt.hpp) from the
//  ml-kem project so the Verilog RTL can be checked bit-for-bit against it.
//
//  It emits three text files (hex, one record per line) consumed by the
//  self-checking Verilog testbench via $fscanf:
//
//    montgomery_vectors.mem :  <a_32>  <r_16>
//         r = montgomery_reduce(a)
//    fqmul_vectors.mem      :  <a_16>  <b_16>  <r_16>
//         r = fqmul(a,b) = montgomery_reduce((int32)a*b)
//    butterfly_vectors.mem  :  <a_16>  <b_16>  <zeta_16>  <aout_16>  <bout_16>
//         t = fqmul(zeta,b);  aout = a+t;  bout = a-t     (Cooley-Tukey butterfly)
//
//  All integers are printed as fixed-width two's-complement hex so the Verilog
//  side can read them straight into a reg and interpret the bits as signed.
//
//  BUILD:  g++ -std=c++17 -O2 gen_vectors.cpp -o gen_vectors
//  RUN:    ./gen_vectors        (writes the three .mem files into ./vectors/)
// ============================================================================
#include "params.hpp"
#include "reduce.hpp"
#include "ntt.hpp"
#include <cstdio>
#include <cstdint>
#include <random>
#include <vector>
using namespace mlkem;

static std::mt19937 rng(0xC0FFEE);

int main() {
    FILE* fm = fopen("vectors/montgomery_vectors.mem", "w");
    FILE* ff = fopen("vectors/fqmul_vectors.mem", "w");
    FILE* fb = fopen("vectors/butterfly_vectors.mem", "w");
    if (!fm || !ff || !fb) { perror("fopen"); return 1; }

    // ---- montgomery_reduce: sweep the full product range |a| < q*2^15 --------
    //  Include the edge cases the reduction must handle, then random products.
    std::vector<int32_t> mont_edge = {
        0, 1, -1, KYBER_Q, -KYBER_Q, 65535, -65536,
        (KYBER_Q - 1) * (KYBER_Q - 1),           // largest coeff*coeff
        -(KYBER_Q - 1) * (KYBER_Q - 1),
        (int32_t)KYBER_Q * 32767, -(int32_t)KYBER_Q * 32768
    };
    for (int32_t a : mont_edge)
        fprintf(fm, "%08x %04x\n", (uint32_t)a, (uint16_t)montgomery_reduce(a));

    // random products in the legal input window (a0*a1 with |a0|,|a1| < q)
    std::uniform_int_distribution<int> dc(-(KYBER_Q - 1), KYBER_Q - 1);
    for (int i = 0; i < 4000; i++) {
        int32_t a = (int32_t)dc(rng) * dc(rng);
        fprintf(fm, "%08x %04x\n", (uint32_t)a, (uint16_t)montgomery_reduce(a));
    }

    // ---- fqmul: two Montgomery-domain coefficients --------------------------
    //  Cover every real twiddle against a range of operands, plus random pairs.
    for (int zi = 0; zi < 128; zi++) {
        int16_t z = zetas[zi];
        for (int b = -(KYBER_Q - 1); b <= (KYBER_Q - 1); b += 149) {
            int16_t r = fqmul(z, (int16_t)b);
            fprintf(ff, "%04x %04x %04x\n",
                    (uint16_t)z, (uint16_t)(int16_t)b, (uint16_t)r);
        }
    }
    for (int i = 0; i < 4000; i++) {
        int16_t a = (int16_t)dc(rng), b = (int16_t)dc(rng);
        fprintf(ff, "%04x %04x %04x\n", (uint16_t)a, (uint16_t)b, (uint16_t)fqmul(a, b));
    }

    // ---- butterfly: t=fqmul(zeta,b); aout=a+t; bout=a-t ----------------------
    //  a,b range over centered coefficient values; every standard twiddle used.
    for (int zi = 0; zi < 128; zi++) {
        int16_t zeta = zetas[zi];
        for (int k = 0; k < 40; k++) {
            int16_t a = (int16_t)dc(rng), b = (int16_t)dc(rng);
            int16_t t = fqmul(zeta, b);
            int16_t aout = (int16_t)(a + t);
            int16_t bout = (int16_t)(a - t);
            fprintf(fb, "%04x %04x %04x %04x %04x\n",
                    (uint16_t)a, (uint16_t)b, (uint16_t)zeta,
                    (uint16_t)aout, (uint16_t)bout);
        }
    }
    // A few explicit edge cases (max positive/negative operands).
    struct { int16_t a, b, z; } edge[] = {
        {0,0,1}, {32767,32767,1}, {-32768,-32768,1},
        {3328,3328,-1044}, {-3328,3328,1493}, {1,-1,17}
    };
    for (auto e : edge) {
        int16_t t = fqmul(e.z, e.b);
        int16_t aout = (int16_t)(e.a + t);
        int16_t bout = (int16_t)(e.a - t);
        fprintf(fb, "%04x %04x %04x %04x %04x\n",
                (uint16_t)e.a, (uint16_t)e.b, (uint16_t)e.z,
                (uint16_t)aout, (uint16_t)bout);
    }

    fclose(fm); fclose(ff); fclose(fb);
    printf("Wrote vectors/montgomery_vectors.mem, fqmul_vectors.mem, butterfly_vectors.mem\n");
    return 0;
}
