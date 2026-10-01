// ============================================================================
//  montgomery_reduce.v  -  Signed Montgomery reduction modulo q = 3329
// ----------------------------------------------------------------------------
//  Bit-exact hardware translation of the C++ reference (reduce.hpp):
//
//      int16_t montgomery_reduce(int32_t a) {
//          int16_t t = (int16_t)((int16_t)a * QINV);           // low 16 bits
//          t = (int16_t)((a - (int32_t)t * KYBER_Q) >> 16);    // arith. shift
//          return t;
//      }
//
//  Input : a  -- 32-bit signed product (|a| < q * 2^15)
//  Output : t -- 16-bit signed value  t == a * 2^-16 (mod q),  |t| < q
//
//  Purely combinational: one 16x16 multiply for the QINV step, one 16x16
//  multiply for the q step, a subtract and an arithmetic right shift. These map
//  to a couple of DSP-style multipliers and an adder in synthesis.
// ============================================================================
`default_nettype none

module montgomery_reduce (
    input  wire signed [31:0] a,
    output wire signed [15:0] t
);
    // Constants fixed by ML-KEM (see reduce.hpp).
    localparam signed [15:0] QINV = -16'sd3327;  // q^-1 mod 2^16  (== 62209 unsigned)
    localparam signed [15:0] Q    =  16'sd3329;  // the modulus

    // Step 1: m = (a mod 2^16) * QINV, then keep the low 16 bits (signed).
    wire signed [15:0] a_lo = a[15:0];           // (int16_t)a  -- low 16 bits, signed
    wire signed [31:0] m1   = a_lo * QINV;        // 16x16 -> 32-bit exact product
    wire signed [15:0] t1   = m1[15:0];           // (int16_t) truncation

    // Step 2: subtract the multiple of q and arithmetic-shift right by 16.
    wire signed [31:0] m2   = t1 * Q;             // 16x16 -> 32-bit signed
    wire signed [31:0] diff = a - m2;             // a - t1*q
    assign t = diff >>> 16;                        // (int16_t)(diff >> 16) : take low 16
endmodule

`default_nettype wire
