import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

Q = 3329
N = 256


def golden_default_f():
    return [(i * 17 + 5) % Q for i in range(N)]


async def wait_for_done(dut, max_cycles=20000):
    # 256*6 (load, unaffected -- doesn't read coeff_mem) + 896*7 (ntt)
    # + (896+256)*7 (intt) + 257 (compare, now needs 1 drain cycle for
    # coeff_mem's registered read) ~= 16129 cycles: LATENCY=7 in
    # control_fsm.v/intt_control_fsm.v now that coeff_mem's read is
    # registered instead of combinational (see coeff_mem.v).
    for _ in range(max_cycles):
        await ReadOnly()
        if dut.done.value == 1:
            return
        await RisingEdge(dut.clk)
    assert False, "demo_top never asserted done"


@cocotb.test()
async def test_demo_top(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.rst.value = 1
    dut.start_i.value = 0
    dut.ext_addr_sel.value = 0
    dut.ext_addr.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    await ReadOnly()
    assert dut.busy.value == 0
    assert dut.done.value == 0
    await RisingEdge(dut.clk)

    dut.start_i.value = 1
    await RisingEdge(dut.clk)
    dut.start_i.value = 0

    await wait_for_done(dut)
    assert dut.pass_o.value == 1, "demo_top: PASS was not asserted -- INTT(NTT(f)) != f"
    got_cycles = int(dut.cycle_count.value)
    assert 15000 <= got_cycles <= 17000, (
        f"demo_top: cycle_count={got_cycles} outside the expected ~16129-cycle "
        f"range (256*6 load + 896*7 ntt + 1152*7 intt + 257 compare)"
    )
    dut._log.info(f"demo_top: full self-contained NTT->INTT round-trip PASS, cycle_count={got_cycles}")

    await RisingEdge(dut.clk)

    # independently confirm orig_mem holds the expected built-in test vector,
    # and that coeff_mem (post round-trip) matches it too -- not just trust
    # the internal `pass_o` bit blindly.
    exp = golden_default_f()
    dut.ext_addr_sel.value = 1  # read orig_mem
    for addr in range(N):
        dut.ext_addr.value = addr
        await ReadOnly()
        got = int(dut.ext_dout.value)
        assert got == exp[addr], f"orig_mem[{addr}]: got {got}, expected {exp[addr]}"
        await RisingEdge(dut.clk)

    # coeff_mem's read is now registered (see coeff_mem.v): unlike orig_mem's
    # combinational readback above, ext_dout here is only valid the cycle
    # AFTER ext_addr is presented.
    dut.ext_addr_sel.value = 0  # read coeff_mem (post round-trip result)
    for addr in range(N):
        dut.ext_addr.value = addr
        await RisingEdge(dut.clk)
        await ReadOnly()
        got = int(dut.ext_dout.value)
        assert got == exp[addr], f"coeff_mem[{addr}] post-roundtrip: got {got}, expected {exp[addr]}"
        await RisingEdge(dut.clk)   # exit ReadOnly before the next iteration sets ext_addr

    dut._log.info("demo_top: independently verified orig_mem and coeff_mem contents match, all 256 coeffs")

    # run it again to confirm it's re-triggerable, not a one-shot fluke
    dut.start_i.value = 1
    await RisingEdge(dut.clk)
    dut.start_i.value = 0
    await wait_for_done(dut)
    assert dut.pass_o.value == 1, "demo_top: second run PASS was not asserted"
    got_cycles2 = int(dut.cycle_count.value)
    assert got_cycles2 == got_cycles, (
        f"demo_top: cycle_count not reproducible across runs: {got_cycles2} != {got_cycles}"
    )
    dut._log.info(f"demo_top: second run also PASS (re-triggerable), cycle_count={got_cycles2} (matches first run)")
