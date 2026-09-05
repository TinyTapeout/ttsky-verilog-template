#!/usr/bin/env bash
# ============================================================================
#  run_intt_sim.sh  -  Compile + simulate the full INVERSE NTT accelerator (xsim)
# ----------------------------------------------------------------------------
#  Runs from code/verilog/sim/.  Verifies intt_engine against the reference
#  invntt() golden transforms (vectors/intt_vectors.mem).
# ============================================================================
set -e
cd "$(dirname "$0")"

RTL=../rtl
TB=../tb

echo "== xvlog =="
xvlog --nolog -i $RTL \
    $RTL/montgomery_reduce.v \
    $RTL/barrett_reduce.v \
    $RTL/fqmul.v \
    $RTL/intt_butterfly.v \
    $RTL/intt_engine.v \
    $TB/tb_intt_engine.v

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_intt_engine -s intt_sim

echo "== xsim =="
xsim --nolog intt_sim -runall
