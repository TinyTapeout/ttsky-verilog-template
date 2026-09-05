// ============================================================================
//  tb_poly_mul.v  -  End-to-end polynomial multiply in hardware
// ----------------------------------------------------------------------------
//  Drives poly_mul the way a host would:
//    1) load operand a (load_sel=0) and operand b (load_sel=1),
//    2) pulse start, wait for done,
//    3) read the 256 canonical result coefficients and compare to the golden
//       product c = a*b (from gen_polymul_vectors.py, cross-checked against
//       schoolbook multiplication).
//
//  Golden data: vectors/polymul_vectors.mem.  Run from code/verilog/sim/.
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_poly_mul;

    // -------------------------------------------------------------- clock/reset
    reg clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz
    reg rst_n = 1'b0;

    // ------------------------------------------------------------------- DUT I/O
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

    // --------------------------------------------------------------- test memory
    integer fh, code, T, t, i, cyc;
    integer errors = 0;
    reg signed [15:0] a_in [0:255];
    reg signed [15:0] b_in [0:255];
    reg signed [15:0] gold [0:255];
    reg [15:0] tmp;

    initial begin
        $dumpfile("tb_poly_mul.vcd");
        $dumpvars(0, tb_poly_mul);

        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);

        fh = $fopen("../tb/vectors/polymul_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open polymul_vectors.mem"); $fatal; end
        code = $fscanf(fh, "%d\n", T);
        $display("[poly_mul] running %0d full a*b polynomial-multiply cases", T);

        for (t = 0; t < T; t = t + 1) begin
            // ---- read a, b, and golden c ----
            for (i = 0; i < 256; i = i + 1) begin code = $fscanf(fh, "%h\n", tmp); a_in[i] = tmp; end
            for (i = 0; i < 256; i = i + 1) begin code = $fscanf(fh, "%h\n", tmp); b_in[i] = tmp; end
            for (i = 0; i < 256; i = i + 1) begin code = $fscanf(fh, "%h\n", tmp); gold[i] = tmp; end

            // ---- 1) load a (sel=0) then b (sel=1) ----
            for (i = 0; i < 256; i = i + 1) begin
                @(negedge clk);
                load_en = 1'b1; load_sel = 1'b0; load_addr = i[7:0]; load_data = a_in[i];
            end
            for (i = 0; i < 256; i = i + 1) begin
                @(negedge clk);
                load_en = 1'b1; load_sel = 1'b1; load_addr = i[7:0]; load_data = b_in[i];
            end
            @(negedge clk); load_en = 1'b0;

            // ---- 2) start and wait for done ----
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            cyc = 0;
            while (done !== 1'b1) begin
                @(negedge clk); cyc = cyc + 1;
                if (cyc > 20000) begin $display("TIMEOUT (test %0d)", t); $fatal; end
            end

            // ---- 3) read back and compare ----
            for (i = 0; i < 256; i = i + 1) begin
                rd_addr = i[7:0]; #1;
                if (rd_data !== gold[i]) begin
                    errors = errors + 1;
                    if (errors <= 12)
                        $display("POLYMUL MISMATCH test %0d idx %0d: got=%0d exp=%0d",
                                 t, i, rd_data, gold[i]);
                end
            end
            // keep the waveform small + readable: record only the first 3 cases
            if (t == 2) $dumpoff;
            if (((t+1) % 50) == 0 || t == T-1)
                $display("   ... %0d/%0d products checked (%0d cycles each), errors=%0d",
                         t+1, T, cyc, errors);
        end
        $fclose(fh);

        $display("==================================================================");
        $display(" POLY_MUL TEST: %0d products, %0d coeff errors", T, errors);
        if (errors == 0) $display(" RESULT: ALL PASS (a*b in hardware == schoolbook)");
        else             $display(" RESULT: FAIL");
        $display("==================================================================");
        if (errors != 0) $fatal(1, "poly_mul mismatch");
        $finish;
    end

endmodule

`default_nettype wire
