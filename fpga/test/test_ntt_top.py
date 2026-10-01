import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

Q = 3329
N = 256
ZETA = 17


def bitrev7(x):
    r = 0
    for i in range(7):
        r |= ((x >> i) & 1) << (6 - i)
    return r


ZETAS = [0] * 128
for _i in range(1, 128):
    ZETAS[_i] = pow(ZETA, bitrev7(_i), Q)


def golden_ntt(f):
    """Plain-canonical (non-Montgomery) forward NTT, matching main branch's
    mod_mult/mod_add/mod_sub/butterfly convention exactly -- NOT the
    Montgomery-domain reference used by the (unrelated) ~/TT big tree."""
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


async def run_one_ntt(dut, f):
    await load_poly(dut, f)

    dut.start_i.value = 1
    await RisingEdge(dut.clk)
    dut.start_i.value = 0

    # 896 butterflies x 7-cycle stall each (mod_mult settle + coeff_mem's
    # registered read, see control_fsm.v) = ~6272 cycles; poll `done` rather
    # than hardcoding it.
    for _ in range(8000):
        await ReadOnly()
        if dut.done.value == 1:
            break
        await RisingEdge(dut.clk)
    else:
        assert False, "ntt_top never asserted done"
    await RisingEdge(dut.clk)

    return await dump_poly(dut)


@cocotb.test()
async def test_ntt_top(dut):
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

    random.seed(2026)
    test_polys = [
        [0] * N,
        [1] + [0] * (N - 1),
        list(range(N)),
        [(Q - 1)] * N,
        [random.randrange(Q) for _ in range(N)],
        [random.randrange(Q) for _ in range(N)],
        [random.randrange(Q) for _ in range(N)],
    ]

    for idx, f in enumerate(test_polys):
        got = await run_one_ntt(dut, f)
        exp = golden_ntt(f)
        if got != exp:
            bad = [i for i in range(N) if got[i] != exp[i]]
            dut._log.info(f"poly #{idx}: {len(bad)} mismatches, first 10 idx: {bad[:10]}")
            for i in bad[:10]:
                dut._log.info(f"  idx {i}: got={got[i]} exp={exp[i]}")
        assert got == exp, (
            f"poly #{idx}: mismatch at "
            f"{[i for i in range(N) if got[i] != exp[i]][:10]}"
        )
        dut._log.info(f"poly #{idx}: NTT matches golden model, all {N} coeffs")

    dut._log.info(f"ntt_top: all {len(test_polys)} polynomials PASS")
