// host_demo.cpp -- minimal XRT host program to run demo_top_krnl on the
// real Alveo U55C card and report the INTT(NTT(f))==f pass/fail result.
//
// The kernel is self-contained (generates its own test vector on-chip,
// see demo_top.v) and exposes only a hand-rolled AXI4-Lite control bus
// (see demo_top_s_axi.v), so this uses the low-level xrt::ip raw
// register interface rather than the higher-level xrt::kernel/xrt::run
// argument-passing API, matching the hardware's actual register map
// exactly:
//   0x00 AP_CTRL : bit0=ap_start (write 1 to launch), bit1=ap_done
//                  (read-only, clear-on-read), bit2=ap_idle (read-only)
//   0x10 STATUS  : bit3=pass, bits[2:0]=phase (valid once ap_done reads 1)
//   0x18 CYCLE_COUNT (read-only): # of busy cycles the run took (valid once
//                  ap_done reads 1) -- measured live on real hardware here,
//                  not just predicted from simulation.
#include <chrono>
#include <cstdint>
#include <iostream>
#include <thread>

#include "xrt/xrt_device.h"
#include "xrt/xrt_uuid.h"
#include "xrt/experimental/xrt_ip.h"

static constexpr uint32_t ADDR_AP_CTRL     = 0x00;
static constexpr uint32_t ADDR_STATUS      = 0x10;
static constexpr uint32_t ADDR_CYCLE_COUNT = 0x18;

int main(int argc, char** argv) {
    const std::string xclbin_path =
        (argc > 1) ? argv[1] : "build/demo_top_krnl.hw.xclbin";

    try {
        std::cout << "Opening device 0...\n";
        xrt::device device(0);

        std::cout << "Loading xclbin: " << xclbin_path << "\n";
        auto uuid = device.load_xclbin(xclbin_path);

        std::cout << "Opening IP demo_top_krnl:demo_top_krnl_1...\n";
        xrt::ip ip(device, uuid, "demo_top_krnl:demo_top_krnl_1");

        uint32_t ctrl = ip.read_register(ADDR_AP_CTRL);
        std::cout << "AP_CTRL out of reset: 0x" << std::hex << ctrl << std::dec
                   << " (idle=" << ((ctrl >> 2) & 1)
                   << " done=" << ((ctrl >> 1) & 1)
                   << " start=" << (ctrl & 1) << ")\n";

        std::cout << "Writing AP_CTRL.ap_start=1 to launch the demo...\n";
        ip.write_register(ADDR_AP_CTRL, 0x1);

        std::cout << "Polling for ap_done...\n";
        const int max_polls = 20000;
        int i = 0;
        for (; i < max_polls; ++i) {
            ctrl = ip.read_register(ADDR_AP_CTRL);
            if (ctrl & 0x2) break;
            std::this_thread::sleep_for(std::chrono::microseconds(100));
        }
        if (i == max_polls) {
            std::cerr << "FAIL: ap_done never asserted after " << max_polls
                       << " polls\n";
            return 1;
        }
        std::cout << "ap_done observed after " << i << " polls, AP_CTRL=0x"
                   << std::hex << ctrl << std::dec << "\n";

        // STATUS is independently latched (only a new `done` pulse updates
        // it) so it stays valid no matter how many times AP_CTRL was
        // already read; the poll loop's own AP_CTRL reads already cleared
        // ap_done (clear-on-read), so we don't re-check that here.
        uint32_t status = ip.read_register(ADDR_STATUS);
        int pass_bit = (status >> 3) & 1;
        int phase = status & 0x7;
        std::cout << "STATUS=0x" << std::hex << status << std::dec
                   << " pass=" << pass_bit << " phase=" << phase << "\n";

        uint32_t cycle_count = ip.read_register(ADDR_CYCLE_COUNT);
        double period_ns = 1000.0 / 300.0;  // DATA_CLK = 300 MHz
        std::cout << "CYCLE_COUNT=" << cycle_count << " ("
                   << (cycle_count * period_ns / 1000.0) << " us @ 300 MHz)\n";

        uint32_t ctrl2 = ip.read_register(ADDR_AP_CTRL);
        std::cout << "AP_CTRL after run (done already cleared by the poll "
                     "loop's own reads, idle should be back to 1): 0x"
                   << std::hex << ctrl2 << std::dec << "\n";

        if (pass_bit == 1) {
            std::cout << "\n=== HARDWARE RESULT: PASS -- INTT(NTT(f)) == f "
                         "on the real Alveo U55C ===\n";
            return 0;
        } else {
            std::cout << "\n=== HARDWARE RESULT: FAIL -- pass bit not set "
                         "===\n";
            return 1;
        }
    } catch (const std::exception& e) {
        std::cerr << "EXCEPTION: " << e.what() << "\n";
        return 1;
    }
}
