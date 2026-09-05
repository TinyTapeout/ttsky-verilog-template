import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

STRETCH_CYCLES = 20   # must match Makefile_stretch's -P override


@cocotb.test()
async def test_pulse_stretch(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.rst.value = 1
    dut.in_level.value = 0
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    await ReadOnly()
    assert dut.out_stretched.value == 0, "should be low out of reset"
    await RisingEdge(dut.clk)

    # single-cycle input pulse
    dut.in_level.value = 1
    await RisingEdge(dut.clk)
    dut.in_level.value = 0

    # out_stretched must read 1 for exactly STRETCH_CYCLES cycles after that
    for i in range(STRETCH_CYCLES):
        await ReadOnly()
        assert dut.out_stretched.value == 1, f"cycle {i}: expected stretched output high"
        await RisingEdge(dut.clk)

    await ReadOnly()
    assert dut.out_stretched.value == 0, "expected stretched output to have cleared by now"
    dut._log.info(f"pulse_stretch: held high for exactly {STRETCH_CYCLES} cycles, PASS")

    # re-arming: a fresh pulse while idle should stretch again
    await RisingEdge(dut.clk)
    dut.in_level.value = 1
    await RisingEdge(dut.clk)
    dut.in_level.value = 0
    await ReadOnly()
    assert dut.out_stretched.value == 1, "expected re-arm on a second pulse"
    dut._log.info("pulse_stretch: re-arms correctly on a second pulse, PASS")
