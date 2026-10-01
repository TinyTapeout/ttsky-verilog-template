# Running the live demonstration

A laptop loads a polynomial into the Arty A7-100T over USB, runs the forward transform, runs the
inverse, and streams the result back coefficient by coefficient so a viewer can watch
`INTT(NTT(f)) == f` land 256 times.

## What you need

- An Arty A7-100T and a USB cable
- Vivado 2023.2 to build and program, or the bitstream already in the repository
- Python 3 with `pyserial` installed

## Build and program

```sh
vivado -mode batch -source fpga/arty_a7_100t/build_arty.tcl
```

The script finds its own sources, so the working directory does not matter. The design is `arty_top`,
which wraps `uart_demo_top`. A prebuilt bitstream is already at
`fpga/arty_a7_100t/vivado_project/arty_top.bit` if you would rather just program the board.

The constraints in `fpga/arty_a7_100t/constraints/arty_a7_100t.xdc` place the UART on A9 and D10.

**The pin direction matters and was wrong once.** On the Arty, A9 carries data from the FTDI chip
into the FPGA and D10 carries data out of the FPGA. The constraint file had these crossed for a
while, which is why the host script appeared to hang for no reason. If you change these lines, check
the direction rather than the name.

## Run the host

```sh
cd fpga/arty_a7_100t/host
python uart-host.py
```

It loads 256 coefficients, triggers the forward transform, prints the first five results, triggers
the inverse transform, then reads all 256 back and prints each against the value it started as.

### Two things to change before you present

1. **The serial port.** Line 8 reads `serial.Serial('/dev/ttyUSB1', 115200, timeout=5.0)`. That is a
   Linux path. On Windows it needs the COM port the Arty enumerates as, usually something like
   `COM3`, which you can find in Device Manager under Ports.
2. **The speed.** The whole run finishes in well under a second, which is too fast to watch. Line 88
   has a `time.sleep(0.02)` that is commented out. Uncomment it and the 256 coefficient stream takes
   about five seconds, which is the right pace for someone standing at a poster.

On a Windows console the pass and fail marks are emoji, which raise an encoding error under the old
`cmd.exe`. Windows Terminal and PowerShell 7 handle them.

## The protocol

Four commands over 8N1 at 115200 baud.

| Command | Bytes out | Bytes back | What it does |
| ------- | --------- | ---------- | ------------ |
| Write | `0x01`, addr, lsb, msb | none | writes one 12 bit coefficient |
| Read | `0x02`, addr | lsb, msb | reads one coefficient |
| Forward | `0x03` | `0xAA` when done | runs the NTT |
| Inverse | `0x04` | `0xAA` when done | runs the INTT and the `1/n` scaling |

Addresses are one byte, which covers all 256 coefficients exactly. Values are 12 bits, sent low byte
first, since `q = 3329` needs 12 bits.

The inverse includes the scaling by `128^-1 mod 3329`, which is 3303, so the round trip returns the
original polynomial rather than a multiple of it.

## What the LEDs show

| LED | Meaning |
| --- | ------- |
| 0 | UART receive activity, flickers while the laptop is streaming |
| 1 | Engine busy, stretched so it is visible to the eye |
| 2, 3 | The low bits of the command FSM state |

## If it does not respond

The host raises a clear error rather than hanging, so read which one you get.

- `TimeoutError` on a read means the FPGA is not sending. Check the COM port first, then the UART pin
  directions in the XDC.
- A wrong first coefficient with everything after it shifted means the stream is out of sync. The
  script has no `ser.reset_input_buffer()` at startup, so stale bytes from an aborted run stay
  queued. Unplug and replug the board, or add that call after opening the port.
- `Engine execution completed` never printing means the FSM is stuck waiting on `done`. Press the
  reset button, which is BTN[1].

## Simulating it instead

`fpga/src/tb_uart_demo.v` drives the same command sequence in Vivado's simulator, so the protocol can
be checked without a board. Its last run is logged in
`fpga/arty_a7_100t/vivado_project/arty_top_proj/arty_top_proj.sim/`, and it reports the UART loopback
and the NTT execution both passing.
