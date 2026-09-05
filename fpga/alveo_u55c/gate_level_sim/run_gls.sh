#!/usr/bin/env bash
# Gate-level simulation of demo_top: standalone Vivado synth -> funcsim
# netlist -> xsim against Xilinx UNISIM primitives. Needs the udevstub
# LD_LIBRARY_PATH workaround (see alveo_demo/udevstub/) for Vivado's
# post-synth reporting crash in this container.
set -e
cd "$(dirname "$0")"
source /tools/Xilinx/Vivado/2023.2/settings64.sh
export LD_LIBRARY_PATH="$(cd ../alveo_demo/udevstub && pwd):${LD_LIBRARY_PATH}"
sudo mkdir -p /run/udev 2>/dev/null || true

echo "== synthesizing demo_top + exporting gate-level netlist =="
vivado -mode batch -source synth_netlist.tcl -nolog -nojournal

echo "== xvlog =="
xvlog --nolog -sourcelibext .v --relax \
    /tools/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v \
    demo_top_funcsim.v \
    tb_demo_top_gls.v \
    -L unisims_ver -L unimacro_ver

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_demo_top_gls glbl -s gls_sim \
    -L unisims_ver -L unimacro_ver -L secureip

echo "== xsim =="
xsim --nolog gls_sim -runall
