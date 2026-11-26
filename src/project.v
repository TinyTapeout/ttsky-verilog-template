import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_tensor_core(dut):
    dut._log.info("Start Tensor Core test")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    assert dut.uo_out.value == 0

    # 4 lanes * (1 * 1) = 4
    dut.ui_in.value = 0x11
    dut.uio_in.value = 0x11
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 4

    # Accumulate another cycle -> 8
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 8
