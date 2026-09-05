// demo_top_s_axi -- minimal AXI4-Lite slave wrapping demo_top for Vitis RTL
// kernel packaging. Standard AXI4-Lite port naming (s_axi_control_*) so
// Vivado's IP packager auto-recognizes it as an AXI4-Lite slave interface.
//
// Register map (32-bit registers, byte addresses):
//   0x00  AP_CTRL   bit0 = ap_start (write 1 to launch a run; read back
//                          reflects internal busy/ap_start_r for host polling)
//                   bit1 = ap_done  (read-only, 1 the cycle a run completes;
//                                    a read of this register clears it, the
//                                    standard HLS "clear-on-read" convention,
//                                    so the host's poll loop naturally
//                                    de-asserts it after observing done)
//                   bit2 = ap_idle  (read-only)
//   0x10  STATUS    bit3 = pass    (valid once AP_CTRL.ap_done has read 1)
//                   bits[2:0] = phase (status/debug visibility)
//   0x18  CYCLE_COUNT (read-only) # of busy cycles the just-completed run
//                   took (load + forward NTT + inverse NTT + compare),
//                   valid once AP_CTRL.ap_done has read 1 -- lets a host
//                   measure the design's real cycle count directly on
//                   hardware rather than relying on the simulation
//                   prediction (~16129 cycles / 16134 in gate-level sim).
//
// This mirrors the well-known Xilinx HLS control-bus convention (AP_CTRL at
// 0x00, first scalar/status register at 0x10) so host-side code looks like
// any other Xilinx kernel driver.

module demo_top_s_axi #(
    parameter integer C_S_AXI_ADDR_WIDTH = 5,
    parameter integer C_S_AXI_DATA_WIDTH = 32
) (
    input  wire                              s_axi_control_aclk,
    input  wire                              s_axi_control_aresetn,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_control_awaddr,
    input  wire                              s_axi_control_awvalid,
    output reg                               s_axi_control_awready,

    input  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_control_wdata,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0]   s_axi_control_wstrb,
    input  wire                              s_axi_control_wvalid,
    output reg                               s_axi_control_wready,

    output reg  [1:0]                        s_axi_control_bresp,
    output reg                               s_axi_control_bvalid,
    input  wire                              s_axi_control_bready,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_control_araddr,
    input  wire                              s_axi_control_arvalid,
    output reg                               s_axi_control_arready,

    output reg  [C_S_AXI_DATA_WIDTH-1:0]     s_axi_control_rdata,
    output reg  [1:0]                        s_axi_control_rresp,
    output reg                               s_axi_control_rvalid,
    input  wire                              s_axi_control_rready
);
    localparam ADDR_AP_CTRL     = 5'h00;
    localparam ADDR_STATUS      = 5'h10;
    localparam ADDR_CYCLE_COUNT = 5'h18;

    wire clk = s_axi_control_aclk;
    wire rst = ~s_axi_control_aresetn;   // demo_top wants sync active-high

    // ---- write channel: simple "wait for both AW and W" handshake ----
    reg aw_hs, w_hs;
    wire write_fire = aw_hs && w_hs;

    always @(posedge clk) begin
        if (rst) begin
            s_axi_control_awready <= 1'b0;
            aw_hs <= 1'b0;
        end else if (write_fire) begin
            s_axi_control_awready <= 1'b0;
            aw_hs <= 1'b0;
        end else if (s_axi_control_awvalid && !aw_hs) begin
            s_axi_control_awready <= 1'b1;
            aw_hs <= 1'b1;
        end else begin
            s_axi_control_awready <= 1'b0;
        end
    end

    // Captured on the SAME condition/cycle that sets aw_hs (awvalid && !aw_hs),
    // not awvalid && awready -- awready itself is a registered signal that
    // only turns 1 one cycle after aw_hs does, so gating on it here would
    // capture awaddr_r a full cycle after write_fire could already need it
    // (write_fire depends only on aw_hs/w_hs, not on awready), leaving
    // awaddr_r stale/undefined at the moment it's actually checked below.
    reg [C_S_AXI_ADDR_WIDTH-1:0] awaddr_r;
    always @(posedge clk) begin
        if (s_axi_control_awvalid && !aw_hs) awaddr_r <= s_axi_control_awaddr;
    end

    always @(posedge clk) begin
        if (rst) begin
            s_axi_control_wready <= 1'b0;
            w_hs <= 1'b0;
        end else if (write_fire) begin
            s_axi_control_wready <= 1'b0;
            w_hs <= 1'b0;
        end else if (s_axi_control_wvalid && !w_hs) begin
            s_axi_control_wready <= 1'b1;
            w_hs <= 1'b1;
        end else begin
            s_axi_control_wready <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            s_axi_control_bvalid <= 1'b0;
            s_axi_control_bresp  <= 2'b00;
        end else if (write_fire) begin
            s_axi_control_bvalid <= 1'b1;
            s_axi_control_bresp  <= 2'b00;
        end else if (s_axi_control_bvalid && s_axi_control_bready) begin
            s_axi_control_bvalid <= 1'b0;
        end
    end

    // ---- read channel ----
    reg ar_hs;
    always @(posedge clk) begin
        if (rst) begin
            s_axi_control_arready <= 1'b0;
            ar_hs <= 1'b0;
        end else if (s_axi_control_arvalid && !ar_hs && !s_axi_control_rvalid) begin
            s_axi_control_arready <= 1'b1;
            ar_hs <= 1'b1;
        end else begin
            s_axi_control_arready <= 1'b0;
            if (s_axi_control_rvalid && s_axi_control_rready) ar_hs <= 1'b0;
        end
    end

    // ---- demo_top instance ----
    reg  ap_start_r;      // AP_CTRL bit0, host-writable
    wire busy, done, pass_o;
    wire [2:0] phase;
    wire [31:0] cycle_count;
    wire [11:0] ext_dout_unused;

    reg ap_start_d;
    always @(posedge clk) begin
        if (rst) ap_start_d <= 1'b0;
        else      ap_start_d <= ap_start_r;
    end
    wire start_pulse = ap_start_r && !ap_start_d;

    demo_top u_demo (
        .clk          (clk),
        .rst          (rst),
        .start_i      (start_pulse),
        .busy         (busy),
        .done         (done),
        .pass_o       (pass_o),
        .phase        (phase),
        .cycle_count  (cycle_count),
        .ext_addr_sel (1'b0),
        .ext_addr     (8'd0),
        .ext_dout     (ext_dout_unused)
    );

    // ap_done latches on the cycle `done` pulses, clears on read (standard
    // HLS control-bus convention) or when a new ap_start is written.
    reg ap_done_latched;
    reg [3:0] status_latched;   // {pass_o, phase} snapshot, held stable for the host to read
    reg [31:0] cycle_count_latched;

    always @(posedge clk) begin
        if (rst) begin
            ap_start_r      <= 1'b0;
            ap_done_latched <= 1'b0;
            status_latched  <= 4'd0;
            cycle_count_latched <= 32'd0;
        end else begin
            if (done) begin
                ap_done_latched <= 1'b1;
                status_latched  <= {pass_o, phase};
                cycle_count_latched <= cycle_count;
            end

            if (write_fire && awaddr_r == ADDR_AP_CTRL && s_axi_control_wstrb[0]) begin
                if (s_axi_control_wdata[0]) ap_start_r <= 1'b1;
                // ap_start self-clears once demo_top leaves idle (busy==1);
                // no explicit clear needed here beyond the natural pulse.
            end
            if (start_pulse) ap_start_r <= 1'b0;

            if (s_axi_control_arvalid && s_axi_control_arready && s_axi_control_araddr == ADDR_AP_CTRL) begin
                ap_done_latched <= 1'b0;   // clear-on-read
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            s_axi_control_rvalid <= 1'b0;
            s_axi_control_rresp  <= 2'b00;
            s_axi_control_rdata  <= {C_S_AXI_DATA_WIDTH{1'b0}};
        end else if (s_axi_control_arvalid && s_axi_control_arready) begin
            s_axi_control_rvalid <= 1'b1;
            case (s_axi_control_araddr)
                ADDR_AP_CTRL:     s_axi_control_rdata <= {29'd0, !busy, ap_done_latched, ap_start_r};
                ADDR_STATUS:      s_axi_control_rdata <= {28'd0, status_latched};
                ADDR_CYCLE_COUNT: s_axi_control_rdata <= cycle_count_latched;
                default:          s_axi_control_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
            endcase
        end else if (s_axi_control_rvalid && s_axi_control_rready) begin
            s_axi_control_rvalid <= 1'b0;
        end
    end

endmodule
