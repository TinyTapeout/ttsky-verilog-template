<!---
This file is used to generate your project datasheet.
-->

## How it works

This project implements the **Cooley–Tukey butterfly** that is the core arithmetic
primitive of the Number Theoretic Transform (NTT) used by **ML-KEM-512**
(FIPS 203, formerly CRYSTALS-Kyber).

Every NTT butterfly is one modular multiply followed by an add and a subtract,
all modulo the prime `q = 3329`:

```
t     = zeta * b   (mod q)   -- Montgomery modular multiply
a_out = a + t                -- butterfly add
b_out = a - t                -- butterfly subtract
```

The datapath is a bit-exact hardware translation of the reference C++
(`montgomery_reduce`, `fqmul`, and the inner loop of `ntt()`), verified against
24k+ golden vectors generated from that C++ code. Coefficients are signed 16-bit
values in the Montgomery domain, exactly as the software keeps them.

Because the design has only the Tiny Tapeout pin budget (8 in, 8 out, 8 bidir),
the 48 input bits (`a`, `b`, `zeta`) and 32 output bits (`a_out`, `b_out`) are
moved through a small **byte-oriented register interface**.

## How to test

Interface (a byte is written per clock):

| Signal   | Pins        | Direction | Meaning                                        |
|----------|-------------|-----------|------------------------------------------------|
| data_in  | ui[7:0]     | in        | byte written into the addressed input register |
| addr     | uio[2:0]    | in        | selects the input/output byte                  |
| we       | uio[3]      | in        | write-enable: latch data_in into reg[addr]     |
| start    | uio[4]      | in        | run the butterfly and register the result      |
| data_out | uo[7:0]     | out       | result byte selected by addr                   |
| valid    | uio[7]      | out       | high once a result has been computed           |

Write addresses (inputs): `0:a[7:0] 1:a[15:8] 2:b[7:0] 3:b[15:8] 4:zeta[7:0] 5:zeta[15:8]`
Read addresses (outputs): `0:a_out[7:0] 1:a_out[15:8] 2:b_out[7:0] 3:b_out[15:8]`

Procedure: reset (`rst_n=0` then `1`); write the six input bytes with `we=1`;
pulse `start=1` for one clock; wait for `valid=1`; then read the four output
bytes by setting `addr` and reading `data_out`.

A worked example with expected values is in the project report and the cocotb
testbench under `test/`.

## External hardware

None. The design is self-contained; drive it from the RP2040 on the Tiny Tapeout
demo board (or any microcontroller/FPGA GPIO).
