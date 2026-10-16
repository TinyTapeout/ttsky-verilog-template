# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1

    dut._log.info("Test VGA sync")

    seen_hsync_low = False
    seen_hsync_high = False
    seen_vsync_high = False

    for _ in range(1000):
        await ClockCycles(dut.clk, 1)

        value = int(dut.uo_out.value)

        hsync = (value >> 7) & 1
        vsync = (value >> 3) & 1

        if hsync == 0:
            seen_hsync_low = True
        if hsync == 1:
            seen_hsync_high = True
        if vsync == 1:
            seen_vsync_high = True

    assert seen_hsync_low
    assert seen_hsync_high
    assert seen_vsync_high

    dut._log.info("Test button input")

    dut.ui_in.value = 1
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 50)

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 50)

    dut.ui_in.value = 4
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 50)

    dut.ui_in.value = 8
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 50)

    dut._log.info("Done")
