#!/usr/bin/env python3
# ============================================================================
#  gen_polymul_vectors.py  -  Golden vectors for the full polynomial multiply
# ----------------------------------------------------------------------------
#  Reuses the bit-exact Python reference (code/python/ntt_ref.py).  For each
#  test it emits two random operands a, b and their product c = a*b in
#  R_q = Z_3329[x]/(x^256+1), computed by poly_mul() (NTT/basemul/INTT) and
#  cross-checked against the O(n^2) schoolbook multiply.
#
#  vectors/polymul_vectors.mem :
#        <T>
#        per test:  256 a coeffs (hex16), 256 b coeffs (hex16), 256 c coeffs (hex16)
#
#  RUN (from code/verilog/tb/):  python3 gen_polymul_vectors.py
# ============================================================================
import os, sys, random

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "..", "python"))
import ntt_ref as R

Q, N = R.Q, R.N


def h16(x):
    return f"{x & 0xFFFF:04x}"


def edge_pairs():
    """Structured (a,b) edge cases, including negacyclic-wrap stressors."""
    def unit(k):                       # the monomial x^k
        p = [0] * N; p[k] = 1; return p
    imp = unit(0)                      # multiplicative identity 1
    ramp = [i % Q for i in range(N)]
    allq = [Q - 1] * N
    small = [0] * N; small[0], small[1], small[2], small[3] = 1, 2, 3, 4
    smallb = [0] * N; smallb[0], smallb[1], smallb[2], smallb[3] = 5, 6, 7, 8
    yield (ramp, imp)          # a * 1 == a
    yield (small, smallb)      # the tiny concrete example from the reports
    yield (allq, allq)         # extreme magnitudes
    yield (ramp, allq)
    # negacyclic wrap: x^255 * x = x^256 = -1 (constant term q-1, rest 0)
    yield (unit(255), unit(1))
    yield (unit(255), unit(255))       # x^510 = -x^254
    yield (unit(200), unit(100))       # x^300 = -x^44 (wraps once)
    yield (unit(128), unit(128))       # x^256 = -1
    yield (allq, imp)                  # extreme * identity
    yield (unit(255), allq)            # top monomial * dense extreme


def main():
    os.makedirs(os.path.join(HERE, "vectors"), exist_ok=True)
    rng = random.Random(0xC0FFEE)
    NRAND = 300

    cases = list(edge_pairs())
    cases += [([rng.randrange(Q) for _ in range(N)],
               [rng.randrange(Q) for _ in range(N)]) for _ in range(NRAND)]

    path = os.path.join(HERE, "vectors", "polymul_vectors.mem")
    bad = 0
    with open(path, "w") as f:
        f.write(f"{len(cases)}\n")
        for a, b in cases:
            c = R.poly_mul(a, b)
            if c != R.schoolbook(a, b):        # golden self-check
                bad += 1
            for v in a: f.write(h16(v) + "\n")
            for v in b: f.write(h16(v) + "\n")
            for v in c: f.write(h16(v) + "\n")
    if bad:
        sys.exit(f"ERROR: poly_mul != schoolbook on {bad} cases")
    print(f"wrote {path}  ({len(cases)} poly-multiply cases, poly_mul==schoolbook OK)")


if __name__ == "__main__":
    main()
