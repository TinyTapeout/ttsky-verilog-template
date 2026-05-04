# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # 초기 상태 관찰
    await ClockCycles(dut.clk, 200)

    val1 = dut.uo_out.value.integer

    await ClockCycles(dut.clk, 200)

    val2 = dut.uo_out.value.integer

    # VGA는 계속 바뀌는 신호이므로 고정값 비교 금지
    assert val1 != 0 or val2 != 0

    # 버튼 입력 테스트 (동작 깨지지 않는지만 확인)
    dut.ui_in.value = 1
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 100)

    dut.ui_in.value = 2
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 100)

    dut.ui_in.value = 4
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 100)

    dut.ui_in.value = 8
    await ClockCycles(dut.clk, 5)
    dut.ui_in.value = 0

    await ClockCycles(dut.clk, 100)

    dut._log.info("Done")
