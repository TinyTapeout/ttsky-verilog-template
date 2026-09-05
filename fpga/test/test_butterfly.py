import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

Q = 3329
SETTLE_CYCLES = 6   # mod_mult's true 5-cycle latency + 1 for cocotb's
                     # active-region read (see test_mod_mult.py for why)


def golden(a, b, zeta):
    t = (zeta * b) % Q
    return (a + t) % Q, (a - t) % Q


@cocotb.test()
async def test_butterfly(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    # flush mod_mult's un-reset pipeline registers (start as X) before the
    # real test cases begin
    dut.a.value = 0
    dut.b.value = 0
    dut.zeta.value = 0
    for _ in range(SETTLE_CYCLES + 1):
        await RisingEdge(dut.clk)

    random.seed(1)
    cases = [(0, 0, 1), (1, 1, 1), (3328, 3328, 1729), (100, 200, 17), (3328, 1, 3328)]
    cases += [(random.randrange(Q), random.randrange(Q), random.randrange(Q))
              for _ in range(5000)]

    for a, b, z in cases:
        dut.a.value = a
        dut.b.value = b
        dut.zeta.value = z
        for _ in range(SETTLE_CYCLES):
            await RisingEdge(dut.clk)
        exp_a, exp_b = golden(a, b, z)
        assert dut.a_out.value == exp_a, f"a_out FAIL {a},{b},{z}: got {int(dut.a_out.value)} exp {exp_a}"
        assert dut.b_out.value == exp_b, f"b_out FAIL {a},{b},{z}: got {int(dut.b_out.value)} exp {exp_b}"
    dut._log.info(f"passed {len(cases)} cases (pipelined, held stable {SETTLE_CYCLES} cyc/case)")
