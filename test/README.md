# Tests for the ML-KEM NTT/INTT accelerator

All tests use [cocotb](https://docs.cocotb.org/en/stable/) with Icarus Verilog and check against
`ntt_golden.py`, a bit exact model of the hardware, one Python function per Verilog module, whose constants
are verified against the reference Kyber tables (`zetas` starting `-1044, -758, -359, -1517`, `QINV = -3327`,
`v = 20159`, `f = 1441`).

| Command | What it covers |
| ------- | -------------- |
| `make` | **The hardened design.** Drives `tt_um_ntt` through the TT pins only: all six ops, both reductions reached from outside, all 128 twiddles recovered from the chip's own ROM by index, register persistence, a full forward NTT, an NTT→INTT round trip, `basemul`, and that the latency is uniform across all six ops. |
| `make -f Makefile_bf` | The six-operation datapath: each op with its latency checked constant, 700 operations with the op changing every time, the shared Barrett unit's two callers, that GS undoes CT, and that the two reductions are genuinely distinct units. |
| `make -f Makefile_fq` | The pipelined multiply: exactly 5 clocks of latency, 2,000 multiplies issued one per clock in order, Theorem 6.1's bounds, that the Montgomery factor cancels, and that `fqmul(x,1)` is a bare `montgomery_reduce`. |
| `make -f Makefile_bar` | Barrett over **all 65,536** signed 16 bit inputs, Theorem 6.2's two claims, that the quotient is `round` and not `floor`, and that `v` is the derived constant. |
| `make -f Makefile_rom` | All 128 twiddle entries against `centre(17^brv7(k)·R mod q)`, and that the table is Montgomery rather than plain. |
| `python ntt_golden.py` | The model's own self tests, including both theorems' bounds. |

## Why Barrett is tested exhaustively

Its input is a single 16 bit word, so the entire input space is 65,536 values, small enough to cover
completely, and there is no reason to sample. There is one good reason not to: Theorem 6.2 is stated for
`|a| < 2¹⁵`, so `a = -32768` sits exactly on the boundary. It is a value the hardware can be handed, so it is
checked rather than assumed. The observed output range is exactly `[-1664, 1664]`, i.e. `(-q/2, q/2]`.

Montgomery cannot be tested that way, since its input is 32 bits, so `test_fqmul.py` checks Theorem 6.1's two
claims (`|t| < q` and `t·R ≡ a·b mod q`) directly against the hardware over the ranges that actually occur.

## Tests that do not trust the model

Everything else compares the RTL against `ntt_golden.py`, but that model is ours. If we had misread the
mathematics, model and hardware would be wrong together and everything would still pass. Five checks avoid
that:

- **`ntt_golden.py`'s CRT check.** The incomplete NTT is a Chinese Remainder Theorem map, so `NTT(f)[2i]` and
  `NTT(f)[2i+1]` must be exactly `f` reduced modulo `x² − ζ^(2·brv7(i)+1)`. No layer, twiddle order or
  butterfly enters into that statement.
- **`test.py::test_known_vector`.** `NTT(1)` must be `(1, 0)` at every one of the 128 quadratic factors,
  because the constant polynomial is already its own remainder. Written down from the definition.
- **`test.py::test_twiddle_rom_is_on_chip`.** All 128 twiddles recovered from the chip through `ZMUL`, plus the
  negated half. Nowhere in `test.py` is a twiddle value written to the chip.
- **`test_butterfly.py::test_ct_gs_are_inverse`.** `GS(CT(a, b, ζ), ζ)` must have `2a mod q` as its first
  output, a property of the two butterflies being genuine inverses, checked against the hardware alone.
- **`test_butterfly.py::test_both_reductions_are_present`.** Montgomery and Barrett must give *different*
  answers for the same input, related by exactly `R⁻¹`. If Barrett had been quietly folded onto the multiplier
  as `fqmul(x, R mod q)`, the two would agree and this test would fail.

## Operation timing

| stage | clocks |
| ----- | ------ |
| `fqmul`, the multiply and its Montgomery reduction | 5 |
| `barrett_reduce` | 2, plus one input register, so 3 |
| **every op, as seen at the pins** | **5** |

All six ops take the same 5 clocks, including `BARRETT` and `ADD`, which issue into the multiplier and ignore
its result. Barrett finishes in 3 and its result is held until the outputs are read. Poll `busy` rather than
counting clocks. **Do not write the operand registers while `busy` is high.** The
datapath reads them directly for the whole operation rather than taking its own copy.

## Regenerating the twiddle ROM

`src/twiddle_rom.v` is generated. If it is ever edited by hand, regenerate instead:

```sh
python scripts/generate_twiddle.py
```

The generator asserts the table head against the reference Kyber `zetas` and checks the 12 bit signed fit
before writing, so a wrong table fails there rather than in silicon.

## Gate level simulation

Harden the project first, copy `runs/wokwi/results/final/verilog/gl/tt_um_ntt.v` to `gate_level_netlist.v`,
then:

```sh
make -B GATES=yes
```

The tests read pins through helpers that treat `X`/`Z` as 0, so the same `test.py` runs against both RTL and
the post layout netlist.

## Waveforms

`make` writes `tb.fst`:

```sh
gtkwave tb.fst tb.gtkw     # or: surfer tb.fst
```
