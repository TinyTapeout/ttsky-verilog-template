// ============================================================================
//  ntt_butterfly.v  -  The Cooley-Tukey butterfly: the core of the ML-KEM NTT
// ----------------------------------------------------------------------------
//  Bit-exact hardware translation of the inner loop of ntt() in ntt.hpp:
//
//      int16_t t = fqmul(zeta, b);   // one modular multiply
//      a_out = a + t;                // r[j]       = r[j] + t
//      b_out = a - t;                // r[j + len] = r[j] - t
//
//  The forward NTT, inverse NTT and base multiply are all just this butterfly
//  sequenced in different orders, so this one module is the reusable arithmetic
//  primitive that the whole transform (and this Tiny Tapeout project) is built on.
//
//  Two views of the same datapath are provided:
//    * ntt_butterfly       -- purely combinational (easy to verify vs. C++)
//    * ntt_butterfly_reg   -- the same with a 1-cycle output register, the form
//                             a clocked pipeline / Tiny Tapeout wrapper uses.
//
//  Coefficients are signed 16-bit, matching the int16_t storage of the C++.
// ============================================================================
`default_nettype none

// ------------------------- Combinational butterfly ---------------------------
module ntt_butterfly (
    input  wire signed [15:0] a,       // r[j]        (lower coefficient)
    input  wire signed [15:0] b,       // r[j + len]  (upper coefficient)
    input  wire signed [15:0] zeta,    // twiddle factor for this block
    output wire signed [15:0] a_out,   // r[j]       = a + t
    output wire signed [15:0] b_out    // r[j + len] = a - t
);
    wire signed [15:0] t;              // t = zeta * b (mod q), the one multiply

    fqmul u_fqmul (
        .a (zeta),
        .b (b),
        .r (t)
    );

    // Stored back into int16_t in C++, i.e. truncated to 16 bits -> plain wrap.
    assign a_out = a + t;
    assign b_out = a - t;
endmodule

// ---------------------- Registered (pipelined) butterfly ---------------------
//  Same math, but the result is captured on the clock edge.  `valid_in` is
//  delayed one cycle to `valid_out` so a streaming pipeline knows when a_out/
//  b_out are meaningful.  Synchronous active-low reset (rst_n), matching the
//  Tiny Tapeout convention.
module ntt_butterfly_reg (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               valid_in,
    input  wire signed [15:0] a,
    input  wire signed [15:0] b,
    input  wire signed [15:0] zeta,
    output reg  signed [15:0] a_out,
    output reg  signed [15:0] b_out,
    output reg                valid_out
);
    wire signed [15:0] a_c, b_c;

    ntt_butterfly u_bf (
        .a     (a),
        .b     (b),
        .zeta  (zeta),
        .a_out (a_c),
        .b_out (b_c)
    );

    always @(posedge clk) begin
        if (!rst_n) begin
            a_out     <= 16'sd0;
            b_out     <= 16'sd0;
            valid_out <= 1'b0;
        end else begin
            a_out     <= a_c;
            b_out     <= b_c;
            valid_out <= valid_in;
        end
    end
endmodule

`default_nettype wire
