# Repository guide

What every folder holds and which of them you actually need.

There are **two separate designs** in this repository. They compute the same transform but they are
not the same RTL, and reading one while thinking of the other is the easiest way to get confused.

| | The chip | The FPGA engine |
| --- | --- | --- |
| Lives in | [`src/`](../src/) | [`fpga/src/`](../fpga/src/) |
| Holds the polynomial | no, the host does | yes, in a block RAM |
| Sequences the transform | no, the host does | yes, its own control FSMs |
| Reduction | Montgomery and Barrett, both on die | Montgomery only |
| Twiddle table | on die, 128 entries | on the FPGA |
| Built for | SKY130, a 2x2 Tiny Tapeout tile | Arty A7-100T and Alveo U55C |

The chip is smaller because a 2x2 tile has no room for a mutable 256 coefficient array. That single
constraint is what separates the two designs, and the reasoning is in
[architecture.md](architecture.md).

## Top level

```
src/            the chip. The RTL that taped out on SKY130
test/           the chip's testbenches, 27 cocotb tests
scripts/        generate_twiddle.py, which writes src/twiddle_rom.v
docs/           this guide and the rest of the documentation
results/        what the hardening run produced: GDS, netlist, and the signoff metrics
code/           the reference models and the earlier design lineage
fpga/           the FPGA engine, its tests, and both board builds
info.yaml       the Tiny Tapeout shuttle descriptor
```

## src, the chip

| File | What it is |
| ---- | ---------- |
| `tt_um_ntt.v` | the Tiny Tapeout wrapper, the 24 pin budget |
| `ntt_io.v` | byte serial front end and the register map |
| `ntt_top.v` | ties the front end to the datapath |
| `butterfly.v` | the six operations, uniform 5 clock latency |
| `fqmul.v` | 5 stage multiply and Montgomery reduction |
| `barrett_reduce.v` | 2 stage Barrett reduction |
| `twiddle_rom.v` | **generated**, 128 by 12 bit signed Montgomery zetas |
| `config.json` | the LibreLane configuration, 20 ns period |

`twiddle_rom.v` is generated. Do not edit it by hand, run `python scripts/generate_twiddle.py`.

## results, what the run produced

| Path | What it is |
| ---- | ---------- |
| `gds/tt_um_ntt.gds` | the layout that was submitted |
| `gds/tt_um_ntt.nl.v` | the gate level netlist, 12,521 instances |
| `gds/tt_um_ntt.def` | the routed placement, every instance with its coordinates |
| `gds/tt_um_ntt.lef` | the abstract view, pins and blockages |
| `gds/tt_um_ntt.h.json` | the pin and parameter description |
| `metrics.json` | all 314 signoff metrics |
| `commit_id.json` | the commit and workflow run that produced them |
| `openroad-globalplacement.log` | kept only for the `GPL-0019` utilization line |

Every ASIC number quoted anywhere in this repository comes from these files.
[reproducing.md](reproducing.md) maps each one to its key.

## fpga, the board builds

```
fpga/src/             the FPGA RTL, engine and board glue together
fpga/test/            17 cocotb testbenches
fpga/arty_a7_100t/    the Arty build, the demonstration, and its reports
fpga/alveo_u55c/      the Alveo Vitis kernel and its reports
```

The RTL sits in one directory because both boards share the engine. The board folders keep the names
they had on the FPGA branch, and they sit next to `src/` on purpose: `build_arty.tcl` resolves its
sources as `<script dir>/../src` and the cocotb Makefiles use `$(PWD)/../src`, so both land on
`fpga/src` with nothing rewritten.

Which files belong to which board:

| Board | RTL |
| ----- | --- |
| shared engine | `coeff_mem.v`, `control_fsm.v`, `intt_control_fsm.v`, `butterfly.v`, `intt_butterfly.v`, `mod_mult.v`, `mod_add.v`, `mod_sub.v`, `twiddle_rom.v`, `ntt_top.v`, `intt_top.v` |
| Arty | `arty_top.v`, `uart_demo_top.v`, `uart_rx.v`, `uart_tx.v`, `debounce_pulse.v`, `pulse_stretch.v`, `tb_uart_demo.v` |
| Alveo | `demo_top.v`, `demo_top_axi_wrapper.v`, `demo_top_s_axi.v`, `project.v` |

Both board folders carry their full Vivado project, including the checkpoints, every report, the Arty
bitstream and the Alveo kernel. What is not in them is only what Vivado rewrites on open: journal
files, waveform databases, the run scheduler XML, `.Xil` and the incremental caches.

| Artefact | Path |
| -------- | ---- |
| Arty bitstream | `fpga/arty_a7_100t/vivado_project/arty_top.bit` |
| Arty project | `fpga/arty_a7_100t/vivado_project/arty_top_proj/arty_top_proj.xpr` |
| Arty host script | `fpga/arty_a7_100t/host/uart-host.py` |
| Alveo kernel | `fpga/alveo_u55c/vivado_project/demo_top_krnl.hw.xclbin` |
| Alveo project | `fpga/alveo_u55c/vivado_project/demo_top_proj/demo_top_proj.xpr` |
| Alveo gate level netlists | `fpga/alveo_u55c/gate_level_sim/demo_top_funcsim.v`, `demo_top_timesim.v` |

## code, the models and the lineage

| Path | What it is | Still current |
| ---- | ---------- | ------------- |
| `code/python/` | the Python reference model and a worked example | yes |
| `code/cpp/` | the C++ ML-KEM model, checked byte exact against the NIST ACVP vectors | yes |
| `code/verilog/` | the first RTL, its testbenches and the generated test vectors | superseded by `src/` |
| `code/alveo/` | the first Alveo kernel | superseded by `fpga/alveo_u55c/` |
| `code/tinytapeout/` | an earlier Tiny Tapeout iteration, before both reductions went on die | superseded by `src/` |

The last three are kept because the paper describes the path the design took, and because the earlier
testbenches and vectors are still what the current ones were graded against. Read `src/` and
`fpga/src/` for the design as submitted.

`code/tinytapeout/` in particular is a full copy of an older repository layout, so it has its own
`src/`, `test/` and `info.yaml`. Those are not the submitted design. The submitted design is the
`src/` at the top of this repository.

## Where to start

- To understand the mathematics and the datapath, read [architecture.md](architecture.md).
- To reproduce a published number, read [reproducing.md](reproducing.md).
- To run the live demonstration, read [fpga_demo.md](fpga_demo.md).
- For the chip's pinout and register map, read [info.md](info.md).
