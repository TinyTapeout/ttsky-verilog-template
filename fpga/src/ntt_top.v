// ntt_top -- forward-NTT engine integration.
//
// Wires control_fsm (address/twiddle sequencing) + coeff_mem (256x12
// storage) + twiddle_rom (127-entry ROM) + butterfly (Cooley-Tukey datapath)
// into one engine with a start/done handshake and an external load/dump
// port so a caller can write in the 256 input coefficients before pulsing
// start_i, and read the 256 transformed coefficients back out after done.
//
// The external port only has effect while the engine is NOT busy -- while
// busy, coeff_mem's addressing belongs entirely to control_fsm.

module ntt_top (
    input  wire        clk,
    input  wire        rst,       // sync, active-high
    input  wire        start_i,   // pulse (1 cycle) to begin a forward-NTT pass
    output wire        busy,
    output wire        done,      // pulses 1 cycle when the pass completes

    // external load/dump port (valid only while busy == 0)
    input  wire         ext_we,
    input  wire  [7:0]  ext_addr,
    input  wire  [11:0] ext_din,
    output wire  [11:0] ext_dout
);
    wire [7:0] fsm_addr_a, fsm_addr_b;
    wire       fsm_we;
    wire [6:0] fsm_k;

    control_fsm u_fsm (
        .clk     (clk),
        .rst     (rst),
        .start_i (start_i),
        .addr_a  (fsm_addr_a),
        .addr_b  (fsm_addr_b),
        .we      (fsm_we),
        .k       (fsm_k),
        .busy    (busy),
        .done    (done)
    );

    wire [11:0] zeta;
    twiddle_rom u_rom (
        .k    (fsm_k),
        .zeta (zeta)
    );

    wire [11:0] bf_a_out, bf_b_out;
    wire [11:0] mem_dout_a, mem_dout_b;

    // port A is shared between the FSM (butterfly's f[j]) and the external
    // load/dump path; port B is the FSM's f[j+len] and is otherwise idle.
    wire [7:0]  mem_addr_a = busy ? fsm_addr_a : ext_addr;
    wire [7:0]  mem_addr_b = fsm_addr_b;
    wire        mem_we_a   = busy ? fsm_we : ext_we;
    wire        mem_we_b   = busy ? fsm_we : 1'b0;
    wire [11:0] mem_din_a  = busy ? bf_a_out : ext_din;
    wire [11:0] mem_din_b  = bf_b_out;

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

    butterfly u_bf (
        .clk   (clk),
        .a     (mem_dout_a),
        .b     (mem_dout_b),
        .zeta  (zeta),
        .a_out (bf_a_out),
        .b_out (bf_b_out)
    );

    assign ext_dout = mem_dout_a;

endmodule
