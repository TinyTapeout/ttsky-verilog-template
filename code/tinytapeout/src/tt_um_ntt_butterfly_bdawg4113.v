// ============================================================================
//  tt_um_ntt_butterfly_bdawg4113.v  -  Tiny Tapeout top-level for the ML-KEM NTT butterfly
// ----------------------------------------------------------------------------
//  Tiny Tapeout gives every project the same fixed pin budget: 8 dedicated
//  inputs (ui_in), 8 dedicated outputs (uo_out) and 8 bidirectional pins (uio).
//  The butterfly needs 48 input bits (a, b, zeta) and produces 32 output bits
//  (a_out, b_out), so we wrap it in a tiny byte-oriented register interface:
//  bytes are shifted in one at a time, START runs the (registered) butterfly,
//  and the 4 result bytes are read back out.
//
//  ---- Pin map -------------------------------------------------------------
//  ui_in[7:0]      data byte written into the addressed input register
//
//  uio_in[2:0]     addr  -- selects which byte to write / read:
//                    write side:  0:a[7:0] 1:a[15:8] 2:b[7:0] 3:b[15:8]
//                                 4:zeta[7:0] 5:zeta[15:8]
//                    read  side:  0:aout[7:0] 1:aout[15:8] 2:bout[7:0] 3:bout[15:8]
//  uio_in[3]       we    -- when high, latch ui_in into input register[addr]
//  uio_in[4]       start -- when high, run the butterfly and register the result
//  uio_in[6:5]     unused inputs
//
//  uo_out[7:0]     data_out -- result byte selected by addr (combinational read)
//  uio_out[7]      valid    -- high once a result has been computed (driven out)
//  uio_oe          = 8'b1000_0000  (only uio[7] is an output; uio[6:0] are inputs)
//
//  The core arithmetic is bit-exact to the C++ reference (ntt.hpp / reduce.hpp),
//  verified by tb_ntt_butterfly.v against 24k golden vectors.
// ============================================================================
`default_nettype none

module tt_um_ntt_butterfly_bdawg4113 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (1 = drive out)
    input  wire       ena,      // high when the design is selected (unused)
    input  wire       clk,      // clock
    input  wire       rst_n     // active-low reset
);
    // ---- Decode the control field on the bidirectional input pins ----------
    wire [2:0] addr  = uio_in[2:0];
    wire       we    = uio_in[3];
    wire       start = uio_in[4];

    // ---- Input operand registers (loaded a byte at a time) -----------------
    reg signed [15:0] a_reg, b_reg, zeta_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            a_reg    <= 16'sd0;
            b_reg    <= 16'sd0;
            zeta_reg <= 16'sd0;
        end else if (we) begin
            case (addr)
                3'd0: a_reg[7:0]     <= ui_in;
                3'd1: a_reg[15:8]    <= ui_in;
                3'd2: b_reg[7:0]     <= ui_in;
                3'd3: b_reg[15:8]    <= ui_in;
                3'd4: zeta_reg[7:0]  <= ui_in;
                3'd5: zeta_reg[15:8] <= ui_in;
                default: ;  // 6,7: no-op
            endcase
        end
    end

    // ---- The butterfly datapath (combinational core) -----------------------
    wire signed [15:0] a_bf, b_bf;
    ntt_butterfly u_bf (
        .a     (a_reg),
        .b     (b_reg),
        .zeta  (zeta_reg),
        .a_out (a_bf),
        .b_out (b_bf)
    );

    // ---- Result registers + valid flag -------------------------------------
    reg signed [15:0] aout_reg, bout_reg;
    reg               valid;

    always @(posedge clk) begin
        if (!rst_n) begin
            aout_reg <= 16'sd0;
            bout_reg <= 16'sd0;
            valid    <= 1'b0;
        end else if (start) begin
            aout_reg <= a_bf;
            bout_reg <= b_bf;
            valid    <= 1'b1;
        end
    end

    // ---- Output byte read mux ---------------------------------------------
    reg [7:0] data_out;
    always @(*) begin
        case (addr)
            3'd0: data_out = aout_reg[7:0];
            3'd1: data_out = aout_reg[15:8];
            3'd2: data_out = bout_reg[7:0];
            3'd3: data_out = bout_reg[15:8];
            default: data_out = 8'h00;
        endcase
    end

    assign uo_out  = data_out;
    assign uio_out = {valid, 7'b0000000};  // uio[7] = result valid
    assign uio_oe  = 8'b1000_0000;         // only uio[7] driven as output

    // List unused inputs to keep the linter quiet.
    wire _unused = &{ena, uio_in[7], uio_in[6], uio_in[5], 1'b0};
endmodule

`default_nettype wire
