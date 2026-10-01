// ============================================================================
//  basemul_engine.v  -  Pointwise multiply of two NTT-domain polynomials
// ----------------------------------------------------------------------------
//  Sequences the basemul kernel over the 128 degree-1 "points", bit-exact to
//  the pointwise loop in test_ntt.cpp / poly.hpp:
//
//      for (i = 0; i < 64; i++) {
//        basemul(&c[4i],   &a[4i],   &b[4i],   zetas[64+i]);
//        basemul(&c[4i+2], &a[4i+2], &b[4i+2], -zetas[64+i]);
//      }
//
//  Inputs a_hat and b_hat are the (Barrett-reduced) forward-NTT outputs; the
//  result c_hat is consumed by the inverse NTT.  One base-case multiply is
//  retired per clock (128 total), so the stage costs ~128 cycles.
//
//  Two load ports (a and b) so a host / the poly_mul top can stream both
//  operands in one pass; same start/busy/done/read contract as the engines.
// ============================================================================
`default_nettype none

module basemul_engine (
    input  wire               clk,
    input  wire               rst_n,
    // load ports (write a_hat and b_hat while idle)
    input  wire               load_a_en,
    input  wire [7:0]         load_a_addr,
    input  wire signed [15:0] load_a_data,
    input  wire               load_b_en,
    input  wire [7:0]         load_b_addr,
    input  wire signed [15:0] load_b_data,
    // control / status
    input  wire               start,
    output reg                busy,
    output reg                done,
    // read port (host reads c_hat)
    input  wire [7:0]         rd_addr,
    output wire signed [15:0] rd_data
);
    // ---- operand / result memories (256 x signed 16) -----------------------
    reg signed [15:0] a_hat [0:255];
    reg signed [15:0] b_hat [0:255];
    reg signed [15:0] c_hat [0:255];
    assign rd_data = c_hat[rd_addr];

    // ---- Twiddle ROM (indices 64..127 are the basemul twiddles) ------------
    reg signed [15:0] zetas [0:127];
    initial begin
        `include "zetas_init.vh"
    end

    // ---- iteration state ---------------------------------------------------
    reg [6:0] p;                              // point counter 0..127

    // For point p: i = p>>1 (0..63), sub = p&1 picks the +2 offset and the
    // negated twiddle, exactly mirroring the two basemul() calls per i.
    wire [5:0] i    = p[6:1];
    wire [7:0] grp  = {i, 2'b00};             // 4*i
    wire [7:0] base = p[0] ? (grp | 8'd2) : grp;
    wire [6:0] zidx = 7'd64 + i;              // zetas[64 + i]
    wire signed [15:0] zt = p[0] ? -zetas[zidx] : zetas[zidx];

    wire signed [15:0] r0, r1;
    basemul u_bm (
        .a0   (a_hat[base]),
        .a1   (a_hat[base | 8'd1]),
        .b0   (b_hat[base]),
        .b1   (b_hat[base | 8'd1]),
        .zeta (zt),
        .r0   (r0),
        .r1   (r1)
    );

    // ---- Control FSM -------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            busy <= 1'b0;
            done <= 1'b0;
            p    <= 7'd0;
        end else if (!busy) begin
            // IDLE: accept loads on either port, wait for start.
            if (load_a_en) a_hat[load_a_addr] <= load_a_data;
            if (load_b_en) b_hat[load_b_addr] <= load_b_data;
            if (start) begin
                busy <= 1'b1;
                done <= 1'b0;
                p    <= 7'd0;
            end
        end else begin
            // RUN: retire one base-case multiply (two output coeffs) per cycle.
            c_hat[base]        <= r0;
            c_hat[base | 8'd1] <= r1;
            if (p == 7'd127) begin
                busy <= 1'b0;
                done <= 1'b1;
            end else begin
                p <= p + 7'd1;
            end
        end
    end
endmodule

`default_nettype wire
