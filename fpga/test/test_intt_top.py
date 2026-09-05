import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

Q = 3329
N = 256
ZETA = 17
N_INV = pow(128, -1, Q)


def bitrev7(x):
    r = 0
    for i in range(7):
        r |= ((x >> i) & 1) << (6 - i)
    return r


ZETAS = [0] * 128
for _i in range(1, 128):
    ZETAS[_i] = pow(ZETA, bitrev7(_i), Q)


def golden_ntt(f):
    r = list(f)
    k = 1
    length = 128
    while length >= 2:
        start = 0
        while start < N:
            zeta = ZETAS[k]
            k += 1
            for j in range(start, start + length):
                t = (zeta * r[j + length]) % Q
                r[j + length] = (r[j] - t) % Q
                r[j] = (r[j] + t) % Q
            start += 2 * length
        length >>= 1
    return r


def golden_intt(f):
    r = list(f)
    k = 127
    length = 2
    while length <= 128:
        start = 0
        while start < N:
            zeta = ZETAS[k]
            k -= 1
            for j in range(start, start + length):
                t = r[j]
                r[j] = (t + r[j + length]) % Q
                r[j + length] = (zeta * ((r[j + length] - t) % Q)) % Q
            start += 2 * length
        length <<= 1
    return [(x * N_INV) % Q for x in r]


async def load_poly(dut, f):
    for addr, val in enumerate(f):
        dut.ext_addr.value = addr
        dut.ext_din.value = val
        dut.ext_we.value = 1
        await RisingEdge(dut.clk)
    dut.ext_we.value = 0


async def dump_poly(dut):
    # coeff_mem's read is now registered (see coeff_mem.v): ext_dout for an
    # address presented before a RisingEdge is only valid the cycle AFTER
    # that edge, not combinationally in the same cycle.
    out = []
    for addr in range(N):
        dut.ext_addr.value = addr
        await RisingEdge(dut.clk)
        await ReadOnly()
        out.append(int(dut.ext_dout.value))
        await RisingEdge(dut.clk)   # exit ReadOnly before the next iteration sets ext_addr
    return out


async def run_one_intt(dut, f):
    await load_poly(dut, f)

    dut.start_i.value = 1
    await RisingEdge(dut.clk)
    dut.start_i.value = 0

    # (896 butterflies + 256 scale steps) x 7-cycle stall each (mod_mult
    # settle + coeff_mem's registered read, see intt_control_fsm.v)
    # = ~8064 cycles.
    for _ in range(10000):
        await ReadOnly()
        if dut.done.value == 1:
            break
        await RisingEdge(dut.clk)
    else:
        assert False, "intt_top never asserted done"
    await RisingEdge(dut.clk)

    return await dump_poly(dut)


@cocotb.test()
async def test_intt_top(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.rst.value = 1
    dut.start_i.value = 0
    dut.ext_we.value = 0
    dut.ext_addr.value = 0
    dut.ext_din.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    random.seed(2027)
    test_polys = [
        [0] * N,
        [1] + [0] * (N - 1),
        list(range(N)),
        [(Q - 1)] * N,
        [random.randrange(Q) for _ in range(N)],
        [random.randrange(Q) for _ in range(N)],
    ]

    for idx, f in enumerate(test_polys):
        got = await run_one_intt(dut, f)
        exp = golden_intt(f)
        assert got == exp, (
            f"poly #{idx}: mismatch at "
            f"{[i for i in range(N) if got[i] != exp[i]][:10]}"
        )
        dut._log.info(f"poly #{idx}: INTT matches golden model, all {N} coeffs")

    dut._log.info(f"intt_top: all {len(test_polys)} polynomials PASS (raw INTT vs golden)")

    # the property that actually matters for the Phase 3 demo:
    # INTT(NTT(f)) == f
    random.seed(2028)
    for trial in range(5):
        f = [random.randrange(Q) for _ in range(N)]
        nf = golden_ntt(f)               # computed in Python -- this test is
        got = await run_one_intt(dut, nf)  # RTL-only for the INTT half; the
        assert got == f, (                 # NTT half is already RTL-verified
            f"round-trip #{trial}: INTT(NTT(f)) != f at "
            f"{[i for i in range(N) if got[i] != f[i]][:10]}"
        )
        dut._log.info(f"round-trip #{trial}: INTT(NTT(f)) == f (RTL INTT, Python NTT)")

    dut._log.info("intt_top: round-trip identity holds")
