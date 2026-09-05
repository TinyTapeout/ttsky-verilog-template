// ============================================================================
//  test_ntt.cpp  -  STANDALONE verification of the Number Theoretic Transform
// ----------------------------------------------------------------------------
//  This file proves the NTT is *sound* -- i.e. that transform-based polynomial
//  multiplication equals ordinary (schoolbook) negacyclic multiplication in
//  R_q = Z_3329[x]/(x^256 + 1).  It depends ONLY on the NTT stack (params,
//  reduce, ntt) -- no hashing, no sampling -- so the transform is tested in
//  isolation, independently of the rest of the algorithm.  It closes with a
//  small arithmetic-range check that confirms why the code stores coefficients
//  in int16_t and forms products in int32_t.
//
//  BUILD:  g++ -std=c++17 -O2 test_ntt.cpp -o test_ntt
//  RUN:    ./test_ntt
// ============================================================================
#include "params.hpp"
#include "reduce.hpp"
#include "ntt.hpp"
#include <cstdio>
#include <cstdint>
#include <random>
using namespace mlkem;

// ---- A simple, reproducible random polynomial with coefficients in [0, q) ----
static std::mt19937 rng(12345);   // fixed seed -> the test is deterministic
static void rand_poly(int16_t r[KYBER_N]) {
    std::uniform_int_distribution<int> d(0, KYBER_Q - 1);
    for (int i = 0; i < KYBER_N; i++) r[i] = (int16_t)d(rng);
}

// ---- Reference: schoolbook multiplication in R_q (the ground truth) ----------
//  c(x) = a(x)*b(x) mod (x^256 + 1, q).  O(n^2), obviously correct, slow.
//  The wrap x^256 = -1 means terms of degree >= 256 fold back with a minus sign.
static void schoolbook_negacyclic(int16_t c[KYBER_N], const int16_t a[KYBER_N], const int16_t b[KYBER_N]) {
    long long tmp[2 * KYBER_N] = {0};
    for (int i = 0; i < KYBER_N; i++)
        for (int j = 0; j < KYBER_N; j++)
            tmp[i + j] += (long long)a[i] * b[j];          // full product, degree up to 510
    for (int i = 0; i < KYBER_N; i++) {
        long long v = tmp[i] - tmp[i + KYBER_N];           // x^256 = -1  =>  subtract upper half
        v %= KYBER_Q; if (v < 0) v += KYBER_Q;             // canonical [0,q)
        c[i] = (int16_t)v;
    }
}

// ---- The NTT-based multiply (exactly the path poly.hpp/kpke.hpp use) ----------
//  c = InvNTT( basemul( NTT(a), NTT(b) ) ), canonicalized to [0,q).
static void ntt_multiply(int16_t c[KYBER_N], const int16_t a_in[KYBER_N], const int16_t b_in[KYBER_N]) {
    int16_t a[KYBER_N], b[KYBER_N];
    for (int i = 0; i < KYBER_N; i++) { a[i] = a_in[i]; b[i] = b_in[i]; }

    ntt(a);                                    // forward transform a
    for (int i = 0; i < KYBER_N; i++) a[i] = barrett_reduce(a[i]);
    ntt(b);                                    // forward transform b
    for (int i = 0; i < KYBER_N; i++) b[i] = barrett_reduce(b[i]);

    // Pointwise (base-case) multiply over the 128 degree-1 "points".
    for (int i = 0; i < KYBER_N / 4; i++) {
        basemul(&c[4 * i],     &a[4 * i],     &b[4 * i],     zetas[64 + i]);
        basemul(&c[4 * i + 2], &a[4 * i + 2], &b[4 * i + 2], (int16_t)-zetas[64 + i]);
    }
    invntt(c);                                 // inverse transform (folds in 1/128)

    for (int i = 0; i < KYBER_N; i++) {        // canonicalize to [0,q)
        int16_t t = barrett_reduce(c[i]);
        t += (int16_t)(((int16_t)t >> 15) & KYBER_Q);
        c[i] = t;
    }
}

int main() {
    printf("==================================================================\n");
    printf(" STANDALONE NTT SOUNDNESS TEST  (q=%d, n=%d)\n", KYBER_Q, KYBER_N);
    printf("==================================================================\n\n");

    int fails = 0;

    // ----- TEST 1: NTT multiply == schoolbook multiply, over many trials ------
    printf("[Test 1] NTT-based multiply vs. schoolbook negacyclic multiply\n");
    const int TRIALS = 20000;
    int mism = 0;
    for (int t = 0; t < TRIALS; t++) {
        int16_t a[KYBER_N], b[KYBER_N], c_ntt[KYBER_N], c_ref[KYBER_N];
        rand_poly(a); rand_poly(b);
        ntt_multiply(c_ntt, a, b);
        schoolbook_negacyclic(c_ref, a, b);
        for (int i = 0; i < KYBER_N; i++) if (c_ntt[i] != c_ref[i]) { mism++; break; }
    }
    printf("         %d/%d random products matched.  --> %s\n\n",
           TRIALS - mism, TRIALS, mism ? "FAIL" : "PASS");
    fails += (mism != 0);

    // ----- TEST 2: multiplying by the constant polynomial 1 is the identity ---
    printf("[Test 2] a(x) * 1 == a(x)  (round-trip sanity through NTT/basemul/iNTT)\n");
    {
        int16_t a[KYBER_N], one[KYBER_N] = {0}, c[KYBER_N];
        rand_poly(a); one[0] = 1;
        ntt_multiply(c, a, one);
        int bad = 0;
        for (int i = 0; i < KYBER_N; i++) { int16_t ai = a[i] % KYBER_Q; if (ai < 0) ai += KYBER_Q; if (c[i] != ai) bad++; }
        printf("         %d/%d coefficients preserved.  --> %s\n\n",
               KYBER_N - bad, KYBER_N, bad ? "FAIL" : "PASS");
        fails += (bad != 0);
    }

    // ----- TEST 3: a tiny concrete example, printed so you can eyeball it ------
    printf("[Test 3] Concrete example (first few coefficients shown)\n");
    {
        int16_t a[KYBER_N] = {0}, b[KYBER_N] = {0}, c_ntt[KYBER_N], c_ref[KYBER_N];
        a[0]=1; a[1]=2; a[2]=3; a[3]=4;      // a = 1 + 2x + 3x^2 + 4x^3
        b[0]=5; b[1]=6; b[2]=7; b[3]=8;      // b = 5 + 6x + 7x^2 + 8x^3
        ntt_multiply(c_ntt, a, b);
        schoolbook_negacyclic(c_ref, a, b);
        printf("         a = 1 + 2x + 3x^2 + 4x^3\n");
        printf("         b = 5 + 6x + 7x^2 + 8x^3\n");
        printf("         c (NTT)       = [%d, %d, %d, %d, %d, %d, %d]\n",
               c_ntt[0],c_ntt[1],c_ntt[2],c_ntt[3],c_ntt[4],c_ntt[5],c_ntt[6]);
        printf("         c (schoolbook)= [%d, %d, %d, %d, %d, %d, %d]\n",
               c_ref[0],c_ref[1],c_ref[2],c_ref[3],c_ref[4],c_ref[5],c_ref[6]);
        int bad = 0; for (int i=0;i<KYBER_N;i++) if (c_ntt[i]!=c_ref[i]) bad++;
        printf("         --> %s\n\n", bad ? "FAIL" : "PASS");
        fails += (bad != 0);
    }

    // ----- TEST 4: arithmetic ranges the code relies on -----------------------
    //  Pure number-range sanity check (no I/O tricks): it confirms exactly why a
    //  coefficient is stored in int16_t and a product is formed in int32_t.
    printf("[Test 4] Arithmetic ranges used by the code\n");
    {
        int worst_product = (KYBER_Q - 1) * (KYBER_Q - 1);   // largest coeff*coeff
        printf("         a coefficient is in 0..%d  -> needs 12 bits, fits int16_t\n", KYBER_Q - 1);
        printf("         a product is at most %d -> needs 24 bits, fits int32_t\n", worst_product);
        int ok = ((KYBER_Q - 1) < (1 << 12)) && (worst_product < (1 << 24));
        printf("         check (coeff < 2^12 and product < 2^24)  --> %s\n\n", ok ? "PASS" : "FAIL");
        fails += (ok == 0);
    }

    printf("==================================================================\n");
    printf(" NTT TEST RESULT: %s\n", fails ? "FAIL" : "ALL PASS");
    printf("==================================================================\n");
    return fails ? 1 : 0;
}
