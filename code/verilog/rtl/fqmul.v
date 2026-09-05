// ============================================================================
//  fqmul.v  -  Modular multiply of two Montgomery-domain coefficients mod q
// ----------------------------------------------------------------------------
//  Bit-exact hardware translation of the C++ reference (reduce.hpp):
//
//      int16_t fqmul(int16_t a, int16_t b) {
//          return montgomery_reduce((int32_t)a * b);
//      }
//
//  This is THE single operation the NTT performs most often: one 16x16 signed
//  multiply feeding one Montgomery reduction.  Purely combinational.
// ============================================================================
`default_nettype none

module fqmul (
    input  wire signed [15:0] a,
    input  wire signed [15:0] b,
    output wire signed [15:0] r
);
    wire signed [31:0] prod = a * b;   // (int32_t)a * b  -- 16x16 -> 32-bit exact

    montgomery_reduce u_mont (
        .a (prod),
        .t (r)
    );
endmodule

`default_nettype wire
