# test_twiddle_rom.py -- the on-chip twiddle table.
#
# The ROM is 1,536 bits of generated constants, and a wrong entry does not
# announce itself: the transform still runs, still terminates, and produces a
# result that looks like noise in exactly the same way a correct NTT of random
# input does. So every one of the 128 entries is read and checked, not a sample.
#
# The table is also checked against the mathematics directly --
# zeta[k] = centre(17^brv7(k) * R mod q) -- rather than only against the
# generator script, because the generator and the ROM share an author and would
# share a mistake.

import cocotb
from cocotb.triggers import Timer

from ntt_golden import Q, R, ZETAS, centre


def s12(x):
    """Interpret 12 bits as two's complement."""
    x &= 0xFFF
    return x - 0x1000 if x & 0x800 else x


def _brv7(i):
    r = 0
    for b in range(7):
        r = (r << 1) | ((i >> b) & 1)
    return r


@cocotb.test()
async def test_every_entry(dut):
    """All 128 entries, against centre(17^brv7(k) * R mod q) computed here from
    scratch."""
    for k in range(128):
        dut.k.value = k
        await Timer(1, unit="ns")
        got = s12(int(dut.zeta.value))
        exp = centre(pow(17, _brv7(k), Q) * R)
        assert got == exp, f"zeta[{k}]: ROM has {got}, the definition gives {exp}"
        assert got == ZETAS[k], f"zeta[{k}] disagrees with the golden model"
    dut._log.info("all 128 twiddles match centre(17^brv7(k) * R mod q)")


@cocotb.test()
async def test_table_is_montgomery_not_plain(dut):
    """The entries must be in Montgomery form, not plain field elements.

    This is the single most costly mistake available in this design: a plain
    table is the same width and the same shape, and a Montgomery datapath fed
    with one produces a transform wrong by a factor of R at every butterfly
    while remaining perfectly self-consistent. Pin it down with a value that
    cannot be confused: zeta[1] is -758 in Montgomery form and 1729 plain.
    """
    dut.k.value = 1
    await Timer(1, unit="ns")
    got = s12(int(dut.zeta.value))
    assert got == -758, f"zeta[1] = {got}; Montgomery is -758, plain would be 1729"
    assert got != 1729

    # and the whole table must be the reference Kyber zetas
    head = []
    for k in range(8):
        dut.k.value = k
        await Timer(1, unit="ns")
        head.append(s12(int(dut.zeta.value)))
    assert head == [-1044, -758, -359, -1517, 1493, 1422, 287, 202], head
    dut._log.info(f"zeta[1] = -758 and the table opens {head[:4]}: Montgomery "
                  f"form, bit-identical to the reference Kyber zetas")


@cocotb.test()
async def test_all_entries_fit_and_are_distinct(dut):
    """Every entry must be a centred representative that fits 12 signed bits,
    and all 128 distinct -- 17 has order 256 mod q, so a repeat would mean the
    index order is wrong."""
    seen = []
    for k in range(128):
        dut.k.value = k
        await Timer(1, unit="ns")
        z = s12(int(dut.zeta.value))
        assert -2048 <= z <= 2047, f"zeta[{k}] = {z} does not fit 12 signed bits"
        assert abs(z) <= Q // 2, f"zeta[{k}] = {z} is not centred"
        seen.append(z)
    assert len(set(seen)) == 128, "the table contains duplicates"
    dut._log.info(f"128 distinct centred entries, range [{min(seen)}, {max(seen)}], "
                  f"all inside 12 signed bits")
