// ============================================================================
//  sha3.hpp  -  Self-contained SHA-3 / SHAKE (Keccak) for ML-KEM
// ----------------------------------------------------------------------------
//  ML-KEM (FIPS 203) uses four Keccak-based functions:
//     H  = SHA3-256      (hash the encapsulation key, etc.)
//     G  = SHA3-512      (derive (rho, sigma) and (K, r))
//     J  = SHAKE256      (implicit-rejection secret)
//     PRF/XOF = SHAKE256 / SHAKE128 (noise sampling and matrix expansion)
//
//  This file implements the Keccak-f[1600] permutation and a small sponge on
//  top of it.  It has NO external dependencies so it compiles anywhere and is
//  easy to read and reason about on its own.
//
//  ENDIANNESS NOTE: the byte<->lane conversions below are written explicitly as
//  little-endian (load64_le / bit-shift extraction), so the code is correct on
//  any machine, not just little-endian x86.
//
//  HOW TO TRUST THIS FILE: call sha3_selftest().  It checks our output against
//  NIST's published digests (Known-Answer Tests).  If those pass, the Keccak
//  core and padding are correct.  That is how a hash implementation is verified
//  in practice -- you never "prove" it by inspection, you match known vectors.
// ============================================================================
#pragma once
#include <cstdint>   // fixed-width integer types (uint64_t, uint8_t, ...)
#include <cstddef>   // size_t
#include <cstring>   // memcpy, memset

namespace sha3 {

// Rotate a 64-bit word left by n bits (Keccak's basic mixing operation).
static inline uint64_t ROTL64(uint64_t x, unsigned n) {
    return (x << n) | (x >> (64 - n));
}

// ---- Keccak-f[1600] round constants (iota step), one per of the 24 rounds ----
static const uint64_t KECCAK_RC[24] = {
    0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
    0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008aULL,
    0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
    0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL,
    0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800aULL, 0x800000008000000aULL, 0x8000000080008081ULL,
    0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
};
// Rotation offsets for the rho step (how far each lane is rotated).
static const int KECCAK_ROTC[24] = {
    1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
    27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
};
// Lane permutation indices for the pi step (where each lane moves to).
static const int KECCAK_PILN[24] = {
    10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
    15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
};

// The Keccak-f[1600] permutation: 24 rounds of theta, rho, pi, chi, iota,
// applied in place to the 25-lane (5x5x64-bit) state.
static inline void keccakf(uint64_t st[25]) {
    uint64_t t, bc[5];
    for (int r = 0; r < 24; r++) {
        // -- theta: XOR-fold columns and diffuse them across the state --
        for (int i = 0; i < 5; i++)
            bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15] ^ st[i + 20];
        for (int i = 0; i < 5; i++) {
            t = bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1);
            for (int j = 0; j < 25; j += 5)
                st[j + i] ^= t;
        }
        // -- rho + pi: rotate each lane and move it to a new position --
        t = st[1];
        for (int i = 0; i < 24; i++) {
            int j = KECCAK_PILN[i];
            bc[0] = st[j];
            st[j] = ROTL64(t, KECCAK_ROTC[i]);
            t = bc[0];
        }
        // -- chi: nonlinear step, each lane XORed with a function of two others --
        for (int j = 0; j < 25; j += 5) {
            for (int i = 0; i < 5; i++)
                bc[i] = st[j + i];
            for (int i = 0; i < 5; i++)
                st[j + i] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];
        }
        // -- iota: break symmetry by XORing in the round constant --
        st[0] ^= KECCAK_RC[r];
    }
}

// Load 8 bytes as a little-endian 64-bit lane.
static inline uint64_t load64_le(const uint8_t* x) {
    uint64_t r = 0;
    for (int i = 0; i < 8; i++) r |= (uint64_t)x[i] << (8 * i);
    return r;
}

// -------------------- Generic sponge: absorb then squeeze --------------------
// Absorb the whole message into a fresh state.  `rate` is the block size in
// bytes; `delim` is the domain-separation/padding byte (0x06 for SHA3, 0x1F for
// SHAKE).  After this call the last block is XORed in but NOT yet permuted, so
// the squeeze phase must permute first.
static inline void keccak_absorb(uint64_t s[25], unsigned rate,
                                 const uint8_t* in, size_t inlen, uint8_t delim) {
    for (int i = 0; i < 25; i++) s[i] = 0;                 // zero the state
    while (inlen >= rate) {                                // absorb full blocks
        for (unsigned i = 0; i < rate / 8; i++)
            s[i] ^= load64_le(in + 8 * i);
        keccakf(s);
        in += rate; inlen -= rate;
    }
    uint8_t tmp[200];                                      // final padded block
    memset(tmp, 0, sizeof(tmp));
    memcpy(tmp, in, inlen);
    tmp[inlen] = delim;                                    // pad10*1 start bit
    tmp[rate - 1] |= 0x80;                                 // pad10*1 end bit
    for (unsigned i = 0; i < rate / 8; i++)
        s[i] ^= load64_le(tmp + 8 * i);
}

// Squeeze `outlen` bytes out of the state (permuting once per block).
static inline void keccak_squeeze(uint8_t* out, size_t outlen,
                                  uint64_t s[25], unsigned rate) {
    while (outlen > 0) {
        keccakf(s);
        unsigned n = (outlen < rate) ? (unsigned)outlen : rate;
        for (unsigned i = 0; i < n; i++)
            out[i] = (uint8_t)(s[i >> 3] >> (8 * (i & 7)));  // byte i of lane i/8
        out += n; outlen -= n;
    }
}

// One-shot hash/XOF convenience wrapper.
static inline void keccak(uint8_t* out, size_t outlen, unsigned rate,
                          const uint8_t* in, size_t inlen, uint8_t delim) {
    uint64_t s[25];
    keccak_absorb(s, rate, in, inlen, delim);
    keccak_squeeze(out, outlen, s, rate);
}

// -------- Named functions used by ML-KEM (rates from the FIPS 202 table) -----
static inline void sha3_256(uint8_t out[32], const uint8_t* in, size_t inlen) {
    keccak(out, 32, 136, in, inlen, 0x06);        // capacity 512, rate 136
}
static inline void sha3_512(uint8_t out[64], const uint8_t* in, size_t inlen) {
    keccak(out, 64, 72, in, inlen, 0x06);         // capacity 1024, rate 72
}
static inline void shake128(uint8_t* out, size_t outlen, const uint8_t* in, size_t inlen) {
    keccak(out, outlen, 168, in, inlen, 0x1F);    // rate 168
}
static inline void shake256(uint8_t* out, size_t outlen, const uint8_t* in, size_t inlen) {
    keccak(out, outlen, 136, in, inlen, 0x1F);    // rate 136
}

// -------------------- Streaming XOF (SHAKE128) for SampleNTT -----------------
// Matrix generation needs an unbounded stream of pseudorandom bytes; we absorb
// once, then pull 168-byte blocks on demand until enough coefficients accepted.
static const unsigned SHAKE128_RATE = 168;
struct xof_state { uint64_t s[25]; };

// Absorb seed(32 bytes) || x || y as the XOF input (FIPS 203 XOF(rho, i, j)).
static inline void xof_absorb(xof_state& st, const uint8_t seed[32],
                              uint8_t x, uint8_t y) {
    uint8_t buf[34];
    memcpy(buf, seed, 32);
    buf[32] = x;
    buf[33] = y;
    keccak_absorb(st.s, SHAKE128_RATE, buf, 34, 0x1F);
}
// Squeeze `nblocks` full 168-byte blocks out of the XOF state.
static inline void xof_squeezeblocks(uint8_t* out, size_t nblocks, xof_state& st) {
    while (nblocks--) {
        keccakf(st.s);
        for (unsigned i = 0; i < SHAKE128_RATE; i++)
            out[i] = (uint8_t)(st.s[i >> 3] >> (8 * (i & 7)));
        out += SHAKE128_RATE;
    }
}

// -------------- Incremental sponge: absorb*, finalize, squeeze* ---------------
//  Needed for the accumulated cross-check test, where we feed a long stream of
//  values into a running SHAKE-128 hash, and use SHAKE-128 as a stream RNG.
//  Usage: inc_init -> inc_absorb (any number of times) -> inc_finalize -> inc_squeeze*.
struct keccak_inc { uint64_t s[25]; unsigned pos; };  // pos = byte offset in the current block

inline void inc_init(keccak_inc& st) { for (int i = 0; i < 25; i++) st.s[i] = 0; st.pos = 0; }

inline void inc_absorb(keccak_inc& st, unsigned rate, const uint8_t* in, size_t len) {
    while (len--) {
        st.s[st.pos >> 3] ^= (uint64_t)(*in++) << (8 * (st.pos & 7)); // XOR byte into the lane
        if (++st.pos == rate) { keccakf(st.s); st.pos = 0; }          // permute when block fills
    }
}
inline void inc_finalize(keccak_inc& st, unsigned rate, uint8_t delim) {
    st.s[st.pos >> 3]       ^= (uint64_t)delim << (8 * (st.pos & 7));       // pad10*1 start
    st.s[(rate - 1) >> 3]   ^= (uint64_t)0x80  << (8 * ((rate - 1) & 7));   // pad10*1 end
    keccakf(st.s); st.pos = 0;                                             // switch to squeezing
}
inline void inc_squeeze(keccak_inc& st, unsigned rate, uint8_t* out, size_t len) {
    while (len--) {
        if (st.pos == rate) { keccakf(st.s); st.pos = 0; }  // permute when block is exhausted
        *out++ = (uint8_t)(st.s[st.pos >> 3] >> (8 * (st.pos & 7)));
        st.pos++;
    }
}

// ============================ Known-Answer Tests ============================
// Compare our output to NIST's published digests.  Returns true iff all match.
// This is the concrete answer to "how do I verify a hash?": match known vectors.
static inline bool bytes_equal(const uint8_t* a, const uint8_t* b, size_t n) {
    for (size_t i = 0; i < n; i++) if (a[i] != b[i]) return false;
    return true;
}
static inline bool sha3_selftest() {
    bool ok = true;
    uint8_t out[64];

    // SHA3-256("") = a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a
    const uint8_t sha3_256_empty[32] = {
        0xa7,0xff,0xc6,0xf8,0xbf,0x1e,0xd7,0x66,0x51,0xc1,0x47,0x56,0xa0,0x61,0xd6,0x62,
        0xf5,0x80,0xff,0x4d,0xe4,0x3b,0x49,0xfa,0x82,0xd8,0x0a,0x4b,0x80,0xf8,0x43,0x4a};
    sha3_256(out, (const uint8_t*)"", 0);
    ok &= bytes_equal(out, sha3_256_empty, 32);

    // SHA3-256("abc") = 3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532
    const uint8_t sha3_256_abc[32] = {
        0x3a,0x98,0x5d,0xa7,0x4f,0xe2,0x25,0xb2,0x04,0x5c,0x17,0x2d,0x6b,0xd3,0x90,0xbd,
        0x85,0x5f,0x08,0x6e,0x3e,0x9d,0x52,0x5b,0x46,0xbf,0xe2,0x45,0x11,0x43,0x15,0x32};
    sha3_256(out, (const uint8_t*)"abc", 3);
    ok &= bytes_equal(out, sha3_256_abc, 32);

    // SHA3-512("") first 16 bytes = a69f73cca23a9ac5c8b567dc185a756e ...
    const uint8_t sha3_512_empty16[16] = {
        0xa6,0x9f,0x73,0xcc,0xa2,0x3a,0x9a,0xc5,0xc8,0xb5,0x67,0xdc,0x18,0x5a,0x75,0x6e};
    sha3_512(out, (const uint8_t*)"", 0);
    ok &= bytes_equal(out, sha3_512_empty16, 16);

    // SHAKE128("", 32) = 7f9c2ba4e88f827d616045507605853ed73b8093f6efbc88eb1a6eacfa66ef26
    const uint8_t shake128_empty[32] = {
        0x7f,0x9c,0x2b,0xa4,0xe8,0x8f,0x82,0x7d,0x61,0x60,0x45,0x50,0x76,0x05,0x85,0x3e,
        0xd7,0x3b,0x80,0x93,0xf6,0xef,0xbc,0x88,0xeb,0x1a,0x6e,0xac,0xfa,0x66,0xef,0x26};
    shake128(out, 32, (const uint8_t*)"", 0);
    ok &= bytes_equal(out, shake128_empty, 32);

    // SHAKE256("", 32) = 46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762f
    const uint8_t shake256_empty[32] = {
        0x46,0xb9,0xdd,0x2b,0x0b,0xa8,0x8d,0x13,0x23,0x3b,0x3f,0xeb,0x74,0x3e,0xeb,0x24,
        0x3f,0xcd,0x52,0xea,0x62,0xb8,0x1b,0x82,0xb5,0x0c,0x27,0x64,0x6e,0xd5,0x76,0x2f};
    shake256(out, 32, (const uint8_t*)"", 0);
    ok &= bytes_equal(out, shake256_empty, 32);

    // Incremental SHAKE-128 must reproduce the one-shot result exactly.
    {
        uint8_t a[40], b[40];
        shake128(a, 40, (const uint8_t*)"abc", 3);
        keccak_inc st; inc_init(st);
        inc_absorb(st, SHAKE128_RATE, (const uint8_t*)"ab", 2);   // absorb in two chunks
        inc_absorb(st, SHAKE128_RATE, (const uint8_t*)"c", 1);
        inc_finalize(st, SHAKE128_RATE, 0x1F);
        inc_squeeze(st, SHAKE128_RATE, b, 40);
        ok &= bytes_equal(a, b, 40);
    }

    return ok;
}

} // namespace sha3
