# Reproducing the results

Every number quoted in this repository and in the paper comes from a file that is checked in. This
page says which file, and what to run to regenerate it.

## Software you need

| Stage | Tool | Notes |
| ----- | ---- | ----- |
| Reference model | Python 3.10 or newer | no packages beyond the standard library |
| C++ model | any C++17 compiler | header only, no build system |
| RTL simulation | Icarus Verilog and cocotb | `pip install -r test/requirements.txt` |
| Hardening | LibreLane and the SKY130 PDK | or push to the Tiny Tapeout GDS action |
| FPGA | Vivado 2023.2, plus Vitis for the Alveo | |

Only the last two need a licence, and neither is needed to reproduce the functional results.

## The reference models

```sh
cd code/python && python ntt_ref.py
cd code/cpp    && c++ -std=c++17 -O2 test_ntt.cpp -o test_ntt && ./test_ntt
```

The Python model carries a Chinese Remainder Theorem check that does not depend on any layer, twiddle
order or butterfly, so it grades the transform against the definition rather than against another
implementation. The C++ model answers a different question, whether the arithmetic is the
**standard's** arithmetic, and `test_acvp.cpp` checks it byte exact against the NIST ACVP vectors.

`code/cpp/verify_constants.py` recomputes `QINV`, `v`, `f` and the whole zeta table from their
definitions and compares against the header, because a wrong constant is the failure that hides best.

## The chip, functional

```sh
cd test
make                      # pin level: all six ops, a full NTT, a round trip, basemul
make -f Makefile_bf       # the six operation datapath over both reductions
make -f Makefile_fq       # the pipelined multiply and its Montgomery reduction
make -f Makefile_bar      # Barrett, over all 65,536 inputs
make -f Makefile_rom      # all 128 twiddle entries
python ntt_golden.py      # the model's own self tests
```

27 tests. Five avoid the golden model entirely, so a misreading of FIPS 203 cannot hide in the model
and the hardware together. [../test/README.md](../test/README.md) explains which five and why.

Barrett is checked over its entire input space rather than sampled, because a 16 bit word is only
65,536 values and `a = -32768` sits exactly on the boundary of the theorem being relied on.

To run against the gate level netlist rather than the RTL, copy `results/gds/tt_um_ntt.nl.v` to
`test/gate_level_netlist.v` and run `make -B GATES=yes`. The same `test.py` drives both, because the
tests read pins through helpers that treat `X` and `Z` as 0.

## The chip, physical

The signoff numbers come from `results/metrics.json`, the LibreLane run's own output.
`results/commit_id.json` records the commit and workflow run that produced it.

| Number | Key in `metrics.json` | Value |
| ------ | --------------------- | ----- |
| Die area | `design__die__area` | 75,602.5 µm² |
| Core area | `design__core__area` | 72,564.6 µm² |
| Logic area | `design__instance__area__stdcell` | 52,730.6 µm² |
| All instances | `design__instance__count` | 12,521 |
| Cell count | that, less the 6454 fill cells | 6067 |
| Flip flops | `design__instance__count__class:sequential_cell` | 327 |
| Worst setup slack | `timing__setup__ws__corner:*`, worst of nine | +1.955 ns |
| Worst hold slack | `timing__hold__ws__corner:*`, worst of nine | +0.106 ns |
| Total power | `power__total` | 2.623 mW |
| Routed wire | `route__wirelength` | 128,063 µm |
| Routed nets | `route__net` | 5023 |
| Vias | `route__vias` | 36,218 |
| DRC, LVS, antenna, latches | four separate keys | 0 |

Two derived figures:

- **Gate count 14,048 GE** is the standard cell area divided by the area of a `nand2_1`,
  52,730.6 / 3.7536.
- **Maximum frequency 55.4 MHz** is `1 / (20 ns - 1.955 ns)`, the target period less the worst slack.

### The two utilization figures

There are two, they differ, and both are correct.

```
signoff           52,730.6 / 72,564.6              = 72.7 %
global placement  53,354.5 / (72,564.6 - 1,905.6)  = 75.5 %
```

The first is `design__instance__utilization` in `metrics.json`, taken at the end of the flow over the
whole core. The second is `GPL-0019` in `results/openroad-globalplacement.log`, taken at stage 28 of
55, dividing the movable cell area by the core area less the fixed instances, before the flow finished
resizing. The second is what the Tiny Tapeout summary page reports, so it is the one quoted. Dividing
the two area rows in any table gives the first, not the second.

### The cell breakdown

The 6067 count includes the 1037 tap cells, which the flow places rather than inferring from the RTL.
Only fill and decap are excluded. Grouped as the Tiny Tapeout summary page groups them, and verified
cell type by cell type against `results/gds/tt_um_ntt.nl.v`:

| Category | Count | | Category | Count |
| -------- | ----- | - | -------- | ----- |
| Combinational logic | 1519 | | Multiplexer | 93 |
| Tap | 1037 | | Miscellaneous | 87 |
| NOR | 890 | | Inverter | 86 |
| NAND | 640 | | Buffer | 85 |
| OR and XOR | 541 | | Diode | 5 |
| AND | 440 | | **Total** | **6067** |
| Flip flops | 327 | | Fill and decap | 6454 |
| Clock tree | 317 | | **All instances** | **12,521** |

The grouping follows the tool rather than function, so `xnor2` counts under NOR, `xor2` under OR, and
`clkbuf` under Buffer rather than Clock.

## Rebuilding the twiddle ROM

`src/twiddle_rom.v` is generated. Do not edit it by hand:

```sh
python scripts/generate_twiddle.py
```

The generator asserts the head of the table against the reference Kyber `zetas`
(`-1044, -758, -359, -1517`) and checks the 12 bit signed fit before writing, so a wrong table fails
there rather than in silicon.

## The FPGA numbers

The Arty reports that match the bitstream and the working demonstration are in
`fpga/arty_a7_100t/vivado_project/arty_top_proj/arty_top_proj.runs/impl_1/`.

| Number | File |
| ------ | ---- |
| 532 LUTs, 284 registers, 9 DSP, 8 IOB | `arty_top_utilization_placed.rpt` |
| +0.960 ns setup, +0.176 ns hold, 0 of 922 | `arty_top_timing_summary_routed.rpt`, the `sys_clk_pin` row |
| 0.119 W total, 0.022 dynamic, 0.097 static | `arty_top_power_routed.rpt`, section 1 |
| fully routed, 0 DRC errors | `arty_top_route_status.rpt`, `arty_top_drc_routed.rpt` |

Implied maximum on the Arty is `1 / (10 ns - 0.960 ns)` = 110.6 MHz.

There is also a `fpga/arty_a7_100t/vivado_project/reports/` directory from an earlier build, dated
26 August, which reports 621 LUTs and 12 DSP. That build predates the UART bridge work. The numbers
above and in the paper are the `impl_1` set.

For the Alveo, note which build each number comes from:

| Number | File |
| ------ | ---- |
| 619 LUTs, 215 registers, 12 DSP | `fpga/alveo_u55c/gate_level_sim/utilization_demo_top.rpt`, the bare kernel |
| +0.989 ns across 264 endpoints | `fpga/alveo_u55c/vivado_project/reports/link/imp/impl_1_hw_bb_locked_timing_summary_routed.rpt`, the `clk_kernel_00_unbuffered_net` row |
| 3.318 W, of which 3.273 W static | `fpga/alveo_u55c/vivado_project/demo_top_proj/demo_top_proj.runs/impl_1/demo_top_power_routed.rpt` |

To rebuild either board:

```sh
vivado -mode batch -source fpga/arty_a7_100t/build_arty.tcl
cd fpga/alveo_u55c && ./build.sh
```

Both resolve their own paths, so neither needs a working directory set for it.

## What the cross platform comparison does and does not say

The three platforms run at different clocks, and the chip moves its operands over an 8 bit bus while
the FPGA builds hold the polynomial locally. The power comparison therefore measures standing cost
per unit of deployed function, not energy per transform. An FPGA pays the leakage of an entire device
no matter how little of it you use, and the U55C draws 3.27 W standing still for a kernel occupying
0.05% of its fabric.

FPGA timing closure also turned out to be a poor predictor of ASIC timing closure. The design met
100 MHz on the Arty and 300 MHz on the Alveo with a combinational multiplier and a combinational
reducer, and neither structure could meet 50 MHz on SKY130. Multipliers are hard DSP blocks on both
FPGAs and synthesized gates in silicon, where they become half the chip.
