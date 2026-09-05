// demo_top -- Phase 3 self-contained demonstration: no CPU anywhere.
//
// One controller FSM sequences the whole thing:
//   S_LOAD     : generate 256 test coefficients f[i] = (i*17 + 5) mod q on
//                the fly (reusing mod_mult/mod_add -- no external input
//                needed to run the demo), writing each into BOTH the shared
//                coeff_mem (the working polynomial) AND a separate orig_mem
//                register file (a saved copy of f, since coeff_mem gets
//                overwritten in place by both transforms and the final
//                comparison needs the untouched original).
//   S_RUN_NTT  : hand coeff_mem to the forward engine (control_fsm +
//                butterfly) for 896 cycles -> coeff_mem now holds NTT(f).
//   S_RUN_INTT : hand coeff_mem to the inverse engine (intt_control_fsm +
//                intt_butterfly + the x n_inv scale) for 1152 cycles ->
//                coeff_mem now holds INTT(NTT(f)).
//   S_COMPARE  : walk both memories together, coeff_mem[i] vs orig_mem[i];
//                `pass` is 1 iff every one of the 256 coefficients matches.
//   S_DONE     : hold pass/done until the next start_i.
//
// coeff_mem itself is the SAME 256x12 memory throughout -- there is only
// ever one physical copy of the polynomial being transformed, matching
// "any products/sums that need to be stored, put them into a memory or
// register file" (orig_mem is that second piece of storage).
//
// ext_addr/ext_dout let a host (or a testbench) read back any intermediate
// or final coeff_mem/orig_mem contents for inspection while not busy.

module demo_top (
    input  wire        clk,
    input  wire        rst,        // sync, active-high
    input  wire        start_i,    // pulse (1 cycle): run the full demo once
    output wire        busy,
    output wire        done,       // pulses 1 cycle when the full run completes
    output wire          pass_o,     // valid from `done` until the next start_i: 1 = INTT(NTT(f))==f
    output wire [2:0]   phase,      // for visibility/status readout: see S_* below
    output wire [31:0]  cycle_count, // # of busy cycles for the just-completed (or in-progress) run

    input  wire         ext_addr_sel,  // 0 => read coeff_mem, 1 => read orig_mem
    input  wire [7:0]   ext_addr,
    output wire [11:0]  ext_dout
);
    localparam [2:0] S_IDLE     = 3'd0,
                      S_LOAD     = 3'd1,
                      S_RUN_NTT  = 3'd2,
                      S_RUN_INTT = 3'd3,
                      S_COMPARE  = 3'd4,
                      S_DONE     = 3'd5;

    reg [2:0] state;
    assign phase = state;
    assign busy  = (state != S_IDLE) && (state != S_DONE);
    assign done  = (state == S_DONE);

    // Counts cycles spent busy (S_LOAD through S_COMPARE) for the
    // just-completed run -- reset to 0 the moment a new run is accepted
    // out of S_IDLE, held at its final value from S_DONE onward until the
    // next start_i. A separate always block (not folded into the main FSM
    // case below) so it stays a trivial, obviously-correct counter driven
    // purely off the existing busy/state/start_i signals.
    reg [31:0] cycle_cnt_r;
    assign cycle_count = cycle_cnt_r;
    always @(posedge clk) begin
        if (rst) begin
            cycle_cnt_r <= 32'd0;
        end else if (state == S_IDLE && start_i) begin
            cycle_cnt_r <= 32'd0;
        end else if (busy) begin
            cycle_cnt_r <= cycle_cnt_r + 32'd1;
        end
    end

    // ---- shared coefficient memory (the one working copy of the polynomial) ----
    wire [7:0]  mem_addr_a, mem_addr_b;
    wire        mem_we_a, mem_we_b;
    wire [11:0] mem_din_a, mem_din_b;
    wire [11:0] mem_dout_a, mem_dout_b;

    coeff_mem u_mem (
        .clk    (clk),
        .rst    (rst),
        .addr_a (mem_addr_a),
        .addr_b (mem_addr_b),
        .we_a   (mem_we_a),
        .we_b   (mem_we_b),
        .din_a  (mem_din_a),
        .din_b  (mem_din_b),
        .dout_a (mem_dout_a),
        .dout_b (mem_dout_b)
    );

    // ---- saved copy of the original input, for the final comparison ----
    // orig_mem's own reads stay combinational (unlike coeff_mem.v, which had
    // to become registered for BRAM inference -- see coeff_mem.v): orig_mem
    // is write-once (during S_LOAD) and read-only thereafter, so it never
    // sees the write-heavy, address-churning traffic that made coeff_mem's
    // async read synthesize into a huge distributed-RAM mux tree. The
    // S_COMPARE state machine reads orig_mem[cmp_i_d1] below (delayed to
    // line up with coeff_mem's now-registered mem_dout_a, NOT because
    // orig_mem itself needs it), and the external debug port reads
    // orig_mem[ext_addr] directly here.
    reg [11:0] orig_mem [0:255];
    wire [11:0] orig_dout_c = orig_mem[ext_addr];

    // ---- forward (NTT) engine ----
    wire [7:0] fwd_addr_a, fwd_addr_b;
    wire       fwd_we, fwd_busy, fwd_done;
    wire [6:0] fwd_k;
    reg        fwd_start;

    control_fsm u_fwd_fsm (
        .clk (clk), .rst (rst), .start_i (fwd_start),
        .addr_a (fwd_addr_a), .addr_b (fwd_addr_b), .we (fwd_we), .k (fwd_k),
        .busy (fwd_busy), .done (fwd_done)
    );

    wire [11:0] fwd_zeta;
    twiddle_rom u_fwd_rom (.k (fwd_k), .zeta (fwd_zeta));

    wire [11:0] fwd_a_out, fwd_b_out;
    butterfly u_fwd_bf (
        .clk (clk),
        .a (mem_dout_a), .b (mem_dout_b), .zeta (fwd_zeta),
        .a_out (fwd_a_out), .b_out (fwd_b_out)
    );

    // ---- inverse (INTT) engine ----
    wire [7:0] inv_addr_a, inv_addr_b;
    wire       inv_we, inv_busy, inv_done, inv_scale_phase;
    wire [6:0] inv_k;
    reg        inv_start;

    intt_control_fsm u_inv_fsm (
        .clk (clk), .rst (rst), .start_i (inv_start),
        .addr_a (inv_addr_a), .addr_b (inv_addr_b), .we (inv_we), .k (inv_k),
        .scale_phase (inv_scale_phase), .busy (inv_busy), .done (inv_done)
    );

    wire [11:0] inv_zeta;
    twiddle_rom u_inv_rom (.k (inv_k), .zeta (inv_zeta));

    wire [11:0] gs_a_out, gs_b_out;
    intt_butterfly u_inv_bf (
        .clk (clk),
        .a (mem_dout_a), .b (mem_dout_b), .zeta (inv_zeta),
        .a_out (gs_a_out), .b_out (gs_b_out)
    );

    localparam [11:0] N_INV = 12'd3303;   // 128^-1 mod 3329
    wire [11:0] scale_out;
    mod_mult u_scale (.clk (clk), .a (mem_dout_a), .b (N_INV), .c (scale_out));

    // ---- LOAD-phase test-vector generator: f[i] = (i*17 + 5) mod q ----
    // mod_mult is 4-cycle pipelined (see mod_mult.v) -- S_LOAD below stalls
    // LATENCY cycles per coefficient (same rationale as control_fsm.v),
    // holding load_i stable so load_val settles before it's committed.
    localparam integer LATENCY = 6;
    reg  [7:0]  load_i;
    wire [11:0] load_i12 = {4'd0, load_i};
    wire [11:0] load_mul;
    wire [11:0] load_val;
    mod_mult u_load_mul (.clk (clk), .a (load_i12), .b (12'd17), .c (load_mul));
    mod_add  u_load_add (.a (load_mul), .b (12'd5),  .c (load_val));
    reg [2:0] load_phase_cnt;

    // ---- COMPARE-phase walk ----
    // coeff_mem's read is now registered (see coeff_mem.v): mem_dout_a for
    // address A presented at cycle N is only valid at cycle N+1. cmp_i walks
    // addresses 0..255 (holding at 255 once reached); cmp_i_d1 is cmp_i
    // delayed by exactly one cycle so it always indexes the SAME coefficient
    // mem_dout_a is currently showing. cmp_valid_d1 suppresses the very
    // first cycle of S_COMPARE (mem_dout_a is still stale, showing the
    // INTT engine's last address) and stays asserted one extra cycle past
    // cmp_i's last increment to drain address 255's result.
    reg [7:0] cmp_i;
    reg [7:0] cmp_i_d1;
    reg       cmp_valid_d1;
    reg       cmp_last_d1;
    reg       mismatch;
    // combinational, not registered: `mismatch` is already stable the
    // instant `done` asserts (S_DONE's registered `state<=S_IDLE` is what's
    // one cycle "late", not this) -- a registered pass_o<=!mismatch here
    // would only become valid the cycle *after* done, so a caller sampling
    // pass_o right when done first pulses would see the stale reset value.
    assign pass_o = !mismatch;

    // ---- shared-memory port muxing, selected by `state` ----
    // idle (S_IDLE / S_DONE) falls through to ext_addr, so the external
    // debug port can read back coeff_mem's contents between/after runs.
    assign mem_addr_a = (state == S_LOAD)     ? load_i    :
                         (state == S_RUN_NTT)  ? fwd_addr_a :
                         (state == S_RUN_INTT) ? inv_addr_a :
                         (state == S_COMPARE)  ? cmp_i      : ext_addr;
    assign mem_addr_b = (state == S_RUN_NTT)  ? fwd_addr_b :
                         (state == S_RUN_INTT) ? inv_addr_b : 8'd0;

    assign mem_we_a   = (state == S_LOAD) ? (load_phase_cnt == LATENCY - 1) :
                         (state == S_RUN_NTT)  ? fwd_we :
                         (state == S_RUN_INTT) ? inv_we : 1'b0;
    assign mem_we_b   = (state == S_RUN_NTT)  ? fwd_we :
                         (state == S_RUN_INTT) ? (inv_we && !inv_scale_phase) : 1'b0;

    assign mem_din_a  = (state == S_LOAD)     ? load_val :
                         (state == S_RUN_NTT)  ? fwd_a_out :
                         (state == S_RUN_INTT) ? (inv_scale_phase ? scale_out : gs_a_out) : 12'd0;
    assign mem_din_b  = (state == S_RUN_NTT)  ? fwd_b_out : gs_b_out;

    assign ext_dout = ext_addr_sel ? orig_dout_c : mem_dout_a;

    always @(posedge clk) begin
        if (rst) begin
            state          <= S_IDLE;
            load_i         <= 8'd0;
            load_phase_cnt <= 3'd0;
            cmp_i          <= 8'd0;
            cmp_i_d1       <= 8'd0;
            cmp_valid_d1   <= 1'b0;
            cmp_last_d1    <= 1'b0;
            mismatch       <= 1'b0;
            fwd_start      <= 1'b0;
            inv_start      <= 1'b0;
        end else begin
            fwd_start <= 1'b0;
            inv_start <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (start_i) begin
                        load_i         <= 8'd0;
                        load_phase_cnt <= 3'd0;
                        mismatch       <= 1'b0;
                        state          <= S_LOAD;
                    end
                end

                S_LOAD: begin
                    if (load_phase_cnt != LATENCY - 1) begin
                        load_phase_cnt <= load_phase_cnt + 3'd1;
                    end else begin
                        load_phase_cnt   <= 3'd0;
                        orig_mem[load_i] <= load_val;
                        if (load_i == 8'd255) begin
                            fwd_start <= 1'b1;
                            state     <= S_RUN_NTT;
                        end else begin
                            load_i <= load_i + 8'd1;
                        end
                    end
                end

                S_RUN_NTT: begin
                    if (fwd_done) begin
                        inv_start <= 1'b1;
                        state     <= S_RUN_INTT;
                    end
                end

                S_RUN_INTT: begin
                    if (inv_done) begin
                        cmp_i        <= 8'd0;
                        cmp_valid_d1 <= 1'b0;
                        state        <= S_COMPARE;
                    end
                end

                S_COMPARE: begin
                    cmp_i_d1     <= cmp_i;
                    cmp_valid_d1 <= 1'b1;
                    cmp_last_d1  <= (cmp_i == 8'd255);
                    if (cmp_i != 8'd255) cmp_i <= cmp_i + 8'd1;

                    if (cmp_valid_d1) begin
                        if (mem_dout_a !== orig_mem[cmp_i_d1]) mismatch <= 1'b1;
                        if (cmp_last_d1) state <= S_DONE;
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
