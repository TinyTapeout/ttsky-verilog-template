// ============================================================================
//  basemul.v  -  The ML-KEM base-case (pointwise) multiply: (a0+a1 x)(b0+b1 x)
// ----------------------------------------------------------------------------
//  Because ML-KEM's incomplete NTT leaves data as 128 degree-1 polynomials, the
//  product of two "points" is a multiply modulo the quadratic (x^2 - zeta).
//  Bit-exact hardware translation of basemul() in ntt.hpp:
//
//      r0 = fqmul(a1, b1);  r0 = fqmul(r0, zeta);  r0 += fqmul(a0, b0);
//      r1 = fqmul(a0, b1);  r1 += fqmul(a1, b0);
//
//  i.e. the famous "5 multiplies, 2 adds" kernel.  Purely combinational; it is
//  the reusable arithmetic primitive of the pointwise stage, exactly as
//  ntt_butterfly is the primitive of the transform stage.
// ============================================================================
`default_nettype none

module basemul (
    input  wire signed [15:0] a0,
    input  wire signed [15:0] a1,
    input  wire signed [15:0] b0,
    input  wire signed [15:0] b1,
    input  wire signed [15:0] zeta,
    output wire signed [15:0] r0,     // a0*b0 + a1*b1*zeta
    output wire signed [15:0] r1      // a0*b1 + a1*b0
);
    wire signed [15:0] a1b1, a1b1z, a0b0, a0b1, a1b0;

    fqmul u_a1b1  (.a(a1),   .b(b1),   .r(a1b1));   // a1*b1
    fqmul u_a1b1z (.a(a1b1), .b(zeta), .r(a1b1z));  // (a1*b1)*zeta
    fqmul u_a0b0  (.a(a0),   .b(b0),   .r(a0b0));   // a0*b0
    assign r0 = a1b1z + a0b0;                        // int16 wrap, matches C++

    fqmul u_a0b1  (.a(a0),   .b(b1),   .r(a0b1));   // a0*b1
    fqmul u_a1b0  (.a(a1),   .b(b0),   .r(a1b0));   // a1*b0
    assign r1 = a0b1 + a1b0;                         // int16 wrap, matches C++
endmodule

`default_nettype wire
