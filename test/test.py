# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_authQV(dut):
    dut._log.info("Starting authQV QSPI testbench")

    # 1. Start the clock (64 MHz target -> ~15.6 ns period)
    clock = Clock(dut.clk, 16, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize generic TT inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    dut._log.info("Applying TinyQV QSPI Reset Sequence")
    
    # 2. Toggle rst_n high then low to ensure the design sees a falling edge
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 0

    # 3. Configure QSPI Latency & CS during reset
    # During reset, TinyQV reads the QSPI pins to configure its memory timings.
    # The pinout for uio_in is:
    #   [7]: RAM B CS   [6]: RAM A CS   [5]: SD3      [4]: SD2
    #   [3]: SCK        [2]: SD1        [1]: SD0      [0]: Flash CS
    #
    # To set a Read Latency of 2 cycles (SD2:SD0 = 010) and drive all CS high:
    # 0b1100_0101 = 0xC5
    dut.uio_in.value = 0xC5

    # 4. Clock at least 8 times to latch the configuration
    await ClockCycles(dut.clk, 10)

    # 5. Release all QSPI lines and release reset
    dut.uio_in.value = 0x00
    dut.rst_n.value = 1
    
    dut._log.info("Reset complete, CPU is now alive")
    
    # Wait for the CPU memory controller to wake up
    await ClockCycles(dut.clk, 5)

    # 6. Verify QSPI Fetching Behavior
    # uio_out[0] is qspi_flash_select. 
    # Because it is active-low, it should drop to 0 when the CPU tries to fetch its first instruction.
    flash_cs_active = (dut.uio_out.value.integer & 0x01) == 0
    
    if flash_cs_active:
        dut._log.info("SUCCESS: CPU asserted Flash CS (uio_out[0] is LOW) and is attempting to fetch code!")
    else:
        dut._log.warning("Flash CS is HIGH. CPU is not fetching.")

    # 7. Let the simulation run for a while so you can see the QSPI bus traffic in GTKWave
    dut._log.info("Running simulation for 200 cycles to generate waveform data...")
    await ClockCycles(dut.clk, 200)

    dut._log.info("Test passed.")