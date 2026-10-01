import cocotb 
from cocotb.triggers import Timer 

Q, ZC = 3329, 17

# 7 bit reversion 
def bitrev7(i):
    r = 0 
    for b in range (7): 
        r = (r << 1) | ((i >> b) & 1)
    return r 

# golden model zeta to run the bitrev7
def golden_zeta(k):
    return pow(ZC, bitrev7(k), Q)


@cocotb.test()
async def test_twiddle_rom(dut):
    for k in range(1, 128):             # go through all indices
        dut.k.value = k 
        await Timer(1, unit="ns")
        exp = golden_zeta(k)
        got = int(dut.zeta.value)
        assert got == exp, f"ROM[{k}] FAIL: got {got}, ep {exp}"
    # index 0 should hit the default 
    dut.k.value = 0 
    await Timer(1, unit="ns")
    assert int(dut.zeta.value) == 0, f"ROM[0] default FAIL: got {int(dut.zeta.value)}"
    dut._log.info("twiddle ROM: all 127 entries + default verified")

    