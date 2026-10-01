set src /home/coder/ntt-butterfly-sky26c/src
set part xcu55c-fsvh2892-2L-e

read_verilog $src/mod_mult.v
read_verilog $src/mod_add.v
read_verilog $src/mod_sub.v
read_verilog $src/butterfly.v
read_verilog $src/intt_butterfly.v
read_verilog $src/twiddle_rom.v
read_verilog $src/coeff_mem.v
read_verilog $src/control_fsm.v
read_verilog $src/intt_control_fsm.v
read_verilog $src/demo_top.v

synth_design -top demo_top -part $part -flatten_hierarchy rebuilt

write_verilog -force -mode funcsim ./demo_top_funcsim.v
write_verilog -force -mode timesim ./demo_top_timesim.v

catch { report_utilization -file utilization_demo_top.rpt }
puts "NETLIST_DONE"
flush stdout
