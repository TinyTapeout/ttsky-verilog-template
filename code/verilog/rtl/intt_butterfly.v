// ============================================================================
//  intt_butterfly.v  -  The Gentleman-Sande butterfly: core of the ML-KEM INTT
// ----------------------------------------------------------------------------
//  Bit-exact hardware translation of the inner loop of invntt() in ntt.hpp:
//
//      int16_t t   = r[j];                            // save lower  (= a)
//      r[j]        = barrett_reduce(t + r[j + len]);  // barrett(a + b)
//      r[j + len]  = r[j + len] - t;                  // b - a
//      r[j + len]  = fqmul(zeta, r[j + len]);         // fqmul(zeta, b - a)
//
//  Both outputs are computed from the ORIGINAL (pre-write) a and b, exactly
//  matching the read-then-write ordering of the sequential C++ loop.
//
//  Where the forward (Cooley-Tukey) butterfly multiplies *before* the add/sub,
//  the inverse (Gentleman-Sande) butterfly adds/subtracts first and multiplies
//  the difference by the twiddle -- and Barrett-reduces the sum to keep it small.
//  Coefficients are signed 16-bit, matching the int16_t storage of the C++.
// ============================================================================
`default_nettype none

module intt_butterfly (
    input  wire signed [15:0] a,       // r[j]        (lower coefficient)
    input  wire signed [15:0] b,       // r[j + len]  (upper coefficient)
    input  wire signed [15:0] zeta,    // twiddle factor for this block
    output wire signed [15:0] a_out,   // r[j]       = barrett_reduce(a + b)
    output wire signed [15:0] b_out    // r[j + len] = fqmul(zeta, b - a)
);
    wire signed [15:0] sum = a + b;    // (int16_t)(a + b)  -- 16-bit wrap
    wire signed [15:0] dif = b - a;    // (int16_t)(b - a)  -- 16-bit wrap

    barrett_reduce u_bar (
        .a (sum),
        .r (a_out)
    );

    fqmul u_fqmul (
        .a (zeta),
        .b (dif),
        .r (b_out)
    );
endmodule

`default_nettype wire
