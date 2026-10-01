// ============================================================================
//  intt_engine.v  -  Full inverse Number Theoretic Transform accelerator
// ----------------------------------------------------------------------------
//  Sequences the intt_butterfly across all 256 coefficients to compute the
//  complete inverse NTT, bit-exact to the C++ reference invntt() in ntt.hpp:
//
//      const int16_t f = 1441;                        // mont^2 / 128
//      unsigned k = 127;
//      for (len = 2; len <= 128; len <<= 1)
//        for (start = 0; start < 256; start += 2*len) {
//          zeta = zetas[k--];
//          for (j = start; j < start+len; j++) {
//            t          = r[j];
//            r[j]       = barrett_reduce(t + r[j+len]);
//            r[j+len]   = r[j+len] - t;
//            r[j+len]   = fqmul(zeta, r[j+len]);
//          }
//        }
//      for (j = 0; j < 256; j++) r[j] = fqmul(r[j], f);   // 1/128 + mont scale
//
//  Two phases share one datapath:
//    * TRANSFORM : 896 Gentleman-Sande butterflies (one per clock), len 2..128,
//                  twiddle index k walking DOWN from 127 to 1.
//    * SCALE     : 256 cycles multiplying every coefficient by f = 1441.
//  Total ~896 + 256 = 1152 cycles plus a little control overhead.
//
//  Same host interface and 256x16 memory model as ntt_engine (async read,
//  sync write, read-then-write ordering), so it is a drop-in inverse companion.
// ============================================================================
`default_nettype none

module intt_engine (
    input  wire               clk,
    input  wire               rst_n,
    // load port (host writes coefficients before starting)
    input  wire               load_en,
    input  wire [7:0]         load_addr,
    input  wire signed [15:0] load_data,
    // control / status
    input  wire               start,
    output reg                busy,
    output reg                done,
    // read port (host reads results)
    input  wire [7:0]         rd_addr,
    output wire signed [15:0] rd_data
);
    localparam signed [15:0] F = 16'sd1441;   // mont^2 / 128 (final scale)

    // ---- Coefficient memory (256 x signed 16) ------------------------------
    reg signed [15:0] mem [0:255];
    assign rd_data = mem[rd_addr];

    // ---- Twiddle ROM (128 x signed 16), loaded from the C++-derived table --
    reg signed [15:0] zetas [0:127];
    initial begin
        `include "zetas_init.vh"
    end

    // ---- Loop state (mirrors the C++ variables) ----------------------------
    reg [7:0] len;        // 2, 4, ..., 128   (distance between paired coeffs)
    reg [7:0] k;          // twiddle / block index (walks 127 -> 1)
    reg [8:0] start_idx;  // block base (0..255, needs 9 bits for the +2*len test)
    reg [7:0] j;          // current lower coefficient index
    reg       phase;      // 0 = TRANSFORM butterflies, 1 = SCALE pass
    reg [7:0] sc;         // scale-pass index (0..255)

    // ---- Combinational Gentleman-Sande butterfly (TRANSFORM phase) ---------
    wire signed [15:0] a_cur = mem[j];
    wire signed [15:0] b_cur = mem[j + len];
    wire signed [15:0] zeta  = zetas[k];
    wire signed [15:0] a_new, b_new;

    intt_butterfly u_bf (
        .a     (a_cur),
        .b     (b_cur),
        .zeta  (zeta),
        .a_out (a_new),   // barrett_reduce(a + b)
        .b_out (b_new)    // fqmul(zeta, b - a)
    );

    // ---- Combinational final scale (SCALE phase): mem[sc] * f --------------
    wire signed [15:0] sc_new;
    fqmul u_scale (
        .a (mem[sc]),
        .b (F),
        .r (sc_new)
    );

    // Block-boundary helpers (TRANSFORM phase).
    wire        last_in_block = (j == start_idx[7:0] + len - 8'd1);
    wire [8:0]  next_start    = start_idx + {len, 1'b0};   // start + 2*len
    wire        layer_done    = (next_start >= 9'd256);
    wire        all_layers    = layer_done && (len == 8'd128);

    // ---- Control FSM -------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            busy      <= 1'b0;
            done      <= 1'b0;
            phase     <= 1'b0;
            len       <= 8'd2;
            k         <= 8'd127;
            start_idx <= 9'd0;
            j         <= 8'd0;
            sc        <= 8'd0;
        end else if (!busy) begin
            // IDLE: accept loads and wait for start.
            if (load_en) mem[load_addr] <= load_data;
            if (start) begin
                busy      <= 1'b1;
                done      <= 1'b0;
                phase     <= 1'b0;
                len       <= 8'd2;
                k         <= 8'd127;
                start_idx <= 9'd0;
                j         <= 8'd0;
                sc        <= 8'd0;
            end
        end else if (phase == 1'b0) begin
            // TRANSFORM: retire one Gentleman-Sande butterfly this cycle.
            mem[j]       <= a_new;   // r[j]       = barrett_reduce(a + b)
            mem[j + len] <= b_new;   // r[j + len] = fqmul(zeta, b - a)

            if (!last_in_block) begin
                j <= j + 8'd1;                      // next pair in this block
            end else begin
                k <= k - 8'd1;                      // consumed this block's twiddle
                if (!layer_done) begin
                    start_idx <= next_start;         // advance to next block
                    j         <= next_start[7:0];
                end else if (!all_layers) begin
                    len       <= len << 1;           // rise to the next layer
                    start_idx <= 9'd0;
                    j         <= 8'd0;
                end else begin
                    phase     <= 1'b1;               // butterflies done -> scale
                    sc        <= 8'd0;
                end
            end
        end else begin
            // SCALE: multiply every coefficient by f = 1441 (folds in 1/128).
            mem[sc] <= sc_new;
            if (sc == 8'd255) begin
                busy <= 1'b0;                        // whole inverse transform done
                done <= 1'b1;
            end else begin
                sc <= sc + 8'd1;
            end
        end
    end
endmodule

`default_nettype wire
