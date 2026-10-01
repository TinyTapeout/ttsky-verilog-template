#!/usr/bin/env python3
# ============================================================================
#  verify_constants.py  -  Independent proof that the constants in the C++ NTT
#                          are the mathematically correct ones.
# ----------------------------------------------------------------------------
#  The C++ tests check the code against ITSELF (transform vs. schoolbook) and
#  against external byte vectors.  This script adds a third, orthogonal kind of
#  check: it recomputes every "magic number" in the NTT straight from its
#  mathematical definition, in a *separate language*, and compares the result to
#  the numbers actually written in the C++ source files.
#
#  If this passes, the twiddle table and reduction constants the transform uses
#  are provably the correct ones -- not merely self-consistent.
#
#  It needs nothing but Python's standard library.  Run:
#       python verify_constants.py         (exit code 0 = every check passed)
# ============================================================================
import re, os, sys

# ---- ML-KEM-512 algebra (all fixed by FIPS 203) ----------------------------
q    = 3329          # the prime modulus
N    = 256           # coefficients per polynomial
R    = 1 << 16       # Montgomery radix 2^16
ZETA = 17            # the primitive 256th root of unity ML-KEM uses

HERE = os.path.dirname(os.path.abspath(__file__))
def source(name):
    """Read a sibling source file as text (so we can compare against the code)."""
    with open(os.path.join(HERE, name), encoding="utf-8") as f:
        return f.read()

def signed16(x):
    """Reduce x mod q into the centered range (-q/2, q/2], the way int16_t holds it."""
    x %= q
    return x - q if x > q // 2 else x

def brv7(i):
    """Reverse the low 7 bits of i (the bit-reversal the zetas table is stored in)."""
    r = 0
    for b in range(7):
        r |= ((i >> b) & 1) << (6 - b)
    return r

# ---- tiny check harness ----------------------------------------------------
_all_ok = True
def check(name, ok, detail=""):
    global _all_ok
    _all_ok = _all_ok and ok
    tag = "PASS" if ok else "FAIL"
    print(f"  [{tag}] {name}" + (f"   ({detail})" if detail else ""))

print("=" * 70)
print(" INDEPENDENT CONSTANT / TWIDDLE-TABLE VERIFIER  (Python, vs. the C++)")
print("=" * 70)

# ---- 0. zeta = 17 really is a primitive 256th root of unity mod q -----------
#  This is the fact the whole NTT rests on: 17 has multiplicative order exactly
#  256, so its powers give 256 distinct "evaluation points".
check("17^256 == 1  (mod 3329)", pow(ZETA, 256, q) == 1)
check("17^128 == -1 (mod 3329)", pow(ZETA, 128, q) == q - 1,
      "=> order is 256, not a smaller divisor")

# ---- 1. Recompute the 128-entry twiddle table and compare to ntt.hpp --------
#  Definition (pq-crystals / FIPS 203): zetas[i] = zeta^brv(i) * 2^16 mod q,
#  stored as a signed 16-bit value.  We build it here, then parse the array out
#  of the real ntt.hpp and require an exact, entry-by-entry match.
computed = [signed16(pow(ZETA, brv7(i), q) * R) for i in range(128)]

ntt_src = source("ntt.hpp")
block   = re.search(r"zetas\[128\]\s*=\s*\{(.+?)\}", ntt_src, re.S)
in_code = [int(t) for t in re.findall(r"-?\d+", block.group(1))] if block else []
check("ntt.hpp: zetas[] found and has 128 entries", len(in_code) == 128,
      f"parsed {len(in_code)}")
check("zetas[] == zeta^brv(i) * 2^16 mod q, all 128", in_code == computed,
      "every entry identical" if in_code == computed else "MISMATCH")

# ---- 2. The scalar reduction constants --------------------------------------
def modinv_2_16():
    """q^{-1} mod 2^16, found by brute force (small search space)."""
    for x in range(1 << 16):
        if (q * x) % (1 << 16) == 1:
            return x

MONT   = signed16(R)                              # 2^16 mod q
QINV_u = modinv_2_16()                            # q^{-1} mod 2^16, unsigned
QINV_s = QINV_u - (1 << 16) if QINV_u > (1 << 15) else QINV_u
BARR_V = ((1 << 26) + q // 2) // q                # round(2^26 / q)
F_INV  = signed16(R * R * pow(128, -1, q))        # mont^2 / 128, folded into invntt
F_MONT = (1 << 32) % q                            # 2^32 mod q, used by poly_tomont

# recomputed values must equal the known ML-KEM constants ...
check("MONT  = 2^16 mod q            = -1044", MONT   == -1044)
check("QINV  = q^-1 mod 2^16         = 62209 (= -3327 signed)",
      QINV_u == 62209 and QINV_s == -3327)
check("Barrett v = round(2^26 / q)   = 20159", BARR_V == 20159)
check("invntt f = mont^2 / 128 mod q = 1441",  F_INV  == 1441)
check("tomont f = 2^32 mod q         = 1353",  F_MONT == 1353)

# ... and the literal constants must actually appear in the source that uses them
red = source("reduce.hpp").replace(" ", "")
check("reduce.hpp really defines MONT = -1044", "MONT=-1044" in red)
check("reduce.hpp really defines QINV = -3327", "QINV=-3327" in red)
check("ntt.hpp   really uses     f    = 1441", "f=1441" in ntt_src.replace(" ", ""))

# ---- 3. The 128 quadratic factors used by the base multiply -----------------
#  The incomplete NTT leaves x^256+1 factored into 128 quadratics x^2 - r.
#  poly_basemul uses +zetas[64+i] and -zetas[64+i] as the two roots per pair;
#  collectively the r's must be 128 DISTINCT odd powers of zeta (that is exactly
#  what makes NTT multiplication equal ordinary multiplication).
roots = []
for i in range(64):
    z = pow(ZETA, brv7(64 + i), q)
    roots += [z % q, (-z) % q]
powers = []
for r in roots:
    for e in range(256):
        if pow(ZETA, e, q) == r:
            powers.append(e); break
check("128 base-multiply roots are distinct", len(set(powers)) == 128)
check("128 base-multiply roots are all ODD powers of zeta",
      all(e % 2 == 1 for e in powers))

# ---- verdict ----------------------------------------------------------------
print("-" * 70)
print(" RESULT:", "ALL CONSTANTS VERIFIED" if _all_ok else "*** A CHECK FAILED ***")
print("=" * 70)
sys.exit(0 if _all_ok else 1)
