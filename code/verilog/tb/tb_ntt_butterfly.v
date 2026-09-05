// ============================================================================
//  tb_ntt_butterfly.v  -  Self-checking testbench for the NTT butterfly stack
// ----------------------------------------------------------------------------
//  Reads the golden vectors produced by gen_vectors.cpp (which reuses the exact
//  C++ reference arithmetic) and checks the Verilog RTL bit-for-bit:
//
//    montgomery_reduce  <- vectors/montgomery_vectors.mem
//    fqmul              <- vectors/fqmul_vectors.mem
//    ntt_butterfly      <- vectors/butterfly_vectors.mem   (comb + registered)
//
//  Any mismatch prints the offending record and increments an error counter.
//  The simulation ends with $fatal on failure so a CI script sees a nonzero exit.
//
//  Run from code/verilog/sim/ so the "../tb/vectors/..." paths resolve.
// ============================================================================
`default_nettype none
`timescale 1ns / 1ps

module tb_ntt_butterfly;

    integer errors = 0;
    integer total  = 0;

    // ----------------------------------------------------------------- clock
    reg clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz

    // ============================ montgomery_reduce ========================
    reg  signed [31:0] m_a;
    wire signed [15:0] m_t;
    reg  signed [15:0] m_exp;
    montgomery_reduce dut_mont (.a(m_a), .t(m_t));

    // ================================ fqmul ================================
    reg  signed [15:0] f_a, f_b;
    wire signed [15:0] f_r;
    reg  signed [15:0] f_exp;
    fqmul dut_fqmul (.a(f_a), .b(f_b), .r(f_r));

    // ============================ ntt_butterfly ============================
    reg  signed [15:0] bf_a, bf_b, bf_zeta;
    wire signed [15:0] bf_aout, bf_bout;
    reg  signed [15:0] bf_aexp, bf_bexp;
    ntt_butterfly dut_bf (
        .a(bf_a), .b(bf_b), .zeta(bf_zeta),
        .a_out(bf_aout), .b_out(bf_bout)
    );

    // ==================== ntt_butterfly_reg (pipelined) ====================
    reg               r_valid_in = 1'b0;
    reg               rst_n      = 1'b0;
    wire signed [15:0] r_aout, r_bout;
    wire              r_valid_out;
    ntt_butterfly_reg dut_bf_reg (
        .clk(clk), .rst_n(rst_n), .valid_in(r_valid_in),
        .a(bf_a), .b(bf_b), .zeta(bf_zeta),
        .a_out(r_aout), .b_out(r_bout), .valid_out(r_valid_out)
    );

    // ------------------------------------------------------------ file I/O
    integer fh, code;

    initial begin
        $dumpfile("tb_ntt_butterfly.vcd");
        $dumpvars(0, tb_ntt_butterfly);

        // ---------------- 1) montgomery_reduce ----------------
        fh = $fopen("../tb/vectors/montgomery_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open montgomery_vectors.mem"); $fatal; end
        while (!$feof(fh)) begin
            code = $fscanf(fh, "%h %h\n", m_a, m_exp);
            if (code == 2) begin
                #1;
                total = total + 1;
                if (m_t !== m_exp) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("MONT MISMATCH: a=%08h got=%04h exp=%04h", m_a, m_t, m_exp);
                end
            end
        end
        $fclose(fh);
        $display("[montgomery_reduce] checked, running total=%0d errors=%0d", total, errors);

        // ---------------- 2) fqmul ----------------
        fh = $fopen("../tb/vectors/fqmul_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open fqmul_vectors.mem"); $fatal; end
        while (!$feof(fh)) begin
            code = $fscanf(fh, "%h %h %h\n", f_a, f_b, f_exp);
            if (code == 3) begin
                #1;
                total = total + 1;
                if (f_r !== f_exp) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("FQMUL MISMATCH: a=%04h b=%04h got=%04h exp=%04h",
                                 f_a, f_b, f_r, f_exp);
                end
            end
        end
        $fclose(fh);
        $display("[fqmul] checked, running total=%0d errors=%0d", total, errors);

        // ---------------- 3) ntt_butterfly (combinational) ----------------
        fh = $fopen("../tb/vectors/butterfly_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open butterfly_vectors.mem"); $fatal; end
        while (!$feof(fh)) begin
            code = $fscanf(fh, "%h %h %h %h %h\n", bf_a, bf_b, bf_zeta, bf_aexp, bf_bexp);
            if (code == 5) begin
                #1;
                total = total + 1;
                if (bf_aout !== bf_aexp || bf_bout !== bf_bexp) begin
                    errors = errors + 1;
                    if (errors <= 10)
                        $display("BFLY MISMATCH: a=%04h b=%04h z=%04h got=(%04h,%04h) exp=(%04h,%04h)",
                                 bf_a, bf_b, bf_zeta, bf_aout, bf_bout, bf_aexp, bf_bexp);
                end
            end
        end
        $fclose(fh);
        $display("[ntt_butterfly comb] checked, running total=%0d errors=%0d", total, errors);

        // ---------------- 4) ntt_butterfly_reg (pipelined, clocked) ----------------
        // Release reset, then stream the butterfly vectors through the registered
        // version, checking the 1-cycle-delayed output against the same golden data.
        @(negedge clk); rst_n = 1'b1;
        fh = $fopen("../tb/vectors/butterfly_vectors.mem", "r");
        if (fh == 0) begin $display("ERROR: cannot open butterfly_vectors.mem"); $fatal; end
        while (!$feof(fh)) begin
            code = $fscanf(fh, "%h %h %h %h %h\n", bf_a, bf_b, bf_zeta, bf_aexp, bf_bexp);
            if (code == 5) begin
                @(negedge clk);
                r_valid_in = 1'b1;
                @(posedge clk);        // sample: outputs update on this edge
                #1;
                total = total + 1;
                if (r_valid_out !== 1'b1) begin
                    errors = errors + 1;
                    if (errors <= 20) $display("BFLY_REG valid_out not high");
                end else if (r_aout !== bf_aexp || r_bout !== bf_bexp) begin
                    errors = errors + 1;
                    if (errors <= 20)
                        $display("BFLY_REG MISMATCH: a=%04h b=%04h z=%04h got=(%04h,%04h) exp=(%04h,%04h)",
                                 bf_a, bf_b, bf_zeta, r_aout, r_bout, bf_aexp, bf_bexp);
                end
            end
        end
        $fclose(fh);
        $display("[ntt_butterfly_reg] checked, running total=%0d errors=%0d", total, errors);

        // ------------------------------- verdict -------------------------------
        $display("==================================================================");
        $display(" VERILOG NTT BUTTERFLY TEST: %0d vectors checked, %0d errors",
                 total, errors);
        if (errors == 0) $display(" RESULT: ALL PASS (bit-exact vs C++ reference)");
        else             $display(" RESULT: FAIL");
        $display("==================================================================");
        if (errors != 0) $fatal(1, "verilog/c++ mismatch");
        $finish;
    end

endmodule

`default_nettype wire
