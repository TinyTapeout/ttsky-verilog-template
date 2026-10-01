// butterfly.v -- the datapath: six operations over one pipelined multiplier
// and one Barrett reducer.
//
// All values are signed 16-bit and centred; q = 3329, R = 2^16.
//
//  op  name     a_out              b_out              muls  used by
//  --  -------  -----------------  -----------------  ----  --------------------
//  0   CT       a + fqmul(z,b)     a - fqmul(z,b)       1   forward NTT
//  1   GS       barrett(a + b)     fqmul(z, b - a)      1   inverse NTT
//  2   FQMUL    fqmul(a, b)        same                 1   scaling, basemul
//  3   ZMUL     fqmul(z, a)        same                 1   basemul's twiddle
//  4   BARRETT  barrett(a)         same                 0   range control
//  5   ADD      a + b              a - b                0   poly add/subtract
//
// z is the twiddle, selected by INDEX -- the table is on chip, in Montgomery
// form, so fqmul(z, x) lands as zeta*x with no stray factor.
//
// ---------------------------------------------------------------------------
// Both reductions, and the division of labour between them
// ---------------------------------------------------------------------------
// Montgomery and Barrett are not alternatives here; each does the job the other
// is bad at, exactly as the textbook sets out.
//
// MONTGOMERY after every multiply, because a multiply is where the R
// bookkeeping is free: the twiddle carries a factor R, the product cancels it,
// and the reduction costs two constant multiplies that ride inside the
// multiplier's own pipeline.
//
// BARRETT after chains of additions, where no R factor is involved and the
// value simply needs to come back into range. Gentleman-Sande adds a and b
// every layer with no multiply on that path, so without a reducer the sum grows
// layer over layer until it overflows the 16-bit datapath. Barrett pulls it
// back to (-q/2, q/2] and introduces no Montgomery factor while doing it.
//
// The alternative -- reusing fqmul with the constant R mod q to do range
// reduction -- is arithmetically sound and was what an earlier revision did.
// It costs a second pass through the multiplier for every GS butterfly,
// doubling the inverse transform's multiply count. A dedicated Barrett unit
// buys that back: GS needs one multiply, not two, and the add and the multiply
// happen in parallel rather than in sequence.
//
// ---------------------------------------------------------------------------
// Why Barrett is pipelined, and why every op takes five clocks
// ---------------------------------------------------------------------------
// An earlier revision left barrett_reduce purely combinational so that the
// BARRETT and ADD ops could answer in zero clocks. Post-layout timing rejected
// it: the worst path ran from the op register, through the mux that picks
// Barrett's input, through the whole reduction -- a*v, the rounding add, the
// shift, t*q, the subtract -- and on through the output mux into the caller's
// result register. 22.33 ns of arrival against 20.82 ns required, a violation
// of 1.51 ns at the slow corner across 58 endpoints, every one of them starting
// at op[2].
//
// The zero latency was never worth anything. The caller holds a, b and op still
// until out_valid, so the reduction always had the multiplier's whole latency
// available and was choosing to use one clock of it. barrett_reduce is now
// pipelined internally, and bar_in_r in front of it keeps the operand select off
// its critical path -- see the breakdown at the reducer itself, which explains
// why a single register was not enough.
//
// So every op now takes exactly 5 clocks. That also removes a special case from
// the caller: there is one latency, not two, and out_valid means the same thing
// for all six operations. The byte-serial interface needs four write cycles and
// four read cycles per operation anyway, so five clocks against zero is noise.
//
//   cycle 0   in_valid: bar_in_r and fqmul's operand registers latch
//   cycle 1   barrett stage 1; fqmul stage 1 (two half products)
//   cycle 2   barrett stage 2; fqmul stage 2 (recombine)
//   cycle 3   bar_r latches the finished reduction; fqmul stage 3
//   cycle 4   fqmul stage 4 -- t lands at the end
//   cycle 5   out_valid: a_out and b_out select between t, bar_r and one adder
//
// a, b and zeta must hold steady from in_valid until out_valid: the outputs are
// read live from them rather than from a delay chain, which saves 32 flip-flops
// and costs nothing, because the caller holds them in its operand registers
// anyway.

`default_nettype none

module butterfly (
    input  wire               clk,
    input  wire               rst,
    input  wire        [2:0]  op,
    input  wire               in_valid,    // a, b, zeta are live this clock
    input  wire signed [15:0] a,           // must hold until out_valid
    input  wire signed [15:0] b,
    input  wire signed [15:0] zeta,        // Montgomery-domain, from the ROM
    output wire signed [15:0] a_out,
    output wire signed [15:0] b_out,
    output wire               out_valid    // 5 clocks after in_valid, every op
);

    localparam [2:0] OP_CT      = 3'd0,
                     OP_GS      = 3'd1,
                     OP_FQMUL   = 3'd2,
                     OP_ZMUL    = 3'd3,
                     OP_BARRETT = 3'd4,
                     OP_ADD     = 3'd5;

    // One-hot decodes, computed once. The output selection below is a chain of
    // these rather than a chain of three-bit comparisons, which is what keeps
    // the last stage shallow.
    wire op_ct  = (op == OP_CT);
    wire op_gs  = (op == OP_GS);
    wire op_bar = (op == OP_BARRETT);
    wire op_add = (op == OP_ADD);

    // ---- the two sums the datapath needs ----------------------------------
    // Plain 16-bit two's complement, no modular correction: inside the
    // transforms no intermediate reaches the wrap point, and where growth does
    // accumulate -- the GS path -- Barrett is what brings it back.
    wire signed [15:0] sum  = a + b;
    wire signed [15:0] diff = b - a;

    // ---- the multiplier ----------------------------------------------------
    // FQMUL is the only op that puts a on the first operand; every other
    // multiplying op wants the twiddle there. BARRETT and ADD issue into the
    // multiplier too and simply ignore its result -- that is what makes the
    // latency uniform, and it costs nothing but a little switching.
    wire signed [15:0] mul_x = (op == OP_FQMUL) ? a : zeta;
    wire signed [15:0] mul_y = op_gs            ? diff :
                               (op == OP_ZMUL)  ? a    : b;

    wire signed [15:0] t;

    fqmul u_fqmul (
        .clk       (clk),
        .rst       (rst),
        .in_valid  (in_valid),
        .a         (mul_x),
        .b         (mul_y),
        .c         (t),
        .out_valid (out_valid)
    );

    // ---- the Barrett reducer ----------------------------------------------
    // Shared between GS, which reduces a + b, and the standalone BARRETT op,
    // which reduces a. The reducer is now pipelined internally (2 clocks), and
    // it latches its own input, so nothing here drives its arithmetic directly.
    //
    // bar_in_r stays because it serves a second purpose: it keeps the operand
    // select, which fans out across the whole datapath, off the reducer's front
    // end. Post-layout that net was carrying 4.18 ns of hold repair delay
    // before any arithmetic ran, and the reduction was paying for it.
    //
    // Barrett finishes in 3 clocks against the multiplier's 5, so its result is
    // held until the outputs are read. Holding is free: bar_r stops updating
    // once its valid pulse has passed.
    wire signed [15:0] bar_out;
    wire               bar_done;

    reg signed [15:0] bar_in_r;
    reg               bar_in_v;
    reg signed [15:0] bar_r;

    always @(posedge clk) begin
        if (rst) begin
            bar_in_r <= 16'sd0;
            bar_in_v <= 1'b0;
        end else begin
            if (in_valid) bar_in_r <= op_gs ? sum : a;
            bar_in_v <= in_valid;
        end
    end

    barrett_reduce u_barrett (
        .clk       (clk),
        .rst       (rst),
        .in_valid  (bar_in_v),
        .a         (bar_in_r),
        .c         (bar_out),
        .out_valid (bar_done)
    );

    always @(posedge clk) begin
        if (rst)           bar_r <= 16'sd0;
        else if (bar_done) bar_r <= bar_out;
    end

    // ---- output selection, from registered sources -------------------------
    // Everything feeding these muxes is either a register (t, bar_r) or one
    // adder away from the operand registers (sum, a +/- t), so the last stage
    // is shallow.
    wire use_bar = op_gs | op_bar;

    assign a_out = op_ct   ? a + t :
                   use_bar ? bar_r :
                   op_add  ? sum   :
                             t;      // FQMUL, ZMUL

    assign b_out = op_ct  ? a - t :
                   op_add ? a - b :
                   op_gs  ? t     :
                            a_out;   // FQMUL, ZMUL, BARRETT mirror

endmodule

`default_nettype wire
