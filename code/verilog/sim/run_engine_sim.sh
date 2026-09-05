#!/usr/bin/env bash
# ============================================================================
#  run_engine_sim.sh  -  Compile + simulate the full NTT accelerator (xsim)
# ----------------------------------------------------------------------------
#  Runs from code/verilog/sim/.  Verifies ntt_engine against the C++ ntt()
#  golden transforms (vectors/ntt_poly_vectors.mem).
# ============================================================================
set -e
cd "$(dirname "$0")"

RTL=../rtl
TB=../tb

echo "== xvlog =="
xvlog --nolog -i $RTL \
    $RTL/montgomery_reduce.v \
    $RTL/fqmul.v \
    $RTL/ntt_butterfly.v \
    $RTL/ntt_engine.v \
    $TB/tb_ntt_engine.v

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_ntt_engine -s eng_sim

echo "== xsim =="
xsim --nolog eng_sim -runall
