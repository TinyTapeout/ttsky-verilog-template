#!/usr/bin/env python3
# ============================================================================
#  gen_intt_vectors.py  -  Golden vectors for the INVERSE NTT accelerator and
#                          for the full NTT+INTT round-trip.
# ----------------------------------------------------------------------------
#  Reuses the bit-exact Python reference (code/python/ntt_ref.py), which itself
#  reproduces the signed 16-bit two's-complement values of the C++ ntt.hpp, so
#  the intt_engine / round-trip RTL can be checked bit-for-bit.
#
#  Writes two .mem files (same layout as gen_ntt_vectors.cpp):
#
#    vectors/intt_vectors.mem
#        <T>
#        per test:  256 input coeffs (hex16, an NTT-domain vector)
#                   256 output coeffs (hex16) = invntt(input)   [raw, ntt.hpp-exact]
#
#    vectors/roundtrip_vectors.mem
#        <T>
#        per test:  256 input coeffs (hex16) = a random f in [0,q)
#                   256 output coeffs (hex16) = f   (the SAME polynomial)
#        The hardware computes intt_engine(ntt_engine(f)) and then applies one
#        Montgomery reduction (cancelling the residual R=2^16 factor) and must
#        reproduce f exactly.
#
#  RUN (from code/verilog/tb/):  python3 gen_intt_vectors.py
# ============================================================================
import os, sys, random

# import the golden reference from ../../python
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "..", "python"))
import ntt_ref as R

Q, N = R.Q, R.N


def h16(x):
    """signed value -> 4-digit hex of its 16-bit two's-complement pattern."""
    return f"{x & 0xFFFF:04x}"


def edge_polys():
    """A few structured edge cases (mirrors gen_ntt_vectors.cpp)."""
    yield [0] * N                                     # zero
    p = [0] * N; p[0] = 1; yield p                    # impulse
    yield [Q - 1] * N                                 # all q-1
    yield [i % Q for i in range(N)]                   # ramp
    yield [(1 if (i & 1) else -1) for i in range(N)]  # alternating +/-1


def main():
    os.makedirs(os.path.join(HERE, "vectors"), exist_ok=True)
    rng = random.Random(0xBEEF)
    NRAND = 1000   # thousands of random cases across the two files

    # ---------------- inverse-NTT vectors ----------------
    # inputs live in the NTT domain: take ntt(random poly), barrett_reduce it
    # (exactly how invntt is fed inside poly_mul), then golden = invntt(input).
    intt_path = os.path.join(HERE, "vectors", "intt_vectors.mem")
    with open(intt_path, "w") as f:
        cases = list(edge_polys())
        cases += [[rng.randrange(Q) for _ in range(N)] for _ in range(NRAND)]
        f.write(f"{len(cases)}\n")
        for poly in cases:
            xin = [R.barrett_reduce(x) for x in R.ntt(poly)]  # NTT-domain input
            xout = R.invntt(xin)                              # ntt.hpp-exact invntt
            for v in xin:  f.write(h16(v) + "\n")
            for v in xout: f.write(h16(v) + "\n")
    print(f"wrote {intt_path}  ({len(cases)} inverse-NTT cases)")

    # ---------------- round-trip vectors ----------------
    rt_path = os.path.join(HERE, "vectors", "roundtrip_vectors.mem")
    with open(rt_path, "w") as f:
        cases = list(edge_polys())
        cases += [[rng.randrange(Q) for _ in range(N)] for _ in range(NRAND)]
        f.write(f"{len(cases)}\n")
        rt_fail = 0
        for poly in cases:
            # sanity: the reference round-trip must recover the input exactly
            if R.ntt_roundtrip(poly) != [x % Q for x in poly]:
                rt_fail += 1
            for v in poly: f.write(h16(v % Q) + "\n")   # input  f
            for v in poly: f.write(h16(v % Q) + "\n")   # output f (same)
    if rt_fail:
        sys.exit(f"ERROR: reference round-trip failed on {rt_fail} cases")
    print(f"wrote {rt_path}  ({len(cases)} round-trip cases, ref self-check OK)")


if __name__ == "__main__":
    main()
