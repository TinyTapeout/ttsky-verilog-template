// Gentleman-Sande butterfly -- the inverse-NTT counterpart to butterfly.v
// (Cooley-Tukey). Mirrors the same structural-composition style: pure
// wiring of the three verified primitives, no new arithmetic.
//
//   a_out = (a + b) mod q                    -> f[j]
//   b_out = zeta * ((b - a) mod q) mod q      -> f[j+len]
//
// mod_mult is a 4-cycle pipelined datapath (see mod_mult.v). As with
// butterfly.v, no delay line is needed here: as long as the caller holds
// a/b/zeta stable for the full 4 cycles, `diff` (mod_sub's output, itself
// combinational) stays constant and mod_mult's result settles correctly
// against it. clk only passes through to mod_mult.

module intt_butterfly (
    input  wire        clk,
    input  wire [11:0] a,        // f[j]
    input  wire [11:0] b,        // f[j+len]
    input  wire [11:0] zeta,     // twiddle factor for this block

    output wire [11:0] a_out,    // f[j]       = a + b
    output wire [11:0] b_out     // f[j+len]   = zeta * (b - a)
);
    wire [11:0] diff;    // b - a mod q

    mod_add u_add (
        .a (a),
        .b (b),
        .c (a_out)
    );

    mod_sub u_sub (
        .a (b),
        .b (a),
        .c (diff)
    );

    mod_mult u_mult (
        .clk (clk),
        .a (zeta),
        .b (diff),
        .c (b_out)
    );
endmodule
