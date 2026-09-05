#!/usr/bin/env bash
# ============================================================================
#  run_sim.sh  -  Compile + simulate the NTT butterfly with Vivado xsim
# ----------------------------------------------------------------------------
#  Runs from code/verilog/sim/.  Uses Vivado's standalone simulator
#  (xvlog / xelab / xsim) so no full Vivado project is needed.
# ============================================================================
set -e
cd "$(dirname "$0")"

RTL=../rtl
TB=../tb

echo "== xvlog: compiling RTL + testbench =="
xvlog --nolog \
    $RTL/montgomery_reduce.v \
    $RTL/fqmul.v \
    $RTL/ntt_butterfly.v \
    $TB/tb_ntt_butterfly.v

echo "== xelab: elaborating =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_ntt_butterfly -s tb_sim

echo "== xsim: running =="
xsim --nolog tb_sim -runall
