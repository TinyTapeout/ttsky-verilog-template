import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

LATENCY = 7   # must match control_fsm.v's LATENCY localparam


def golden_trace():
    """(addr_a, addr_b, k) for every one of the 896 forward-NTT butterflies,
    in the exact order control_fsm.v is expected to walk them -- each one
    now held stable for LATENCY cycles, with we asserted only on the last."""
    trace = []
    k = 1
    for length in (128, 64, 32, 16, 8, 4, 2):
        start = 0
        while start < 256:
            for j in range(start, start + length):
                trace.append((j, j + length, k))
            k += 1
            start += 2 * length
    return trace


@cocotb.test()
async def test_control_fsm(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.rst.value = 1
    dut.start_i.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.start_i.value = 1
    await RisingEdge(dut.clk)
    dut.start_i.value = 0

    expected = golden_trace()
    got = []
    for i in range(len(expected)):
        we_seen = False
        for cyc in range(LATENCY):
            await ReadOnly()
            addr = (int(dut.addr_a.value), int(dut.addr_b.value), int(dut.k.value))
            we = int(dut.we.value)
            if cyc == 0:
                addr0 = addr
            else:
                assert addr == addr0, f"step {i} cyc {cyc}: address changed mid-stall: {addr} != {addr0}"
            if cyc == LATENCY - 1:
                assert we == 1, f"step {i}: we not asserted on the last stall cycle"
                we_seen = True
            else:
                assert we == 0, f"step {i} cyc {cyc}: we asserted early (before stall window ends)"
            await RisingEdge(dut.clk)
        assert we_seen
        got.append(addr0)

    for i, (exp, act) in enumerate(zip(expected, got)):
        assert act == exp, f"step {i}: got {act}, expected {exp}"

    await ReadOnly()
    assert dut.done.value == 1, "done not asserted the cycle after the last butterfly's stall window"
    dut._log.info(f"control_fsm: all {len(expected)} steps matched golden trace "
                   f"(each held {LATENCY} cycles, we correctly gated), done asserted correctly")
