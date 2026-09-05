// ntt_top.v -- the engine: byte-serial front end, twiddle ROM, datapath.
//
//                        +--------------+
//        pins  <-------> |   ntt_io     |  operand registers, launch, unload
//                        +--+--------+--+
//                       k |          | a, b, zeta, op
//                  +------v-----+  +-v----------------+
//                  | twiddle_rom|  |    butterfly     |
//                  |  128 x 12  |->| CT GS FQMUL ZMUL |
//                  |  Montgomery| z| BARRETT ADD      |
//                  +------------+  +--+------------+--+
//                                     |            |
//                             +-------v-----+  +---v-------------+
//                             |    fqmul    |  | barrett_reduce  |
//                             | 5-stage,    |  | 2-stage,        |
//                             | Theorem 6.1 |  | Theorem 6.2     |
//                             +-------------+  +-----------------+
//
// ---------------------------------------------------------------------------
// Both reductions, on chip
// ---------------------------------------------------------------------------
// Montgomery (inside fqmul) and Barrett (standalone) are both here, doing the
// jobs the textbook assigns them: Montgomery after every multiply, where the R
// bookkeeping is free; Barrett after chains of additions, where no R factor is
// involved and the value simply needs to come back into range.
//
// Having both is what makes the inverse transform cost one multiply per
// butterfly instead of two. An earlier revision had no Barrett unit and did
// range reduction as fqmul(x, R mod q), which is arithmetically sound but
// occupies the multiplier for a second pass on every Gentleman-Sande butterfly.
//
// ---------------------------------------------------------------------------
// What is on chip and what is not
// ---------------------------------------------------------------------------
// The twiddle table is here, in Montgomery form. The polynomial is not, and
// that is arithmetic rather than preference: 256 coefficients of 16 bits is
// 4,096 flip-flops, which no Tiny Tapeout tile can hold. This shuttle offers no
// SRAM macro either, so there is no denser place to put it.
//
// So the host holds the 256 coefficients and walks the FIPS 203 address
// pattern; the chip holds the constants and does every piece of modular
// arithmetic the transform needs. Both transforms and basemul are covered by
// the six ops in butterfly.v.

`default_nettype none

module ntt_top (
    input  wire       clk,
    input  wire       rst,          // synchronous, active high

    input  wire [7:0] in_byte,
    input  wire [2:0] waddr,
    input  wire       we,
    input  wire       start,
    output wire [7:0] out_byte,
    output wire       out_valid,
    output wire       busy
);

    wire [6:0]         k_idx;
    wire signed [11:0] rom_zeta;

    wire [2:0]         op;
    wire               issue;
    wire signed [15:0] a, b, zeta;
    wire signed [15:0] a_out, b_out;
    wire               mul_done;

    ntt_io u_io (
        .clk       (clk),
        .rst       (rst),
        .in_byte   (in_byte),
        .waddr     (waddr),
        .we        (we),
        .start     (start),
        .out_byte  (out_byte),
        .out_valid (out_valid),
        .busy      (busy),
        .k_idx     (k_idx),
        .rom_zeta  (rom_zeta),
        .op        (op),
        .issue     (issue),
        .a         (a),
        .b         (b),
        .zeta      (zeta),
        .a_out     (a_out),
        .b_out     (b_out),
        .mul_done  (mul_done)
    );

    twiddle_rom u_rom (
        .k    (k_idx),
        .zeta (rom_zeta)
    );

    butterfly u_butterfly (
        .clk       (clk),
        .rst       (rst),
        .op        (op),
        .in_valid  (issue),
        .a         (a),
        .b         (b),
        .zeta      (zeta),
        .a_out     (a_out),
        .b_out     (b_out),
        .out_valid (mul_done)
    );

endmodule

`default_nettype wire
