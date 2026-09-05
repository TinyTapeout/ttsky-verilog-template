// ============================================================================
//  barrett_reduce.v  -  Signed Barrett reduction modulo q = 3329
// ----------------------------------------------------------------------------
//  Bit-exact hardware translation of the C++ reference (reduce.hpp):
//
//      int16_t barrett_reduce(int16_t a) {
//          const int16_t v = ((1<<26) + q/2) / q;              // = 20159
//          int16_t t = (int16_t)(((int32_t)v * a + (1<<25)) >> 26);
//          t = (int16_t)(t * q);
//          return (int16_t)(a - t);
//      }
//
//  Input : a -- 16-bit signed value
//  Output : r -- a value congruent to a (mod q), in a centered range (~-q/2..q/2)
//
//  Purely combinational: one 16x16 multiply for the estimate, one 16x16 for the
//  multiple of q, an add of the rounding constant, an arithmetic shift, and a
//  final subtract.  Used inside every inverse-NTT (Gentleman-Sande) butterfly to
//  keep the running sums from growing out of the signed-16 range.
// ============================================================================
`default_nettype none

module barrett_reduce (
    input  wire signed [15:0] a,
    output wire signed [15:0] r
);
    localparam signed [15:0] Q = 16'sd3329;   // the modulus
    localparam signed [15:0] V = 16'sd20159;  // round(2^26 / q)

    // t = (int16_t)(((int32_t)v*a + 2^25) >> 26)
    wire signed [31:0] va   = V * a;                 // 16x16 -> 32-bit exact
    wire signed [31:0] vah  = va + 32'sd33554432;    // + (1 << 25)  rounding
    wire signed [15:0] t    = vah >>> 26;            // arith. shift, (int16_t) trunc

    // t = (int16_t)(t*q);  return (int16_t)(a - t)
    wire signed [31:0] tq   = t * Q;                 // 16x16 -> 32-bit
    wire signed [15:0] tq16 = tq[15:0];              // (int16_t)(t*q)
    assign r = a - tq16;                             // 16-bit signed wrap
endmodule

`default_nettype wire
