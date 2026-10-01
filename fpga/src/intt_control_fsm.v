// intt_control_fsm -- address/twiddle-index sequencer for the inverse NTT
// (Gentleman-Sande, in place). Mirror image of control_fsm.v's loop nest,
// walked in the opposite direction, plus a final 1/n scaling pass:
//
//   k = 127
//   for len in {2, 4, 8, 16, 32, 64, 128}:            (7 layers, increasing)
//     for start = 0; start < 256; start += 2*len:
//       zeta = zetas[k];  k -= 1
//       for j = start; j < start + len; j += 1:
//         intt_butterfly(f[j], f[j+len], zeta) -> f[j], f[j+len]
//   for i = 0; i < 256; i += 1:
//     f[i] = f[i] * n_inv                              (n_inv = 128^-1 mod q)
//
// 896 Gentleman-Sande butterflies + 256 scale ops.
//
// Both intt_butterfly.v (via mod_mult) and the separate scale multiply in
// intt_top.v/demo_top.v are pipelined datapaths (see mod_mult.v -- the
// original zero-register version routed at WNS -11.699 ns on the real
// U55C). This FSM now HOLDS each butterfly's addr_a/addr_b/k, and each
// scale step's addr_a, stable for LATENCY=7 cycles (mod_mult's own 6-cycle
// settle time, plus 1 more for coeff_mem's now-registered read -- see
// coeff_mem.v and control_fsm.v's header for why), asserting `we` only on
// the last cycle once the result has actually settled -- same "stall
// rather than pipeline" rationale as control_fsm.v. 896*LATENCY +
// 256*LATENCY cycles total per pass, not 1152.

module intt_control_fsm (
    input  wire        clk,
    input  wire        rst,        // sync, active-high
    input  wire        start_i,    // pulse (1 cycle) to begin an inverse-NTT pass
    output wire [7:0]  addr_a,     // = j (butterfly phase) or i (scale phase)
    output wire [7:0]  addr_b,     // = j + len (butterfly phase only)
    output wire        we,         // -> coeff_mem.we_a / we_b (same cycle)
    output wire [6:0]  k,          // twiddle index -> twiddle_rom.k
    output wire        scale_phase,// 1 => final x n_inv pass (single-port write)
    output wire        busy,
    output wire        done        // pulses 1 cycle when the pass completes
);
    localparam [2:0] LAYER_MAX = 3'd6;   // 7 layers: 0..6 => len 2..128
    localparam integer LATENCY = 7;      // mod_mult settle (6) + coeff_mem registered read (1)

    localparam [1:0] S_IDLE  = 2'd0,
                      S_BFLY  = 2'd1,
                      S_SCALE = 2'd2,
                      S_DONE  = 2'd3;

    reg [1:0] state;
    reg [2:0] layer;      // len = 2 << layer
    reg [7:0] len_r;
    reg [7:0] start_r;
    reg [7:0] j_off;      // 0 .. len_r-1
    reg [6:0] k_r;
    reg [7:0] scale_i;    // 0..255 during S_SCALE
    reg [2:0] phase_cnt;  // 0 .. LATENCY-1, position within the current
                           // butterfly/scale-step's stall window

    assign addr_a       = (state == S_SCALE) ? scale_i : (start_r + j_off);
    assign addr_b        = start_r + j_off + len_r;
    assign k             = k_r;
    assign we             = ((state == S_BFLY) || (state == S_SCALE)) &&
                             (phase_cnt == LATENCY - 1);
    assign scale_phase   = (state == S_SCALE);
    assign busy          = (state != S_IDLE);
    assign done          = (state == S_DONE);

    wire last_j_in_block     = (j_off == len_r - 8'd1);
    // same 9-bit-overflow fix as control_fsm.v: len_r==128 => len_r<<1==256
    // silently wraps to 0 in an 8-bit wire.
    wire [8:0] two_len_ext        = {1'b0, len_r} << 1;
    wire       last_block_in_layer = (({1'b0, start_r} + two_len_ext) >= 9'd256);

    always @(posedge clk) begin
        if (rst) begin
            state     <= S_IDLE;
            layer     <= 3'd0;
            len_r     <= 8'd2;
            start_r   <= 8'd0;
            j_off     <= 8'd0;
            k_r       <= 7'd127;
            scale_i   <= 8'd0;
            phase_cnt <= 3'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (start_i) begin
                        layer     <= 3'd0;
                        len_r     <= 8'd2;
                        start_r   <= 8'd0;
                        j_off     <= 8'd0;
                        k_r       <= 7'd127;
                        phase_cnt <= 3'd0;
                        state     <= S_BFLY;
                    end
                end

                S_BFLY: begin
                    if (phase_cnt != LATENCY - 1) begin
                        phase_cnt <= phase_cnt + 3'd1;
                    end else begin
                        phase_cnt <= 3'd0;
                        if (last_j_in_block) begin
                            j_off <= 8'd0;
                            if (last_block_in_layer) begin
                                if (layer == LAYER_MAX) begin
                                    scale_i <= 8'd0;
                                    state   <= S_SCALE;
                                end else begin
                                    layer   <= layer + 3'd1;
                                    len_r   <= len_r << 1;
                                    start_r <= 8'd0;
                                    k_r     <= k_r - 7'd1;
                                end
                            end else begin
                                start_r <= start_r + (len_r << 1);
                                k_r     <= k_r - 7'd1;
                            end
                        end else begin
                            j_off <= j_off + 8'd1;
                        end
                    end
                end

                S_SCALE: begin
                    if (phase_cnt != LATENCY - 1) begin
                        phase_cnt <= phase_cnt + 3'd1;
                    end else begin
                        phase_cnt <= 3'd0;
                        if (scale_i == 8'd255) begin
                            state <= S_DONE;
                        end else begin
                            scale_i <= scale_i + 8'd1;
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
