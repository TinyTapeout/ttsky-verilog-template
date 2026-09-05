// ============================================================================
//  ntt_krnl.cpp  -  Vitis HLS kernel: ML-KEM-512 forward/inverse NTT on Alveo
// ----------------------------------------------------------------------------
//  This kernel runs the SAME bit-exact arithmetic as the verified C++ reference
//  (code/cpp/ntt.hpp, reduce.hpp) and the Verilog RTL: q=3329, zeta=17, n=256,
//  16-bit signed coefficients, Montgomery/Barrett reduction, 7 butterfly layers
//  (896 butterflies), 127 distinct twiddles held in an on-chip ROM.
//
//  It processes a BATCH of `num_poly` polynomials streamed from HBM:
//      mode 0 : out = ntt(in)                        (forward)
//      mode 1 : out = invntt(in)                     (inverse)
//      mode 2 : out = canonical(mont_reduce(invntt(ntt(in)))) == in   (round-trip)
//
//  Interfaces (standard Vitis): in/out are AXI4 master ports to HBM; the scalars
//  and the control handshake are AXI4-Lite (s_axilite). One kernel invocation
//  transforms all num_poly polynomials.
// ============================================================================
#include <stdint.h>

#define KYBER_N 256
#define KYBER_Q 3329

// ---- exact-width modular arithmetic (mirrors reduce.hpp to the bit) ---------
static const int16_t QINV = -3327;   // q^-1 mod 2^16

static inline int16_t montgomery_reduce(int32_t a) {
#pragma HLS INLINE
    int16_t t = (int16_t)((int16_t)a * QINV);
    t = (int16_t)((a - (int32_t)t * KYBER_Q) >> 16);
    return t;
}

static inline int16_t barrett_reduce(int16_t a) {
#pragma HLS INLINE
    const int16_t v = (int16_t)(((1 << 26) + KYBER_Q / 2) / KYBER_Q); // 20159
    int16_t t = (int16_t)(((int32_t)v * a + (1 << 25)) >> 26);
    t = (int16_t)(t * KYBER_Q);
    return (int16_t)(a - t);
}

static inline int16_t fqmul(int16_t a, int16_t b) {
#pragma HLS INLINE
    return montgomery_reduce((int32_t)a * b);
}

static inline uint16_t to_canonical(int16_t a) {
#pragma HLS INLINE
    uint16_t t = (uint16_t)a;
    t += (uint16_t)(((int16_t)t >> 15) & KYBER_Q);
    return t;
}

// ---- the 127 twiddles (index 0 used only by invntt scan) --------------------
static const int16_t zetas[128] = {
    -1044,  -758,  -359, -1517,  1493,  1422,   287,   202,
     -171,   622,  1577,   182,   962, -1202, -1474,  1468,
      573, -1325,   264,   383,  -829,  1458, -1602,  -130,
     -681,  1017,   732,   608, -1542,   411,  -205, -1571,
     1223,   652,  -552,  1015, -1293,  1491,  -282, -1544,
      516,    -8,  -320,  -666, -1618, -1162,   126,  1469,
     -853,   -90,  -271,   830,   107, -1421,  -247,  -951,
     -398,   961, -1508,  -725,   448, -1065,   677, -1275,
    -1103,   430,   555,   843, -1251,   871,  1550,   105,
      422,   587,   177,  -235,  -291,  -460,  1574,  1653,
     -246,   778,  1159,  -147,  -777,  1483,  -602,  1119,
    -1590,   644,  -872,   349,   418,   329,  -156,   -75,
      817,  1097,   603,   610,  1322, -1285, -1465,   384,
    -1215,  -136,  1218, -1335,  -874,   220, -1187, -1659,
    -1185, -1530, -1278,   794, -1510,  -854,  -870,   478,
     -108,  -308,   996,   991,   958, -1460,  1522,  1628
};

// ---- forward NTT (Cooley-Tukey), in place on a local array ------------------
static void ntt(int16_t r[KYBER_N]) {
    unsigned k = 1;
    for (unsigned len = 128; len >= 2; len >>= 1) {
        for (unsigned start = 0; start < KYBER_N; start += 2 * len) {
            int16_t zeta = zetas[k++];
            for (unsigned j = start; j < start + len; j++) {
#pragma HLS PIPELINE II=1
                int16_t t = fqmul(zeta, r[j + len]);
                r[j + len] = r[j] - t;
                r[j]       = r[j] + t;
            }
        }
    }
}

// ---- inverse NTT (Gentleman-Sande) + 1/128 scale ----------------------------
static void invntt(int16_t r[KYBER_N]) {
    const int16_t f = 1441;
    unsigned k = 127;
    for (unsigned len = 2; len <= 128; len <<= 1) {
        for (unsigned start = 0; start < KYBER_N; start += 2 * len) {
            int16_t zeta = zetas[k--];
            for (unsigned j = start; j < start + len; j++) {
#pragma HLS PIPELINE II=1
                int16_t t  = r[j];
                r[j]       = barrett_reduce(t + r[j + len]);
                r[j + len] = r[j + len] - t;
                r[j + len] = fqmul(zeta, r[j + len]);
            }
        }
    }
    for (unsigned j = 0; j < KYBER_N; j++) {
#pragma HLS PIPELINE II=1
        r[j] = fqmul(r[j], f);
    }
}

extern "C" {
// in/out : num_poly * 256 signed-16 coefficients, packed contiguously in HBM.
// mode   : 0=ntt, 1=invntt, 2=round-trip (canonical INTT(NTT(in))==in)
void ntt_krnl(const int16_t *in, int16_t *out, int num_poly, int mode) {
#pragma HLS INTERFACE m_axi     port=in       offset=slave bundle=gmem0 depth=256
#pragma HLS INTERFACE m_axi     port=out      offset=slave bundle=gmem1 depth=256
#pragma HLS INTERFACE s_axilite port=in       bundle=control
#pragma HLS INTERFACE s_axilite port=out      bundle=control
#pragma HLS INTERFACE s_axilite port=num_poly bundle=control
#pragma HLS INTERFACE s_axilite port=mode     bundle=control
#pragma HLS INTERFACE s_axilite port=return   bundle=control

    for (int p = 0; p < num_poly; p++) {
        int16_t buf[KYBER_N];
#pragma HLS ARRAY_PARTITION variable=buf cyclic factor=2 dim=1
        const int base = p * KYBER_N;

        // burst-load one polynomial from HBM
        for (int i = 0; i < KYBER_N; i++) {
#pragma HLS PIPELINE II=1
            buf[i] = in[base + i];
        }

        if (mode == 0) {
            ntt(buf);
        } else if (mode == 1) {
            invntt(buf);
        } else { // mode 2: round-trip with the single Montgomery R^-1 correction
            ntt(buf);
            invntt(buf);
            for (int i = 0; i < KYBER_N; i++) {
#pragma HLS PIPELINE II=1
                buf[i] = (int16_t)to_canonical(montgomery_reduce((int32_t)buf[i]));
            }
        }

        // burst-store the result back to HBM
        for (int i = 0; i < KYBER_N; i++) {
#pragma HLS PIPELINE II=1
            out[base + i] = buf[i];
        }
    }
}
} // extern "C"
