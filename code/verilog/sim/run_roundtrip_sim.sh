#!/usr/bin/env bash
# ============================================================================
#  run_roundtrip_sim.sh  -  Compile + simulate the NTT+INTT round-trip (xsim)
# ----------------------------------------------------------------------------
#  Runs from code/verilog/sim/.  Feeds f through ntt_engine then intt_engine,
#  applies the single Montgomery correction, and checks INTT(NTT(f)) == f
#  against vectors/roundtrip_vectors.mem.
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
    $RTL/ntt_engine.v \
    $RTL/intt_engine.v \
    $TB/tb_ntt_roundtrip.v

echo "== xelab =="
xelab --nolog -debug typical --timescale 1ns/1ps tb_ntt_roundtrip -s rt_sim

echo "== xsim =="
xsim --nolog rt_sim -runall
