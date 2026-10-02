# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


def ui_value(prog_mode, we, start, enter, player_input):
    value = 0
    value = value | (prog_mode << 0)
    value = value | (we << 1)
    value = value | (start << 2)
    value = value | (enter << 3)
    value = value | (player_input << 4)
    return value


async def press_button(dut, button):
    # Activate enter with the selected player input
    dut.ui_in.value = ui_value(0, 0, 0, 1, button)
    await ClockCycles(dut.clk, 1)

    # Lower enter and keep the button value for one more cycle
    dut.ui_in.value = ui_value(0, 0, 0, 0, button)
    await ClockCycles(dut.clk, 1)

    # Clear inputs
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Simon memory game test")

    # Clock period: 10 us, same style as Tiny Tapeout template
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Initial reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 3)

    # ==========================================================
    # Program RAM
    #
    # ui_in[0] = prog_mode
    # ui_in[1] = we
    # uio_in[3:0] = address
    # uio_in[7:0] = data
    #
    # Test sequence:
    # address 0 -> data 0
    # address 1 -> data 1
    # address 2 -> data 2
    # address 3 -> data 3
    # ==========================================================

    dut._log.info("Programming RAM")

    # Write data 0 at address 0
    dut.uio_in.value = 0
    dut.ui_in.value = ui_value(1, 1, 0, 0, 0)
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = ui_value(1, 0, 0, 0, 0)
    await ClockCycles(dut.clk, 1)

    # Write data 1 at address 1
    dut.uio_in.value = 1
    dut.ui_in.value = ui_value(1, 1, 0, 0, 0)
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = ui_value(1, 0, 0, 0, 0)
    await ClockCycles(dut.clk, 1)

    # Write data 2 at address 2
    dut.uio_in.value = 2
    dut.ui_in.value = ui_value(1, 1, 0, 0, 0)
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = ui_value(1, 0, 0, 0, 0)
    await ClockCycles(dut.clk, 1)

    # Write data 3 at address 3
    dut.uio_in.value = 3
    dut.ui_in.value = ui_value(1, 1, 0, 0, 0)
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = ui_value(1, 0, 0, 0, 0)
    await ClockCycles(dut.clk, 1)

    # Exit programming mode
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 3)

    # ==========================================================
    # Start game
    # ui_in[2] = start
    # ==========================================================

    dut._log.info("Starting game")

    dut.ui_in.value = ui_value(0, 0, 1, 0, 0)
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 4)

    # ==========================================================
    # Level 1
    # Expected sequence: 0
    # ==========================================================

    dut._log.info("Testing level 1")

    await press_button(dut, 0)
    await ClockCycles(dut.clk, 4)

    # uo_out[4] = error
    assert (dut.uo_out.value.integer & 0b00010000) == 0, "Error should not be active after level 1"

    # ==========================================================
    # Level 2
    # Expected sequence: 0, 1
    # ==========================================================

    dut._log.info("Testing level 2")

    await press_button(dut, 0)
    await press_button(dut, 1)
    await ClockCycles(dut.clk, 5)

    assert (dut.uo_out.value.integer & 0b00010000) == 0, "Error should not be active after level 2"

    # ==========================================================
    # Level 3 with wrong answer
    # Expected sequence: 0, 1, 2
    # Wrong last value: 3
    # ==========================================================

    dut._log.info("Testing wrong answer at level 3")

    await press_button(dut, 0)
    await press_button(dut, 1)
    await press_button(dut, 3)
    await ClockCycles(dut.clk, 5)

    # uo_out[4] = error
    assert (dut.uo_out.value.integer & 0b00010000) != 0, "Error should be active after wrong answer"

    dut._log.info("Test finished successfully")
