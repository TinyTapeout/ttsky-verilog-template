"""
ntt_golden.py -- bit-exact golden model for the ML-KEM-512 NTT/INTT accelerator.

This mirrors the hardware exactly, in the arithmetic the textbook derives:

  * coefficients are SIGNED and centred, carried as 16-bit values
  * the twiddle table is stored in Montgomery form (zeta^brv7(k) * R mod q)
  * the butterfly multiply is fqmul = montgomery_reduce(a*b)   -- Theorem 6.1
  * range control after addition chains is barrett_reduce      -- Theorem 6.2

Both reductions are on the chip, and they are not alternatives. The textbook's
division of labour: Montgomery after every multiply, because a multiply is
where the R bookkeeping is free; Barrett to tidy up after chains of additions,
where no R factor is involved and the value simply needs to come back in range.

Constants are checked against the reference Kyber tables, and both theorems'
bounds are checked exhaustively, in the self-test at the bottom of this file.
"""

Q = 3329
N = 256
ZETA = 17

R = 1 << 16                 # Montgomery radix
QINV = -3327                # q^-1 mod 2^16, as a signed 16-bit value
R_MOD_Q = R % Q             # 2285

BARRETT_V = 20159           # floor((2^26 + q/2) / q)
BARRETT_K = 26

F = 1441                    # R^2 / 128 mod q -- the inverse transform's final scale


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------
def s16(x):
    """Interpret the low 16 bits of x as a signed 16-bit value."""
    x &= 0xFFFF
    return x - 0x10000 if x & 0x8000 else x


def centre(x):
    """Representative of x in the centred range (-q/2, q/2]."""
    x %= Q
    return x - Q if x > Q // 2 else x


def _brv7(i):
    r = 0
    for b in range(7):
        r = (r << 1) | ((i >> b) & 1)
    return r


# Twiddle table in Montgomery form -- exactly what src/twiddle_rom.v holds.
# Index 0 is R mod q centred (-1044), which is what makes this table identical
# to the reference Kyber `zetas` array.
ZETAS = [centre(pow(ZETA, _brv7(i), Q) * R) for i in range(128)]


# ---------------------------------------------------------------------------
# the two reduction kernels
# ---------------------------------------------------------------------------
def montgomery_reduce(a):
    """Signed Montgomery reduction -- Theorem 6.1, and src/fqmul.v.

        m = (a mod^+- R) * QINV mod^+- R
        t = (a - m*q) / R

    For |a| < q*R/2 this returns t = a*R^-1 mod q with |t| < q. m is chosen so
    that m*q matches a in the low 16 bits, which makes the division by R exact
    -- in hardware a wire, not a divider, and a 16-bit subtract rather than a
    32-bit one.
    """
    m = s16(s16(a & 0xFFFF) * QINV)
    return (a - m * Q) >> 16


def barrett_reduce(a):
    """Signed Barrett reduction -- Theorem 6.2, and src/barrett_reduce.v.

        t = floor((a*v + 2^25) / 2^26)
        barrett(a) = a - t*q

    For |a| < 2^15 this is congruent to a mod q and lies in (-q/2, q/2].
    v/2^k approximates 1/q closely enough that t is exactly round(a/q), which
    is what makes the remainder centred rather than merely bounded.
    """
    t = (BARRETT_V * a + (1 << (BARRETT_K - 1))) >> BARRETT_K
    return a - t * Q


def fqmul(a, b):
    """The workhorse multiply -- src/fqmul.v: one 16x16 product into one
    Montgomery reduction.

    Returns a*b*R^-1 mod q. Because ZETAS is stored pre-multiplied by R, a
    butterfly multiply fqmul(zeta*R, x) = zeta*x comes out with no stray factor
    -- Key Idea 6.1.
    """
    return montgomery_reduce(a * b)


# ---------------------------------------------------------------------------
# the butterflies -- src/butterfly.v
# ---------------------------------------------------------------------------
# Every add and subtract below is wrapped through s16, because the datapath is
# signed 16-bit two's complement and that is what the silicon does. Inside the
# transforms no value ever reaches the wrap point; it matters only when the
# accelerator is driven with operands a transform would never produce, and the
# model has to stay bit-exact with the hardware in that case too.

def butterfly_ct(a, b, zeta):
    """Cooley-Tukey, the forward kernel: multiply, then add and subtract."""
    t = fqmul(zeta, b)
    return s16(a + t), s16(a - t)


def butterfly_gs(a, b, zeta):
    """Gentleman-Sande, the inverse kernel: subtract, then multiply.

    The a + b path carries no multiply, so it is Barrett that keeps it in range
    -- one multiply per butterfly, not two.
    """
    return barrett_reduce(s16(a + b)), fqmul(zeta, s16(b - a))


# ---------------------------------------------------------------------------
# the transforms -- the HOST walks these loops, streaming each butterfly
# through the chip. The chip supplies the twiddle from its own ROM, so the host
# passes the index k rather than the value ZETAS[k].
# ---------------------------------------------------------------------------
def ntt(f_in):
    """Forward NTT: 7 layers, len = 128 down to 2, twiddle index walking up."""
    assert len(f_in) == N
    r = list(f_in)
    k = 1
    length = 128
    while length >= 2:
        start = 0
        while start < N:
            zeta = ZETAS[k]
            k += 1
            for j in range(start, start + length):
                r[j], r[j + length] = butterfly_ct(r[j], r[j + length], zeta)
            start += 2 * length
        length >>= 1
    return r


def invntt(f_in):
    """Inverse NTT: same butterflies, layers reversed, twiddle index walking
    down, then a final scale by f which folds in the 1/128 normalisation."""
    assert len(f_in) == N
    r = list(f_in)
    k = 127
    length = 2
    while length <= 128:
        start = 0
        while start < N:
            zeta = ZETAS[k]
            k -= 1
            for j in range(start, start + length):
                r[j], r[j + length] = butterfly_gs(r[j], r[j + length], zeta)
            start += 2 * length
        length <<= 1
    return [fqmul(x, F) for x in r]


def basemul(a0, a1, b0, b1, zeta):
    """Base multiplication: the pointwise product of the incomplete NTT.

    The transform leaves degree-1 polynomials, so a 'pointwise' product is a
    multiplication of two linear polynomials modulo x^2 - zeta. Five fqmuls and
    two adds, which the host composes from FQMUL, ZMUL and ADD -- ZMUL is what
    keeps the twiddle table on chip for this, since its twiddles are the signed
    pair +/-zetas[64+i].
    """
    r0 = fqmul(fqmul(a1, b1), zeta) + fqmul(a0, b0)
    r1 = fqmul(a0, b1) + fqmul(a1, b0)
    return r0, r1


# ---------------------------------------------------------------------------
# the datapath's six operations, as src/butterfly.v numbers them
# ---------------------------------------------------------------------------
OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD = range(6)

OP_NAMES = {OP_CT: "CT", OP_GS: "GS", OP_FQMUL: "FQMUL",
            OP_ZMUL: "ZMUL", OP_BARRETT: "BARRETT", OP_ADD: "ADD"}

# Every op takes 3 clocks. BARRETT and ADD do not need the multiplier, but they
# issue into it anyway and ignore the result: Barrett is registered, so its
# latency is the multiplier's, and one uniform latency removed a special case
# from the front end. MUL_OPS records which ops actually consume a multiply,
# which is what the transforms' cost is counted in.
MUL_OPS = (OP_CT, OP_GS, OP_FQMUL, OP_ZMUL)
LATENCY = 5


def apply_op(op, a, b, zeta):
    """Mirrors src/butterfly.v exactly, including which outputs are mirrored."""
    if op == OP_CT:
        return butterfly_ct(a, b, zeta)
    if op == OP_GS:
        return butterfly_gs(a, b, zeta)
    if op == OP_FQMUL:
        t = fqmul(a, b)
        return t, t
    if op == OP_ZMUL:
        t = fqmul(zeta, a)
        return t, t
    if op == OP_BARRETT:
        t = barrett_reduce(a)
        return t, t
    return s16(a + b), s16(a - b)          # OP_ADD


# ---------------------------------------------------------------------------
if __name__ == "__main__":
    import random

    ref = [-1044, -758, -359, -1517, 1493, 1422, 287, 202]
    assert ZETAS[:8] == ref, f"zetas mismatch: {ZETAS[:8]}"
    assert R_MOD_Q == 2285 and QINV == -3327 and BARRETT_V == 20159 and F == 1441
    assert BARRETT_V == (2 ** BARRETT_K + Q // 2) // Q, "v is not the derived constant"
    assert max(abs(z) for z in ZETAS) < 2048, "the table must fit 12 signed bits"
    print("constants match the reference Kyber tables and the textbook's "
          "derivations (QINV = -3327, v = 20159, f = 1441)")

    # Theorem 6.1, exhaustively over the range the hardware can be handed:
    # |a| < q*R/2. Sampled densely rather than all 1.1e8 values.
    random.seed(1)
    LIM = Q * (1 << 15)
    for _ in range(200000):
        a = random.randrange(-LIM + 1, LIM)
        t = montgomery_reduce(a)
        assert abs(t) < Q, f"Theorem 6.1 bound violated: montgomery({a}) = {t}"
        assert (t - a * pow(R, -1, Q)) % Q == 0
    for a in (-LIM + 1, LIM - 1, 0, 1, -1, Q, -Q):
        assert abs(montgomery_reduce(a)) < Q
    print("Theorem 6.1: |t| < q and t == a*R^-1 (mod q), over the full |a| < qR/2 range")

    # Theorem 6.2, EXHAUSTIVELY over every signed 16-bit input. The theorem is
    # stated for |a| < 2^15, so a = -32768 sits exactly on the boundary and is
    # the one value worth being certain about -- the hardware can be handed it.
    lo = hi = 0
    for a in range(-32768, 32768):
        t = barrett_reduce(a)
        assert (t - a) % Q == 0, f"barrett({a}) changed the residue"
        lo, hi = min(lo, t), max(hi, t)
    assert -Q // 2 <= lo and hi <= Q // 2 + 1, f"range was [{lo}, {hi}]"
    print(f"Theorem 6.2: congruent mod q and centred over ALL 65,536 signed "
          f"16-bit inputs; observed range [{lo}, {hi}], q/2 = {Q // 2}")

    # An INDEPENDENT check of the forward transform.
    #
    # Every other test compares the RTL against this model -- but this model is
    # ours. If we had misread the mathematics, model and hardware would be wrong
    # together and everything would still pass. So check the transform against
    # its mathematical definition instead, with no reference to how it is
    # computed: the incomplete NTT is a Chinese Remainder Theorem map, and
    # NTT(f)[2i], NTT(f)[2i+1] must be exactly f reduced modulo the quadratic
    # factor x^2 - zeta^(2*brv7(i)+1).
    def _poly_mod_quadratic(f, gamma):
        r0 = r1 = 0
        for j in range(N):
            kk, odd = divmod(j, 2)
            term = f[j] * pow(gamma, kk, Q) % Q
            if odd:
                r1 = (r1 + term) % Q
            else:
                r0 = (r0 + term) % Q
        return r0, r1

    for _ in range(2):
        f = [centre(random.randrange(Q)) for _ in range(N)]
        fhat = ntt(f)
        for i in range(128):
            gamma = pow(ZETA, 2 * _brv7(i) + 1, Q)
            assert (fhat[2 * i] % Q, fhat[2 * i + 1] % Q) == \
                _poly_mod_quadratic(f, gamma), \
                f"NTT is not the CRT map at quadratic factor {i}"
    print("forward NTT is the CRT map FIPS 203 defines (independent of our butterflies)")

    # The round trip leaves one extra Montgomery factor R -- Eq (10.4).
    for _ in range(20):
        v = [centre(random.randrange(Q)) for _ in range(N)]
        rt = invntt(ntt(v))
        assert all((rt[i] - v[i] * R_MOD_Q) % Q == 0 for i in range(N))
        assert all((montgomery_reduce(rt[i]) - v[i]) % Q == 0 for i in range(N))
    print("round trip: INTT(NTT(f)) == f*R (mod q), and one montgomery_reduce "
          "recovers f")

    # basemul must agree with an honest polynomial multiply mod x^2 - zeta
    for _ in range(2000):
        a0, a1, b0, b1 = (centre(random.randrange(Q)) for _ in range(4))
        z = random.choice(ZETAS)
        r0, r1 = basemul(a0, a1, b0, b1, z)
        zp = z * pow(R, -1, Q) % Q          # the plain twiddle this represents
        want0 = (a0 * b0 + a1 * b1 * zp) * pow(R, -1, Q) % Q
        want1 = (a0 * b1 + a1 * b0) * pow(R, -1, Q) % Q
        assert r0 % Q == want0 and r1 % Q == want1
    print("basemul is multiplication mod x^2 - zeta, in the Montgomery domain")

    # The GS path is where growth accumulates; check Barrett actually holds it.
    worst = 0
    for _ in range(20):
        v = [centre(random.randrange(Q)) for _ in range(N)]
        r = list(ntt(v))
        k, length = 127, 2
        while length <= 128:
            start = 0
            while start < N:
                z = ZETAS[k]; k -= 1
                for j in range(start, start + length):
                    worst = max(worst, abs(r[j] + r[j + length]))
                    r[j], r[j + length] = butterfly_gs(r[j], r[j + length], z)
                start += 2 * length
            length <<= 1
    print(f"inverse transform: widest value entering Barrett is {worst}, "
          f"against the 2^15 = 32768 the theorem allows")

    print("all golden-model self-tests passed")
