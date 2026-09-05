// fqmul.v -- fqmul(a,b) = a*b*R^-1 mod q, one multiply into one Montgomery
// reduction, in five pipeline stages.
//
//     p = a*b
//     m = (p mod^+- R) * QINV
//     c = (p - m*q) / R
//
// with R = 2^16 and QINV = q^-1 mod R. Theorem 6.1 gives |c| < q for
// |p| < qR/2, and because m is chosen to cancel p's low 16 bits the division by
// R is exact. That last point is what removes the divider: the subtraction
// cannot borrow out of the low half, so only the two top halves are subtracted
// and no 32-bit subtractor appears anywhere in this module.
//
// ---------------------------------------------------------------------------
// Where the stage boundaries are, and why
// ---------------------------------------------------------------------------
// Three constraints set the cuts, and the first two were learned from
// post-layout timing rather than predicted.
//
// ONE MULTIPLY PER STAGE. Written combinationally the block chains a*b, then
// *QINV, then *q, which is roughly 120 gate levels. Each now sits alone.
//
// NO STAGE MAY CONTAIN A LONG PATH AND A SHORT PATH FROM THE SAME REGISTER.
// An earlier revision let the operand multiplexers feed the 16x16 array
// directly from the caller's control register. That register also drove short
// paths elsewhere, so the placer padded its net to protect hold and the
// multiply paid 4 ns for it before any arithmetic ran. Stage 0 exists purely to
// break that: it latches the operands, so the array starts from registers whose
// only job is to feed it.
//
// THE 16x16 ARRAY IS ITSELF TOO DEEP. Measured at roughly 15 ns at the slow
// corner, it does not fit a 20 ns period once buffering is added. Splitting b
// into halves turns it into two 16x8 multiplies that run in parallel, followed
// by a shift and an add:
//
//     a*b = a*b_hi*256 + a*b_lo
//
// b_hi is the signed top half and b_lo the unsigned low half, which keeps the
// identity exact in two's complement. Each 16x8 is about half the depth of the
// 16x16 it replaces, and the shift costs nothing.
//
//     stage 0   operands latched
//     stage 1   pp_hi <= a*b_hi,  pp_lo <= a*b_lo        two 16x8
//     stage 2   p     <= (pp_hi << 8) + pp_lo            one 32-bit add
//     stage 3   m     <= p_lo * QINV,  p_hi carried      one 16x16 constant
//     stage 4   c     <= p_hi - (m*q)_hi                 one 16x16 constant
//
// Latency is exactly 5 clocks, always. The latency is nearly free here: the
// byte serial pin interface cannot deliver operands anywhere near one per
// clock, so a shorter pipeline would only idle.

`default_nettype none

module fqmul (
    input  wire               clk,
    input  wire               rst,        // synchronous, active high
    input  wire               in_valid,   // a, b are live this clock
    input  wire signed [15:0] a,
    input  wire signed [15:0] b,
    output wire signed [15:0] c,          // a*b*R^-1 mod q, |c| < q
    output wire               out_valid   // 5 clocks after in_valid
);

    localparam signed [15:0] QINV = -16'sd3327;   // q^-1 mod 2^16
    localparam signed [15:0] Q    =  16'sd3329;

    // ---- stage 0: latch the operands ---------------------------------------
    // The array below starts here and nowhere else, so no control net that
    // drives a short path anywhere in the design can slow it down.
    reg signed [15:0] s0_a, s0_b;
    reg               s0_v;

    always @(posedge clk) begin
        if (rst) begin
            s0_a <= 16'sd0;
            s0_b <= 16'sd0;
            s0_v <= 1'b0;
        end else begin
            s0_a <= a;
            s0_b <= b;
            s0_v <= in_valid;
        end
    end

    // ---- stage 1: two half products ---------------------------------------
    // b_hi carries the sign, b_lo does not. Both products are formed against
    // the full 16-bit a.
    wire signed [7:0] b_hi = s0_b[15:8];
    wire       [7:0]  b_lo = s0_b[7:0];

    reg signed [23:0] s1_pp_hi;
    reg signed [23:0] s1_pp_lo;
    reg               s1_v;

    always @(posedge clk) begin
        if (rst) begin
            s1_pp_hi <= 24'sd0;
            s1_pp_lo <= 24'sd0;
            s1_v     <= 1'b0;
        end else begin
            s1_pp_hi <= s0_a * b_hi;                  // signed x signed
            s1_pp_lo <= s0_a * $signed({1'b0, b_lo}); // signed x unsigned
            s1_v     <= s0_v;
        end
    end

    // ---- stage 2: recombine ------------------------------------------------
    reg signed [31:0] s2_p;
    reg               s2_v;

    always @(posedge clk) begin
        if (rst) begin
            s2_p <= 32'sd0;
            s2_v <= 1'b0;
        end else begin
            s2_p <= (s1_pp_hi <<< 8) + s1_pp_lo;
            s2_v <= s1_v;
        end
    end

    // ---- stage 3: the Montgomery factor ------------------------------------
    // Only p's top half survives alongside m: the low half has done its job
    // once m is formed.
    reg signed [15:0] s3_m;
    reg signed [15:0] s3_phi;
    reg               s3_v;

    wire signed [15:0] p_lo   = s2_p[15:0];
    wire signed [31:0] m_full = p_lo * QINV;

    always @(posedge clk) begin
        if (rst) begin
            s3_m   <= 16'sd0;
            s3_phi <= 16'sd0;
            s3_v   <= 1'b0;
        end else begin
            s3_m   <= m_full[15:0];
            s3_phi <= s2_p[31:16];
            s3_v   <= s2_v;
        end
    end

    // ---- stage 4: subtract the top halves ----------------------------------
    reg signed [15:0] s4_c;
    reg               s4_v;

    wire signed [31:0] mq = s3_m * Q;

    always @(posedge clk) begin
        if (rst) begin
            s4_c <= 16'sd0;
            s4_v <= 1'b0;
        end else begin
            s4_c <= s3_phi - mq[31:16];
            s4_v <= s3_v;
        end
    end

    assign c         = s4_c;
    assign out_valid = s4_v;

    // the low halves cancel by construction and are never read
    wire _unused = &{1'b0, m_full[31:16], mq[15:0], 1'b0};

endmodule

`default_nettype wire
