// ============================================================================
//  test_mlkem.cpp  -  Full test suite for ML-KEM-512
// ----------------------------------------------------------------------------
//  Verifies the whole algorithm the way the user asked: plug in random values,
//  run the algorithm, check it is correct.  Tests, in order:
//    0. SHA-3 Known-Answer Tests  (proves the hashing layer -- how you verify a hash)
//    1. K-PKE message recovery    (the IND-CPA core: encrypt m, decrypt, get m back)
//    2. Full KEM round-trip       (KeyGen -> Encaps -> Decaps, secrets must match)
//    3. Determinism               (same coins -> identical outputs)
//    4. Implicit rejection        (a tampered ciphertext must NOT yield the real key)
//    5. Byte-serialization        (ByteEncode/Decode are exact inverses)
//    6. Deterministic fingerprints(stable hashes of ek/dk/ct/ss for cross-checking
//                                  against a reference implementation or ACVP)
//
//  BUILD:  g++ -std=c++17 -O2 test_mlkem.cpp -o test_mlkem
//  RUN:    ./test_mlkem
// ============================================================================
#include "mlkem.hpp"
#include "poly.hpp"
#include <cstdio>
#include <cstring>
using namespace mlkem;

// Print a 32-byte value as hex.
static void print_hex(const char *label, const uint8_t *p, int n) {
    printf("   %-10s ", label);
    for (int i = 0; i < n; i++) printf("%02x", p[i]);
    printf("\n");
}
// Compact SHA3-256 fingerprint of an arbitrary buffer (for cross-checking).
static void fingerprint(const char *label, const uint8_t *p, size_t n) {
    uint8_t fp[32];
    sha3::sha3_256(fp, p, n);
    printf("   %-14s SHA3-256 = ", label);
    for (int i = 0; i < 32; i++) printf("%02x", fp[i]);
    printf("\n");
}

int main() {
    printf("==================================================================\n");
    printf(" ML-KEM-512 FULL TEST SUITE\n");
    printf("==================================================================\n\n");
    int fails = 0;

    // ---- Test 0: hashing layer (KATs vs NIST published digests) --------------
    printf("[Test 0] SHA-3 / SHAKE Known-Answer Tests: %s\n\n",
           sha3::sha3_selftest() ? "PASS" : (fails++, "FAIL"));

    // ---- Test 1: K-PKE (IND-CPA) message recovery ----------------------------
    printf("[Test 1] K-PKE encrypt/decrypt: recover a random 32-byte message\n");
    {
        int bad = 0, N = 2000;
        for (int t = 0; t < N; t++) {
            uint8_t d[32], m[32], coins[32];
            randombytes(d, 32); randombytes(m, 32); randombytes(coins, 32);
            uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES], sk[KYBER_INDCPA_SECRETKEYBYTES];
            uint8_t c[KYBER_INDCPA_BYTES], m2[32];
            indcpa_keypair_derand(pk, sk, d);
            indcpa_enc(c, m, pk, coins);
            indcpa_dec(m2, c, sk);
            if (memcmp(m, m2, 32) != 0) bad++;
        }
        printf("         %d/%d messages recovered exactly.  --> %s\n\n",
               N - bad, N, bad ? "FAIL" : "PASS");
        fails += (bad != 0);
    }

    // ---- Test 2: Full KEM round-trip -----------------------------------------
    printf("[Test 2] ML-KEM KeyGen -> Encaps -> Decaps: shared secrets match\n");
    {
        int bad = 0, N = 2000;
        for (int t = 0; t < N; t++) {
            uint8_t pk[KYBER_PUBLICKEYBYTES], sk[KYBER_SECRETKEYBYTES];
            uint8_t ct[KYBER_CIPHERTEXTBYTES], ssA[32], ssB[32];
            crypto_kem_keypair(pk, sk);
            crypto_kem_enc(ct, ssA, pk);
            crypto_kem_dec(ssB, ct, sk);
            if (memcmp(ssA, ssB, 32) != 0) bad++;
        }
        printf("         %d/%d shared secrets agreed.  --> %s\n\n",
               N - bad, N, bad ? "FAIL" : "PASS");
        fails += (bad != 0);
    }

    // ---- Test 3: Determinism (derandomized functions reproduce outputs) ------
    printf("[Test 3] Determinism: identical coins produce identical outputs\n");
    {
        uint8_t coins[2*32]; for (int i = 0; i < 64; i++) coins[i] = (uint8_t)(i * 7 + 1);
        uint8_t pk1[KYBER_PUBLICKEYBYTES], sk1[KYBER_SECRETKEYBYTES];
        uint8_t pk2[KYBER_PUBLICKEYBYTES], sk2[KYBER_SECRETKEYBYTES];
        crypto_kem_keypair_derand(pk1, sk1, coins);
        crypto_kem_keypair_derand(pk2, sk2, coins);
        uint8_t m[32]; for (int i = 0; i < 32; i++) m[i] = (uint8_t)(i * 3 + 5);
        uint8_t ct1[KYBER_CIPHERTEXTBYTES], ss1[32], ct2[KYBER_CIPHERTEXTBYTES], ss2[32];
        crypto_kem_enc_derand(ct1, ss1, pk1, m);
        crypto_kem_enc_derand(ct2, ss2, pk1, m);
        bool ok = !memcmp(pk1,pk2,sizeof pk1) && !memcmp(sk1,sk2,sizeof sk1)
               && !memcmp(ct1,ct2,sizeof ct1) && !memcmp(ss1,ss2,32);
        printf("         keypair & encaps reproducible.  --> %s\n\n", ok ? "PASS" : "FAIL");
        fails += !ok;
    }

    // ---- Test 4: Implicit rejection (FO transform) ---------------------------
    printf("[Test 4] Implicit rejection: a tampered ciphertext yields a DIFFERENT key\n");
    {
        uint8_t pk[KYBER_PUBLICKEYBYTES], sk[KYBER_SECRETKEYBYTES];
        uint8_t ct[KYBER_CIPHERTEXTBYTES], ssA[32], ssGood[32], ssBad1[32], ssBad2[32];
        crypto_kem_keypair(pk, sk);
        crypto_kem_enc(ct, ssA, pk);
        crypto_kem_dec(ssGood, ct, sk);                   // honest decaps -> matches ssA
        ct[100] ^= 0x01;                                  // flip one bit of the ciphertext
        crypto_kem_dec(ssBad1, ct, sk);                   // must NOT reveal ssA
        crypto_kem_dec(ssBad2, ct, sk);                   // rejection is deterministic
        bool honest_ok  = (memcmp(ssA, ssGood, 32) == 0);
        bool rejected   = (memcmp(ssA, ssBad1, 32) != 0);
        bool determin   = (memcmp(ssBad1, ssBad2, 32) == 0);
        printf("         honest decaps matches: %s ; tampered rejected: %s ; deterministic: %s\n",
               honest_ok?"yes":"no", rejected?"yes":"no", determin?"yes":"no");
        bool ok = honest_ok && rejected && determin;
        printf("         --> %s\n\n", ok ? "PASS" : "FAIL");
        fails += !ok;
    }

    // ---- Test 5: ByteEncode/ByteDecode are exact inverses --------------------
    printf("[Test 5] 12-bit serialization round-trips exactly\n");
    {
        poly a, b;
        std::mt19937 r(999);
        std::uniform_int_distribution<int> d(0, KYBER_Q - 1);
        for (int i = 0; i < KYBER_N; i++) a.coeffs[i] = (int16_t)d(r);
        uint8_t buf[KYBER_POLYBYTES];
        poly_tobytes(buf, &a);
        poly_frombytes(&b, buf);
        int bad = 0; for (int i = 0; i < KYBER_N; i++) if (a.coeffs[i] != b.coeffs[i]) bad++;
        printf("         %d/%d coefficients survived encode+decode.  --> %s\n\n",
               KYBER_N - bad, KYBER_N, bad ? "FAIL" : "PASS");
        fails += (bad != 0);
    }

    // ---- Test 6: Deterministic fingerprints for external cross-checking ------
    //  Fix d, z, m and print stable SHA3-256 fingerprints of every artifact.  To
    //  confirm FIPS 203 / ACVP compliance, run a trusted reference (e.g. the
    //  itzmeanjan/ml-kem library, or an ACVP vector with these exact d,z,m) and
    //  check that its ek/dk/ct/ss produce the SAME fingerprints.
    printf("[Test 6] Deterministic fingerprints (cross-check these vs. a reference)\n");
    {
        uint8_t coins[64], m[32];
        for (int i = 0; i < 32; i++) coins[i]      = 0x00;   // d = 00..00
        for (int i = 0; i < 32; i++) coins[32 + i] = 0x01;   // z = 01..01
        for (int i = 0; i < 32; i++) m[i]          = 0x02;   // m = 02..02
        uint8_t pk[KYBER_PUBLICKEYBYTES], sk[KYBER_SECRETKEYBYTES];
        uint8_t ct[KYBER_CIPHERTEXTBYTES], ss[32], ssB[32];
        crypto_kem_keypair_derand(pk, sk, coins);
        crypto_kem_enc_derand(ct, ss, pk, m);
        crypto_kem_dec(ssB, ct, sk);
        printf("         inputs: d=00..00, z=01..01, m=02..02\n");
        fingerprint("ek (public)", pk, KYBER_PUBLICKEYBYTES);
        fingerprint("dk (secret)", sk, KYBER_SECRETKEYBYTES);
        fingerprint("ct (cipher)", ct, KYBER_CIPHERTEXTBYTES);
        print_hex("ss =", ss, 32);
        printf("         decaps(ct) matches encaps ss: %s\n\n",
               memcmp(ss, ssB, 32) == 0 ? "PASS" : (fails++, "FAIL"));
    }

    printf("==================================================================\n");
    printf(" OVERALL: %s\n", fails ? "FAIL" : "ALL TESTS PASSED");
    printf("==================================================================\n");
    return fails ? 1 : 0;
}
