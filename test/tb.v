`default_nettype none
`timescale 1ns / 1ps

/*
 * tb.v — Verilog Testbench Wrapper for tt_um_alu7b
 *
 * Bootcamp IC Design & Fabrication — IEEE OpenSilicon / IEEE CASS UTP 2026
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * PURPOSE
 * ─────────────────────────────────────────────────────────────────────────────
 * Instantiates the tt_um_alu7b top-level module and exposes all signals so that
 * the cocotb Python testbench (test.py) can drive inputs and observe outputs.
 *
 * This file provides the Verilog structural wrapper required by cocotb's
 * simulation interface. All actual test logic resides in test.py.
 *
 * Compatible with both:
 *   - RTL simulation (default): compiles src/alu_7b.v, src/serial_alu_ctrl.v,
 *     src/tt_um_alu7b.v via PROJECT_SOURCES in the Makefile.
 *   - Gate-level simulation (GATES=yes): compiles gate_level_netlist.v with
 *     GL_TEST define, which includes VPWR/VGND power pins for the sky130A PDK.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * WAVEFORM GENERATION
 * ─────────────────────────────────────────────────────────────────────────────
 * The initial block dumps all signals to tb.fst (FST format) for viewing in
 * GTKWave or Surfer. To use VCD format instead, edit $dumpfile to "tb.vcd"
 * and re-run with `make -B FST=`.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * SIGNAL INTERFACE
 * ─────────────────────────────────────────────────────────────────────────────
 *   clk     : System clock (driven by cocotb's Clock helper, 20 ns period)
 *   rst_n   : Active-low synchronous reset (driven by cocotb)
 *   ena     : Always 1 (design powered — TinyTapeout convention)
 *   ui_in   : 8-bit dedicated input bus
 *               ui_in[0]   = Bit_in (serial input, LSB first)
 *               ui_in[3:1] = op[2:0] (opcode, parallel)
 *               ui_in[7:4] = unused
 *   uio_in  : 8-bit bidirectional input (unused in this design, driven to 0)
 *   uo_out  : 8-bit parallel result output (Data_out[7:0])
 *   uio_out : 8-bit bidirectional output  (uio_out[0] = Done flag)
 *   uio_oe  : 8-bit bidirectional direction (uio_oe[0] = 1 → output)
 *
 * SPDX-License-Identifier: Apache-2.0
 */

module tb ();

    // ─────────────────────────────────────────────────────────────────────────
    // Waveform dump — FST format (compact, fast; preferred over VCD for cocotb)
    // ─────────────────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("tb.fst");
        $dumpvars(0, tb);
        #1;
    end

    // ─────────────────────────────────────────────────────────────────────────
    // Signal declarations
    // ─────────────────────────────────────────────────────────────────────────
    reg        clk;
    reg        rst_n;
    reg        ena;
    reg  [7:0] ui_in;    // ui_in[0] = Bit_in (serial input); ui_in[3:1] = op[2:0]
    reg  [7:0] uio_in;   // Bidirectional input path — not used in this design

    wire [7:0] uo_out;   // Data_out[7:0] — 8-bit parallel result
    wire [7:0] uio_out;  // uio_out[0] = Done flag (one-cycle high pulse)
    wire [7:0] uio_oe;   // Bidirectional direction control (uio_oe[0] = 1 → output)

    // ─────────────────────────────────────────────────────────────────────────
    // Gate-level simulation power pins (sky130A standard cell requirement)
    // Only present when compiled with `make GATES=yes` (GL_TEST defined).
    // ─────────────────────────────────────────────────────────────────────────
`ifdef GL_TEST
    wire VPWR = 1'b1;
    wire VGND = 1'b0;
`endif

    // ─────────────────────────────────────────────────────────────────────────
    // Device Under Test — tt_um_alu7b
    //
    // Instantiated as `user_project` so cocotb can reference internal signals
    // as `dut.user_project.<signal>` through the Verilog hierarchy.
    // ─────────────────────────────────────────────────────────────────────────
    tt_um_alu7b user_project (
`ifdef GL_TEST
        .VPWR    (VPWR),
        .VGND    (VGND),
`endif
        .ui_in   (ui_in),
        .uo_out  (uo_out),
        .uio_in  (uio_in),
        .uio_out (uio_out),
        .uio_oe  (uio_oe),
        .ena     (ena),
        .clk     (clk),
        .rst_n   (rst_n)
    );

endmodule
