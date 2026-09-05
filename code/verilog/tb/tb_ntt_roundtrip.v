// ============================================================================
//  tb_ntt_roundtrip.v  -  End-to-end INTT(NTT(f)) == f in hardware
// ----------------------------------------------------------------------------
//  Wires the forward and inverse accelerators back to back and proves the pure
//  round-trip recovers the original polynomial:
//
//      f  --ntt_engine-->  NTT(f)  --intt_engine-->  f * R  --correct-->  f
//
//  The ML-KEM invntt leaves one residual Montgomery factor R = 2^16, so the
//  raw hardware output is f*R (mod q).  A single Montgomery reduction per
//  coefficient (montgomery_reduce(x) = x * R^-1) cancels it, and the result is
//  canonicalized to [0,q) and compared to the original f.
//
//  Golden data: vectors/roundtrip_vectors.mem (input f, expected f).
//  Run from code/verilog/sim/.
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_ntt_roundtrip;

    // -------------------------------------------------------------- clock/reset
    reg clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz
    reg rst_n = 1'b0;

    // ------------------------------------------------- forward engine (ntt) I/O
    reg               n_load_en = 1'b0;
    reg  [7:0]        n_load_addr = 8'd0;
    reg  signed [15:0] n_load_data = 16'sd0;
    reg               n_start = 1'b0;
    wire              n_busy, n_done;
    reg  [7:0]        n_rd_addr = 8'd0;
    wire signed [15:0] n_rd_data;

    ntt_engine u_ntt (
        .clk(clk), .rst_n(rst_n),
        .load_en(n_load_en), .load_addr(n_load_addr), .load_data(n_load_data),
        .start(n_start), .busy(n_busy), .done(n_done),
        .rd_addr(n_rd_addr), .rd_data(n_rd_data)
    );

    // ------------------------------------------------- inverse engine (intt) I/O
    reg               i_load_en = 1'b0;
    reg  [7:0]        i_load_addr = 8'd0;
    reg  signed [15:0] i_load_data = 16'sd0;
    reg               i_start = 1'b0;
    wire              i_busy, i_done;
    reg  [7:0]        i_rd_addr = 8'd0;
    wire signed [15:0] i_rd_data;

    intt_engine u_intt (
        .clk(clk), .rst_n(rst_n),
        .load_en(i_load_en), .load_addr(i_load_addr), .load_data(i_load_data),
        .start(i_start), .busy(i_busy), .done(i_done),
        .rd_addr(i_rd_addr), .rd_data(i_rd_data)
    );

    // ----------------------------- Montgomery correction (cancel residual R) --
    reg  signed [15:0] mont_in = 16'sd0;
    wire signed [31:0] mont_a = {{16{mont_in[15]}}, mont_in};  // sign-extend to 32
    wire signed [15:0] mont_t;                                 // = mont_in * R^-1
    montgomery_reduce u_corr (.a(mont_a), .t(mont_t));

    // --------------------------------------------------------------- test memory
    integer fh, code, T, t, i, cyc;
    integer errors = 0;
    reg signed [15:0] f_in  [0:255];   // original polynomial
    reg signed [15:0] gold  [0:255];   // expected output (== f_in)
    reg signed [15:0] corr;            // canonicalized corrected coefficient
    reg [15:0] tmp;

    initial begin
        $dumpfile("tb_ntt_roundtrip.vcd");
        $dumpvars(0, tb_ntt_roundtrip);

        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);

        fh = $fopen("../tb/vectors/roundtrip_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open roundtrip_vectors.mem"); $fatal; end
        code = $fscanf(fh, "%d\n", T);
        $display("[roundtrip] running %0d INTT(NTT(f)) == f test cases", T);

        for (t = 0; t < T; t = t + 1) begin
            // ---- read f and the expected output (same) ----
            for (i = 0; i < 256; i = i + 1) begin
                code = $fscanf(fh, "%h\n", tmp); f_in[i] = tmp;
            end
            for (i = 0; i < 256; i = i + 1) begin
                code = $fscanf(fh, "%h\n", tmp); gold[i] = tmp;
            end

            // ---- 1) load f into the forward engine, run NTT ----
            for (i = 0; i < 256; i = i + 1) begin
                @(negedge clk);
                n_load_en = 1'b1; n_load_addr = i[7:0]; n_load_data = f_in[i];
            end
            @(negedge clk); n_load_en = 1'b0;
            @(negedge clk); n_start = 1'b1;
            @(negedge clk); n_start = 1'b0;
            cyc = 0;
            while (n_done !== 1'b1) begin
                @(negedge clk); cyc = cyc + 1;
                if (cyc > 5000) begin $display("TIMEOUT ntt (test %0d)", t); $fatal; end
            end

            // ---- 2) copy NTT(f) into the inverse engine ----
            for (i = 0; i < 256; i = i + 1) begin
                n_rd_addr = i[7:0]; #1;
                @(negedge clk);
                i_load_en = 1'b1; i_load_addr = i[7:0]; i_load_data = n_rd_data;
            end
            @(negedge clk); i_load_en = 1'b0;

            // ---- 3) run INTT ----
            @(negedge clk); i_start = 1'b1;
            @(negedge clk); i_start = 1'b0;
            cyc = 0;
            while (i_done !== 1'b1) begin
                @(negedge clk); cyc = cyc + 1;
                if (cyc > 5000) begin $display("TIMEOUT intt (test %0d)", t); $fatal; end
            end

            // ---- 4) read back, apply Montgomery correction, canonicalize, compare ----
            for (i = 0; i < 256; i = i + 1) begin
                i_rd_addr = i[7:0]; #1;
                mont_in = i_rd_data;   #1;                 // mont_t = i_rd_data * R^-1
                corr = mont_t + ((mont_t >>> 15) & 16'sd3329);  // -> [0, q)
                if (corr !== gold[i]) begin
                    errors = errors + 1;
                    if (errors <= 12)
                        $display("ROUNDTRIP MISMATCH test %0d idx %0d: got=%0d exp=%0d",
                                 t, i, corr, gold[i]);
                end
            end
            // keep the waveform small + readable: record only the first 3 cases
            if (t == 2) $dumpoff;
            if (((t+1) % 100) == 0 || t == T-1)
                $display("   ... %0d/%0d round-trips checked, errors=%0d", t+1, T, errors);
        end
        $fclose(fh);

        $display("==================================================================");
        $display(" ROUND-TRIP TEST: %0d cases, %0d coeff errors", T, errors);
        if (errors == 0) $display(" RESULT: ALL PASS (INTT(NTT(f)) == f in hardware)");
        else             $display(" RESULT: FAIL");
        $display("==================================================================");
        if (errors != 0) $fatal(1, "round-trip mismatch");
        $finish;
    end

endmodule

`default_nettype wire
