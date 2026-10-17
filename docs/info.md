How it works
This design implements a 4-bit synchronous counter.
The counter increments its value on every rising edge of the clock signal.
The clock is provided through ui_in[0].
When reset (rst_n) is low, the counter is cleared to 0.
The counter output is mapped to uo_out[3:0].
---
How to test
Apply reset (rst_n = 0) to initialize the counter.
Release reset (rst_n = 1).
Toggle ui_in[0] to generate a clock signal.
Observe the output on uo_out[3:0].
The output should increment in binary:
0000 → 0001 → 0010 → ... → 1111 → 0000