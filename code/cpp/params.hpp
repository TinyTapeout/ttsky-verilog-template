// ============================================================================
//  params.hpp  -  ML-KEM-512 parameter set (FIPS 203, security category 1)
// ----------------------------------------------------------------------------
//  ML-KEM-512 is the *smallest* standardized parameter set, so it is the right
//  simplest starting point to learn from.  Every size below is fixed by the
//  standard; changing KYBER_K to 3 or 4 would give ML-KEM-768 / ML-KEM-1024.
// ============================================================================
#pragma once
#include <cstdint>
#include <array>

namespace mlkem {

// ---- Core algebraic parameters (identical across all ML-KEM sizes) ----------
constexpr int KYBER_N = 256;   // polynomial degree: 256 coefficients per poly
constexpr int KYBER_Q = 3329;  // prime modulus; coefficients live in Z_3329
constexpr int KYBER_SYMBYTES = 32;  // byte length of seeds/hashes (256 bits)
constexpr int KYBER_SSBYTES  = 32;  // shared-secret length in bytes

// ---- ML-KEM-512-specific parameters -----------------------------------------
constexpr int KYBER_K    = 2;  // module rank -> ML-KEM-512 (vectors have 2 polys)
constexpr int KYBER_ETA1 = 3;  // CBD parameter for secret s, error e, and y
constexpr int KYBER_ETA2 = 2;  // CBD parameter for e1 and e2
constexpr int KYBER_DU   = 10; // bits per coefficient when compressing u (c1)
constexpr int KYBER_DV   = 4;  // bits per coefficient when compressing v (c2)

// ---- Derived byte sizes -----------------------------------------------------
// One polynomial serialized at 12 bits/coeff: 256 * 12 / 8 = 384 bytes.
constexpr int KYBER_POLYBYTES    = 384;
constexpr int KYBER_POLYVECBYTES = KYBER_K * KYBER_POLYBYTES;         // 768

// Compressed polynomial sizes (used only inside the ciphertext).
constexpr int KYBER_POLYCOMPRESSEDBYTES    = KYBER_N * KYBER_DV / 8;  // 128 (dv=4)
constexpr int KYBER_POLYVECCOMPRESSEDBYTES = KYBER_K * (KYBER_N * KYBER_DU / 8); // 640 (du=10)

// K-PKE (the internal public-key encryption) key/ciphertext sizes.
constexpr int KYBER_INDCPA_PUBLICKEYBYTES = KYBER_POLYVECBYTES + KYBER_SYMBYTES; // 800 (t_hat || rho)
constexpr int KYBER_INDCPA_SECRETKEYBYTES = KYBER_POLYVECBYTES;                  // 768 (s_hat)
constexpr int KYBER_INDCPA_BYTES = KYBER_POLYVECCOMPRESSEDBYTES + KYBER_POLYCOMPRESSEDBYTES; // 768 (c1||c2)

// ML-KEM (the KEM wrapping K-PKE with the Fujisaki-Okamoto transform).
constexpr int KYBER_PUBLICKEYBYTES  = KYBER_INDCPA_PUBLICKEYBYTES;   // 800
// Secret key = dk_PKE || ek_PKE || H(ek) || z
constexpr int KYBER_SECRETKEYBYTES  = KYBER_INDCPA_SECRETKEYBYTES
                                    + KYBER_INDCPA_PUBLICKEYBYTES
                                    + 2 * KYBER_SYMBYTES;             // 1632
constexpr int KYBER_CIPHERTEXTBYTES = KYBER_INDCPA_BYTES;            // 768

// A polynomial is 256 signed 16-bit coefficients.  16 bits is a safe, comfortable
// choice: a single coefficient lies in 0..3328 and so needs only 12 bits, while a
// product of two coefficients reaches up to 24 bits before modular reduction.
// Those two facts are exactly why the code stores a coefficient in an int16_t and
// forms every product in a wider int32_t (see reduce.hpp).
using poly_t = std::array<int16_t, KYBER_N>;

} // namespace mlkem
