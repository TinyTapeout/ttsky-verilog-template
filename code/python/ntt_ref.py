#!/usr/bin/env python3
# ============================================================================
#  ntt_ref.py  -  Bit-exact Python reference for the ML-KEM-512 NTT / INTT
# ----------------------------------------------------------------------------
#  This is the "golden model": a pure-Python port of the C++ reference
#  (reduce.hpp / ntt.hpp) that reproduces the SAME signed 16-/32-bit
#  two's-complement values at every step.  Both the C++ tests and the Verilog
#  RTL are checked against this model, and it is used to generate every test
#  vector fed to the Vivado simulations.
#
#  Constraints (ML-KEM-512, FIPS 203):
#      q = 3329 (prime modulus)      n = 256 (coefficients)
#      zeta = 17 (primitive 256th root of unity)   max coeff width = 12 bits
#      forward NTT = 7 layers (len = 128,64,32,16,8,4,2), 128 butterflies each
#                  = 896 butterfly operations, using 127 distinct twiddles.
# ============================================================================

Q     = 3329
N     = 256
QINV  = -3327        # q^-1 mod 2^16   (montgomery_reduce)
MONT  = -1044        # 2^16 mod q (signed)
MONT_R = 2285        # 2^16 mod q (unsigned) = R, the residual round-trip factor
F_INV = 1441         # mont^2 / 128    (invntt final scale)

# The 128 precomputed twiddle factors, bit-reversed and in Montgomery form,
# IDENTICAL to the C++ zetas[] table in ntt.hpp (indices 1..127 are used by the
# forward NTT, i.e. 127 distinct twiddles; index 0 is used only by invntt scan).
ZETAS = [
    -1044,  -758,  -359, -1517,  1493,  1422,   287,   202,
     -171,   622,  1577,   182,   962, -1202, -1474,  1468,
      573, -1325,   264,   383,  -829,  1458, -1602,  -130,
     -681,  1017,   732,   608, -1542,   411,  -205, -1571,
     1223,   652,  -552,  1015, -1293,  1491,  -282, -1544,
      516,    -8,  -320,  -666, -1618, -1162,   126,  1469,
     -853,   -90,  -271,   830,   107, -1421,  -247,  -951,
     -398,   961, -1508,  -725,   448, -1065,   677, -1275,
    -1103,   430,   555,   843, -1251,   871,  1550,   105,
      422,   587,   177,  -235,  -291,  -460,  1574,  1653,
     -246,   778,  1159,  -147,  -777,  1483,  -602,  1119,
    -1590,   644,  -872,   349,   418,   329,  -156,   -75,
      817,  1097,   603,   610,  1322, -1285, -1465,   384,
    -1215,  -136,  1218, -1335,  -874,   220, -1187, -1659,
    -1185, -1530, -1278,   794, -1510,  -854,  -870,   478,
     -108,  -308,   996,   991,   958, -1460,  1522,  1628,
]
assert len(ZETAS) == 128


# ------------------------- signed integer emulation -------------------------
def s16(x):
    """Truncate to a signed 16-bit two's-complement value, like (int16_t)x."""
    x &= 0xFFFF
    return x - 0x10000 if x & 0x8000 else x


def montgomery_reduce(a):
    """a: 32-bit signed product; returns a * 2^-16 (mod q), |result| < q."""
    t = s16(s16(a) * QINV)          # (int16_t)((int16_t)a * QINV)
    t = s16((a - t * Q) >> 16)      # (int16_t)((a - t*q) >> 16), arithmetic shift
    return t


def barrett_reduce(a):
    """a: signed 16-bit; returns a value == a (mod q) in a centered range."""
    v = (( 1 << 26) + Q // 2) // Q  # 20159
    t = s16((v * a + (1 << 25)) >> 26)
    t = s16(t * Q)
    return s16(a - t)


def fqmul(a, b):
    """Montgomery-domain modular multiply of two signed-16 values."""
    return montgomery_reduce(s16(a) * s16(b))


def to_canonical(a):
    """Map a signed representative into [0, q)."""
    t = a % Q
    return t + Q if t < 0 else t


# ------------------------------- forward NTT --------------------------------
def ntt(r):
    """In-place forward NTT (Cooley-Tukey), bit-exact to ntt.hpp::ntt()."""
    r = list(r)
    k = 1
    length = 128
    while length >= 2:
        start = 0
        while start < N:
            zeta = ZETAS[k]; k += 1
            for j in range(start, start + length):
                t = fqmul(zeta, r[j + length])
                r[j + length] = s16(r[j] - t)
                r[j]          = s16(r[j] + t)
            start += 2 * length
        length >>= 1
    return r


# ------------------------------- inverse NTT --------------------------------
def invntt(r):
    """In-place inverse NTT (Gentleman-Sande), bit-exact to ntt.hpp::invntt()."""
    r = list(r)
    k = 127
    length = 2
    while length <= 128:
        start = 0
        while start < N:
            zeta = ZETAS[k]; k -= 1
            for j in range(start, start + length):
                t = r[j]
                r[j]          = barrett_reduce(s16(t + r[j + length]))
                r[j + length] = s16(r[j + length] - t)
                r[j + length] = fqmul(zeta, r[j + length])
            start += 2 * length
        length <<= 1
    for j in range(N):
        r[j] = fqmul(r[j], F_INV)   # fold in 1/128 and Montgomery factor
    return r


# ------------------------ NTT / INTT round-trip -----------------------------
#  The ML-KEM invntt() is *deliberately* not a bare inverse of ntt(): to stay
#  cheap it leaves every output multiplied by one Montgomery factor R = 2^16.
#  Concretely, for any polynomial f,
#
#        invntt(ntt(f)) == f * R   (mod q),   R = 2^16 mod q = 2285.
#
#  In real ML-KEM this residual R is absorbed by the surrounding basemul (that
#  is why poly_mul below is exact).  To demonstrate a *pure* INTT(NTT(f)) == f
#  round-trip we cancel that one factor with a single Montgomery reduction,
#  since montgomery_reduce(x) == x * R^{-1} (mod q):
#
#        montgomery_reduce(f * R) == f.
#
#  This costs exactly one extra multiply+reduce per coefficient (256 total) and
#  is the same correction the round-trip testbench applies in hardware.
def ntt_roundtrip(f):
    """Return canonical(INTT(NTT(f))) == f, cancelling the residual R factor."""
    g = invntt(ntt(f))
    return [to_canonical(montgomery_reduce(x)) for x in g]


# --------------------- base-case (pointwise) multiplication -----------------
def basemul(a0, a1, b0, b1, zeta):
    r0 = fqmul(a1, b1)
    r0 = fqmul(r0, zeta)
    r0 = s16(r0 + fqmul(a0, b0))
    r1 = fqmul(a0, b1)
    r1 = s16(r1 + fqmul(a1, b0))
    return r0, r1


# ----------------------- NTT-based polynomial multiply ----------------------
def poly_mul(a_in, b_in):
    """c = a*b in R_q, via NTT/basemul/INTT.  Matches test_ntt.cpp exactly."""
    a = ntt(a_in); a = [barrett_reduce(x) for x in a]
    b = ntt(b_in); b = [barrett_reduce(x) for x in b]
    c = [0] * N
    for i in range(N // 4):
        c[4*i], c[4*i+1] = basemul(a[4*i],   a[4*i+1], b[4*i],   b[4*i+1],  ZETAS[64 + i])
        c[4*i+2], c[4*i+3] = basemul(a[4*i+2], a[4*i+3], b[4*i+2], b[4*i+3], s16(-ZETAS[64 + i]))
    c = invntt(c)
    out = []
    for x in c:
        t = barrett_reduce(x)
        t = s16(t + ((t >> 15) & Q))   # canonicalize to [0,q)
        out.append(t)
    return out


# --------------------------- schoolbook reference ---------------------------
def schoolbook(a, b):
    """Ground-truth negacyclic multiply in R_q = Z_q[x]/(x^256+1)."""
    tmp = [0] * (2 * N)
    for i in range(N):
        for j in range(N):
            tmp[i + j] += a[i] * b[j]
    c = [0] * N
    for i in range(N):
        v = (tmp[i] - tmp[i + N]) % Q
        c[i] = v
    return c


# ------------------------------- self-test ----------------------------------
if __name__ == "__main__":
    import random
    random.seed(0xA5A5)

    print("=" * 66)
    print(f" PYTHON NTT REFERENCE SELF-TEST  (q={Q}, n={N}, zeta=17)")
    print("=" * 66)

    # 1) NTT-based multiply == schoolbook
    fails = 0
    for _ in range(500):
        a = [random.randrange(Q) for _ in range(N)]
        b = [random.randrange(Q) for _ in range(N)]
        if poly_mul(a, b) != schoolbook(a, b):
            fails += 1
    print(f"[1] poly_mul == schoolbook over 500 trials : "
          f"{'PASS' if not fails else f'FAIL ({fails})'}")

    # 2) round-trip: does INTT(NTT(f)) recover f?  The bare invntt(ntt(f))
    #    equals f*R (mont factor); ntt_roundtrip() cancels the one R with a
    #    single Montgomery reduction, so the recovered polynomial equals f.
    rt_fails = raw_fails = 0
    for _ in range(500):
        f = [random.randrange(Q) for _ in range(N)]
        if ntt_roundtrip(f) != f:
            rt_fails += 1
        # show that the *bare* round-trip is off by exactly R = 2285
        raw = [to_canonical(x) for x in invntt(ntt(f))]
        if raw != [(x * MONT_R) % Q for x in f]:
            raw_fails += 1
    print(f"[2] canonical(INTT(NTT(f))) == f (500)     : "
          f"{'PASS' if not rt_fails else f'FAIL ({rt_fails})'}")
    print(f"    (bare invntt(ntt(f)) == f*R, R={MONT_R}      : "
          f"{'confirmed' if not raw_fails else f'UNEXPECTED ({raw_fails})'})")

    # 3) a tiny concrete example (eyeball)
    a = [0]*N; b = [0]*N
    a[0],a[1],a[2],a[3] = 1,2,3,4
    b[0],b[1],b[2],b[3] = 5,6,7,8
    c = poly_mul(a, b)
    print(f"[3] (1+2x+3x^2+4x^3)*(5+6x+7x^2+8x^3) -> {c[:7]}")
    print(f"    schoolbook                          -> {schoolbook(a,b)[:7]}")
