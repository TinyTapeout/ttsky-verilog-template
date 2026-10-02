import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start")

    # Inicializar entradas
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset activo en bajo
    dut._log.info("Reset")
    dut.rst_n.value = 0
    await Timer(50, units="us")
    dut.rst_n.value = 1

    dut._log.info("Start counting")

    # Generar clock en ui_in[0]
    for i in range(10):

        # clk = 0
        dut.ui_in.value = 0b00000000
        await Timer(10, units="us")

        # clk = 1
        dut.ui_in.value = 0b00000001
        await Timer(10, units="us")

        dut._log.info(f"Count = {dut.uo_out.value}")