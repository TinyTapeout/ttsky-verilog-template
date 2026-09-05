// ============================================================================
//  tb_worked_example.v  -  Concrete base-case demonstration in HARDWARE
// ----------------------------------------------------------------------------
//  Drives ONE base-case product through the real poly_mul RTL and prints the
//  first coefficients of the result in DECIMAL, HEX and BINARY, so they can be
//  read straight off the transcript / waveform and compared, digit-for-digit,
//  against worked_example.py:
//
//      a = 1 + 2x + 3x^2 + 4x^3
//      b = 5 + 6x + 7x^2 + 8x^3
//      c = a*b  ->  5, 16, 34, 60, 61, 52, 32, ...   (== 0005 0010 0022 003c ...)
//
//  This is the literal "feed the two coefficient strings to the algorithm,
//  simulate, and see the number in hex/binary" step of the test plan.
//  Run from code/verilog/sim/ :  ./run_worked_example.sh
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_worked_example;

    reg clk = 1'b0;  always #5 clk = ~clk;
    reg rst_n = 1'b0;

    reg               load_en   = 1'b0;
    reg               load_sel  = 1'b0;
    reg  [7:0]        load_addr = 8'd0;
    reg  signed [15:0] load_data = 16'sd0;
    reg               start     = 1'b0;
    wire              busy, done;
    reg  [7:0]        rd_addr   = 8'd0;
    wire signed [15:0] rd_data;

    poly_mul dut (
        .clk(clk), .rst_n(rst_n),
        .load_en(load_en), .load_sel(load_sel), .load_addr(load_addr), .load_data(load_data),
        .start(start), .busy(busy), .done(done),
        .rd_addr(rd_addr), .rd_data(rd_data)
    );

    integer i, cyc;
    reg signed [15:0] a_in [0:255];
    reg signed [15:0] b_in [0:255];
    // golden result (from worked_example.py / schoolbook), first 7 coeffs
    reg signed [15:0] gold7 [0:6];
    integer mism = 0;

    initial begin
        $dumpfile("tb_worked_example.vcd");
        $dumpvars(0, tb_worked_example);

        // ---- build the two base-case coefficient strings ----
        for (i = 0; i < 256; i = i + 1) begin a_in[i] = 16'sd0; b_in[i] = 16'sd0; end
        a_in[0]=1; a_in[1]=2; a_in[2]=3; a_in[3]=4;
        b_in[0]=5; b_in[1]=6; b_in[2]=7; b_in[3]=8;
        gold7[0]=5; gold7[1]=16; gold7[2]=34; gold7[3]=60; gold7[4]=61; gold7[5]=52; gold7[6]=32;

        repeat (3) @(negedge clk); rst_n = 1'b1; @(negedge clk);

        // ---- load a (sel=0), then b (sel=1) ----
        for (i = 0; i < 256; i = i + 1) begin
            @(negedge clk); load_en=1'b1; load_sel=1'b0; load_addr=i[7:0]; load_data=a_in[i];
        end
        for (i = 0; i < 256; i = i + 1) begin
            @(negedge clk); load_en=1'b1; load_sel=1'b1; load_addr=i[7:0]; load_data=b_in[i];
        end
        @(negedge clk); load_en=1'b0;

        // ---- run ----
        @(negedge clk); start=1'b1; @(negedge clk); start=1'b0;
        cyc = 0;
        while (done !== 1'b1) begin
            @(negedge clk); cyc = cyc + 1;
            if (cyc > 20000) begin $display("TIMEOUT"); $fatal; end
        end

        // ---- read back and print in decimal / hex / binary ----
        $display("==================================================================");
        $display(" WORKED EXAMPLE IN HARDWARE (poly_mul), %0d cycles", cyc);
        $display("  a = 1 + 2x + 3x^2 + 4x^3     b = 5 + 6x + 7x^2 + 8x^3");
        $display("  idx | decimal |  hex  |      binary       | golden | match");
        $display("  ----+---------+-------+-------------------+--------+------");
        for (i = 0; i < 7; i = i + 1) begin
            rd_addr = i[7:0]; #1;
            if (rd_data !== gold7[i]) mism = mism + 1;
            $display("   %1d  | %7d | %04h  | %016b | %6d |  %s",
                     i[3:0], rd_data, rd_data, rd_data, gold7[i],
                     (rd_data === gold7[i]) ? "OK" : "XX");
        end
        $display("==================================================================");
        if (mism == 0)
            $display(" RESULT: hardware hex/binary == python golden (0005 0010 0022 003c ...)  ALL MATCH");
        else
            $display(" RESULT: %0d mismatches", mism);
        $display("==================================================================");
        if (mism != 0) $fatal(1, "worked-example mismatch");
        $finish;
    end

endmodule

`default_nettype wire
