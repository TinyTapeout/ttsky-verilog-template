import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

ADDR_AP_CTRL = 0x00
ADDR_STATUS = 0x10
ADDR_CYCLE_COUNT = 0x18


async def axi_write(dut, addr, data, strb=0xF):
    dut.s_axi_control_awaddr.value = addr
    dut.s_axi_control_awvalid.value = 1
    dut.s_axi_control_wdata.value = data
    dut.s_axi_control_wstrb.value = strb
    dut.s_axi_control_wvalid.value = 1
    dut.s_axi_control_bready.value = 1

    # Track AW and W handshakes independently -- they need not fire on the
    # same cycle. Whichever fires gets its valid cleared exactly one cycle
    # later; clearing both on the SAME shared cycle (regardless of which one
    # actually finished first) causes a lingering valid to be misread by the
    # RTL as a brand-new request once its handshake flag has already
    # self-cleared, permanently wedging the write.
    aw_done = w_done = False
    aw_pending_clear = w_pending_clear = False

    while not (aw_done and w_done):
        await RisingEdge(dut.s_axi_control_aclk)
        if aw_pending_clear:
            dut.s_axi_control_awvalid.value = 0
            aw_pending_clear = False
        if w_pending_clear:
            dut.s_axi_control_wvalid.value = 0
            w_pending_clear = False
        await ReadOnly()
        if not aw_done and dut.s_axi_control_awvalid.value == 1 and dut.s_axi_control_awready.value == 1:
            aw_done = True
            aw_pending_clear = True
        if not w_done and dut.s_axi_control_wvalid.value == 1 and dut.s_axi_control_wready.value == 1:
            w_done = True
            w_pending_clear = True

    await RisingEdge(dut.s_axi_control_aclk)
    if aw_pending_clear:
        dut.s_axi_control_awvalid.value = 0
    if w_pending_clear:
        dut.s_axi_control_wvalid.value = 0

    while True:
        await ReadOnly()
        if dut.s_axi_control_bvalid.value == 1:
            break
        await RisingEdge(dut.s_axi_control_aclk)
    await RisingEdge(dut.s_axi_control_aclk)
    dut.s_axi_control_bready.value = 0


async def axi_read(dut, addr):
    dut.s_axi_control_araddr.value = addr
    dut.s_axi_control_arvalid.value = 1
    dut.s_axi_control_rready.value = 1

    while True:
        await RisingEdge(dut.s_axi_control_aclk)
        await ReadOnly()
        if dut.s_axi_control_arvalid.value == 1 and dut.s_axi_control_arready.value == 1:
            break
    await RisingEdge(dut.s_axi_control_aclk)
    dut.s_axi_control_arvalid.value = 0

    while True:
        await ReadOnly()
        if dut.s_axi_control_rvalid.value == 1:
            data = int(dut.s_axi_control_rdata.value)
            break
        await RisingEdge(dut.s_axi_control_aclk)
    await RisingEdge(dut.s_axi_control_aclk)
    dut.s_axi_control_rready.value = 0
    return data


@cocotb.test()
async def test_demo_top_s_axi(dut):
    cocotb.start_soon(Clock(dut.s_axi_control_aclk, 2, units="ns").start())

    dut.s_axi_control_aresetn.value = 0
    dut.s_axi_control_awvalid.value = 0
    dut.s_axi_control_wvalid.value = 0
    dut.s_axi_control_bready.value = 0
    dut.s_axi_control_arvalid.value = 0
    dut.s_axi_control_rready.value = 0
    for _ in range(3):
        await RisingEdge(dut.s_axi_control_aclk)
    dut.s_axi_control_aresetn.value = 1
    await RisingEdge(dut.s_axi_control_aclk)

    # AP_CTRL should read idle=1, done=0, start=0 out of reset
    ctrl = await axi_read(dut, ADDR_AP_CTRL)
    assert ctrl == 0b100, f"AP_CTRL out of reset: {ctrl:#x}, expected idle=1"
    dut._log.info(f"AP_CTRL out of reset: {ctrl:#05b} (idle=1, done=0, start=0) OK")

    # launch a run
    await axi_write(dut, ADDR_AP_CTRL, 0x1)
    dut._log.info("wrote AP_CTRL.ap_start=1 over AXI4-Lite")

    # start_pulse takes a couple cycles to propagate through demo_top_s_axi's
    # edge-detector before demo_top itself leaves S_IDLE, so poll briefly
    # rather than asserting not-idle on the very next read.
    for _ in range(10):
        ctrl = await axi_read(dut, ADDR_AP_CTRL)
        if (ctrl & 0b100) == 0:
            break
    else:
        assert False, f"AP_CTRL never left idle after start: {ctrl:#x}"

    # poll ap_done
    for _ in range(6000):
        ctrl = await axi_read(dut, ADDR_AP_CTRL)
        if ctrl & 0b010:
            break
    else:
        assert False, "AP_CTRL.ap_done never asserted over AXI4-Lite polling"
    dut._log.info(f"AP_CTRL.ap_done observed over AXI4-Lite: {ctrl:#05b}")

    status = await axi_read(dut, ADDR_STATUS)
    pass_bit = (status >> 3) & 1
    phase = status & 0x7
    assert pass_bit == 1, f"STATUS pass bit not set: {status:#x}"
    dut._log.info(f"STATUS register over AXI4-Lite: {status:#x} (pass={pass_bit}, phase={phase}) PASS")

    cycle_count = await axi_read(dut, ADDR_CYCLE_COUNT)
    assert 15000 <= cycle_count <= 17000, (
        f"CYCLE_COUNT={cycle_count} outside the expected ~16129-cycle range"
    )
    dut._log.info(f"CYCLE_COUNT register over AXI4-Lite: {cycle_count} cycles")

    # ap_done should have cleared on read (clear-on-read convention)
    ctrl2 = await axi_read(dut, ADDR_AP_CTRL)
    assert (ctrl2 & 0b010) == 0, f"AP_CTRL.ap_done should clear on read: {ctrl2:#x}"
    assert (ctrl2 & 0b100) != 0, f"AP_CTRL should be idle again: {ctrl2:#x}"
    dut._log.info("AP_CTRL.ap_done correctly cleared on read, idle again")

    dut._log.info("demo_top_s_axi: full AXI4-Lite control-bus round trip PASS")
