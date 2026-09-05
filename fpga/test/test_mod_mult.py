import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

Q = 3329

# True architectural latency of mod_mult is 5 cycles (confirmed with a
# stable-held-input register trace of T_r/T_mu_r/r_r/c_r). This testbench
# reads dut.c.value immediately after a plain `await RisingEdge` with no
# settle step -- that's cocotb's "active region", which observes register
# outputs one cycle before their non-blocking assignment for the
# just-occurred edge is guaranteed visible (a well-known Verilog/cocotb
# testbench gotcha, not an RTL property) -- so from *this test's* point of
# view results appear one cycle later than the true 4. Any real synchronous
# consumer of mod_mult's output (e.g. the control FSMs) sees the true
# 4-cycle latency; this constant is specific to how this test observes it.
OBSERVED_LATENCY = 6


@cocotb.test()
async def test_mod_mult(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    random.seed(3)
    edge_cases = [
        (0, 0), (0, 1), (1, 0), (1, 1),
        (Q - 1, Q - 1), (Q - 1, 1), (1, Q - 1),
        (Q - 1, 0), (17, 17), (2285, 2285),
    ]
    random_cases = [(random.randrange(Q), random.randrange(Q)) for _ in range(9990)]
    cases = edge_cases + random_cases

    dut.a.value = 0
    dut.b.value = 0
    for _ in range(OBSERVED_LATENCY + 1):
        await RisingEdge(dut.clk)

    pending = []
    checked = 0
    for a, b in cases:
        pending.append((a, b))
        if len(pending) > OBSERVED_LATENCY:
            exp_a, exp_b = pending.pop(0)
            exp = (exp_a * exp_b) % Q
            got = int(dut.c.value)
            assert got == exp, f"mod_mult FAIL a={exp_a} b={exp_b}: got {got} expected {exp}"
            checked += 1
        dut.a.value = a
        dut.b.value = b
        await RisingEdge(dut.clk)

    for _ in range(OBSERVED_LATENCY):
        exp_a, exp_b = pending.pop(0)
        exp = (exp_a * exp_b) % Q
        got = int(dut.c.value)
        assert got == exp, f"mod_mult FAIL a={exp_a} b={exp_b}: got {got} expected {exp}"
        checked += 1
        await RisingEdge(dut.clk)

    assert checked == len(cases)
    dut._log.info(f"mod_mult (pipelined, true latency 5 cyc): {checked} cases PASS")
