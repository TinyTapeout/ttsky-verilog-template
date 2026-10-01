import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

STABLE_CYCLES = 20   # must match Makefile_debounce's -P override


async def count_pulses(dut, cycles):
    count = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
        await ReadOnly()
        if dut.pulse.value == 1:
            count += 1
    await RisingEdge(dut.clk)   # exit ReadOnly phase before the caller sets a value
    return count


@cocotb.test()
async def test_debounce_pulse(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.rst.value = 1
    dut.btn_raw.value = 0
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)

    # Simulate real mechanical bounce: flip rapidly (1 cycle per level, far
    # faster than STABLE_CYCLES) before finally settling high. Every flip
    # back to the old (0) value resets the stability counter, so none of
    # this should produce a pulse.
    for v in [1, 0, 1, 0, 1, 1, 0, 1, 0]:
        dut.btn_raw.value = v
        await RisingEdge(dut.clk)

    bounce_pulses = await count_pulses(dut, 5)
    assert bounce_pulses == 0, f"bounce alone produced {bounce_pulses} pulse(s), expected 0"

    # Now settle high for real and hold -- exactly one pulse once stable.
    dut.btn_raw.value = 1
    pulses = await count_pulses(dut, STABLE_CYCLES + 10)
    assert pulses == 1, f"expected exactly 1 pulse after settling high, got {pulses}"

    # Continuing to hold high must not produce any further pulses.
    held_pulses = await count_pulses(dut, 30)
    assert held_pulses == 0, f"expected no pulses while held, got {held_pulses}"

    # Release, then press again -> exactly one more pulse (re-triggerable).
    dut.btn_raw.value = 0
    await count_pulses(dut, STABLE_CYCLES + 10)
    dut.btn_raw.value = 1
    pulses2 = await count_pulses(dut, STABLE_CYCLES + 10)
    assert pulses2 == 1, f"expected exactly 1 pulse on second press, got {pulses2}"

    dut._log.info("debounce_pulse: bounce rejected, exactly one clean pulse per real press, PASS")
