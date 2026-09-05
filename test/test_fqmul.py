# test_fqmul.py -- the pipelined multiply and its Montgomery reduction.
#
# Two things are being checked, and they fail in different ways:
#
#   1. the arithmetic -- Theorem 6.1: t = a*b*R^-1 (mod q) with |t| < q
#   2. the pipeline -- exactly 3 clocks of latency, results in order when
#      operations are issued back to back
#
# The second is what pipelining introduces. A combinational block cannot get its
# results out of order or drop a valid; a three-stage one can, and the symptom
# would be a transform wrong by one butterfly's worth in a way that looks like
# an arithmetic bug.

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly, NextTimeStep

from ntt_golden import Q, R, ZETAS, fqmul, montgomery_reduce, s16

LATENCY = 5


async def reset(dut):
    dut.rst.value = 1
    dut.in_valid.value = 0
    dut.a.value = 0
    dut.b.value = 0
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)


@cocotb.test()
async def test_latency_is_three(dut):
    """out_valid must appear exactly 3 clocks after in_valid, every time."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    for a, b in [(0, 0), (1, 1), (Q - 1, Q - 1), (-1044, 2580), (-3328, 3328)]:
        dut.a.value = a
        dut.b.value = b
        dut.in_valid.value = 1
        await RisingEdge(dut.clk)
        dut.in_valid.value = 0
        dut.a.value = 0
        dut.b.value = 0        # operands withdrawn: the pipeline holds its own state

        for n in range(1, LATENCY + 3):
            await ReadOnly()
            valid = int(dut.out_valid.value)
            got = s16(int(dut.c.value))
            await NextTimeStep()
            if valid:
                assert n == LATENCY, f"latency was {n}, expected {LATENCY}"
                assert got == fqmul(a, b), \
                    f"fqmul({a},{b}): got {got}, expected {fqmul(a, b)}"
                break
            await RisingEdge(dut.clk)
        else:
            assert False, f"no result for fqmul({a},{b})"
    dut._log.info(f"latency is exactly {LATENCY} clocks, and operands need not "
                  f"be held after in_valid")


@cocotb.test()
async def test_streaming(dut):
    """One multiply issued every clock for 2000 clocks. Results must come back
    in order, one per clock, three behind."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(90)
    ops = [(random.randrange(-Q + 1, Q), random.randrange(-Q + 1, Q))
           for _ in range(2000)]
    ops[:5] = [(0, Q - 1), (Q - 1, 0), (Q - 1, Q - 1), (-(Q - 1), Q - 1),
               (-(Q - 1), -(Q - 1))]

    got = []
    for i in range(len(ops) + LATENCY):
        if i < len(ops):
            dut.a.value = ops[i][0]
            dut.b.value = ops[i][1]
            dut.in_valid.value = 1
        else:
            dut.in_valid.value = 0
        await RisingEdge(dut.clk)
        await ReadOnly()
        if int(dut.out_valid.value):
            got.append(s16(int(dut.c.value)))
        await NextTimeStep()

    assert len(got) == len(ops), f"got {len(got)} results for {len(ops)} operations"
    exp = [fqmul(a, b) for a, b in ops]
    bad = [(i, got[i], exp[i]) for i in range(len(ops)) if got[i] != exp[i]]
    for i, g, e in bad[:8]:
        dut._log.error(f"op {i} {ops[i]}: got {g}, expected {e}")
    assert not bad, f"{len(bad)}/{len(ops)} streamed results wrong"
    dut._log.info(f"{len(ops)} multiplies issued one per clock, all correct and "
                  f"in order")


@cocotb.test()
async def test_theorem_6_1(dut):
    """Theorem 6.1 against the hardware alone: the result must satisfy
    |t| < q and t*R = a*b (mod q). No reference to the Python model."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(91)
    cases = [(a, b) for a in (0, 1, -1, Q - 1, -(Q - 1))
             for b in (0, 1, -1, Q - 1, -(Q - 1))]
    cases += [(random.randrange(-Q + 1, Q), random.randrange(-Q + 1, Q))
              for _ in range(400)]

    for a, b in cases:
        dut.a.value = a
        dut.b.value = b
        dut.in_valid.value = 1
        await RisingEdge(dut.clk)
        dut.in_valid.value = 0
        for _ in range(LATENCY - 1):
            await RisingEdge(dut.clk)
        await ReadOnly()
        assert int(dut.out_valid.value), "no result"
        t = s16(int(dut.c.value))
        await NextTimeStep()
        assert abs(t) < Q, f"fqmul({a},{b}) = {t} violates |t| < q"
        assert (t * R - a * b) % Q == 0, \
            f"fqmul({a},{b}) = {t} is not a*b*R^-1 mod q"
    dut._log.info(f"{len(cases)} products: |t| < q and t*R == a*b (mod q)")


@cocotb.test()
async def test_montgomery_domain_cancels(dut):
    """The point of storing the twiddles pre-multiplied by R -- Key Idea 6.1.

    fqmul(zeta_mont, x) must equal the PLAIN zeta times x, mod q, with no
    stray factor. This is the property that would silently break if the ROM
    ever held plain zetas instead of Montgomery ones.
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(92)
    rinv = pow(R, -1, Q)
    for k in (1, 2, 17, 64, 100, 127):
        zeta_plain = ZETAS[k] * rinv % Q
        for _ in range(10):
            x = random.randrange(-Q + 1, Q)
            dut.a.value = ZETAS[k]
            dut.b.value = x
            dut.in_valid.value = 1
            await RisingEdge(dut.clk)
            dut.in_valid.value = 0
            for _ in range(LATENCY - 1):
                await RisingEdge(dut.clk)
            await ReadOnly()
            t = s16(int(dut.c.value))
            await NextTimeStep()
            assert (t - zeta_plain * x) % Q == 0, \
                f"fqmul(zetas[{k}], {x}) is not zeta*x mod q"
    dut._log.info("fqmul(zeta*R, x) == zeta*x mod q: the Montgomery factor "
                  "cancels exactly as Key Idea 6.1 requires")


@cocotb.test()
async def test_b_equals_one_is_bare_montgomery(dut):
    """fqmul(x, 1) must be a bare montgomery_reduce -- that is how the host
    strips the residual R after a round trip, so it has to be exact."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(93)
    for _ in range(200):
        x = random.randrange(-32768, 32768)
        dut.a.value = x
        dut.b.value = 1
        dut.in_valid.value = 1
        await RisingEdge(dut.clk)
        dut.in_valid.value = 0
        for _ in range(LATENCY - 1):
            await RisingEdge(dut.clk)
        await ReadOnly()
        t = s16(int(dut.c.value))
        await NextTimeStep()
        assert t == montgomery_reduce(x), \
            f"fqmul({x}, 1) = {t}, montgomery_reduce = {montgomery_reduce(x)}"
    dut._log.info("fqmul(x, 1) is a bare montgomery_reduce over 200 values")
