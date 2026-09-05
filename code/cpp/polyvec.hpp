// ============================================================================
//  polyvec.hpp  -  Vectors of K polynomials (K = 2 for ML-KEM-512)
// ----------------------------------------------------------------------------
//  ML-KEM keys and ciphertexts are vectors/matrices of polynomials.  The single
//  most multiply-heavy operation is polyvec_basemul_acc_montgomery: the inner
//  product of two length-K vectors in the NTT domain.  This is the exact kernel
//  that dominates encapsulation -- the single most performance-critical step.
// ============================================================================
#pragma once
#include "params.hpp"
#include "poly.hpp"

namespace mlkem {

// A vector of K = 2 polynomials.
struct polyvec { poly vec[KYBER_K]; };

// Apply the (forward / inverse) NTT to every polynomial in the vector.
inline void polyvec_ntt(polyvec *r)            { for (int i = 0; i < KYBER_K; i++) poly_ntt(&r->vec[i]); }
inline void polyvec_invntt_tomont(polyvec *r)  { for (int i = 0; i < KYBER_K; i++) poly_invntt_tomont(&r->vec[i]); }
inline void polyvec_reduce(polyvec *r)         { for (int i = 0; i < KYBER_K; i++) poly_reduce(&r->vec[i]); }
inline void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b) {
    for (int i = 0; i < KYBER_K; i++) poly_add(&r->vec[i], &a->vec[i], &b->vec[i]);
}

//  Inner product in the NTT domain: r = sum_i a[i] * b[i]  (pointwise-multiply
//  each pair, accumulate, then reduce).  <-- the heart of every matrix*vector.
inline void polyvec_basemul_acc_montgomery(poly *r, const polyvec *a, const polyvec *b) {
    poly t;
    poly_basemul_montgomery(r, &a->vec[0], &b->vec[0]);         // first product
    for (int i = 1; i < KYBER_K; i++) {
        poly_basemul_montgomery(&t, &a->vec[i], &b->vec[i]);    // next product
        poly_add(r, r, &t);                                     // accumulate
    }
    poly_reduce(r);                                             // keep coefficients small
}

// 12-bit (un)packing for a whole vector.
inline void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], const polyvec *a) {
    for (int i = 0; i < KYBER_K; i++) poly_tobytes(r + i * KYBER_POLYBYTES, &a->vec[i]);
}
inline void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES]) {
    for (int i = 0; i < KYBER_K; i++) poly_frombytes(&r->vec[i], a + i * KYBER_POLYBYTES);
}

// ------------------- Compression of u (du = 10) inside ciphertext ------------
//  Pack four 10-bit values into 5 bytes.
inline void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES], const polyvec *a) {
    size_t off = 0;
    uint16_t t[4];
    for (int i = 0; i < KYBER_K; i++) {
        for (int j = 0; j < KYBER_N / 4; j++) {
            for (int k = 0; k < 4; k++) {
                uint16_t u = to_canonical(a->vec[i].coeffs[4 * j + k]);
                t[k] = (uint16_t)(((((uint32_t)u << 10) + KYBER_Q / 2) / KYBER_Q) & 0x3FF); // round(1024u/q)
            }
            r[off + 0] = (uint8_t)(t[0]);
            r[off + 1] = (uint8_t)((t[0] >> 8) | (t[1] << 2));
            r[off + 2] = (uint8_t)((t[1] >> 6) | (t[2] << 4));
            r[off + 3] = (uint8_t)((t[2] >> 4) | (t[3] << 6));
            r[off + 4] = (uint8_t)((t[3] >> 2));
            off += 5;
        }
    }
}
inline void polyvec_decompress(polyvec *r, const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES]) {
    size_t off = 0;
    uint16_t t[4];
    for (int i = 0; i < KYBER_K; i++) {
        for (int j = 0; j < KYBER_N / 4; j++) {
            t[0] = (uint16_t)((a[off + 0] >> 0) | ((uint16_t)a[off + 1] << 8));
            t[1] = (uint16_t)((a[off + 1] >> 2) | ((uint16_t)a[off + 2] << 6));
            t[2] = (uint16_t)((a[off + 2] >> 4) | ((uint16_t)a[off + 3] << 4));
            t[3] = (uint16_t)((a[off + 3] >> 6) | ((uint16_t)a[off + 4] << 2));
            for (int k = 0; k < 4; k++)
                r->vec[i].coeffs[4 * j + k] =
                    (int16_t)(((uint32_t)(t[k] & 0x3FF) * KYBER_Q + 512) >> 10); // Decompress_10
            off += 5;
        }
    }
}

} // namespace mlkem
