import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

LATENCY = 7   # must match intt_control_fsm.v's LATENCY localparam


def golden_trace():
    """('bfly', addr_a, addr_b, k) for each of 896 GS butterflies, then
    ('scale', i) for each of 256 final-pass steps -- each step now held for
    LATENCY cycles, we asserted only on the last."""
    trace = []
    k = 127
    for length in (2, 4, 8, 16, 32, 64, 128):
        start = 0
        while start < 256:
            for j in range(start, start + length):
                trace.append(("bfly", j, j + length, k))
            k -= 1
            start += 2 * length
    for i in range(256):
        trace.append(("scale", i))
    return trace


@cocotb.test()
async def test_intt_control_fsm(dut):
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
    for i, step in enumerate(expected):
        addr0 = None
        for cyc in range(LATENCY):
            await ReadOnly()
            we = int(dut.we.value)
            if step[0] == "bfly":
                _, ea, eb, ek = step
                assert dut.scale_phase.value == 0, f"step {i}: scale_phase set during butterfly phase"
                got = (int(dut.addr_a.value), int(dut.addr_b.value), int(dut.k.value))
                exp = (ea, eb, ek)
            else:
                _, ei = step
                assert dut.scale_phase.value == 1, f"step {i}: scale_phase not set during scale phase"
                got = int(dut.addr_a.value)
                exp = ei
            if cyc == 0:
                addr0 = got
            else:
                assert got == addr0, f"step {i} cyc {cyc}: address changed mid-stall: {got} != {addr0}"
            if cyc == LATENCY - 1:
                assert we == 1, f"step {i}: we not asserted on the last stall cycle"
            else:
                assert we == 0, f"step {i} cyc {cyc}: we asserted early"
            await RisingEdge(dut.clk)
        assert addr0 == exp, f"step {i}: got {addr0}, expected {exp}"

    await ReadOnly()
    assert dut.done.value == 1, "done not asserted the cycle after the last scale step's stall window"
    dut._log.info(f"intt_control_fsm: all {len(expected)} steps matched golden trace "
                   f"(each held {LATENCY} cycles, we correctly gated), done asserted correctly")
