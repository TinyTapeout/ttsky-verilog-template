#!/usr/bin/env bash
# ============================================================================
#  build.sh  -  Build the ML-KEM-512 NTT/INTT Alveo kernel + host
# ----------------------------------------------------------------------------
#  Usage:  ./build.sh <hw_emu|hw> [jobs]
#    hw_emu : fast (minutes) hardware-emulation xclbin, validates host+kernel
#    hw     : real bitstream for the U55C (HOURS on this 4-core host)
#
#  Produces:  build/ntt_krnl.<target>.xclbin  and  build/host
#  Emulation also needs emconfig.json (generated here for hw_emu).
# ============================================================================
set -e
cd "$(dirname "$0")"
HERE="$(pwd)"

TARGET="${1:-hw_emu}"
JOBS="${2:-4}"
PLATFORM=xilinx_u55c_gen3x16_xdma_3_202210_1

# --- tool + runtime environment ---
source /tools/Xilinx/Vitis/2023.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/opt/xilinx/platforms

# --- udev-less-container fix (see history/DEBUGGING.md, Issue 3) ---------------
# Vivado's WebTalk/license host-info scan dlopen()s libudev.so.1 and calls
# udev_enumerate_scan_devices, which SIGABRTs here (no udev) and kills the
# vpl config_hw_runs synthesis launcher -> the hw build hangs forever.
# dlopen defeats LD_PRELOAD, so we shadow libudev.so.1 with a harmless stub
# placed FIRST on LD_LIBRARY_PATH (after the tool sources, so it wins).
export LD_LIBRARY_PATH="$HERE/udevstub:${LD_LIBRARY_PATH}"
sudo mkdir -p /run/udev 2>/dev/null || true   # belt-and-suspenders (tmpfs, per-boot)

mkdir -p build
cd build

XO=ntt_krnl.${TARGET}.xo
XCLBIN=ntt_krnl.${TARGET}.xclbin

echo "==================================================================="
echo " BUILD  target=$TARGET  jobs=$JOBS  platform=$PLATFORM"
echo "==================================================================="

# 1) compile HLS kernel -> .xo
echo "== v++ -c (HLS compile) =="
v++ -c -t "$TARGET" --platform "$PLATFORM" -k ntt_krnl \
    -o "$XO" ../src/ntt_krnl.cpp \
    --save-temps -j "$JOBS" 2>&1 | tee vpp_compile_${TARGET}.log

# 2) link -> .xclbin
echo "== v++ -l (link) =="
v++ -l -t "$TARGET" --platform "$PLATFORM" \
    --config ../ntt_krnl.cfg \
    -o "$XCLBIN" "$XO" \
    -j "$JOBS" 2>&1 | tee vpp_link_${TARGET}.log

# 3) emulation config (only needed for hw_emu)
if [ "$TARGET" = "hw_emu" ]; then
    echo "== emconfigutil =="
    emconfigutil --platform "$PLATFORM" --nd 1
fi

# 4) host program (same binary for emu and hw)
echo "== g++ host =="
g++ -std=c++17 -O2 -Wall ../host/host.cpp \
    -I"${XILINX_XRT}/include" \
    -L"${XILINX_XRT}/lib" -lxrt_coreutil -luuid -lpthread \
    -o host 2>&1 | tee gpp_host.log

echo "==================================================================="
echo " DONE: build/$XCLBIN  and  build/host"
echo "==================================================================="
