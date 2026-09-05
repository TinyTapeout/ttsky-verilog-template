#!/usr/bin/env bash
# ============================================================================
#  run.sh  -  Run the NTT/INTT host on the Alveo card or in emulation
#  Usage:  ./run.sh <hw_emu|hw> [num_poly] [seed]
# ============================================================================
set -e
cd "$(dirname "$0")"

TARGET="${1:-hw_emu}"
NUM="${2:-1000}"
SEED="${3:-0xA5A5}"
PLATFORM=xilinx_u55c_gen3x16_xdma_3_202210_1

source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/opt/xilinx/platforms

cd build
XCLBIN=ntt_krnl.${TARGET}.xclbin
if [ ! -f "$XCLBIN" ]; then echo "missing $XCLBIN — build it first"; exit 1; fi

if [ "$TARGET" = "hw_emu" ]; then
    # emulation launches the Vivado simulator -> needs the Vitis environment
    source /tools/Xilinx/Vitis/2023.2/settings64.sh
    export XCL_EMULATION_MODE=hw_emu
    echo "== running in HARDWARE EMULATION =="
else
    unset XCL_EMULATION_MODE
    echo "== running on the REAL Alveo U55C =="
fi

./host "$XCLBIN" "$NUM" "$SEED"
