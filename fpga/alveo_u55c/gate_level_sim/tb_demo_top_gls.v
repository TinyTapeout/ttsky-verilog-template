`timescale 1ns/1ps
// Gate-level self-check for demo_top: same pass/fail criterion, and the
// same independent memory readback cross-check, as the RTL-level cocotb
// test (test/test_demo_top.py) -- run here against the SYNTHESIZED netlist
// (demo_top_funcsim.v, Xilinx UNISIM primitives) instead of the RTL, to
// confirm synthesis preserved behavior.
module tb_demo_top_gls;
    localparam Q = 3329;
    integer i;

    reg clk = 0;
    reg rst;
    reg start_i;
    wire busy, done, pass_o;
    wire [2:0] phase;
    wire [31:0] cycle_count;
    reg ext_addr_sel;
    reg [7:0] ext_addr;
    wire [11:0] ext_dout;

    always #1 clk = ~clk;   // 2ns period, matching the cocotb tests

    demo_top dut (
        .clk (clk),
        .rst (rst),
        .start_i (start_i),
        .busy (busy),
        .done (done),
        .pass_o (pass_o),
        .phase (phase),
        .cycle_count (cycle_count),
        .ext_addr_sel (ext_addr_sel),
        .ext_addr (ext_addr),
        .ext_dout (ext_dout)
    );

    integer errors;
    reg [11:0] expected;

    // UNISIM flip-flop primitives (FDRE etc.) power up in an unknown
    // simulation state until the FPGA's global set/reset is pulsed --
    // separate from, and a precondition for, this design's own `rst` logic
    // actually taking effect correctly in a gate-level (post-synthesis) sim.
    initial begin
        force glbl.GSR = 1'b1;
        #100;
        release glbl.GSR;
    end

    initial begin
        errors = 0;
        rst = 1;
        start_i = 0;
        ext_addr_sel = 0;
        ext_addr = 0;
        #150;   // safely past the 100ns GSR release window above
        repeat (3) @(posedge clk);
        rst = 0;
        @(posedge clk);

        if (busy !== 1'b0) begin
            $display("FAIL: busy should be 0 out of reset");
            errors = errors + 1;
        end

        start_i = 1;
        @(posedge clk);
        start_i = 0;

        // wait for done, bounded
        i = 0;
        // 256*6(load) + 896*7(ntt) + (896+256)*7(intt) + 257(compare) ~=
        // 16129 cycles with LATENCY=7 (coeff_mem's read is now registered
        // for BRAM inference -- see coeff_mem.v / control_fsm.v).
        while (done !== 1'b1 && i < 20000) begin
            @(posedge clk);
            i = i + 1;
        end
        if (done !== 1'b1) begin
            $display("FAIL: done never asserted (gate-level netlist)");
            errors = errors + 1;
        end else if (pass_o !== 1'b1) begin
            $display("FAIL: pass_o not asserted at done -- INTT(NTT(f)) != f (gate-level netlist)");
            errors = errors + 1;
        end else if (cycle_count < 15000 || cycle_count > 17000) begin
            $display("FAIL: cycle_count=%0d outside the expected ~16129-cycle range (gate-level netlist)", cycle_count);
            errors = errors + 1;
        end else begin
            $display("OK: gate-level demo_top asserted done with pass_o=1 after %0d cycles (dut.cycle_count=%0d)", i, cycle_count);
        end

        @(posedge clk);

        // independently verify orig_mem and coeff_mem contents match the
        // known default test vector f[i] = (i*17+5) mod q, same as the
        // cocotb-level check.
        ext_addr_sel = 1;
        for (i = 0; i < 256; i = i + 1) begin
            ext_addr = i[7:0];
            #1;
            expected = (i * 17 + 5) % Q;
            if (ext_dout !== expected) begin
                $display("FAIL: orig_mem[%0d] = %0d, expected %0d", i, ext_dout, expected);
                errors = errors + 1;
            end
            @(posedge clk);
        end

        // coeff_mem's read is now registered (see coeff_mem.v): unlike
        // orig_mem's combinational readback above, ext_dout here is only
        // valid the cycle AFTER ext_addr is presented.
        ext_addr_sel = 0;
        for (i = 0; i < 256; i = i + 1) begin
            ext_addr = i[7:0];
            @(posedge clk);
            #1;
            expected = (i * 17 + 5) % Q;
            if (ext_dout !== expected) begin
                $display("FAIL: coeff_mem[%0d] (post-roundtrip) = %0d, expected %0d", i, ext_dout, expected);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("GATE_LEVEL_SIM: ALL PASS (demo_top synthesized netlist, 256/256 coeffs, pass_o=1)");
        else
            $display("GATE_LEVEL_SIM: FAILED with %0d errors", errors);

        $finish;
    end
endmodule
