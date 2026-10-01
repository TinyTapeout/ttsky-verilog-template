// ============================================================================
//  ntt_engine.v  -  Full forward Number Theoretic Transform accelerator
// ----------------------------------------------------------------------------
//  Sequences the ntt_butterfly across all 256 coefficients to compute the
//  complete forward NTT, bit-exact to the C++ reference ntt() in ntt.hpp:
//
//      unsigned k = 1;
//      for (len = 128; len >= 2; len >>= 1)
//        for (start = 0; start < 256; start += 2*len) {
//          zeta = zetas[k++];
//          for (j = start; j < start+len; j++) {
//            t = fqmul(zeta, r[j+len]);
//            r[j+len] = r[j] - t;
//            r[j]     = r[j] + t;
//          }
//        }
//
//  This is the "NTT accelerator" a host offloads to: the software loads the 256
//  coefficients, pulses `start`, waits for `done`, and reads the 256 results
//  back.  One butterfly is retired per clock (896 butterflies total), so the
//  whole transform costs ~896 cycles plus a little control overhead.
//
//  Memory model: a 256x16 signed register array with asynchronous read and
//  synchronous write.  Each cycle reads the pair (r[j], r[j+len]), computes the
//  butterfly, and writes both back -- exactly the read-then-write ordering of
//  the sequential C++ loop, so results match to the bit.
//
//  Interface
//    load_en/load_addr/load_data : write coefficients while IDLE
//    start                       : begin the transform (ignored unless IDLE)
//    busy / done                 : status (done stays high until next start)
//    rd_addr -> rd_data          : read a coefficient (valid any time)
// ============================================================================
`default_nettype none

module ntt_engine (
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
    // ---- Coefficient memory (256 x signed 16) ------------------------------
    reg signed [15:0] mem [0:255];
    assign rd_data = mem[rd_addr];

    // ---- Twiddle ROM (128 x signed 16), loaded from the C++-derived table --
    reg signed [15:0] zetas [0:127];
    initial begin
        `include "zetas_init.vh"
    end

    // ---- Loop state (mirrors the C++ variables) ----------------------------
    reg [7:0] len;        // 128, 64, ..., 2   (distance between paired coeffs)
    reg [7:0] k;          // twiddle / block index (1..127)
    reg [8:0] start_idx;  // block base (0..255, needs 9 bits for the +2*len test)
    reg [7:0] j;          // current lower coefficient index

    // ---- Combinational butterfly datapath ----------------------------------
    wire signed [15:0] a_cur = mem[j];
    wire signed [15:0] b_cur = mem[j + len];
    wire signed [15:0] zeta  = zetas[k];
    wire signed [15:0] a_new, b_new;

    ntt_butterfly u_bf (
        .a     (a_cur),
        .b     (b_cur),
        .zeta  (zeta),
        .a_out (a_new),   // a + t
        .b_out (b_new)    // a - t
    );

    // Block-boundary helpers.
    wire        last_in_block = (j == start_idx[7:0] + len - 8'd1);
    wire [8:0]  next_start    = start_idx + {len, 1'b0};   // start + 2*len
    wire        layer_done    = (next_start >= 9'd256);
    wire        all_done      = layer_done && (len == 8'd2);

    // ---- Control FSM -------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            busy      <= 1'b0;
            done      <= 1'b0;
            len       <= 8'd128;
            k         <= 8'd1;
            start_idx <= 9'd0;
            j         <= 8'd0;
        end else if (!busy) begin
            // IDLE: accept loads and wait for start.
            if (load_en) mem[load_addr] <= load_data;
            if (start) begin
                busy      <= 1'b1;
                done      <= 1'b0;
                len       <= 8'd128;
                k         <= 8'd1;
                start_idx <= 9'd0;
                j         <= 8'd0;
            end
        end else begin
            // RUN: retire one butterfly this cycle.
            mem[j]       <= a_new;   // r[j]       = r[j] + t
            mem[j + len] <= b_new;   // r[j + len] = r[j] - t

            if (!last_in_block) begin
                j <= j + 8'd1;                      // next pair in this block
            end else begin
                k <= k + 8'd1;                      // consumed this block's twiddle
                if (!layer_done) begin
                    start_idx <= next_start;         // advance to next block
                    j         <= next_start[7:0];
                end else if (!all_done) begin
                    len       <= len >> 1;           // drop to the next layer
                    start_idx <= 9'd0;
                    j         <= 8'd0;
                end else begin
                    busy <= 1'b0;                    // whole transform complete
                    done <= 1'b1;
                end
            end
        end
    end
endmodule

`default_nettype wire
