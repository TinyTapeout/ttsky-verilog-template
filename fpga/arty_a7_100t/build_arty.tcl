## build_arty.tcl -- standalone Vivado synthesis + implementation + bitstream
## for the Arty A7-100T (xc7a100tcsg324-1). Plain Vivado flow (synth_design
## through write_bitstream), not the Vitis/v++ path used for the Alveo U55C
## kernel -- Arty is an ordinary dev board, not a Vitis platform.
set src   [file normalize [file join [file dirname [info script]] .. src]]
set xdc   [file join [file dirname [info script]] constraints arty_a7_100t.xdc]
set part  xc7a100tcsg324-1
set outdir [file join [file dirname [info script]] vivado_project]

file mkdir $outdir
file mkdir [file join $outdir reports]

read_verilog [list \
    $src/mod_mult.v \
    $src/mod_add.v \
    $src/mod_sub.v \
    $src/butterfly.v \
    $src/intt_butterfly.v \
    $src/twiddle_rom.v \
    $src/coeff_mem.v \
    $src/control_fsm.v \
    $src/intt_control_fsm.v \
    $src/demo_top.v \
    $src/debounce_pulse.v \
    $src/pulse_stretch.v \
    $src/arty_top.v \
]
read_xdc $xdc

synth_design -top arty_top -part $part
write_checkpoint -force $outdir/post_synth.dcp
report_utilization -file $outdir/reports/post_synth_utilization.rpt
report_timing_summary -file $outdir/reports/post_synth_timing_summary.rpt

opt_design
place_design
report_utilization -file $outdir/reports/post_place_utilization.rpt
report_timing_summary -file $outdir/reports/post_place_timing_summary.rpt

phys_opt_design
route_design
write_checkpoint -force $outdir/post_route.dcp
report_utilization -file $outdir/reports/post_route_utilization.rpt
report_timing_summary -file $outdir/reports/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 10 -path_type summary \
    -file $outdir/reports/post_route_timing_worst_paths.rpt
report_drc -file $outdir/reports/post_route_drc.rpt

write_bitstream -force $outdir/arty_top.bit

puts "ARTY_BUILD_DONE"
flush stdout
