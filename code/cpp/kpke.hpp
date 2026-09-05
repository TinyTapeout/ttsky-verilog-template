// ============================================================================
//  kpke.hpp  -  K-PKE: the Module-LWE public-key encryption inside ML-KEM
// ----------------------------------------------------------------------------
//  This is the "IND-CPA" core.  Its security rests on Module-LWE: the public key
//  t = A*s + e hides the small secret s behind small noise e.  Encryption adds
//  the message to a noisy inner product; decryption subtracts s*u to cancel the
//  large terms and rounds away the leftover noise.  ML-KEM (mlkem.hpp) wraps this
//  with the Fujisaki-Okamoto transform to get chosen-ciphertext security.
//
//  Every A*s, A^T*y, t^T*y, s^T*u below is a matrix/vector of polynomial
//  multiplications done in the NTT domain -- i.e. many calls to the NTT block.
// ============================================================================
#pragma once
#include "params.hpp"
#include "poly.hpp"
#include "polyvec.hpp"
#include "sha3.hpp"
#include <cstring>

namespace mlkem {

// Number of SHAKE128 blocks squeezed up-front when rejection-sampling a matrix
// entry.  168 is divisible by 3, so no candidate straddles a block boundary and
// the byte stream is consumed exactly as the standard requires.
constexpr int GEN_MATRIX_NBLOCKS = 3;

// Build the public matrix A-hat (already in the NTT domain) from seed rho.
//  transposed = 0 : A[i][j] = SampleNTT(XOF(rho, j, i))   (used in KeyGen)
//  transposed = 1 : A[i][j] = SampleNTT(XOF(rho, i, j))   (= A^T, used in Encrypt)
inline void gen_matrix(polyvec a[KYBER_K], const uint8_t seed[KYBER_SYMBYTES], int transposed) {
    for (int i = 0; i < KYBER_K; i++) {
        for (int j = 0; j < KYBER_K; j++) {
            sha3::xof_state state;
            uint8_t buf[GEN_MATRIX_NBLOCKS * sha3::SHAKE128_RATE];
            // A[i][j] = SampleNTT(XOF(rho, j, i)) for gen_a; transposed swaps to (i, j).
            // (This XOF index order is the same in the IPD and the final standard.)
            if (transposed) sha3::xof_absorb(state, seed, (uint8_t)i, (uint8_t)j);
            else            sha3::xof_absorb(state, seed, (uint8_t)j, (uint8_t)i);
            sha3::xof_squeezeblocks(buf, GEN_MATRIX_NBLOCKS, state);
            unsigned buflen = GEN_MATRIX_NBLOCKS * sha3::SHAKE128_RATE;
            unsigned ctr = rej_uniform(a[i].vec[j].coeffs, KYBER_N, buf, buflen);
            while (ctr < KYBER_N) {                        // rare: need more bytes
                sha3::xof_squeezeblocks(buf, 1, state);
                ctr += rej_uniform(a[i].vec[j].coeffs + ctr, KYBER_N - ctr, buf, sha3::SHAKE128_RATE);
            }
        }
    }
}

// ------------------------------ K-PKE.KeyGen ---------------------------------
//  Input : 32-byte seed d.  Output: pk = (t_hat || rho), sk = s_hat.
inline void indcpa_keypair_derand(uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                                  uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES],
                                  const uint8_t coins[KYBER_SYMBYTES]) {
    // (rho, sigma) = G(d || k).  The extra byte k is FIPS 203 (final) domain separation.
    // Define MLKEM_IPD to reproduce the initial-public-draft vectors, which used G(d).
    uint8_t buf[2 * KYBER_SYMBYTES];
#ifdef MLKEM_IPD
    sha3::sha3_512(buf, coins, KYBER_SYMBYTES);            // IPD: (rho,sigma) = G(d)
#else
    uint8_t gin[KYBER_SYMBYTES + 1];
    memcpy(gin, coins, KYBER_SYMBYTES);
    gin[KYBER_SYMBYTES] = (uint8_t)KYBER_K;                // final: bind the parameter set
    sha3::sha3_512(buf, gin, KYBER_SYMBYTES + 1);          // final: (rho,sigma) = G(d || k)
#endif
    const uint8_t *rho = buf;                 // seed for the public matrix A
    const uint8_t *sigma = buf + KYBER_SYMBYTES; // seed for the noise

    polyvec a[KYBER_K], e, pkpv, skpv;
    gen_matrix(a, rho, 0);                    // A-hat

    uint8_t nonce = 0;
    for (int i = 0; i < KYBER_K; i++) poly_getnoise_eta1(&skpv.vec[i], sigma, nonce++); // secret s
    for (int i = 0; i < KYBER_K; i++) poly_getnoise_eta1(&e.vec[i],    sigma, nonce++); // error  e

    polyvec_ntt(&skpv);                       // work in the NTT domain
    polyvec_ntt(&e);

    // t_hat = A-hat o s_hat + e_hat
    for (int i = 0; i < KYBER_K; i++) {
        polyvec_basemul_acc_montgomery(&pkpv.vec[i], &a[i], &skpv); // row i of A times s
        poly_tomont(&pkpv.vec[i]);            // fix Montgomery factor from basemul
    }
    polyvec_add(&pkpv, &pkpv, &e);
    polyvec_reduce(&pkpv);

    polyvec_tobytes(sk, &skpv);               // sk = s_hat
    polyvec_tobytes(pk, &pkpv);               // pk = t_hat ...
    memcpy(pk + KYBER_POLYVECBYTES, rho, KYBER_SYMBYTES); // ... || rho
}

// ------------------------------ K-PKE.Encrypt --------------------------------
//  Encrypt 32-byte message m under pk using 32 bytes of coins r.  Output c.
inline void indcpa_enc(uint8_t c[KYBER_INDCPA_BYTES],
                       const uint8_t m[KYBER_SYMBYTES],
                       const uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                       const uint8_t coins[KYBER_SYMBYTES]) {
    uint8_t seed[KYBER_SYMBYTES];
    polyvec at[KYBER_K], sp, ep, b, pkpv;
    poly v, k, epp;

    polyvec_frombytes(&pkpv, pk);                        // recover t_hat
    memcpy(seed, pk + KYBER_POLYVECBYTES, KYBER_SYMBYTES); // recover rho
    poly_frommsg(&k, m);                                 // encode message into a poly
    gen_matrix(at, seed, 1);                             // A^T-hat

    uint8_t nonce = 0;
    for (int i = 0; i < KYBER_K; i++) poly_getnoise_eta1(&sp.vec[i], coins, nonce++); // y  (eta1)
    for (int i = 0; i < KYBER_K; i++) poly_getnoise_eta2(&ep.vec[i], coins, nonce++); // e1 (eta2)
    poly_getnoise_eta2(&epp, coins, nonce++);                                         // e2 (eta2)

    polyvec_ntt(&sp);                                    // y_hat

    for (int i = 0; i < KYBER_K; i++)
        polyvec_basemul_acc_montgomery(&b.vec[i], &at[i], &sp); // b = A^T o y   (in NTT domain)
    polyvec_basemul_acc_montgomery(&v, &pkpv, &sp);      // v = t^T o y   (in NTT domain)

    polyvec_invntt_tomont(&b);                           // back to normal domain
    poly_invntt_tomont(&v);

    polyvec_add(&b, &b, &ep);                            // u = A^T o y + e1
    poly_add(&v, &v, &epp);                              // v += e2
    poly_add(&v, &v, &k);                                // v += Decompress_1(m)

    polyvec_reduce(&b);
    poly_reduce(&v);

    polyvec_compress(c, &b);                             // c1 = Compress_du(u)
    poly_compress(c + KYBER_POLYVECCOMPRESSEDBYTES, &v); // c2 = Compress_dv(v)
}

// ------------------------------ K-PKE.Decrypt --------------------------------
//  Recover the 32-byte message from ciphertext c using secret key sk.
inline void indcpa_dec(uint8_t m[KYBER_SYMBYTES],
                       const uint8_t c[KYBER_INDCPA_BYTES],
                       const uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES]) {
    polyvec b, skpv;
    poly v, mp;

    polyvec_decompress(&b, c);                           // u  (approx.)
    poly_decompress(&v, c + KYBER_POLYVECCOMPRESSEDBYTES); // v  (approx.)
    polyvec_frombytes(&skpv, sk);                        // s_hat

    polyvec_ntt(&b);                                     // NTT(u)
    polyvec_basemul_acc_montgomery(&mp, &skpv, &b);      // s^T o NTT(u)
    poly_invntt_tomont(&mp);                             // back to normal domain

    poly_sub(&mp, &v, &mp);                              // w = v - s^T u  (message + small noise)
    poly_reduce(&mp);
    poly_tomsg(m, &mp);                                  // round each coeff to a bit
}

} // namespace mlkem
