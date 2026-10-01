#!/usr/bin/env bash
# ============================================================================
#  run_polymul_sim.sh  -  Compile + simulate the full a*b polynomial multiply
# ----------------------------------------------------------------------------
#  Runs from code/verilog/sim/.  Feeds a and b through the poly_mul top
#  (ntt_engine x2 -> basemul_engine -> intt_engine) and checks the product
#  against the schoolbook golden (vectors/polymul_vectors.mem).
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
    $RTL/ntt_butterfly.v \
    $RTL/intt_butterfly.v \
    $RTL/basemul.v \
    $RTL/ntt_engine.v \
    $RTL/intt_engine.v \
    $RTL/basemul_engine.v \
    $RTL/poly_mul.v \
    $TB/tb_poly_mul.v

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_poly_mul -s pm_sim

echo "== xsim =="
xsim --nolog pm_sim -runall
