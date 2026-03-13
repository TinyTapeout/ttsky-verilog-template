# ALU-4 for TinyTapeout (tt_um_alu4)

## 1. Design description

This project implements a small 4-bit Arithmetic Logic Unit (ALU) suitable for TinyTapeout I/O constraints.  
The ALU supports arithmetic, bitwise logic, and simple shifts. Outputs are registered on the rising edge of `clk` and cleared to zero on active-low reset (`rst_n = 0`).

### 1.1 I/O mapping

**Inputs**
- `ui_in[3:0]` = Operand **A** (4-bit)
- `ui_in[7:4]` = Operand **B** (4-bit)
- `uio_in[2:0]` = `opcode` (3-bit)
- `uio_in[3]`   = `cin` (carry-in / borrow-in depending on operation)

**Outputs** (registered)
- `uo_out[3:0]` = Result **R** (4-bit)
- `uo_out[4]`   = **Z** (Zero flag): 1 if `R == 0`
- `uo_out[5]`   = **N** (Negative flag): `R[3]`
- `uo_out[6]`   = **C** (Carry / No-borrow flag): carry-out for add; “no borrow” for sub
- `uo_out[7]`   = **V** (Signed overflow flag): valid for add/sub

`uio_out` and `uio_oe` are not used (always 0).

### 1.2 Opcode table

- `000` ADD: `R = A + B + cin`
- `001` SUB: `R = A - B - cin` (implemented as `A + ~B + (1-cin)`); `C=1` indicates **no borrow**
- `010` AND: `R = A & B`
- `011` OR : `R = A | B`
- `100` XOR: `R = A ^ B`
- `101` SHL: `R = A << 1`, `C = A[3]`
- `110` SHR: `R = A >> 1`, `C = A[0]`
- `111` PASS: `R = A`

## 2. Testbench description and justification

A self-checking Verilog testbench drives the DUT with a clock and reset, applies stimuli, and checks the registered outputs against a reference model computed inside the testbench.

Test coverage includes:
1. Reset behavior check (`uo_out` must become `0x00` after reset).
2. Directed edge cases for carry, borrow, zero, shift carry-out, and signed overflow scenarios.
3. An exhaustive sweep of all input combinations:
   - 8 opcodes × 2 cin values × 16 A values × 16 B values = **4096** checked cases.

For each case, the testbench computes expected `R, Z, N, C, V` and compares them to the DUT outputs after the next rising clock edge. Any mismatch triggers `$fatal`. If all cases pass, the testbench prints a `PASS` message and exits successfully.

## 3. Use of GenAI tools

GenAI was used to help draft the Verilog ALU module, the self-checking testbench structure, and this documentation.  
The final code was reviewed and edited to ensure correctness, clear I/O mapping, and thorough test coverage.

## 
