<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

>The top‑level module tt_um_alu7b connects external inputs/outputs to a serial ALU controller (serial_alu_ctrl).

Input signals:

>ui_in[0]: Serial bit input stream.

>ui_in[3:1]: Operation code (op[2:0]) selecting the ALU function.

>The ALU processes the incoming serial data according to the selected operation and produces an 8‑bit result on uo_out[7:0].

>A Done flag (done_reg) indicates when the operation is complete. This is exposed on uio_out[0].

>Output enable (uio_oe) ensures only uio_out[0] drives an external signal, while other bidirectional pins remain unused.

>Reset (rst_n) clears the ALU state, and the system clock (clk) drives the sequential logic.

## How to test

> Reset the design: Hold rst_n low, then release it high to initialize.

Provide inputs:

> Stream your data bits into ui_in[0] one clock cycle at a time.

> Set the operation code on ui_in[3:1] before starting.

Observe outputs:

> The computed result appears on uo_out[7:0].

> When the computation is complete, uio_out[0] goes high (Done).

Verification:

> Compare the result against expected ALU outputs for the given operation.

> Monitor timing to ensure the Done flag asserts only after the full operation.

## External hardware

> None required.

> All inputs/outputs are handled via the TinyTapeout interface pins.

> Optional: You can connect LEDs to uo_out[7:0] to visualize the result and one LED to uio_out[0] for the Done signal.
