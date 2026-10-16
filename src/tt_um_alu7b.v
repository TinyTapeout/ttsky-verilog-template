
`default_nettype none

module tt_um_alu7b (
    input  wire [7:0] ui_in,    // ui_in[0]=Bit_in (serial), ui_in[3:1]=op[2:0]
    output wire [7:0] uo_out,   // Dedicated outputs — result[7:0]
    input  wire [7:0] uio_in,   // Bidirectional IOs: input path  (unused)
    output wire [7:0] uio_out,  // Bidirectional IOs: output path — uio_out[0] = Done
    output wire [7:0] uio_oe,   // Bidirectional IOs: enable path (active high: 1=output)
    input  wire       ena,      // Always 1 when the design is powered
    input  wire       clk,      // System clock
    input  wire       rst_n     // Active-low reset
);


wire done_reg;

serial_alu_ctrl alu (
    .CLK(clk),
    .RST_n(rst_n),
    .Bit_in(ui_in[0]),
    .op(ui_in[3:1]),
    .Data_out(uo_out[7:0]),
    .Done(done_reg)
);

    // ── Output assignments ────────────────────────────────────────────────────
    assign uio_out = {7'b0, done_reg};  // uio_out[0] = Done; uio_out[7:1] = 0
    assign uio_oe  = 8'b0000_0001;      // Only uio[0] is an output

    // ── Unused input tie-off (suppresses linter warnings) ────────────────────
    wire _unused = &{ena, uio_in, ui_in[7:4], 1'b0};

endmodule
/* verilator lint_on TIMESCALEMOD */
