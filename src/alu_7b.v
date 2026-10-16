/*
 * alu_7b.v — 7-bit Arithmetic Logic Unit (combinational)
 *
 * Bootcamp IC Design & Fabrication — IEEE OpenSilicon / IEEE CASS UTP 2026
 *
 * Pure combinational module. Receives two 7-bit operands and a 3-bit
 * operation code; delivers an 8-bit result.
 * Bit [7] of the result carries the overflow:
 *   - Addition : bit[7] = carry-out
 *   - Subtraction: bit[7] = borrow (two's complement)
 *   - Logic ops : bit[7] = 0 (always)
 *
 * OPERATION TABLE (op[2:0]):
 *   000 → ADD   result = A + B   (bit[7] = carry)
 *   001 → AND   result = A & B
 *   010 → OR    result = A | B
 *   011 → XOR   result = A ^ B
 *   100 → SUB   result = A - B   (bit[7] = borrow, two's complement)
 *
 * NOTE ON `timescale:
 *   `timescale is intentionally omitted from synthesis RTL files.
 *   It is only meaningful in simulation (testbench tb.v).
 *   Verilator warns (TIMESCALEMOD) when some modules in a compilation
 *   unit have `timescale and others (e.g. SKY130 PDK black-box models)
 *   do not. The suppress directive below silences that warning on the
 *   PDK side; this file simply does not declare `timescale at all,
 *   which is the correct practice for synthesisable RTL.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/* verilator lint_off TIMESCALEMOD */
`default_nettype none

module alu_7b (
    input  wire [6:0] A,       // Operand A (7 bits)
    input  wire [6:0] B,       // Operand B (7 bits)
    input  wire [2:0] op,      // Operation code
    output reg  [7:0] result   // 8-bit result (includes carry/borrow in bit[7])
);

    always @(*) begin
        case (op)
            3'b000: result = {1'b0, A} + {1'b0, B};  // ADD  — bit[7] = carry
            3'b001: result = {1'b0, A & B};            // AND
            3'b010: result = {1'b0, A | B};            // OR
            3'b011: result = {1'b0, A ^ B};            // XOR
            3'b100: result = {1'b0, A} - {1'b0, B};   // SUB  — bit[7] = borrow (C2)
            default: result = 8'b0;
        endcase
    end

endmodule
/* verilator lint_on TIMESCALEMOD */
