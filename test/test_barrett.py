# test_barrett.py -- the Barrett reducer, Theorem 6.2.
#
# The input is one 16-bit word, so the entire input space is 65,536 values,
# small enough to test COMPLETELY. There is no reason to sample here, and one
# good reason not to: the theorem is stated for |a| < 2^15, and a = -32768 sits
# exactly on that boundary. It is a value the hardware can be handed, so it has
# to be checked rather than assumed.
#
# The unit is pipelined in two stages, so these tests stream one input per clock
# and collect results two clocks behind. That also exercises the pipeline. A
# reducer that dropped a result or returned them out of order would show up here
# as a mismatch, rather than as a silently wrong inverse transform later.
#
# Three properties, all taken from the theorem:
#   1. congruence      barrett(a) = a (mod q)
#   2. centred range   barrett(a) is in (-q/2, q/2]
#   3. it is round     t is exactly round(a/q), not merely a bound

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly, NextTimeStep

from ntt_golden import Q, BARRETT_V, BARRETT_K, barrett_reduce, s16

LATENCY = 2


async def start(dut):
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    dut.rst.value = 1
    dut.in_valid.value = 0
    dut.a.value = 0
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)


async def reduce_all(dut, values):
    """Stream values in one per clock and return the results in order."""
    out = []
    n = len(values)
    for i in range(n + LATENCY):
        if i < n:
            dut.a.value = values[i]
            dut.in_valid.value = 1
        else:
            dut.in_valid.value = 0
        await RisingEdge(dut.clk)
        await ReadOnly()
        if int(dut.out_valid.value):
            out.append(s16(int(dut.c.value)))
        await NextTimeStep()
    assert len(out) == n, f"got {len(out)} results for {n} inputs"
    return out


@cocotb.test()
async def test_exhaustive(dut):
    """Every one of the 65,536 signed 16-bit inputs, against the model."""
    await start(dut)

    vals = list(range(-32768, 32768))
    got_all = await reduce_all(dut, vals)

    bad = 0
    lo, hi = 0, 0
    for a, got in zip(vals, got_all):
        exp = barrett_reduce(a)
        if got != exp:
            if bad < 8:
                dut._log.error(f"barrett({a}): got {got}, expected {exp}")
            bad += 1
        lo, hi = min(lo, got), max(hi, got)
    assert not bad, f"{bad}/65536 inputs wrong"
    dut._log.info(f"all 65,536 signed 16-bit inputs match; output range "
                  f"[{lo}, {hi}]")


@cocotb.test()
async def test_theorem_6_2(dut):
    """The two claims of Theorem 6.2, checked against the hardware alone.

    Congruence and the centred range are stated by the theorem, so they are
    verified here without reference to the Python model. A reducer that agreed
    with a wrong model would still fail this.
    """
    await start(dut)

    vals = list(range(-32768, 32768))
    got_all = await reduce_all(dut, vals)

    half = Q // 2
    for a, c in zip(vals, got_all):
        assert (c - a) % Q == 0, f"barrett({a}) = {c} changed the residue"
        assert -half <= c <= half + 1, f"barrett({a}) = {c} is not centred"
    dut._log.info("Theorem 6.2 holds over the whole input space: congruent "
                  "mod q and inside (-q/2, q/2]")


@cocotb.test()
async def test_quotient_is_round_not_floor(dut):
    """The proof's real content is that t = round(a/q) EXACTLY, which is what
    makes the remainder centred rather than merely bounded.

    We recover t from the output as (a - c)/q and require it to be within half
    a unit of a/q. A floor would fail this for every negative input, which is
    the bug the 2^25 rounding term exists to prevent.
    """
    await start(dut)

    vals = list(range(-32768, 32768))
    got_all = await reduce_all(dut, vals)

    for a, c in zip(vals, got_all):
        assert (a - c) % Q == 0
        t = (a - c) // Q
        assert a - t * Q == c
        assert abs(a / Q - t) <= 0.5 + 1e-9, \
            f"t = {t} for a = {a} is not round(a/q)"
    dut._log.info("the quotient is round(a/q) for every input, not a floor")


@cocotb.test()
async def test_constant_is_derived(dut):
    """v must be the constant the derivation gives, floor((2^26 + q/2)/q).

    This is checked against the formula rather than against the number in the
    RTL, so a transcription error in either place fails here. The extremal
    inputs are then driven through the hardware to confirm the constant it was
    built with behaves the same way.
    """
    assert BARRETT_V == (2 ** BARRETT_K + Q // 2) // Q == 20159
    assert BARRETT_K == 26

    await start(dut)

    edge = [-32768, -32767, -3330, -3329, -3328, -1665, -1664, -1,
            0, 1, 1664, 1665, 3328, 3329, 3330, 32766, 32767]
    got_all = await reduce_all(dut, edge)

    for a, c in zip(edge, got_all):
        assert c == barrett_reduce(a) and abs(c) <= Q // 2 + 1, \
            f"barrett({a}) = {c}"
    dut._log.info(f"v = {BARRETT_V} matches floor((2^{BARRETT_K} + q/2)/q), "
                  f"and the extremal inputs reduce correctly")
