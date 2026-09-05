#!/usr/bin/env bash
# ============================================================================
#  build.sh  -  link + build the self-contained NTT/INTT round-trip demo
#               kernel (demo_top_krnl.xo, already packaged) for the U55C.
# ----------------------------------------------------------------------------
#  Usage:  ./build.sh <hw_emu|hw>
#    hw     : real bitstream for the U55C (HOURS on this 4-core host)
#
#  Produces:  build/demo_top_krnl.<target>.xclbin
# ============================================================================
set -e
cd "$(dirname "$0")"
HERE="$(pwd)"

TARGET="${1:-hw}"
PLATFORM=xilinx_u55c_gen3x16_xdma_3_202210_1

source /tools/Xilinx/Vitis/2023.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
export PLATFORM_REPO_PATHS=/opt/xilinx/platforms

# same libudev-shadow workaround proven necessary in this container for the
# other Alveo build in this environment (see ~/TT/code/alveo/build.sh) --
# Vivado's WebTalk/license host-info scan dlopen()s libudev.so.1 and SIGABRTs
# with no real udev present, killing the vpl config_hw_runs launcher.
export LD_LIBRARY_PATH="$HERE/udevstub:${LD_LIBRARY_PATH}"
sudo mkdir -p /run/udev 2>/dev/null || true

cd build
XCLBIN=demo_top_krnl.${TARGET}.xclbin

echo "==================================================================="
echo " LINK  target=$TARGET  platform=$PLATFORM"
echo "==================================================================="

v++ -l -t "$TARGET" --platform "$PLATFORM" \
    --config ../demo_krnl.cfg \
    -o "$XCLBIN" demo_top_krnl.xo \
    2>&1 | tee vpp_link_${TARGET}.log

echo "==================================================================="
echo " DONE: build/$XCLBIN"
echo "==================================================================="
