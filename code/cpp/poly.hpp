// ============================================================================
//  poly.hpp  -  Single-polynomial operations for ML-KEM
// ----------------------------------------------------------------------------
//  A `poly` is 256 signed coefficients mod q.  This file provides: NTT-domain
//  multiply, add/sub/reduce, conversion to/from bytes (12-bit packing),
//  compression/decompression (used only inside ciphertexts), message <-> poly
//  encoding, and noise sampling from a centered binomial distribution (CBD).
// ============================================================================
#pragma once
#include "params.hpp"
#include "reduce.hpp"
#include "ntt.hpp"
#include "sha3.hpp"
#include <cstring>

namespace mlkem {

// A polynomial: 256 coefficients bundled into one struct, so a whole polynomial
// can be passed around by a single name (see polyvec.hpp for vectors of these).
struct poly { int16_t coeffs[KYBER_N]; };

// ---- little-endian byte loaders used by the CBD sampler ---------------------
inline uint32_t load24_le(const uint8_t x[3]) {
    return (uint32_t)x[0] | ((uint32_t)x[1] << 8) | ((uint32_t)x[2] << 16);
}
inline uint32_t load32_le(const uint8_t x[4]) {
    return (uint32_t)x[0] | ((uint32_t)x[1] << 8) | ((uint32_t)x[2] << 16) | ((uint32_t)x[3] << 24);
}

// ------------------------- Basic polynomial arithmetic -----------------------
inline void poly_reduce(poly *r) {                       // canonicalize sizes
    for (int i = 0; i < KYBER_N; i++) r->coeffs[i] = barrett_reduce(r->coeffs[i]);
}
inline void poly_add(poly *r, const poly *a, const poly *b) {
    for (int i = 0; i < KYBER_N; i++) r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}
inline void poly_sub(poly *r, const poly *a, const poly *b) {
    for (int i = 0; i < KYBER_N; i++) r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

// Forward NTT of a polynomial, followed by a Barrett reduction to keep sizes small.
inline void poly_ntt(poly *r) { ntt(r->coeffs); poly_reduce(r); }
// Inverse NTT (also converts back into the Montgomery domain via the constant f).
inline void poly_invntt_tomont(poly *r) { invntt(r->coeffs); }

// NTT-domain multiply of two polynomials: apply the degree-1 basemul to each of
// the 128 "points".  Point i uses twiddle zetas[64+i]; the two halves of the
// point use +zeta and -zeta (the two roots of the quadratic factor).
inline void poly_basemul_montgomery(poly *r, const poly *a, const poly *b) {
    for (int i = 0; i < KYBER_N / 4; i++) {
        basemul(&r->coeffs[4 * i],     &a->coeffs[4 * i],     &b->coeffs[4 * i],     zetas[64 + i]);
        basemul(&r->coeffs[4 * i + 2], &a->coeffs[4 * i + 2], &b->coeffs[4 * i + 2], (int16_t)-zetas[64 + i]);
    }
}
// Convert a normal-domain polynomial into the Montgomery domain (multiply by R).
inline void poly_tomont(poly *r) {
    const int16_t f = (int16_t)(((int64_t)1 << 32) % KYBER_Q); // 2^32 mod q = 1353
    for (int i = 0; i < KYBER_N; i++) r->coeffs[i] = montgomery_reduce((int32_t)r->coeffs[i] * f);
}

// ------------------------- 12-bit serialization ------------------------------
//  ByteEncode_12: pack 256 coefficients (canonicalized to [0,q)) into 384 bytes,
//  two 12-bit coefficients per 3 bytes.
inline void poly_tobytes(uint8_t r[KYBER_POLYBYTES], const poly *a) {
    for (int i = 0; i < KYBER_N / 2; i++) {
        uint16_t t0 = to_canonical(a->coeffs[2 * i]);
        uint16_t t1 = to_canonical(a->coeffs[2 * i + 1]);
        r[3 * i + 0] = (uint8_t)(t0);              // low 8 bits of t0
        r[3 * i + 1] = (uint8_t)((t0 >> 8) | (t1 << 4)); // hi 4 of t0 | lo 4 of t1
        r[3 * i + 2] = (uint8_t)(t1 >> 4);         // hi 8 bits of t1
    }
}
//  ByteDecode_12: inverse of the above.
inline void poly_frombytes(poly *r, const uint8_t a[KYBER_POLYBYTES]) {
    for (int i = 0; i < KYBER_N / 2; i++) {
        r->coeffs[2 * i]     = (int16_t)(((a[3 * i + 0] >> 0) | ((uint16_t)a[3 * i + 1] << 8)) & 0xFFF);
        r->coeffs[2 * i + 1] = (int16_t)(((a[3 * i + 1] >> 4) | ((uint16_t)a[3 * i + 2] << 4)) & 0xFFF);
    }
}

// ------------------------- Message <-> polynomial ----------------------------
//  Decompress_1: each of 256 message bits becomes a coefficient 0 or (q+1)/2.
inline void poly_frommsg(poly *r, const uint8_t msg[KYBER_SYMBYTES]) {
    for (int i = 0; i < KYBER_N / 8; i++) {
        for (int j = 0; j < 8; j++) {
            int16_t mask = -(int16_t)((msg[i] >> j) & 1);      // 0x0000 or 0xFFFF
            r->coeffs[8 * i + j] = mask & (int16_t)((KYBER_Q + 1) / 2); // 0 or 1665
        }
    }
}
//  Compress_1: round each coefficient to the nearer of 0 and (q+1)/2 -> one bit.
inline void poly_tomsg(uint8_t msg[KYBER_SYMBYTES], const poly *a) {
    for (int i = 0; i < KYBER_N / 8; i++) {
        msg[i] = 0;
        for (int j = 0; j < 8; j++) {
            uint16_t t = to_canonical(a->coeffs[8 * i + j]);
            t = (uint16_t)(((((uint32_t)t << 1) + KYBER_Q / 2) / KYBER_Q) & 1); // round(2t/q) mod 2
            msg[i] |= (uint8_t)(t << j);
        }
    }
}

// ------------------------- Compression (dv=4, for v) -------------------------
inline void poly_compress(uint8_t r[KYBER_POLYCOMPRESSEDBYTES], const poly *a) {
    uint8_t t[8];
    for (int i = 0; i < KYBER_N / 8; i++) {
        for (int j = 0; j < 8; j++) {
            uint16_t u = to_canonical(a->coeffs[8 * i + j]);
            t[j] = (uint8_t)(((((uint32_t)u << 4) + KYBER_Q / 2) / KYBER_Q) & 15); // round(16u/q) mod 16
        }
        // pack 8 nibbles into 4 bytes
        r[4 * i + 0] = (uint8_t)(t[0] | (t[1] << 4));
        r[4 * i + 1] = (uint8_t)(t[2] | (t[3] << 4));
        r[4 * i + 2] = (uint8_t)(t[4] | (t[5] << 4));
        r[4 * i + 3] = (uint8_t)(t[6] | (t[7] << 4));
    }
}
inline void poly_decompress(poly *r, const uint8_t a[KYBER_POLYCOMPRESSEDBYTES]) {
    for (int i = 0; i < KYBER_N / 2; i++) {
        r->coeffs[2 * i + 0] = (int16_t)((((uint16_t)(a[i] & 15) * KYBER_Q) + 8) >> 4);       // Decompress_4
        r->coeffs[2 * i + 1] = (int16_t)((((uint16_t)(a[i] >> 4)  * KYBER_Q) + 8) >> 4);
    }
}

// ------------------------- Centered Binomial noise ---------------------------
//  CBD_eta: turn uniform PRF bytes into small, centered coefficients by summing
//  eta bits and subtracting eta bits.  Larger eta = wider (noisier) distribution.
inline void cbd2(poly *r, const uint8_t buf[2 * KYBER_N / 4]) { // eta = 2
    for (int i = 0; i < KYBER_N / 8; i++) {
        uint32_t t = load32_le(buf + 4 * i);
        uint32_t d = t & 0x55555555;          // sum bit b0
        d += (t >> 1) & 0x55555555;           // + bit b1  -> 2-bit popcount per pair
        for (int j = 0; j < 8; j++) {
            int16_t a = (d >> (4 * j + 0)) & 0x3;
            int16_t b = (d >> (4 * j + 2)) & 0x3;
            r->coeffs[8 * i + j] = a - b;      // value in {-2,-1,0,1,2}
        }
    }
}
inline void cbd3(poly *r, const uint8_t buf[3 * KYBER_N / 4]) { // eta = 3
    for (int i = 0; i < KYBER_N / 4; i++) {
        uint32_t t = load24_le(buf + 3 * i);
        uint32_t d = t & 0x00249249;          // sum bit b0 of each triple
        d += (t >> 1) & 0x00249249;           // + bit b1
        d += (t >> 2) & 0x00249249;           // + bit b2  -> 3-bit popcount per triple
        for (int j = 0; j < 4; j++) {
            int16_t a = (d >> (6 * j + 0)) & 0x7;
            int16_t b = (d >> (6 * j + 3)) & 0x7;
            r->coeffs[4 * i + j] = a - b;      // value in {-3,...,3}
        }
    }
}

// PRF(key, nonce) = SHAKE256(key || nonce), squeezing `outlen` bytes.
inline void prf(uint8_t *out, size_t outlen, const uint8_t key[KYBER_SYMBYTES], uint8_t nonce) {
    uint8_t in[KYBER_SYMBYTES + 1];
    memcpy(in, key, KYBER_SYMBYTES);
    in[KYBER_SYMBYTES] = nonce;
    sha3::shake256(out, outlen, in, KYBER_SYMBYTES + 1);
}

// Sample the secret/error polynomials (eta1=3) and e1/e2 (eta2=2) from a seed+nonce.
inline void poly_getnoise_eta1(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce) {
    uint8_t buf[KYBER_ETA1 * KYBER_N / 4];               // 3*256/4 = 192 bytes
    prf(buf, sizeof(buf), seed, nonce);
    cbd3(r, buf);                                        // eta1 = 3
}
inline void poly_getnoise_eta2(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce) {
    uint8_t buf[KYBER_ETA2 * KYBER_N / 4];               // 2*256/4 = 128 bytes
    prf(buf, sizeof(buf), seed, nonce);
    cbd2(r, buf);                                        // eta2 = 2
}

// ------------------------- Rejection sampling (SampleNTT) --------------------
//  Read 3 bytes at a time -> two 12-bit candidates; keep those < q.  Produces
//  uniform coefficients that are already interpreted as an NTT-domain polynomial.
inline unsigned rej_uniform(int16_t *r, unsigned len, const uint8_t *buf, unsigned buflen) {
    unsigned ctr = 0, pos = 0;
    while (ctr < len && pos + 3 <= buflen) {
        uint16_t val0 = (uint16_t)(((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF);
        uint16_t val1 = (uint16_t)(((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF);
        pos += 3;
        if (val0 < KYBER_Q) r[ctr++] = (int16_t)val0;
        if (ctr < len && val1 < KYBER_Q) r[ctr++] = (int16_t)val1;
    }
    return ctr;
}

} // namespace mlkem
