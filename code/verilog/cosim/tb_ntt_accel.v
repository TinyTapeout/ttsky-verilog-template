// ============================================================================
//  tb_ntt_accel.v  -  File-driven "accelerator call" for HW/SW co-simulation
// ----------------------------------------------------------------------------
//  This testbench is the hardware side of the co-design demo.  It models a
//  single call to the FPGA NTT accelerator the way a software driver would use
//  a real board over AXI / PCIe / UART:
//
//        accel_in.mem  (256 input coefficients, hex)
//                |  load -> start -> wait done -> read back
//                v
//        accel_out.mem (256 transformed coefficients, hex)
//
//  The C++ host (cosim_ntt.cpp) writes accel_in.mem, invokes xsim on this
//  testbench, then reads accel_out.mem -- so from the software's point of view
//  ntt_hw() is just "hand the poly to the hardware and get the transform back."
//
//  Run from code/verilog/cosim/ so the file paths resolve.
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_ntt_accel;
    reg clk = 1'b0;
    always #5 clk = ~clk;
    reg rst_n = 1'b0;

    reg               load_en   = 1'b0;
    reg  [7:0]        load_addr = 8'd0;
    reg  signed [15:0] load_data = 16'sd0;
    reg               start     = 1'b0;
    wire              busy, done;
    reg  [7:0]        rd_addr   = 8'd0;
    wire signed [15:0] rd_data;

    ntt_engine dut (
        .clk(clk), .rst_n(rst_n),
        .load_en(load_en), .load_addr(load_addr), .load_data(load_data),
        .start(start), .busy(busy), .done(done),
        .rd_addr(rd_addr), .rd_data(rd_data)
    );

    reg [15:0] inbuf [0:255];   // input coefficients read from file
    integer i, cyc, fo;

    initial begin
        // Load the operand the host wrote for this accelerator call.
        $readmemh("accel_in.mem", inbuf);

        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);

        // ---- stream the 256 coefficients into the engine ----
        for (i = 0; i < 256; i = i + 1) begin
            @(negedge clk);
            load_en   = 1'b1;
            load_addr = i[7:0];
            load_data = inbuf[i];
        end
        @(negedge clk); load_en = 1'b0;

        // ---- run the transform ----
        @(negedge clk); start = 1'b1;
        @(negedge clk); start = 1'b0;
        cyc = 0;
        while (done !== 1'b1) begin
            @(negedge clk);
            cyc = cyc + 1;
            if (cyc > 5000) begin $display("ACCEL TIMEOUT"); $fatal; end
        end

        // ---- write the 256 results back for the host ----
        fo = $fopen("accel_out.mem", "w");
        for (i = 0; i < 256; i = i + 1) begin
            rd_addr = i[7:0];
            #1;
            $fdisplay(fo, "%04h", rd_data);
        end
        $fclose(fo);
        $display("ACCEL_DONE transform in %0d cycles", cyc);
        $finish;
    end
endmodule

`default_nettype wire
