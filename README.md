![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# ML-KEM-512 NTT/INTT Accelerator

A Number Theoretic Transform accelerator for **ML-KEM-512** (FIPS 203, formerly Kyber), taken from a
reference model through two FPGAs and hardened for silicon on a Tiny Tapeout shuttle. Every stage
uses an open flow: an open PDK (SkyWater SKY130), an open RTL to GDSII flow (LibreLane), open
simulation (Icarus and cocotb), and an open shuttle.

Marc Boudames and Brendon Chang, Department of Electrical and Computer Engineering,
University of California San Diego.

**New here? Read [docs/repository_guide.md](docs/repository_guide.md) first.** It says what every
folder holds and which of them you actually need.

## What is in here

There are two separate designs. They compute the same transform but they are not the same RTL.

| | The chip | The FPGA engine |
| --- | --- | --- |
| Lives in | [`src/`](src/) | [`fpga/src/`](fpga/src/) |
| Holds the polynomial | no, the host does | yes, in a block RAM |
| Reduction | Montgomery and Barrett, both on die | Montgomery only |
| Twiddle table | on die, 128 entries | on the FPGA |
| Built for | SKY130, a 2x2 tile | Arty A7-100T and Alveo U55C |

The chip is smaller because a 2x2 tile has no room for a mutable 256 coefficient array. That single
constraint is what separates the two designs.

```
src/            the chip, the RTL that taped out
test/           the chip's testbenches, 27 cocotb tests
scripts/        generate_twiddle.py, which writes src/twiddle_rom.v
docs/           the guide, the architecture, how to reproduce, the demo
results/        what the hardening run produced: GDS, netlist, and the signoff metrics
code/           the reference models and the earlier design lineage
fpga/           the FPGA engine, its tests, and both board builds
info.yaml       the Tiny Tapeout shuttle descriptor
```

## What the chip does

It is the **modular arithmetic engine** of the transform. It carries **both reduction kernels**,
Montgomery and Barrett, and the **128 entry twiddle table** on die. A host holds the 256 coefficient
polynomial and walks the FIPS 203 address pattern; the chip does the arithmetic and looks up its own
constants, so the host sends a twiddle **index** and never a value.

| op | name | `a_out` | `b_out` | used for |
| -- | ---- | ------- | ------- | -------- |
| 0 | CT | `a + fqmul(ζ,b)` | `a − fqmul(ζ,b)` | forward NTT |
| 1 | GS | `barrett(a + b)` | `fqmul(ζ, b − a)` | inverse NTT |
| 2 | FQMUL | `fqmul(a, b)` | same | scaling, basemul |
| 3 | ZMUL | `fqmul(ζ, a)` | same | basemul's twiddle multiply |
| 4 | BARRETT | `barrett(a)` | same | range control |
| 5 | ADD | `a + b` | `a − b` | polynomial add and subtract |

Values are signed 16 bit and centred; `q = 3329`, `R = 2¹⁶`. Every operation takes 5 clocks.

## Results

| | Arty A7-100T | Alveo U55C | SKY130 |
| --- | --- | --- | --- |
| Clock | 100 MHz | 300 MHz | 50 MHz |
| Logic | 532 LUTs | 619 LUTs | 6067 cells |
| Multipliers | 9 DSP48E1 | 12 DSP48E2 | synthesized |
| Worst setup slack | +0.960 ns | +0.989 ns | +1.955 ns |
| Total power | 119 mW | 3318 mW | 2.623 mW |

Hardened on a **2x2 tile**, closing **50 MHz**:

| | |
| --- | --- |
| Technology | SkyWater SKY130, 130 nm, 1.80 V |
| Die area | 334.88 × 225.76 µm (75,603 µm²) |
| Standard cells | 6067, 52,731 µm² |
| Core utilization | 75.5% |
| Worst setup slack | **+1.955 ns**, 0 violations at all nine corners |
| Worst hold slack | +0.106 ns, 0 violations |
| DRC / LVS / antenna / latches | 0 / 0 / 0 / 0 |
| Total power | 2.623 mW |
| Routed wire | 128,063 µm across 5023 nets |

The arithmetic is 72% of the design. There are **no macros**: `design__instance__area__macros = 0`.
Every one of these numbers can be recovered from [`results/`](results/), and
[docs/reproducing.md](docs/reproducing.md) says exactly how.

## Testing

```sh
cd test
make                      # pin level: all six ops, a full NTT, a round trip, basemul
make -f Makefile_bf       # the six operation datapath over both reductions
make -f Makefile_fq       # the pipelined multiply and its Montgomery reduction
make -f Makefile_bar      # Barrett, over all 65,536 inputs
make -f Makefile_rom      # all 128 twiddle entries
python ntt_golden.py      # the model's own self tests
```

27 tests. Several avoid the golden model entirely, so a misreading of FIPS 203 cannot hide in the
model and the hardware together: `NTT(1)` must be `(1,0)` at all 128 quadratic factors, `GS` must
undo `CT` to give `2a`, each ROM entry is recomputed from `centre(17^brv7(k)·R mod q)` inside its own
test, and Montgomery and Barrett are required to return *different* answers related by exactly `R⁻¹`.

See [test/README.md](test/README.md) for detail, and [fpga/test/](fpga/test/) for the FPGA engine's
17 testbenches.

## The live demonstration

A laptop drives the Arty over USB and streams a full `INTT(NTT(f)) == f` round trip back coefficient
by coefficient. See [docs/fpga_demo.md](docs/fpga_demo.md).

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)
