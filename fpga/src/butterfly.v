//Cooley Tukey Algorithm (top level module) for ML-KEM NTT

// t = zeta * b mod q (twiddle multiply)
// a_out = a + t mod q (upper output, -> f[j])
// b_out = a - t mod q (lower output, -> f[j+len])

// Pure structural composition of three verified blocks.

// 'a' fans out to both adder and subtractor
//'b' only enters the multiply

// mod_mult is now a 4-cycle pipelined datapath (see mod_mult.v -- the
// original zero-register version routed at WNS -11.699 ns). This module
// itself needs no delay line for `a`: as long as the caller holds a/b/zeta
// stable for the full 4 cycles (which control_fsm.v now does, one "stall"
// window per butterfly), `a` is still the same value when `t` finally
// settles, so mod_add/mod_sub combine correctly with no extra registers
// here -- clk is only needed to pass through to mod_mult.

module butterfly(
    input wire         clk,
    input wire [11:0] a,        //f[j]
    input wire [11:0] b,        //f[j+len]
    input wire [11:0] zeta,     //twiddle factor

    output wire [11:0] a_out,    //f[j] after butterfly
    output wire [11:0] b_out    // f[j+len] after butterfly

);
    wire [11:0] t;      // zeta * b mod q

    //.... mod_mult, mod_add, mod_sub pin wrappers
     mod_mult u_mult (
        .clk (clk),
        .a (zeta),
        .b (b),
        .c (t)
    );

    mod_add u_add (
        .a (a),
        .b (t),
        .c (a_out)
    );

    mod_sub u_sub (
        .a (a),
        .b (t),
        .c (b_out)
    );
endmodule
