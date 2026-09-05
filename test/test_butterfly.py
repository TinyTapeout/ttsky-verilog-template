# test_butterfly.py -- the six-operation datapath, over both reductions.
#
# One pipelined multiplier and one Barrett reducer serve CT, GS, FQMUL, ZMUL,
# BARRETT and ADD, so the failure mode to hunt is cross-talk: a mux that leaks
# the forward transform's post-multiply subtract into the inverse's output, or a
# Barrett input that stays wired to the GS sum when the standalone BARRETT op
# runs. The tests therefore interleave the ops rather than running each in a
# clean block.
#
# Every op takes exactly five clocks. An earlier revision let BARRETT and ADD
# answer in zero, since neither needs the multiplier -- but that left the whole
# Barrett reduction inside a single-cycle path from the op register to the
# caller's result register, and post-layout timing rejected it by 1.51 ns at the
# slow corner. Barrett is registered now. test_each_op pins the uniform latency
# down, because a datapath that silently changes latency is the failure this
# design would be least likely to notice.

import random
from collections import Counter

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly, NextTimeStep

from ntt_golden import (Q, R, ZETAS, apply_op, OP_NAMES, s16,
                        OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD)

ALL_OPS = [OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD]
LATENCY = 5


async def reset(dut):
    dut.rst.value = 1
    dut.in_valid.value = 0
    dut.op.value = 0
    dut.a.value = 0
    dut.b.value = 0
    dut.zeta.value = 0
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)


def outputs(dut):
    return s16(int(dut.a_out.value)), s16(int(dut.b_out.value))


async def run_op(dut, op, a, b, zeta):
    """Issue one operation and return (result, clocks).

    Every op issues into the datapath and answers five clocks later, including
    BARRETT and ADD, which ignore the multiplier's result.
    """
    dut.op.value = op
    dut.a.value = a
    dut.b.value = b
    dut.zeta.value = zeta
    dut.in_valid.value = 1
    await RisingEdge(dut.clk)
    dut.in_valid.value = 0

    n = 1
    while True:
        await ReadOnly()
        valid = int(dut.out_valid.value)
        got = outputs(dut)
        await NextTimeStep()
        if valid:
            return got, n
        assert n < 20, f"{OP_NAMES[op]} never produced a result"
        await RisingEdge(dut.clk)
        n += 1


@cocotb.test()
async def test_each_op(dut):
    """Each operation over the ranges that actually occur, with its latency
    checked constant."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(91)
    for op in ALL_OPS:
        cases = [(0, 0, ZETAS[1]), (1, -1, ZETAS[1]), (-3328, 3328, ZETAS[64]),
                 (16628, -16628, ZETAS[127])]
        cases += [(random.randrange(-16628, 16629),
                   random.randrange(-16628, 16629),
                   random.choice(ZETAS)) for _ in range(200)]
        seen = Counter()
        for a, b, z in cases:
            got, n = await run_op(dut, op, a, b, z)
            exp = tuple(s16(v) for v in apply_op(op, a, b, z))
            assert got == exp, \
                f"{OP_NAMES[op]}(a={a}, b={b}, zeta={z}): got {got}, expected {exp}"
            seen[n] += 1
        assert len(seen) == 1, f"{OP_NAMES[op]}: variable latency {dict(seen)}"
        assert list(seen)[0] == LATENCY, \
            f"{OP_NAMES[op]} latency {list(seen)[0]}, expected {LATENCY}"
        dut._log.info(f"{OP_NAMES[op]:<7}: {len(cases)} operations correct, "
                      f"{list(seen)[0]} clocks each")


@cocotb.test()
async def test_op_interleaving(dut):
    """The six operations share one multiplier and one Barrett unit. Change the
    op every single operation, so any mux wired to the wrong source shows up
    immediately."""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(92)
    for _ in range(700):
        op = random.choice(ALL_OPS)
        a = random.randrange(-16628, 16629)
        b = random.randrange(-16628, 16629)
        z = random.choice(ZETAS)
        got, _ = await run_op(dut, op, a, b, z)
        exp = tuple(s16(v) for v in apply_op(op, a, b, z))
        assert got == exp, \
            f"{OP_NAMES[op]}(a={a}, b={b}, zeta={z}): got {got}, expected {exp}"
    dut._log.info("700 operations with the op changing every time: no cross-talk")


@cocotb.test()
async def test_barrett_shared_between_gs_and_standalone(dut):
    """One Barrett unit has two callers: GS reduces a+b through it, the
    standalone BARRETT op reduces a. The mux between them is the piece that
    would corrupt the inverse transform silently.

    Drive the standalone op and the GS op alternately with operands chosen so
    that a wrong mux gives a plausible-but-wrong field element.
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(93)
    for _ in range(300):
        a = random.randrange(-16628, 16629)
        b = random.randrange(-16628, 16629)
        z = random.choice(ZETAS)

        (ba, bb), _ = await run_op(dut, OP_BARRETT, a, b, z)
        assert ba == bb, "BARRETT outputs should mirror"
        assert (ba - a) % Q == 0 and abs(ba) <= Q // 2 + 1, \
            f"standalone BARRETT({a}) = {ba} is wrong"

        (ga, _gb), _ = await run_op(dut, OP_GS, a, b, z)
        assert (ga - s16(a + b)) % Q == 0 and abs(ga) <= Q // 2 + 1, \
            f"GS a_out did not Barrett-reduce a+b (a={a}, b={b}) -> {ga}"
    dut._log.info("the shared Barrett unit serves GS and the standalone op "
                  "without cross-talk, over 300 cases")


@cocotb.test()
async def test_both_reductions_are_present(dut):
    """The two reductions must be genuinely different units doing different
    jobs -- not one standing in for the other.

    Montgomery introduces a factor R^-1; Barrett does not. So for the same
    input, FQMUL(a, 1) and BARRETT(a) must give DIFFERENT answers that are
    related by exactly that factor. If Barrett had been implemented as
    fqmul(x, R mod q), the two would agree, and this test would fail.
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(94)
    differed = 0
    for _ in range(200):
        a = random.randrange(-16628, 16629)
        (m, _x), _ = await run_op(dut, OP_FQMUL, a, 1, 0)     # montgomery_reduce(a)
        (t, _y), _ = await run_op(dut, OP_BARRETT, a, 0, 0)   # barrett(a)

        # Barrett preserves the residue; Montgomery multiplies it by R^-1.
        assert (t - a) % Q == 0, "Barrett changed the residue"
        assert (m * R - a) % Q == 0, "Montgomery did not apply R^-1"
        if m != t:
            differed += 1
    assert differed > 150, \
        (f"only {differed}/200 inputs distinguished the two reductions -- "
         f"are they the same unit?")
    dut._log.info(f"Montgomery and Barrett are distinct units: {differed}/200 "
                  f"inputs give different results, related by exactly R^-1")


@cocotb.test()
async def test_ct_gs_are_inverse(dut):
    """CT and GS must undo each other up to the factor of 2 a single butterfly
    layer introduces -- checked against the hardware alone.

        CT: (a, b) -> (a + zb, a - zb)
        GS on that pair, same zeta: a_out = barrett(2a)

    So the first output must be 2a reduced mod q. That is a property of the two
    butterflies being genuine inverses, and it is why one datapath serves both
    transforms.
    """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    await reset(dut)

    random.seed(95)
    for _ in range(200):
        a = random.randrange(-1664, 1665)
        b = random.randrange(-1664, 1665)
        z = random.choice(ZETAS)
        (x, y), _ = await run_op(dut, OP_CT, a, b, z)
        (p, _q), _ = await run_op(dut, OP_GS, x, y, z)
        assert (p - 2 * a) % Q == 0, \
            f"GS(CT(a={a}, b={b}, z={z}))[0] = {p}, expected 2a = {2 * a} mod q"
    dut._log.info("GS undoes CT: the first output is 2a mod q for 200 inputs")
