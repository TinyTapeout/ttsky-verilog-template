// mod_mult -- Barrett reduction, c = (a*b) mod q, q = 3329.
// k = 24, mu = floor(2^24/q) = 5039, one conditional subtract.
//
// 5-stage pipelined: the original fully-combinational version put two
// chained DSP48E2 multiplies (T=a*b then T_mu=T*MU) with zero register
// between them directly in the datapath from an FSM register to a
// coeff_mem write, and routed WNS came back -11.699 ns against a 3.333 ns
// (300 MHz) budget -- 39 logic levels, ~15 ns. A first pass split the two
// multiplies (plus the constant quo*Q multiply and final compare) across 4
// register stages, which fixed mod_mult in isolation (standalone WNS
// +1.261 ns) but exposed a SECOND, different long path in the full
// kernel: the address-mux logic feeding coeff_mem, combined with
// intt_butterfly's mod_sub, reached all the way into this module's FIRST
// register uninterrupted (5.524 ns, still failing). Registering a/b on
// entry (this stage 0) caps that incoming path too. See
// documentation/history (or docs/PROGRESS.md) for the full account.
//
// Callers hold their address/inputs stable for LATENCY cycles (see
// control_fsm.v / intt_control_fsm.v / demo_top.v's LATENCY localparam --
// empirically confirmed against the full ntt_top.v/demo_top.v test suite,
// not just hand-derived from the stage count below).
module mod_mult (
    input  wire        clk,
    input  wire [11:0] a,
    input  wire [11:0] b,
    output wire [11:0] c
);
    localparam [12:0] Q  = 13'd3329;
    localparam [12:0] MU = 13'd5039;
    localparam integer K = 24;

    // stage 0: register the inputs so any long combinational chain
    // upstream (address decode, mod_sub, etc.) stops here, not inside the
    // DSP cascade below.
    reg [11:0] a_r, b_r;
    always @(posedge clk) begin
        a_r <= a;
        b_r <= b;
    end

    // stage 1: T = a*b
    reg [23:0] T_r;
    always @(posedge clk) T_r <= a_r * b_r;

    // stage 2: T_mu = T*MU, carry T's low bits forward for stage 3
    reg [36:0] T_mu_r;
    reg [12:0] T_lo_r;
    always @(posedge clk) begin
        T_mu_r <= T_r * MU;
        T_lo_r <= T_r[12:0];
    end

    // stage 3: quo_q = quo*Q, r = T_lo - quo_q (low 13 bits, same modular
    // wraparound technique as the original combinational design)
    wire [12:0] quo = T_mu_r[36:K];
    wire [25:0] quo_q = quo * Q;
    reg [12:0] r_r;
    always @(posedge clk) r_r <= T_lo_r - quo_q[12:0];

    // stage 4: conditional subtract
    reg [11:0] c_r;
    always @(posedge clk) c_r <= (r_r >= Q) ? (r_r - Q) : r_r[11:0];

    assign c = c_r;
endmodule
