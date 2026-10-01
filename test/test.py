# test.py -- Tiny Tapeout wrapper test for the ML-KEM NTT/INTT accelerator.
#
# Everything here drives the design through the physical TT pins only, so it
# runs unchanged against the RTL and against the post-layout gate-level netlist
# (make -B GATES=yes).
#
# The chip is the arithmetic engine and holds the twiddle table. These tests
# play the part of the host FPGA: they hold the 256-coefficient polynomial in
# Python, walk the FIPS 203 address pattern, and stream each butterfly's
# operands through the chip -- passing the twiddle INDEX k, never the value.
# Nowhere in this file is a zeta written to the chip; that is the point.
#
# Pin protocol (see src/ntt_io.v):
#   ui_in[7:0]   write data       uio_in[2:0] register address
#   uio_in[3]    write enable     uio_in[4]   start (rising edge)
#   uo_out[7:0]  result byte      uio_out[5]  out_valid    uio_out[6] busy

import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, ReadOnly, NextTimeStep

from ntt_golden import (Q, N, R, R_MOD_Q, ZETAS, F, s16, centre,
                        ntt, invntt, apply_op, basemul, montgomery_reduce,
                        barrett_reduce, OP_NAMES,
                        OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD)

# register map
A_LO, A_HI, B_LO, B_HI, K_IDX, CTRL = range(6)

WE_BIT, START_BIT = 3, 4
OUT_VALID_BIT, BUSY_BIT = 5, 6

# longest operation is 3 multiplier clocks plus four result bytes
OP_TIMEOUT = 40


def pin(sig, bit):
    v = sig.value
    return 0 if not v.is_resolvable else (int(v) >> bit) & 1


def bus(sig):
    v = sig.value
    return 0 if not v.is_resolvable else int(v)


class Accel:
    """Host-side driver: mirrors what the FPGA does over the pins."""

    def __init__(self, dut):
        self.dut = dut
        self.shadow = {}        # last value written to each register

    async def reset(self):
        d = self.dut
        d.ena.value = 1
        d.ui_in.value = 0
        d.uio_in.value = 0
        d.rst_n.value = 0
        await ClockCycles(d.clk, 5)
        d.rst_n.value = 1
        await ClockCycles(d.clk, 2)
        self.shadow = {}

    async def write(self, addr, val):
        """Write one register, skipping the bus cycle if it already holds val."""
        val &= 0xFF
        if self.shadow.get(addr) == val:
            return
        d = self.dut
        d.ui_in.value = val
        d.uio_in.value = (addr & 7) | (1 << WE_BIT)
        await RisingEdge(d.clk)
        d.uio_in.value = 0
        self.shadow[addr] = val

    async def execute(self):
        """Pulse start and collect the four result bytes."""
        d = self.dut
        d.uio_in.value = 1 << START_BIT
        await RisingEdge(d.clk)
        d.uio_in.value = 0

        out = []
        guard = 0
        while len(out) < 4:
            await ReadOnly()
            if pin(d.uio_out, OUT_VALID_BIT):
                out.append(bus(d.uo_out))
            await NextTimeStep()
            if len(out) < 4:
                await RisingEdge(d.clk)
            guard += 1
            assert guard < OP_TIMEOUT, f"timed out with {len(out)}/4 result bytes"

        return s16(out[0] | (out[1] << 8)), s16(out[2] | (out[3] << 8))

    async def op(self, op, a, b=0, k=0, zneg=0):
        """Run one operation. The twiddle is selected by index, not value."""
        a &= 0xFFFF
        b &= 0xFFFF
        await self.write(A_LO, a)
        await self.write(A_HI, a >> 8)
        await self.write(B_LO, b)
        await self.write(B_HI, b >> 8)
        await self.write(K_IDX, k)
        await self.write(CTRL, (op & 7) | ((zneg & 1) << 3))
        return await self.execute()


def zeta_of(k, zneg=0):
    """What the chip's ROM will supply for this index -- used only to build the
    expected value, never written to the chip."""
    return -ZETAS[k] if zneg else ZETAS[k]


@cocotb.test()
async def test_all_ops_through_pins(cocotb_dut):
    """Every operation, driven through the register interface."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    random.seed(71)
    checked = 0
    for op in (OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD):
        for _ in range(20):
            a = random.randrange(-3328, 3329)
            b = random.randrange(-3328, 3329)
            k = random.randrange(1, 128)
            zneg = random.randrange(2)
            got = await acc.op(op, a, b, k, zneg)
            exp = tuple(s16(v) for v in apply_op(op, a, b, zeta_of(k, zneg)))
            assert got == exp, (f"{OP_NAMES[op]}(a={a},b={b},k={k},zneg={zneg}): "
                                f"got {got} expected {exp}")
            checked += 1
    dut._log.info(f"{checked} operations across all six ops correct via the pins")


@cocotb.test()
async def test_both_reductions_reachable_from_pins(cocotb_dut):
    """Both reductions must be usable from outside, and must be different.

    FQMUL(a, 1) is a bare Montgomery reduction; BARRETT(a) is Barrett. Barrett
    preserves the residue, Montgomery multiplies it by R^-1 -- so the two give
    different answers for almost every input, related by exactly that factor.
    If Barrett had been folded onto the multiplier as fqmul(x, R mod q), they
    would agree and this test would fail.
    """
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    random.seed(75)
    differed = 0
    for _ in range(120):
        a = random.randrange(-16000, 16001)
        m, _ = await acc.op(OP_FQMUL, a, 1)
        t, _ = await acc.op(OP_BARRETT, a)
        assert (t - a) % Q == 0 and abs(t) <= Q // 2 + 1, \
            f"BARRETT({a}) = {t} is not a centred representative"
        assert (m * R - a) % Q == 0 and abs(m) < Q, \
            f"FQMUL({a},1) = {m} is not montgomery_reduce"
        assert t == barrett_reduce(a) and m == montgomery_reduce(a)
        if m != t:
            differed += 1
    assert differed > 90, \
        f"only {differed}/120 inputs distinguished the two reductions"
    dut._log.info(f"both reductions reachable through the pins and genuinely "
                  f"distinct ({differed}/120 differ, related by R^-1)")


@cocotb.test()
async def test_twiddle_rom_is_on_chip(cocotb_dut):
    """The host never sends a twiddle value -- only an index. Sweep all 128
    indices through ZMUL, which returns fqmul(z, a), and recover the table.

    With a = 1 the chip returns fqmul(z, 1) = z*R^-1 mod q, so multiplying back
    by R recovers the stored entry. That the recovered table is the reference
    Kyber zetas proves the constants are in silicon, not in this file."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    for k in range(128):
        got, mirror = await acc.op(OP_ZMUL, 1, 0, k)
        assert got == mirror, "ZMUL outputs should mirror"
        assert (got * R - ZETAS[k]) % Q == 0, \
            f"twiddle {k}: chip returned {got}, table holds {ZETAS[k]}"

    # and the negated half, which is what basemul needs
    for k in (1, 64, 65, 100, 127):
        got, _ = await acc.op(OP_ZMUL, 1, 0, k, zneg=1)
        assert (got * R + ZETAS[k]) % Q == 0, f"zneg wrong at k={k}"
    dut._log.info("all 128 twiddles recovered from the chip's own ROM by index, "
                  "plus the negated half")


@cocotb.test()
async def test_register_persistence(cocotb_dut):
    """Registers hold between operations, so a host walking an NTT block only
    rewrites what changed."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    a, b, k = 1234, -567, 33
    first = await acc.op(OP_CT, a, b, k)
    second = await acc.execute()          # no register writes at all
    assert first == second, f"registers did not persist: {first} vs {second}"
    assert first == tuple(s16(v) for v in apply_op(OP_CT, a, b, zeta_of(k)))
    dut._log.info("operand registers persist across operations")


async def host_ntt(acc, coeffs):
    """Forward NTT, sequenced by the host exactly as the FPGA will.

    Note what is NOT here: any twiddle value. The host tracks k, which FIPS 203
    already defines, and the chip looks the constant up itself."""
    r = list(coeffs)
    k = 1
    length = 128
    while length >= 2:
        start = 0
        while start < N:
            for j in range(start, start + length):
                a, b = await acc.op(OP_CT, r[j], r[j + length], k)
                r[j], r[j + length] = a, b
            k += 1
            start += 2 * length
        length >>= 1
    return r


async def host_invntt(acc, coeffs):
    """Inverse NTT, then the final scale by f = 1441."""
    r = list(coeffs)
    k = 127
    length = 2
    while length <= 128:
        start = 0
        while start < N:
            for j in range(start, start + length):
                a, b = await acc.op(OP_GS, r[j], r[j + length], k)
                r[j], r[j + length] = a, b
            k -= 1
            start += 2 * length
        length <<= 1
    return [(await acc.op(OP_FQMUL, x, F))[0] for x in r]


@cocotb.test()
async def test_forward_ntt(cocotb_dut):
    """A complete 256-point forward NTT driven through the pins."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    random.seed(72)
    v = [centre(random.randrange(Q)) for _ in range(N)]
    got = await host_ntt(acc, v)
    exp = ntt(v)
    bad = [(i, got[i], exp[i]) for i in range(N) if got[i] != exp[i]]
    for i, g, e in bad[:8]:
        dut._log.error(f"coefficient {i}: got {g}, expected {e}")
    assert not bad, f"{len(bad)}/{N} coefficients differ from the golden model"
    dut._log.info("forward NTT: 896 butterflies, all 256 coefficients match")


@cocotb.test()
async def test_ntt_intt_round_trip(cocotb_dut):
    """NTT then INTT through the pins must return f*R, per Eq (10.4), and a
    single montgomery_reduce must then recover the original polynomial.

    The inverse transform is where both reductions earn their place: every GS
    butterfly Barrett-reduces its a+b path and Montgomery-reduces its multiply,
    in the same operation."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    random.seed(73)
    v = [centre(random.randrange(Q)) for _ in range(N)]

    fwd = await host_ntt(acc, v)
    assert fwd == ntt(v), "forward transform diverged"

    inv = await host_invntt(acc, fwd)
    assert inv == invntt(fwd), "inverse transform diverged"

    assert all((inv[i] - v[i] * R_MOD_Q) % Q == 0 for i in range(N)), \
        "round trip is not f*R mod q"

    # strip the residual R with one FQMUL(x, 1), i.e. a bare montgomery_reduce
    recovered = [(await acc.op(OP_FQMUL, x, 1))[0] for x in inv]
    assert all((recovered[i] - v[i]) % Q == 0 for i in range(N)), \
        "montgomery_reduce did not recover the original coefficients"
    dut._log.info("NTT -> INTT through the pins recovers all 256 coefficients "
                  "(Eq 10.4, then one montgomery_reduce)")


@cocotb.test()
async def test_known_vector(cocotb_dut):
    """A transform whose answer can be written down without the model.

    NTT of the constant polynomial f(x) = 1 is, by the CRT definition, the pair
    (1, 0) at every one of the 128 quadratic factors -- f is already its own
    remainder mod each x^2 - gamma. The datapath works in the Montgomery domain,
    so the stored result is congruent to those values, not equal to them."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    f = [0] * N
    f[0] = 1
    got = await host_ntt(acc, f)
    for i in range(128):
        assert got[2 * i] % Q == 1, f"factor {i}: constant term is {got[2 * i]}"
        assert got[2 * i + 1] % Q == 0, f"factor {i}: linear term is not zero"
    dut._log.info("NTT(1) = (1,0) at all 128 quadratic factors -- checked "
                  "against the CRT definition, not the model")


@cocotb.test()
async def test_basemul(cocotb_dut):
    """A pointwise product, composed on chip from FQMUL, ZMUL and ADD.

    This is the operation that would force the twiddle table back into the host
    if ZMUL did not exist: its twiddles are the signed pair +/-zetas[64+i], and
    the sign is what zneg supplies."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    random.seed(74)
    for i in range(0, 64, 9):
        for zneg in (0, 1):
            a0, a1, b0, b1 = (centre(random.randrange(Q)) for _ in range(4))
            k = 64 + i

            # r0 = fqmul(fqmul(a1,b1), zeta) + fqmul(a0,b0)
            t, _ = await acc.op(OP_FQMUL, a1, b1)
            t, _ = await acc.op(OP_ZMUL, t, 0, k, zneg)
            u, _ = await acc.op(OP_FQMUL, a0, b0)
            r0, _ = await acc.op(OP_ADD, t, u)

            # r1 = fqmul(a0,b1) + fqmul(a1,b0)
            t, _ = await acc.op(OP_FQMUL, a0, b1)
            u, _ = await acc.op(OP_FQMUL, a1, b0)
            r1, _ = await acc.op(OP_ADD, t, u)

            exp = basemul(a0, a1, b0, b1, zeta_of(k, zneg))
            assert (r0, r1) == tuple(s16(x) for x in exp), \
                f"basemul at k={k} zneg={zneg}: got {(r0, r1)} expected {exp}"
    dut._log.info("basemul composed on chip from FQMUL/ZMUL/ADD, with the "
                  "twiddle and its negation both from the on-chip table")


@cocotb.test()
async def test_latency_is_uniform(cocotb_dut):
    """Every op must take the same number of clocks.

    An earlier revision let BARRETT and ADD answer immediately, which left the
    whole Barrett reduction in a single-cycle path from the op register to the
    result register -- post-layout timing rejected it by 1.51 ns at the slow
    corner. Barrett is registered now and the latency is uniform. A datapath
    that silently reverts to two latencies would corrupt a host that had
    stopped polling, so this is pinned down rather than assumed.
    """
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    async def clocks_to_first_byte(op, a, b):
        await acc.write(A_LO, a & 0xFF)
        await acc.write(A_HI, (a >> 8) & 0xFF)
        await acc.write(B_LO, b & 0xFF)
        await acc.write(B_HI, (b >> 8) & 0xFF)
        await acc.write(CTRL, op)
        d = dut
        d.uio_in.value = 1 << START_BIT
        await RisingEdge(d.clk)
        d.uio_in.value = 0
        n = 0
        while True:
            await ReadOnly()
            v = pin(d.uio_out, OUT_VALID_BIT)
            await NextTimeStep()
            if v:
                return n
            n += 1
            assert n < OP_TIMEOUT
            await RisingEdge(d.clk)

    seen = {}
    for op in (OP_CT, OP_GS, OP_FQMUL, OP_ZMUL, OP_BARRETT, OP_ADD):
        seen[OP_NAMES[op]] = await clocks_to_first_byte(op, 1000, 2000)
        await ClockCycles(dut.clk, 8)

    assert len(set(seen.values())) == 1, f"latency is not uniform: {seen}"
    dut._log.info(f"every op answers in {list(seen.values())[0]} clocks: {seen}")


@cocotb.test()
async def test_uio_directions(cocotb_dut):
    """uio_oe must expose exactly the two status outputs and nothing else."""
    dut = cocotb_dut
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    acc = Accel(dut)
    await acc.reset()

    oe = dut.uio_oe.value
    assert oe.is_resolvable, f"uio_oe unresolvable: {oe}"
    assert int(oe) == 0b01100000, f"uio_oe should be 0b01100000, got {int(oe):#010b}"
    dut._log.info("uio_oe = 0b01100000: uio[5]=out_valid, uio[6]=busy, rest inputs")
