import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


async def wait_for_ap_done(dut, max_cycles=4000):
    for _ in range(max_cycles):
        await ReadOnly()
        if dut.ap_done.value == 1:
            return
        await RisingEdge(dut.clk if hasattr(dut, "clk") else dut.ap_clk)
    assert False, "ap_done never asserted"


@cocotb.test()
async def test_demo_top_axi_wrapper(dut):
    cocotb.start_soon(Clock(dut.ap_clk, 2, units="ns").start())

    dut.ap_rst_n.value = 0
    dut.ap_start.value = 0
    await RisingEdge(dut.ap_clk)
    await RisingEdge(dut.ap_clk)
    dut.ap_rst_n.value = 1
    await RisingEdge(dut.ap_clk)

    await ReadOnly()
    assert dut.ap_idle.value == 1, "should be idle out of reset"
    assert dut.ap_done.value == 0
    await RisingEdge(dut.ap_clk)

    # host behavior: hold ap_start high until it sees ap_done, like real XRT control logic
    dut.ap_start.value = 1
    await RisingEdge(dut.ap_clk)

    await ReadOnly()
    assert dut.ap_idle.value == 0, "should leave idle the cycle after ap_start"
    await RisingEdge(dut.ap_clk)

    for _ in range(4000):
        await ReadOnly()
        if dut.ap_done.value == 1:
            break
        await RisingEdge(dut.ap_clk)
    else:
        assert False, "ap_done never asserted"

    pass_bit = (int(dut.pass_reg.value) >> 3) & 1
    assert pass_bit == 1, f"pass_reg={int(dut.pass_reg.value):#x}, expected bit3=1"
    dut._log.info(f"demo_top_axi_wrapper: ap_done asserted, pass_reg={int(dut.pass_reg.value):#x}, PASS")

    # host now drops ap_start (having seen ap_done)
    await RisingEdge(dut.ap_clk)
    dut.ap_start.value = 0
    await RisingEdge(dut.ap_clk)

    await ReadOnly()
    assert dut.ap_idle.value == 1, "should return to idle after ap_start drops"
    dut._log.info("demo_top_axi_wrapper: returned to idle correctly")
