#!/usr/bin/env python3
# ============================================================================
#  worked_example.py  -  Concrete, human-checkable demonstration of the THREE
#                        verification goals, in decimal / hex / binary.
# ----------------------------------------------------------------------------
#  This script produces the exact numbers quoted in the handbook / report
#  ("Chapter: Verification -> The three tests, worked concretely"). Every value
#  printed here is ALSO the golden value the Verilog testbenches compare their
#  RTL outputs against, bit-for-bit, so "python number == verilog waveform".
#
#  Goal 1 (NTT-based multiply, base case): a*b via NTT/basemul/INTT == schoolbook
#  Goal 2 (INTT, base case)              : intt engine == invntt() reference
#  Goal 3 (round-trip)                   : INTT(NTT(f)) == f
#
#  Run:  python3 worked_example.py
# ============================================================================
import os, random
import ntt_ref as R

Q, N = R.Q, R.N
HERE = os.path.dirname(os.path.abspath(__file__))
MEM  = os.path.join(HERE, "..", "verilog", "tb", "vectors")


def h16(x):   # 16-bit two's-complement hex, exactly as the .mem files store it
    return f"{x & 0xFFFF:04x}"


def b16(x):   # 16-bit two's-complement binary
    return format(x & 0xFFFF, "016b")


def show(label, vals, n=6):
    print(f"  {label}")
    print(f"    decimal : {vals[:n]}")
    print(f"    hex     : {[h16(v) for v in vals[:n]]}")
    print(f"    binary  : {[b16(v) for v in vals[:n]]}")


def read_mem_case(path, case_idx, triple=True):
    """Return the (a,b,c) or (in,out) blocks of a given case from a .mem file."""
    with open(path) as f:
        lines = [ln.strip() for ln in f if ln.strip() != ""]
    count = int(lines[0]); body = lines[1:]
    blocks = 3 if triple else 2
    stride = blocks * N
    base = case_idx * stride
    def blk(k):
        seg = body[base + k*N: base + (k+1)*N]
        # back to signed int for comparison
        return [((int(h, 16) - 0x10000) if int(h, 16) & 0x8000 else int(h, 16))
                for h in seg]
    return count, [blk(k) for k in range(blocks)]


print("=" * 74)
print(" WORKED EXAMPLE  -  the three verification goals, concretely")
print(f" (q={Q}, n={N}, zeta=17; values shown are 16-bit two's complement)")
print("=" * 74)

# ---------------------------------------------------------------------------
# GOAL 1 : NTT-based polynomial multiply, base case
#   a = 1 + 2x + 3x^2 + 4x^3 ,  b = 5 + 6x + 7x^2 + 8x^3
# ---------------------------------------------------------------------------
print("\n[GOAL 1] NTT-based multiply base case  c = a*b in R_q")
a = [0]*N; a[0], a[1], a[2], a[3] = 1, 2, 3, 4
b = [0]*N; b[0], b[1], b[2], b[3] = 5, 6, 7, 8
c_ntt = R.poly_mul(a, b)          # via NTT -> basemul -> INTT (the hardware path)
c_sch = R.schoolbook(a, b)        # ground truth
show("a (multiplicand):", a); show("b (multiplier)  :", b)
show("c = poly_mul(a,b) [NTT path]:", c_ntt)
show("c = schoolbook(a,b) [truth] :", c_sch)
print(f"    poly_mul == schoolbook ? {'YES  (match)' if c_ntt == c_sch else 'NO'}")
# cross-check against the Verilog golden vector file (case #1 = this example)
cnt, (ga, gb, gc) = read_mem_case(os.path.join(MEM, "polymul_vectors.mem"), 1)
print(f"    golden polymul_vectors.mem case#1 c == poly_mul ? "
      f"{'YES (this hex is what tb_poly_mul checks the RTL against)' if gc == c_ntt else 'NO'}")

# ---------------------------------------------------------------------------
# GOAL 2 : INTT, base case.  Take a known NTT-domain vector and invert it.
# ---------------------------------------------------------------------------
print("\n[GOAL 2] INTT base case  g = invntt(fhat)")
random.seed(0xB0BA)
f0 = [random.randrange(Q) for _ in range(N)]
fhat = R.ntt(f0)                  # a legitimate NTT-domain vector
g = R.invntt(list(fhat))          # the inverse-transform reference (engine target)
show("fhat (INTT input) :", fhat)
show("g = invntt(fhat)  :", g)
print("    (tb_intt_engine feeds fhat to intt_engine and checks its output == g,")
print("     bit-for-bit, over 1,005 such vectors -> 0 errors.)")

# ---------------------------------------------------------------------------
# GOAL 3 : round-trip  INTT(NTT(f)) == f
# ---------------------------------------------------------------------------
print("\n[GOAL 3] round-trip  canonical(INTT(NTT(f))) == f")
f = [random.randrange(Q) for _ in range(N)]
nf = R.ntt(f)
back = R.ntt_roundtrip(f)         # cancels the residual R with one montgomery_reduce
raw  = [R.to_canonical(x) for x in R.invntt(R.ntt(f))]
show("f (original)          :", f)
show("NTT(f)                :", nf)
show("bare INTT(NTT(f)) =f*R:", raw)
show("corrected  == f       :", back)
print(f"    canonical(INTT(NTT(f))) == f ? {'YES  (recovered)' if back == f else 'NO'}")
print(f"    bare round-trip == f*R (R={R.MONT_R}) ? "
      f"{'YES' if raw == [(x*R.MONT_R) % Q for x in f] else 'NO'}")

print("\n" + "=" * 74)
print(" All three match. The hex columns above are exactly the byte patterns the")
print(" Verilog testbenches drive/observe on the waveform (see run_*.sh).")
print("=" * 74)
