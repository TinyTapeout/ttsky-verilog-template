// ============================================================================
//  tb_ntt_engine.v  -  Self-checking testbench for the full NTT accelerator
// ----------------------------------------------------------------------------
//  Drives ntt_engine exactly the way a host/FPGA driver would:
//    1) load 256 coefficients through the load port,
//    2) pulse `start` and wait for `done`,
//    3) read the 256 results back and compare to the C++ ntt() golden output.
//
//  Golden data comes from gen_ntt_vectors.cpp (vectors/ntt_poly_vectors.mem).
//  Run from code/verilog/sim/ so the relative path resolves.
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_ntt_engine;

    // -------------------------------------------------------------- clock/reset
    reg clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz
    reg rst_n = 1'b0;

    // ------------------------------------------------------------------- DUT I/O
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

    // --------------------------------------------------------------- test memory
    integer fh, code, T, t, i, cyc;
    integer errors = 0;
    reg signed [15:0] gold_out [0:255];
    reg [15:0] tmp;

    initial begin
        $dumpfile("tb_ntt_engine.vcd");
        $dumpvars(0, tb_ntt_engine);

        // release reset
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);

        fh = $fopen("../tb/vectors/ntt_poly_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open ntt_poly_vectors.mem"); $fatal; end
        code = $fscanf(fh, "%d\n", T);
        $display("[ntt_engine] running %0d full-transform test cases", T);

        for (t = 0; t < T; t = t + 1) begin
            // ---- 1) load 256 input coefficients ----
            for (i = 0; i < 256; i = i + 1) begin
                code = $fscanf(fh, "%h\n", tmp);
                @(negedge clk);
                load_en   = 1'b1;
                load_addr = i[7:0];
                load_data = tmp;
            end
            @(negedge clk); load_en = 1'b0;

            // ---- read the 256 golden outputs into local memory ----
            for (i = 0; i < 256; i = i + 1) begin
                code = $fscanf(fh, "%h\n", tmp);
                gold_out[i] = tmp;
            end

            // ---- 2) start and wait for done ----
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            cyc = 0;
            while (done !== 1'b1) begin
                @(negedge clk);
                cyc = cyc + 1;
                if (cyc > 5000) begin $display("TIMEOUT waiting for done (test %0d)", t); $fatal; end
            end

            // ---- 3) read back and compare ----
            for (i = 0; i < 256; i = i + 1) begin
                rd_addr = i[7:0];
                #1;
                if (rd_data !== gold_out[i]) begin
                    errors = errors + 1;
                    if (errors <= 12)
                        $display("NTT MISMATCH test %0d idx %0d: got=%04h exp=%04h",
                                 t, i, rd_data, gold_out[i]);
                end
            end
            // keep the waveform small + readable: record only the first 3 cases
            if (t == 2) $dumpoff;
            if (((t+1) % 10) == 0 || t == T-1)
                $display("   ... %0d/%0d transforms checked (%0d cycles each), errors=%0d",
                         t+1, T, cyc, errors);
        end
        $fclose(fh);

        $display("==================================================================");
        $display(" NTT ENGINE TEST: %0d transforms, %0d coeff errors", T, errors);
        if (errors == 0) $display(" RESULT: ALL PASS (engine == C++ ntt(), bit-exact)");
        else             $display(" RESULT: FAIL");
        $display("==================================================================");
        if (errors != 0) $fatal(1, "engine/c++ mismatch");
        $finish;
    end

endmodule

`default_nettype wire
