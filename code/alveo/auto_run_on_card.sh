#!/usr/bin/env bash
# ============================================================================
#  auto_run_on_card.sh
#  Waits for the hw bitstream (build/ntt_krnl.hw.xclbin) to finish building,
#  then runs the NTT/INTT host on the REAL Alveo U55C and logs the result.
#  Launch DETACHED so it survives this workspace's recurring session deaths:
#     setsid nohup ./auto_run_on_card.sh </dev/null >auto_run_on_card.out 2>&1 &
# ============================================================================
set -u
cd "$(dirname "$0")"
HERE="$PWD"
XCLBIN="$HERE/build/ntt_krnl.hw.xclbin"
STAMP() { date '+%Y-%m-%d %H:%M:%S'; }

echo "[$(STAMP)] watcher up; waiting for $XCLBIN"
while true; do
    if [ -f "$XCLBIN" ]; then
        # ensure the file is fully written (size stable for 2 checks)
        s1=$(stat -c%s "$XCLBIN" 2>/dev/null || echo 0); sleep 20
        s2=$(stat -c%s "$XCLBIN" 2>/dev/null || echo 0)
        if [ "$s1" = "$s2" ] && [ "$s1" -gt 0 ]; then
            echo "[$(STAMP)] bitstream ready ($s2 bytes) -> running on the real card"
            break
        fi
    fi
    # failure detection: build fully stopped (no v++/vpl/vivado) and still no xclbin
    if ! pgrep -f 'bin/(unwrapped/lnx64.o/)?(v\+\+|vpl|vivado)' >/dev/null 2>&1; then
        if [ ! -f "$XCLBIN" ]; then
            echo "[$(STAMP)] ERROR: build processes gone but no xclbin — build failed."
            echo "[$(STAMP)] see build_hw.out / build/vpp_link_hw.log ; check for hs_err_pid*.log"
            find "$HERE/build/_x" -name 'hs_err_pid*.log' 2>/dev/null | tail -3
            exit 2
        fi
    fi
    sleep 60
done

echo "[$(STAMP)] ===== ./run.sh hw 1000 (physical U55C) ====="
./run.sh hw 1000 0xA5A5
rc=$?
echo "[$(STAMP)] ===== run.sh exit code: $rc ====="
if [ $rc -eq 0 ]; then
    echo "[$(STAMP)] DONE: NTT/INTT executed on the real Alveo U55C."
else
    echo "[$(STAMP)] run.sh returned non-zero ($rc) — inspect output above (xclbin load / XRT compat?)."
fi
exit $rc
