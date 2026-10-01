// ============================================================================
//  reduce.hpp  -  Modular arithmetic modulo q = 3329
// ----------------------------------------------------------------------------
//  Every NTT butterfly needs a multiply-then-reduce modulo q.  A general integer
//  division is expensive, so we use Montgomery and Barrett reduction, which replace
//  division by a fixed prime with multiplies, shifts, and a conditional add/sub.
//  These two routines are the arithmetic workhorses of the whole algorithm, so the
//  bit-widths involved are called out in the comments.
// ============================================================================
#pragma once
#include "params.hpp"

namespace mlkem {

// R = 2^16 is the Montgomery radix.  We keep coefficients in the "Montgomery
// domain" (multiplied by R) so that a reduction is just a multiply + shift.
constexpr int16_t MONT = -1044;  // 2^16 mod q, in signed form (2^16 = 19*3329 - 1044... i.e. 65536 mod 3329 = 2285 = -1044 mod q)
constexpr int16_t QINV = -3327;  // q^{-1} mod 2^16 (so q*QINV ≡ 1 mod 2^16); equals 62209 unsigned

// -------------------------- Montgomery reduction -----------------------------
//  Input : a, a 32-bit signed integer with |a| < q * 2^15 (a product a0*a1).
//  Output: t ≡ a * R^{-1} (mod q), with |t| < q.  (t is in [-q+1, q-1].)
//  This is the reduction used after every coefficient multiply in the NTT.
inline int16_t montgomery_reduce(int32_t a) {
    int16_t t = (int16_t)((int16_t)a * QINV);          // t = (a mod 2^16) * QINV  (low 16 bits)
    t = (int16_t)((a - (int32_t)t * KYBER_Q) >> 16);   // subtract multiple of q, keep high bits
    return t;                                          // now a*R^{-1} mod q
}

// ---------------------------- Barrett reduction ------------------------------
//  Input : a, any 16-bit signed value.
//  Output: a value congruent to a mod q, reduced to the centered range
//          about 0 (roughly (-q/2, q/2]).  Used to keep sums small in invntt.
inline int16_t barrett_reduce(int16_t a) {
    // v = round(2^26 / q) = 20159; multiplying by v/2^26 approximates dividing by q.
    constexpr int16_t v = (int16_t)(((1 << 26) + KYBER_Q / 2) / KYBER_Q);
    int16_t t = (int16_t)(((int32_t)v * a + (1 << 25)) >> 26); // t ≈ round(a / q)
    t = (int16_t)(t * KYBER_Q);                                // t = round(a/q) * q
    return (int16_t)(a - t);                                   // remainder in centered range
}

// ------------------------- Modular multiplication ----------------------------
//  Multiply two Montgomery-domain coefficients and reduce.  The intermediate
//  product (int16 * int16) is up to 32 bits -- one multiply followed by one
//  reduction, and this is the single operation the NTT performs most often.
inline int16_t fqmul(int16_t a, int16_t b) {
    return montgomery_reduce((int32_t)a * b);
}

// Map a possibly-negative representative into the canonical range [0, q).
// Used just before serializing coefficients to bytes.
inline uint16_t to_canonical(int16_t a) {
    uint16_t t = (uint16_t)a;
    t += (uint16_t)(((int16_t)t >> 15) & KYBER_Q); // if a<0, add q
    return t;
}

} // namespace mlkem
