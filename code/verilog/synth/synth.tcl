# ============================================================================
#  synth.tcl  -  Vivado batch synthesis of the NTT accelerator (FPGA sanity check)
# ----------------------------------------------------------------------------
#  Synthesizes a chosen top module for an Artix-7 part to confirm the RTL is
#  synthesizable and to report resource usage + timing.  Tiny Tapeout itself
#  hardens on Sky130 via OpenLane; Vivado is the fast local check requested.
#
#  RUN:  vivado -mode batch -source synth.tcl -tclargs <top>
#        (from code/verilog/synth/ ; default top = tt_um_ntt_butterfly)
#
#  NOTE: this environment's Vivado aborts inside libudev during its *exit*
#  house-keeping, so every report is printed to stdout (tee'd to a log) and
#  wrapped in `catch` -- the numbers are all emitted before that exit crash.
# ============================================================================
set_param general.maxThreads 4

set rtl  ../rtl
set part xc7a35tcpg236-1
set top  [lindex $argv 0]
if {$top eq ""} { set top tt_um_ntt_butterfly }

read_verilog $rtl/montgomery_reduce.v
read_verilog $rtl/fqmul.v
read_verilog $rtl/ntt_butterfly.v
if {[file exists $rtl/barrett_reduce.v]}      { read_verilog $rtl/barrett_reduce.v }
if {[file exists $rtl/intt_butterfly.v]}      { read_verilog $rtl/intt_butterfly.v }
if {[file exists $rtl/basemul.v]}             { read_verilog $rtl/basemul.v }
if {[file exists $rtl/ntt_engine.v]}          { read_verilog $rtl/ntt_engine.v }
if {[file exists $rtl/intt_engine.v]}         { read_verilog $rtl/intt_engine.v }
if {[file exists $rtl/basemul_engine.v]}      { read_verilog $rtl/basemul_engine.v }
if {[file exists $rtl/poly_mul.v]}            { read_verilog $rtl/poly_mul.v }
if {[file exists $rtl/tt_um_ntt_butterfly.v]} { read_verilog $rtl/tt_um_ntt_butterfly.v }

synth_design -top $top -part $part -flatten_hierarchy rebuilt

# Write utilization to a file IMMEDIATELY (this environment's Vivado can abort in
# libudev during exit, so we persist the report before any later step can crash).
catch { report_utilization -file utilization_$top.rpt }

if {[llength [get_ports -quiet clk]] > 0} {
    create_clock -name clk -period 20.000 [get_ports clk]
    catch { report_timing_summary -file timing_$top.rpt -delay_type max -max_paths 3 }
}

puts "########## UTILIZATION_BEGIN $top ##########"
catch { puts [report_utilization -return_string] } e0
puts "########## UTILIZATION_END ##########"

puts "########## TIMING_BEGIN $top ##########"
catch { puts [report_timing_summary -return_string -delay_type max -max_paths 3] } e1
puts "########## TIMING_END ##########"

puts "SYNTH_DONE $top"
flush stdout
