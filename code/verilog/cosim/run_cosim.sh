#!/usr/bin/env bash
# ============================================================================
#  run_cosim.sh  -  End-to-end HW/SW co-design demo
# ----------------------------------------------------------------------------
#  1. Builds the xsim snapshot of the NTT accelerator (tb_ntt_accel) once.
#  2. Builds the C++ host (cosim_ntt) which runs ML-KEM-512 and offloads each
#     forward NTT to that snapshot.
#  3. Runs the host; it verifies the hardware result is bit-exact and that the
#     full polynomial product is unchanged.
#
#  Run from code/verilog/cosim/.  Vivado (xvlog/xelab/xsim) must be on PATH.
# ============================================================================
set -e
cd "$(dirname "$0")"

RTL=../rtl
HDRS=../tb   # params.hpp / reduce.hpp / ntt.hpp live next to the generators

# --- headers for the C++ host ---
cp -f $HDRS/params.hpp $HDRS/reduce.hpp $HDRS/ntt.hpp .

echo "== [1/3] building NTT accelerator xsim snapshot =="
xvlog --nolog -i $RTL \
    $RTL/montgomery_reduce.v $RTL/fqmul.v $RTL/ntt_butterfly.v $RTL/ntt_engine.v \
    tb_ntt_accel.v
xelab --nolog -debug typical --timescale 1ns/1ps tb_ntt_accel -s accel_sim

echo "== [2/3] building C++ host (offloads NTT to hardware) =="
g++ -std=c++17 -O2 cosim_ntt.cpp -o cosim_ntt

echo "== [3/3] running co-simulation =="
./cosim_ntt
