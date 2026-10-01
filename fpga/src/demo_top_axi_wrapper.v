// demo_top_axi_wrapper -- thin adapter from demo_top's plain start/done/pass
// interface to the standard Xilinx "ap_ctrl_hs" handshake protocol
// (ap_clk/ap_rst_n/ap_start/ap_done/ap_idle) that Vivado's IP packager
// auto-recognizes and wires to an AXI-Lite control bus for a Vitis RTL
// kernel -- so the host can start it and poll done/pass over PCIe via XRT,
// the same mechanism already proven working for the HLS kernel elsewhere
// in this project.
//
// demo_top itself is untouched by this wrapper (still exactly the module
// verified in test/test_demo_top.py) -- this file only adapts the control
// handshake and exposes `pass_o` as a plain scalar output register.

module demo_top_axi_wrapper (
    input  wire ap_clk,
    input  wire ap_rst_n,
    input  wire ap_start,
    output wire ap_done,
    output wire ap_idle,
    output wire ap_ready,
    output wire [31:0] pass_reg
);
    wire rst = ~ap_rst_n;

    // ap_start is held high by the host until it sees ap_done; demo_top
    // wants a single-cycle start_i pulse, so edge-detect it.
    reg ap_start_d;
    always @(posedge ap_clk) begin
        if (!ap_rst_n) ap_start_d <= 1'b0;
        else            ap_start_d <= ap_start;
    end
    wire start_pulse = ap_start && !ap_start_d;

    wire       busy, done, pass_o;
    wire [2:0] phase;
    wire [11:0] ext_dout;

    demo_top u_demo (
        .clk          (ap_clk),
        .rst          (rst),
        .start_i      (start_pulse),
        .busy         (busy),
        .done         (done),
        .pass_o       (pass_o),
        .phase        (phase),
        .ext_addr_sel (1'b0),
        .ext_addr     (8'd0),
        .ext_dout     (ext_dout)
    );

    assign ap_done   = done;
    assign ap_idle   = !busy;
    assign ap_ready  = done;
    // bits [2:0] = phase (status visibility), bit [3] = pass_o (valid once
    // ap_done reads 1 via the control register), rest zero.
    assign pass_reg  = {28'd0, pass_o, phase};

endmodule
