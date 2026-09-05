// intt_top -- inverse-NTT engine integration. Mirrors ntt_top.v exactly,
// swapping in intt_control_fsm + intt_butterfly, plus a dedicated mod_mult
// for the final x n_inv scaling pass (n_inv = 128^-1 mod q = 3303).

module intt_top (
    input  wire        clk,
    input  wire        rst,       // sync, active-high
    input  wire        start_i,   // pulse (1 cycle) to begin an inverse-NTT pass
    output wire        busy,
    output wire        done,      // pulses 1 cycle when the pass completes

    // external load/dump port (valid only while busy == 0)
    input  wire         ext_we,
    input  wire  [7:0]  ext_addr,
    input  wire  [11:0] ext_din,
    output wire  [11:0] ext_dout
);
    localparam [11:0] N_INV = 12'd3303;   // 128^-1 mod 3329

    wire [7:0] fsm_addr_a, fsm_addr_b;
    wire       fsm_we;
    wire [6:0] fsm_k;
    wire       fsm_scale_phase;

    intt_control_fsm u_fsm (
        .clk         (clk),
        .rst         (rst),
        .start_i     (start_i),
        .addr_a      (fsm_addr_a),
        .addr_b      (fsm_addr_b),
        .we          (fsm_we),
        .k           (fsm_k),
        .scale_phase (fsm_scale_phase),
        .busy        (busy),
        .done        (done)
    );

    wire [11:0] zeta;
    twiddle_rom u_rom (
        .k    (fsm_k),
        .zeta (zeta)
    );

    wire [11:0] mem_dout_a, mem_dout_b;

    // Gentleman-Sande butterfly, active during the address-walk phase.
    wire [11:0] gs_a_out, gs_b_out;
    intt_butterfly u_gsbf (
        .clk   (clk),
        .a     (mem_dout_a),
        .b     (mem_dout_b),
        .zeta  (zeta),
        .a_out (gs_a_out),
        .b_out (gs_b_out)
    );

    // Final x n_inv scale, active during the scale phase (single value,
    // read/write through port A only).
    wire [11:0] scale_out;
    mod_mult u_scale (
        .clk (clk),
        .a (mem_dout_a),
        .b (N_INV),
        .c (scale_out)
    );

    // port A is shared between the FSM (butterfly f[j] / scale index i)
    // and the external load/dump path; port B is the FSM's f[j+len],
    // unused during the scale phase and idle while not busy.
    wire [7:0]  mem_addr_a = busy ? fsm_addr_a : ext_addr;
    wire [7:0]  mem_addr_b = fsm_addr_b;
    wire        mem_we_a   = busy ? fsm_we : ext_we;
    wire        mem_we_b   = busy && !fsm_scale_phase && fsm_we;
    wire [11:0] mem_din_a  = !busy         ? ext_din
                            : fsm_scale_phase ? scale_out
                                              : gs_a_out;
    wire [11:0] mem_din_b  = gs_b_out;

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

    assign ext_dout = mem_dout_a;

endmodule
