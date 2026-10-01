# Architecture

## The transform

ML-KEM-512 multiplies polynomials in the ring `Z_3329[x] / (x^256 + 1)`. Doing that directly costs
65,536 coefficient multiplies. The Number Theoretic Transform is the butterfly network an FFT
already uses, with the complex roots of unity replaced by powers of 17 modulo 3329, so every
intermediate value stays an exact integer and no rounding enters.

A full decomposition of a negacyclic ring of degree 256 would need a primitive 512th root of unity.
Since `q - 1 = 3328 = 2^8 * 13` carries only `2^8` as a power of two, `Z_3329` has a primitive 256th
root and no 512th root. The factorization therefore stops at 128 quadratic factors rather than 256
linear ones, the transform runs 7 layers instead of 8, and the pointwise stage multiplies degree 1
polynomials modulo those quadratics rather than multiplying scalars. Seven layers of 128 butterflies
is 896 butterflies, and 127 distinct twiddle factors serve all of them.

Constants: `q = 3329`, `n = 256`, `zeta = 17`, `R = 2^16`, `QINV = -3327`, `v = 20159`.

## Why two reduction kernels

Every product has to be brought back under `q`, and the two standard ways to do it suit different
places in the datapath.

**Montgomery** follows every multiply. It wants a wide product as its input, which a multiply has
just produced, so it costs almost nothing extra there. Given `a`, it computes
`m = (a mod R) * QINV` and `t = (a - m*q) / R`, and the result satisfies `|t| < q`.

**Barrett** runs on the addition path of the inverse transform. That path carries no product, so
there is no radix factor for a Montgomery step to absorb. Barrett takes a single 16 bit word:
`t = round(a*v / 2^26)` and `c = a - t*q`, which lands in `(-q/2, q/2]`.

Building both cost 22% of the cell count and saved one multiply per inverse butterfly. The two are
genuinely distinct units on the die, and `test/test_butterfly.py` has a test that fails if they were
ever quietly folded onto each other.

## The chip

The chip is the modular arithmetic engine. A host holds the 256 coefficients and walks the FIPS 203
address pattern, and the chip does the arithmetic and looks up its own constants, so the host sends a
twiddle **index** and never a value.

```
        pins  <-------> ntt_io          operand registers, launch, unload
                           |
              +------------+------------+
              |                         |
        twiddle_rom               butterfly            CT GS FQMUL ZMUL BARRETT ADD
        128 x 12                   |      |
        Montgomery                 |      |
                                 fqmul  barrett_reduce
                                 5 stage    2 stage
```

Six operations cover the forward transform, the inverse transform and `basemul`:

| op | name | `a_out` | `b_out` | used for |
| -- | ---- | ------- | ------- | -------- |
| 0 | CT | `a + fqmul(zeta,b)` | `a - fqmul(zeta,b)` | forward NTT |
| 1 | GS | `barrett(a + b)` | `fqmul(zeta, b - a)` | inverse NTT |
| 2 | FQMUL | `fqmul(a, b)` | same | scaling, basemul |
| 3 | ZMUL | `fqmul(zeta, a)` | same | basemul twiddle multiply |
| 4 | BARRETT | `barrett(a)` | same | range control |
| 5 | ADD | `a + b` | `a - b` | polynomial add and subtract |

Values are signed 16 bit and centred. Every operation takes 5 clocks as seen at the pins, including
the two that do not use the multiplier, so a host can poll `busy` rather than counting.

The register map is in [info.md](info.md). Do not write the operand registers while `busy` is high;
the datapath reads them directly for the whole operation rather than taking its own copy.

### Why the coefficients are off chip

The twiddle table is 1536 bits and costs about 463 cells, because a constant is a fixed function of
its index and the synthesizer minimizes it into gates. The coefficient array is the same order of
magnitude in bits and does not compress at all, because it is mutable. At 4096 bits it does not fit
beside the datapath on a 2x2 tile, so it stayed with the host. That asymmetry is the single decision
that shaped the chip.

### What closed timing

Two rules set the stage boundaries:

1. Every stage holds at most one multiply.
2. **No register drives both a long path and a short path.**

The second rule came out of two failed builds. A register feeding both gets padded with hold repair
buffers to protect the short path, and the long path pays for that padding. One netlist held 227 such
buffers, contributing 4.18 ns on a single register's output before any arithmetic ran. Splitting
Barrett across two registers and giving the multiplier its own operand register fixed it. The
multiply itself is two 16 by 8 partial products and a recombine rather than one 16 by 16, which took
that stage from 63 logic levels to 46.

## The FPGA engine

The FPGA builds hold all 256 coefficients in on board memory (`coeff_mem`, one block RAM) and
sequence the transform themselves, so the host only starts them and reads results back. This is a
different RTL lineage from the chip, with separate forward and inverse control FSMs and separate
butterfly units, and a `mod_mult` that maps onto DSP blocks.

The sequencer walks three loops. The outer steps through the 7 layers halving the stride, the middle
walks the blocks in a layer and draws one new twiddle per block, and the inner issues the butterflies.
Within a layer the pairs are disjoint, so the butterflies are independent.

On the Arty the whole thing sits behind a UART bridge so a laptop can load a polynomial, run the
forward transform, run the inverse, and read the result back. On the Alveo the same engine is wrapped
in an AXI slave and built as a Vitis kernel.
