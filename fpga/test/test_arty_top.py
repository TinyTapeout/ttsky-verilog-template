import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

STABLE_CYCLES = 10   # must match Makefile_arty_top's -P override for u_start_db

LED_PASS = 0x1        # LED[0]
LED_BUSY = 0x2         # LED[1]
LED_RUN_TOGGLE = 0x4   # LED[2]
LED_HEARTBEAT = 0x8    # LED[3]


async def press_start(dut, hold_cycles):
    dut.BTN.value = 0b01     # BTN[0] = start
    for _ in range(hold_cycles):
        await RisingEdge(dut.clk)
    dut.BTN.value = 0b00


async def wait_for_run_toggle_change(dut, prev_toggle, max_cycles=20000):
    # LED[0]=pass_o defaults HIGH out of reset (demo_top.v's `mismatch`
    # register resets to 0, so `!mismatch` reads 1 before any run has ever
    # happened) -- so polling for LED[0] alone can never distinguish "a real
    # run just completed" from "no run has happened yet". LED[2]=run_toggle
    # only ever changes on a real `done` pulse, so waiting for IT to flip is
    # the unambiguous way to detect a completed run.
    for _ in range(max_cycles):
        await ReadOnly()
        cur = int(dut.LED.value) & LED_RUN_TOGGLE
        if cur != prev_toggle:
            return
        await RisingEdge(dut.clk)
    assert False, "run_toggle (LED[2]) never changed -- a run never completed"


@cocotb.test()
async def test_arty_top(dut):
    cocotb.start_soon(Clock(dut.clk, 2, units="ns").start())

    dut.BTN.value = 0b00
    for _ in range(3):
        await RisingEdge(dut.clk)

    # reset via BTN[1] (level-sensitive, synchronized only, no debounce)
    dut.BTN.value = 0b10
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.BTN.value = 0b00
    await RisingEdge(dut.clk)

    await ReadOnly()
    initial_toggle = int(dut.LED.value) & LED_RUN_TOGGLE
    await RisingEdge(dut.clk)

    # press the (debounced) start button, then wait for a REAL run to finish
    await press_start(dut, STABLE_CYCLES + 5)
    await wait_for_run_toggle_change(dut, initial_toggle)

    led = int(dut.LED.value)
    assert led & LED_PASS, f"LED[0] (pass_o) not set after a completed run: {led:#06b}"
    dut._log.info("arty_top: LED[0] (pass_o) asserted after physical button press -- "
                   "INTT(NTT(f))==f on the board-wrapped demo_top core")
    run_toggle_1 = led & LED_RUN_TOGGLE

    # press start again -- re-triggerable, and LED[2] must flip again
    await RisingEdge(dut.clk)
    await press_start(dut, STABLE_CYCLES + 5)
    await wait_for_run_toggle_change(dut, run_toggle_1)

    led2 = int(dut.LED.value)
    assert led2 & LED_PASS, f"LED[0] (pass_o) not set after second run: {led2:#06b}"
    run_toggle_2 = led2 & LED_RUN_TOGGLE
    assert run_toggle_2 != run_toggle_1, "LED[2] (run_toggle) did not flip between two completed runs"
    dut._log.info("arty_top: LED[2] correctly toggled between two consecutive runs, "
                   "confirming re-triggerability -- PASS")
