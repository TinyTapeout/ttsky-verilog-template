#!/usr/bin/env bash
# ============================================================================
#  run_worked_example.sh  -  base-case a*b through poly_mul, printed in
#                            decimal / hex / binary (matches worked_example.py)
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
    $TB/tb_worked_example.v

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_worked_example -s we_sim

echo "== xsim =="
xsim --nolog we_sim -runall
