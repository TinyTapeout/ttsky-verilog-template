/*
 * tt_um_ntt.v -- Tiny Tapeout wrapper for the ML-KEM-512 NTT/INTT accelerator.
 *
 * The chip is the arithmetic engine of the transform, and it holds the twiddle
 * table. A host -- an Arty A7 FPGA -- holds the 256-coefficient polynomial and
 * walks the address pattern; the chip performs every modular operation the
 * forward transform, the inverse transform and basemul need, and looks up its
 * own twiddles from an index.
 *
 * Pin map:
 *   ui_in [7:0]  write data byte
 *   uio_in[2:0]  register address
 *   uio_in[3]    write enable
 *   uio_in[4]    start (rising edge launches one operation)
 *   uo_out[7:0]  result byte
 *   uio_out[5]   out_valid
 *   uio_out[6]   busy
 *
 * Operations are multi-cycle, so the host must wait for busy to fall before
 * writing new operands. See src/ntt_io.v for the register map and the protocol.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ntt (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [2:0] waddr = uio_in[2:0];
    wire       we    = uio_in[3];
    wire       start = uio_in[4];

    wire [7:0] out_byte;
    wire       out_valid;
    wire       busy;

    ntt_top u_ntt (
        .clk       (clk),
        .rst       (~rst_n),   // the engine uses active-high reset, TT supplies active-low
        .in_byte   (ui_in),
        .waddr     (waddr),
        .we        (we),
        .start     (start),
        .out_byte  (out_byte),
        .out_valid (out_valid),
        .busy      (busy)
    );

    assign uo_out = out_byte;

    // uio[2:0], uio[3], uio[4] are inputs; uio[5] and uio[6] are status outputs.
    assign uio_out = {1'b0, busy, out_valid, 5'b00000};
    assign uio_oe  = 8'b01100000;

    // Sink the inputs the design does not read: ena is tied high by the
    // harness, and uio_in[7:5] are spare.
    wire _unused = &{ena, uio_in[7:5], 1'b0};

endmodule

`default_nettype wire
