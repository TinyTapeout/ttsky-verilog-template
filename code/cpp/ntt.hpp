// ============================================================================
//  ntt.hpp  -  The Number Theoretic Transform for ML-KEM  (THE core building block)
// ----------------------------------------------------------------------------
//  WHY THIS EXISTS
//  Multiplying two polynomials in R_q = Z_3329[x]/(x^256 + 1) naively costs
//  256*256 = 65536 coefficient multiplies.  The NTT turns that convolution into
//  cheap coefficient-wise multiplication, cutting the cost to O(n log n).  Since
//  ML-KEM spends most of its time on polynomial multiplication (especially in
//  encapsulation), the NTT is the fundamental building block of the algorithm.
//
//  ML-KEM'S "INCOMPLETE" NTT
//  A full negacyclic NTT of size 256 would need a primitive 512th root of unity
//  mod 3329, which does NOT exist (512 does not divide q-1 = 3328 = 2^8 * 13).
//  So ML-KEM stops one layer early: it runs 7 layers (log2(256) - 1) and leaves
//  the data as 128 *degree-1 polynomials* instead of 256 scalars.  That is why
//  "pointwise" multiplication here (basemul) multiplies pairs (a0+a1*x), not
//  single numbers.  Equivalent picture: x^256+1 factors mod q into 128 quadratics
//  x^2 - zeta^(2*brv(i)+1), and the NTT is the Chinese-Remainder map onto them.
//
//  DATA FORMAT
//  We use the standard ML-KEM (pq-crystals) layout: coefficients are kept in the
//  Montgomery domain, and the twiddle-factor table `zetas` is precomputed in
//  Montgomery form AND in bit-reversed order, so the transform is a simple
//  in-place sequence of butterflies with no separate reordering pass.
//
//  ONE OPERATION, REUSED
//  The whole transform is built from ONE operation: the butterfly
//        t = zeta * b ;  b' = a - t ;  a' = a + t   (all mod q)
//  i.e. one modular multiply and one modular add/subtract.  The forward NTT, the
//  inverse NTT, and the base multiply are all just this butterfly, sequenced in
//  different orders -- which is why the algorithm is so compact.
// ============================================================================
#pragma once
#include "params.hpp"
#include "reduce.hpp"

namespace mlkem {

// ---- Twiddle factors ("zetas") ----------------------------------------------
//  zetas[i] = zeta^(brv(i)) * 2^16  mod q, reduced to a signed 16-bit value,
//  where zeta = 17 is the primitive 256th root of unity used by ML-KEM and
//  brv(i) is the 7-bit reversal of i.  These 128 constants are exactly the ones
//  fixed by the standard and precomputed once into the constant table below.
static const int16_t zetas[128] = {
    -1044,  -758,  -359, -1517,  1493,  1422,   287,   202,
     -171,   622,  1577,   182,   962, -1202, -1474,  1468,
      573, -1325,   264,   383,  -829,  1458, -1602,  -130,
     -681,  1017,   732,   608, -1542,   411,  -205, -1571,
     1223,   652,  -552,  1015, -1293,  1491,  -282, -1544,
      516,    -8,  -320,  -666, -1618, -1162,   126,  1469,
     -853,   -90,  -271,   830,   107, -1421,  -247,  -951,
     -398,   961, -1508,  -725,   448, -1065,   677, -1275,
    -1103,   430,   555,   843, -1251,   871,  1550,   105,
      422,   587,   177,  -235,  -291,  -460,  1574,  1653,
     -246,   778,  1159,  -147,  -777,  1483,  -602,  1119,
    -1590,   644,  -872,   349,   418,   329,  -156,   -75,
      817,  1097,   603,   610,  1322, -1285, -1465,   384,
    -1215,  -136,  1218, -1335,  -874,   220, -1187, -1659,
    -1185, -1530, -1278,   794, -1510,  -854,  -870,   478,
     -108,  -308,   996,   991,   958, -1460,  1522,  1628
};

// ------------------------------- Forward NTT ---------------------------------
//  Transforms 256 coefficients (normal order) into the NTT domain in place.
//  Uses Cooley-Tukey butterflies over 7 layers (len = 128, 64, ..., 2).
inline void ntt(int16_t r[KYBER_N]) {
    unsigned k = 1;                                   // index into the zetas table
    // Layer loop: the "distance" between paired coefficients halves each time.
    for (unsigned len = 128; len >= 2; len >>= 1) {
        // Each layer is split into blocks of size 2*len; each block shares a twiddle.
        for (unsigned start = 0; start < KYBER_N; start += 2 * len) {
            int16_t zeta = zetas[k++];                // twiddle for this block
            // Butterfly across the block: pair index j with j+len.
            for (unsigned j = start; j < start + len; j++) {
                int16_t t = fqmul(zeta, r[j + len]);  // t = zeta * upper   (the one multiply)
                r[j + len] = r[j] - t;                // lower - t          (subtract)
                r[j]       = r[j] + t;                // lower + t          (add)
            }
        }
    }
    // Coefficients are left un-canonicalized (|value| can exceed q); callers
    // that serialize will canonicalize, and basemul tolerates this range.
}

// ------------------------------- Inverse NTT ---------------------------------
//  Transforms NTT-domain coefficients back to normal order in place, and folds
//  in the 1/128 normalization together with a Montgomery factor (constant f).
//  Uses Gentleman-Sande butterflies over 7 layers (len = 2, 4, ..., 128).
inline void invntt(int16_t r[KYBER_N]) {
    // f = mont^2 / 128 = (2^16)^2 * 128^{-1} mod q = 1441.  Multiplying every
    // output by f both removes the accumulated Montgomery factors and applies
    // the 1/128 that the inverse transform requires.
    const int16_t f = 1441;
    unsigned k = 127;                                 // walk the zetas table backwards
    for (unsigned len = 2; len <= 128; len <<= 1) {
        for (unsigned start = 0; start < KYBER_N; start += 2 * len) {
            int16_t zeta = zetas[k--];
            for (unsigned j = start; j < start + len; j++) {
                int16_t t   = r[j];                             // save lower
                r[j]        = barrett_reduce(t + r[j + len]);   // lower + upper (keep small)
                r[j + len]  = r[j + len] - t;                   // upper - lower
                r[j + len]  = fqmul(zeta, r[j + len]);          // * twiddle (the one multiply)
            }
        }
    }
    for (unsigned j = 0; j < KYBER_N; j++)
        r[j] = fqmul(r[j], f);                         // final scale by 1/128 (in Montgomery form)
}

// --------------------- Base-case (pointwise) multiplication ------------------
//  Because the incomplete NTT leaves data as degree-1 polynomials, the product
//  of two "points" is a multiplication of (a0 + a1*x)(b0 + b1*x) modulo the
//  quadratic (x^2 - zeta).  Expanding and using x^2 = zeta gives:
//        r0 = a0*b0 + a1*b1*zeta
//        r1 = a0*b1 + a1*b0
//  This is the famous "5 multiplies, 2 adds" kernel at the heart of every ML-KEM
//  implementation's polynomial multiply.
inline void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta) {
    r[0]  = fqmul(a[1], b[1]);   // a1*b1
    r[0]  = fqmul(r[0], zeta);   // (a1*b1)*zeta
    r[0] += fqmul(a[0], b[0]);   // + a0*b0        -> r0
    r[1]  = fqmul(a[0], b[1]);   // a0*b1
    r[1] += fqmul(a[1], b[0]);   // + a1*b0        -> r1
}

} // namespace mlkem
