import cocotb
from cocotb.triggers import Timer
import random

Q = 3329


@cocotb.test()
async def test_mod_sub(dut):
    random.seed(5)
    edge_cases = [
        (0, 0), (0, 1), (1, 0), (Q - 1, Q - 1),
        (Q - 1, 0), (0, Q - 1), (Q - 1, 1), (1, Q - 1),
    ]
    random_cases = [(random.randrange(Q), random.randrange(Q)) for _ in range(9992)]
    cases = edge_cases + random_cases

    for a, b in cases:
        dut.a.value = a
        dut.b.value = b
        await Timer(1, unit="ns")
        exp = (a - b) % Q
        got = int(dut.c.value)
        assert got == exp, f"mod_sub FAIL a={a} b={b}: got {got} expected {exp}"

    dut._log.info(f"mod_sub: {len(cases)} cases PASS")
