// ============================================================================
//  mlkem.hpp  -  ML-KEM-512 (FIPS 203): KeyGen, Encaps, Decaps
// ----------------------------------------------------------------------------
//  This is the public interface.  It wraps the IND-CPA K-PKE (kpke.hpp) with the
//  Fujisaki-Okamoto (FO) transform to reach IND-CCA2 security:
//    * encryption randomness r is derived by HASHING the message (so a given m
//      always yields the same ciphertext -- "derandomized"),
//    * decapsulation RE-ENCRYPTS the recovered message and checks it matches the
//      received ciphertext; on mismatch it returns a pseudorandom "implicit
//      rejection" key instead of failing openly.
//
//  Two flavors of each routine:
//    *_derand / *_internal : take explicit random coins -> deterministic, so you
//                            can reproduce exact outputs (for KAT/ACVP testing).
//    plain                 : draw fresh randomness internally (normal use).
// ============================================================================
#pragma once
#include "params.hpp"
#include "kpke.hpp"
#include "sha3.hpp"
#include <cstring>
#include <random>

namespace mlkem {

// ---- Constant-time helpers (used by the FO transform's ciphertext compare) --
//  verify: returns 0 if the two buffers are equal, 1 otherwise, in constant time.
inline int verify(const uint8_t *a, const uint8_t *b, size_t len) {
    uint8_t r = 0;
    for (size_t i = 0; i < len; i++) r |= a[i] ^ b[i];
    return (int)((-(uint64_t)r) >> 63);       // 0 -> 0, nonzero -> 1
}
//  cmov: copy src into dst iff b == 1, without branching on secret data.
inline void cmov(uint8_t *dst, const uint8_t *src, size_t len, uint8_t b) {
    b = (uint8_t)(-(int8_t)b);                 // 0x00 or 0xFF
    for (size_t i = 0; i < len; i++) dst[i] ^= b & (dst[i] ^ src[i]);
}

// ---- Randomness source ------------------------------------------------------
//  NOTE: std::random_device is fine for a functional model / testing, but is NOT
//  a certified cryptographic RNG.  A real device needs a vetted TRNG/DRBG.
inline void randombytes(uint8_t *out, size_t n) {
    static std::random_device rd;
    static std::mt19937_64 gen(((uint64_t)rd() << 32) ^ rd());
    std::uniform_int_distribution<int> dist(0, 255);
    for (size_t i = 0; i < n; i++) out[i] = (uint8_t)dist(gen);
}

// =============================== KeyGen ======================================
//  Deterministic variant: coins = d (32 bytes) || z (32 bytes).
inline void crypto_kem_keypair_derand(uint8_t pk[KYBER_PUBLICKEYBYTES],
                                      uint8_t sk[KYBER_SECRETKEYBYTES],
                                      const uint8_t coins[2 * KYBER_SYMBYTES]) {
    indcpa_keypair_derand(pk, sk, coins);                // dk_PKE (into sk), ek (into pk)
    // sk = dk_PKE || ek || H(ek) || z
    memcpy(sk + KYBER_INDCPA_SECRETKEYBYTES, pk, KYBER_INDCPA_PUBLICKEYBYTES);
    sha3::sha3_256(sk + KYBER_INDCPA_SECRETKEYBYTES + KYBER_INDCPA_PUBLICKEYBYTES,
                   pk, KYBER_PUBLICKEYBYTES);            // H(ek)
    memcpy(sk + KYBER_SECRETKEYBYTES - KYBER_SYMBYTES,
           coins + KYBER_SYMBYTES, KYBER_SYMBYTES);      // z (implicit-rejection secret)
}
//  Randomized variant.
inline void crypto_kem_keypair(uint8_t pk[KYBER_PUBLICKEYBYTES],
                               uint8_t sk[KYBER_SECRETKEYBYTES]) {
    uint8_t coins[2 * KYBER_SYMBYTES];
    randombytes(coins, 2 * KYBER_SYMBYTES);              // d || z
    crypto_kem_keypair_derand(pk, sk, coins);
}

// =============================== Encaps ======================================
//  Deterministic variant: coins = m (32 bytes).  Produces ciphertext ct and
//  shared secret ss.
inline void crypto_kem_enc_derand(uint8_t ct[KYBER_CIPHERTEXTBYTES],
                                  uint8_t ss[KYBER_SSBYTES],
                                  const uint8_t pk[KYBER_PUBLICKEYBYTES],
                                  const uint8_t coins[KYBER_SYMBYTES]) {
    uint8_t buf[2 * KYBER_SYMBYTES];
    memcpy(buf, coins, KYBER_SYMBYTES);                  // m
    sha3::sha3_256(buf + KYBER_SYMBYTES, pk, KYBER_PUBLICKEYBYTES); // H(ek)
    uint8_t kr[2 * KYBER_SYMBYTES];
    sha3::sha3_512(kr, buf, 2 * KYBER_SYMBYTES);         // (K, r) = G(m || H(ek))
    indcpa_enc(ct, coins, pk, kr + KYBER_SYMBYTES);      // c = K-PKE.Encrypt(ek, m, r)
    memcpy(ss, kr, KYBER_SYMBYTES);                      // shared secret K = first half of G
}
//  Randomized variant: draw a fresh 32-byte message m.
inline void crypto_kem_enc(uint8_t ct[KYBER_CIPHERTEXTBYTES],
                           uint8_t ss[KYBER_SSBYTES],
                           const uint8_t pk[KYBER_PUBLICKEYBYTES]) {
    uint8_t m[KYBER_SYMBYTES];
    randombytes(m, KYBER_SYMBYTES);
    crypto_kem_enc_derand(ct, ss, pk, m);
}

// =============================== Decaps ======================================
//  Recover the shared secret ss from ciphertext ct using secret key sk.
inline void crypto_kem_dec(uint8_t ss[KYBER_SSBYTES],
                           const uint8_t ct[KYBER_CIPHERTEXTBYTES],
                           const uint8_t sk[KYBER_SECRETKEYBYTES]) {
    const uint8_t *pk = sk + KYBER_INDCPA_SECRETKEYBYTES;                      // ek
    const uint8_t *h  = sk + KYBER_INDCPA_SECRETKEYBYTES + KYBER_INDCPA_PUBLICKEYBYTES; // H(ek)
    const uint8_t *z  = sk + KYBER_SECRETKEYBYTES - KYBER_SYMBYTES;            // z

    uint8_t buf[2 * KYBER_SYMBYTES];
    indcpa_dec(buf, ct, sk);                             // m' = K-PKE.Decrypt(dk_PKE, c)
    memcpy(buf + KYBER_SYMBYTES, h, KYBER_SYMBYTES);     // append H(ek)
    uint8_t kr[2 * KYBER_SYMBYTES];
    sha3::sha3_512(kr, buf, 2 * KYBER_SYMBYTES);         // (K', r') = G(m' || H(ek))

    uint8_t cmp[KYBER_CIPHERTEXTBYTES];
    indcpa_enc(cmp, buf, pk, kr + KYBER_SYMBYTES);       // c' = re-encrypt m' with r'
    int fail = verify(ct, cmp, KYBER_CIPHERTEXTBYTES);   // 1 if c != c'

    // K_bar = J(z || c)  (the implicit-rejection key)
    uint8_t jin[KYBER_SYMBYTES + KYBER_CIPHERTEXTBYTES];
    memcpy(jin, z, KYBER_SYMBYTES);
    memcpy(jin + KYBER_SYMBYTES, ct, KYBER_CIPHERTEXTBYTES);
    uint8_t kbar[KYBER_SYMBYTES];
    sha3::shake256(kbar, KYBER_SYMBYTES, jin, sizeof(jin));

    memcpy(ss, kr, KYBER_SYMBYTES);                      // tentatively K'
    cmov(ss, kbar, KYBER_SYMBYTES, (uint8_t)fail);       // if mismatch, replace with K_bar
}

} // namespace mlkem
