// ============================================================================
//  test_acvp.cpp  -  BYTE-EXACT external cross-check of ML-KEM-512
// ----------------------------------------------------------------------------
//  The round-trip tests prove the code is self-consistent; THIS test proves it
//  is byte-identical to a third-party reference -- the strongest verification we
//  have.  It checks against the C2SP/CCTV vectors
//  (https://github.com/C2SP/CCTV/tree/main/ML-KEM), the same family of vectors
//  used to validate ML-KEM libraries and closely related to NIST's ACVP.
//
//  TWO checks:
//    A) A single intermediate-value vector: fixed (d, z, m) -> we recompute
//       rho, sigma, ek, K, ct, KBar and compare each to the published values
//       (32-byte values compared exactly; the long ek/ct compared by SHA3-256
//       fingerprint).
//    B) An "accumulated" vector: 10,000 KeyGen/Encaps/Decaps runs driven by a
//       SHAKE-128 stream, all outputs folded into one running SHAKE-128 hash,
//       compared to the single published digest.
//
//  IMPORTANT -- IPD vs FINAL:
//    The public CCTV vectors follow the FIPS 203 *initial public draft* (IPD).
//    The IPD differs from the FINAL standard in exactly ONE place that affects
//    these bytes: (rho, sigma) = G(d) in the IPD vs G(d || k) in the final
//    standard (a domain-separation byte added in the final version).  This file
//    therefore defines MLKEM_IPD to select the IPD convention so it can match
//    the published vectors.  Our DEFAULT build (without this define) is FIPS 203
//    FINAL, matching the pq-crystals reference; the only delta is that one byte.
//    So a pass here proves the entire engine -- sampling, NTT, base multiply,
//    compression, serialization, hashing, the FO transform -- is byte-exact.
//
//  BUILD:  g++ -std=c++17 -O2 test_acvp.cpp -o test_acvp   (defines MLKEM_IPD itself)
//  RUN:    ./test_acvp
// ============================================================================
#define MLKEM_IPD                     // select the IPD convention (see note above)
#include "mlkem.hpp"
#include <cstdio>
#include <cstring>
using namespace mlkem;

// Parse a hex string into bytes.
static void hx(const char* h, uint8_t* o, int n) {
    for (int i = 0; i < n; i++) { unsigned v; sscanf(h + 2 * i, "%2x", &v); o[i] = (uint8_t)v; }
}
// Compare `b` (n bytes) against expected hex; print PASS/FAIL and return 0/1 fail.
static int check(const char* label, const uint8_t* b, int n, const char* expect_hex) {
    uint8_t e[64]; hx(expect_hex, e, n);
    bool ok = memcmp(b, e, n) == 0;
    printf("   %-26s %s\n", label, ok ? "MATCH" : "DIFFERS");
    return ok ? 0 : 1;
}
// SHA3-256 fingerprint of a buffer, compared to expected hex.
static int check_fp(const char* label, const uint8_t* b, int n, const char* expect_hex) {
    uint8_t fp[32]; sha3::sha3_256(fp, b, n);
    return check(label, fp, 32, expect_hex);
}

int main() {
    printf("==================================================================\n");
    printf(" ML-KEM-512 BYTE-EXACT CROSS-CHECK  (C2SP/CCTV, FIPS 203 IPD)\n");
    printf("==================================================================\n\n");
    int fails = 0;

    printf("[pre] SHA-3 self-test (incl. incremental sponge): %s\n\n",
           sha3::sha3_selftest() ? "PASS" : (fails++, "FAIL"));

    // ---------------- Test A: single intermediate-value vector ----------------
    printf("[A] Single known-answer vector (fixed d, z, m):\n");
    {
        uint8_t d[32], z[32], m[32];
        hx("e1e3206875e67d7e81353774fe9025035b9b41a4a9f6ec00b91c600442fd717d", d, 32);
        hx("c6f5785a6f2b42e843228be53eb768d64c6f9d4355ae95f083e51ed57c437310", z, 32);
        hx("a741ec2002be6f4fa76037b7f0644f833fa823e630401a39d3240c6e82a430bb", m, 32);

        // (rho, sigma) = G(d) in the IPD.
        uint8_t g[64]; sha3::sha3_512(g, d, 32);
        fails += check("rho    = G(d)[0:32]",  g,      32, "b1720e4ed5ac0add457f573a041465bcbd7ca4e1d7d53eaadeda511962a36eb0");
        fails += check("sigma  = G(d)[32:64]", g + 32, 32, "176c5e5bdef7f0b03349110742125810116450aa6ed6a02a87a8c04cb508d6fa");

        uint8_t coins[64]; memcpy(coins, d, 32); memcpy(coins + 32, z, 32);
        uint8_t ek[KYBER_PUBLICKEYBYTES], dk[KYBER_SECRETKEYBYTES];
        crypto_kem_keypair_derand(ek, dk, coins);
        fails += check_fp("SHA3-256(ek)",  ek, KYBER_PUBLICKEYBYTES,
                          "a9ce0ecbcfbbbd9a2636e23a0c1c22683943639cd44af051ff235b8dfbb73a4d");

        uint8_t ct[KYBER_CIPHERTEXTBYTES], K[32];
        crypto_kem_enc_derand(ct, K, ek, m);
        fails += check("K (shared secret)", K, 32,
                       "62a8c220b01793ecd183dea9762c5602211e0aab001cbc892d0a95693ab17cc1");
        fails += check_fp("SHA3-256(ct)", ct, KYBER_CIPHERTEXTBYTES,
                          "ce31b9b5e0f8c2c4db7dffc3e1d2b6883a46dd3b85afbc1ff9c000520c7a38eb");

        // KBar = J(z || ct) is the implicit-rejection key.
        uint8_t jin[32 + KYBER_CIPHERTEXTBYTES], KBar[32];
        memcpy(jin, z, 32); memcpy(jin + 32, ct, KYBER_CIPHERTEXTBYTES);
        sha3::shake256(KBar, 32, jin, sizeof(jin));
        fails += check("KBar = J(z||ct)", KBar, 32,
                       "d08b06e61415a845c0fe5447ba9b22072130d897fd7117457a9060121955a1e5");
    }
    printf("\n");

    // ---------------- Test B: accumulated 10,000-iteration vector -------------
    printf("[B] Accumulated vector (10,000 KeyGen/Encaps/Decaps iterations):\n");
    {
        // Deterministic RNG = SHAKE-128("") squeezed as a stream.
        sha3::keccak_inc rng; sha3::inc_init(rng);
        sha3::inc_absorb(rng, sha3::SHAKE128_RATE, nullptr, 0);
        sha3::inc_finalize(rng, sha3::SHAKE128_RATE, 0x1F);
        // Running accumulator = one SHAKE-128 over all outputs.
        sha3::keccak_inc acc; sha3::inc_init(acc);

        for (int i = 0; i < 10000; i++) {
            uint8_t coins[64], m[32], ct_rand[KYBER_CIPHERTEXTBYTES];
            sha3::inc_squeeze(rng, sha3::SHAKE128_RATE, coins,      32);  // d
            sha3::inc_squeeze(rng, sha3::SHAKE128_RATE, coins + 32, 32);  // z
            sha3::inc_squeeze(rng, sha3::SHAKE128_RATE, m,          32);  // m
            sha3::inc_squeeze(rng, sha3::SHAKE128_RATE, ct_rand, KYBER_CIPHERTEXTBYTES); // random ct

            uint8_t ek[KYBER_PUBLICKEYBYTES], dk[KYBER_SECRETKEYBYTES];
            uint8_t ct[KYBER_CIPHERTEXTBYTES], k[32], kprime[32];
            crypto_kem_keypair_derand(ek, dk, coins);
            crypto_kem_enc_derand(ct, k, ek, m);
            crypto_kem_dec(kprime, ct_rand, dk);

            // Accumulate in order: ek, dk, ct, k, k'.
            sha3::inc_absorb(acc, sha3::SHAKE128_RATE, ek,     KYBER_PUBLICKEYBYTES);
            sha3::inc_absorb(acc, sha3::SHAKE128_RATE, dk,     KYBER_SECRETKEYBYTES);
            sha3::inc_absorb(acc, sha3::SHAKE128_RATE, ct,     KYBER_CIPHERTEXTBYTES);
            sha3::inc_absorb(acc, sha3::SHAKE128_RATE, k,      32);
            sha3::inc_absorb(acc, sha3::SHAKE128_RATE, kprime, 32);
        }
        uint8_t digest[32];
        sha3::inc_finalize(acc, sha3::SHAKE128_RATE, 0x1F);
        sha3::inc_squeeze(acc, sha3::SHAKE128_RATE, digest, 32);
        fails += check("accumulated digest (10000)", digest, 32,
                       "845913ea5a308b803c764a9ed8e9d814ca1fd9c82ba43c7b1e64b79c7a6ec8e4");
    }

    printf("\n==================================================================\n");
    printf(" RESULT: %s\n", fails ? "FAIL" :
        "ALL MATCH -- ML-KEM-512 is BYTE-EXACT vs the reference vectors");
    printf("==================================================================\n");
    return fails ? 1 : 0;
}
