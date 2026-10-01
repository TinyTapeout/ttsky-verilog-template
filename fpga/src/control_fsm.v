// control_fsm -- address/twiddle-index sequencer for the forward NTT
// (Cooley-Tukey, in place, matching the standard FIPS-203 loop nest):
//
//   k = 1
//   for len in {128, 64, 32, 16, 8, 4, 2}:            (7 layers)
//     for start = 0; start < 256; start += 2*len:      (blocks in a layer)
//       zeta = zetas[k];  k += 1
//       for j = start; j < start + len; j += 1:        (butterflies in a block)
//         butterfly(f[j], f[j+len], zeta) -> f[j], f[j+len]
//
// 7 layers x 128 butterflies/layer = 896 total butterfly ops, k spans 1..127
// (127 distinct twiddles).
//
// butterfly.v's mod_mult is a pipelined datapath (see mod_mult.v -- the
// original zero-register version routed at WNS -11.699 ns on the real
// U55C). This FSM now HOLDS each butterfly's addr_a/addr_b/k stable for
// LATENCY=7 cycles: mod_mult's own 6-cycle settle time (5 register stages,
// see test_mod_mult.py's OBSERVED_LATENCY), plus 1 more cycle for
// coeff_mem's now-REGISTERED read (see coeff_mem.v -- its combinational
// read version routed at WNS -1.877ns, forcing a huge distributed-RAM
// mux-tree instead of block RAM; registering it needs one settle cycle
// before butterfly.v's `a`/`b` inputs are valid). Since addr_a/addr_b never
// change mid-window, this is a pure constant bump, not new hazard logic.
// asserting `we` only on the last cycle once the
// butterfly's result has actually settled, then advances to the next j/
// block/layer -- i.e. it "stalls" rather than pipelines, trading throughput
// (a full pass is now 896*LATENCY cycles, not 896) for a design that's
// trivially correct: since addr_a/addr_b never change mid-butterfly, there
// is no read-after-write hazard to reason about across the stall window,
// unlike a fully-pipelined issue-every-cycle design would need at layer
// boundaries.

module control_fsm (
    input  wire        clk,
    input  wire        rst,      // sync, active-high
    input  wire        start_i,  // pulse (1 cycle) to begin a forward-NTT pass
    output wire [7:0]  addr_a,   // = j            -> coeff_mem.addr_a
    output wire [7:0]  addr_b,   // = j + len      -> coeff_mem.addr_b
    output wire        we,       // -> coeff_mem.we_a / we_b (same cycle, same value)
    output wire [6:0]  k,        // twiddle index  -> twiddle_rom.k
    output wire        busy,
    output wire        done      // pulses 1 cycle when the pass completes
);
    localparam [2:0] LAYER_MAX = 3'd6;   // 7 layers: 0..6 => len 128..2
    localparam integer LATENCY = 7;      // mod_mult settle (6) + coeff_mem registered read (1)

    localparam [1:0] S_IDLE = 2'd0,
                      S_RUN  = 2'd1,
                      S_DONE = 2'd2;

    reg [1:0] state;
    reg [2:0] layer;      // len = 128 >> layer
    reg [7:0] len_r;
    reg [7:0] start_r;
    reg [7:0] j_off;      // 0 .. len_r-1
    reg [6:0] k_r;
    reg [2:0] phase_cnt;  // 0 .. LATENCY-1, position within the current
                           // butterfly's stall window

    assign addr_a = start_r + j_off;
    assign addr_b = start_r + j_off + len_r;
    assign k      = k_r;
    assign we     = (state == S_RUN) && (phase_cnt == LATENCY - 1);
    assign busy   = (state != S_IDLE);
    assign done   = (state == S_DONE);

    wire last_j_in_block  = (j_off == len_r - 8'd1);
    // 9-bit intermediate: len_r==128 => len_r<<1==256, which overflows an
    // 8-bit wire and silently wraps to 0 (truncation), breaking layer 0's
    // block-boundary detection. addr_a/addr_b never need this extra bit
    // (j+len always fits in 8 bits by construction), only this comparison.
    wire [8:0] two_len_ext = {1'b0, len_r} << 1;
    wire last_block_in_layer = (({1'b0, start_r} + two_len_ext) >= 9'd256);

    always @(posedge clk) begin
        if (rst) begin
            state     <= S_IDLE;
            layer     <= 3'd0;
            len_r     <= 8'd128;
            start_r   <= 8'd0;
            j_off     <= 8'd0;
            k_r       <= 7'd1;
            phase_cnt <= 3'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (start_i) begin
                        layer     <= 3'd0;
                        len_r     <= 8'd128;
                        start_r   <= 8'd0;
                        j_off     <= 8'd0;
                        k_r       <= 7'd1;
                        phase_cnt <= 3'd0;
                        state     <= S_RUN;
                    end
                end

                S_RUN: begin
                    if (phase_cnt != LATENCY - 1) begin
                        phase_cnt <= phase_cnt + 3'd1;
                    end else begin
                        phase_cnt <= 3'd0;
                        if (last_j_in_block) begin
                            j_off <= 8'd0;
                            if (last_block_in_layer) begin
                                if (layer == LAYER_MAX) begin
                                    state <= S_DONE;
                                end else begin
                                    layer   <= layer + 3'd1;
                                    len_r   <= len_r >> 1;
                                    start_r <= 8'd0;
                                    k_r     <= k_r + 7'd1;
                                end
                            end else begin
                                start_r <= start_r + (len_r << 1);
                                k_r     <= k_r + 7'd1;
                            end
                        end else begin
                            j_off <= j_off + 8'd1;
                        end
                    end
                end

                S_DONE: begin
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
