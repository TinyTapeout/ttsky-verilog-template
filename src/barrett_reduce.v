// barrett_reduce.v -- signed Barrett reduction, Theorem 6.2, in two stages.
//
//     v = floor((2^26 + q/2)/q) = 20159
//     t = floor((a*v + 2^25) / 2^26)
//     c = a - t*q
//
// For |a| < 2^15 the theorem gives c congruent to a modulo q and lying in the
// centred range (-q/2, q/2]. v/2^26 approximates 1/q closely enough that t is
// exactly round(a/q), which is what makes the remainder centred rather than
// merely bounded. The 2^25 term turns the floor into a round; without it every
// negative input would come back one q low.
//
// ---------------------------------------------------------------------------
// Why this is pipelined, and why one register was the wrong place to put it
// ---------------------------------------------------------------------------
// Written combinationally this block chains two multiplies, a*v and t*q, for
// roughly 15 ns at the slow corner. That alone would not close at 20 ns once
// buffering is added.
//
// It also has a subtler problem, and it is the one that dominated the first two
// builds. The input a reaches the output twice: the long way, through both
// multiplies, and the short way, straight into the final subtract. A register
// driving that pair drives a 15 ns path and a 1 ns path from the same net. The
// placer cannot satisfy both, so it pads the net to protect hold on the short
// path, and the long path pays for it. Post-layout, 4.18 ns of hold repair
// delay sat on that net before a single gate of arithmetic ran.
//
// Splitting the block in two fixes both. Stage 1 forms the quotient estimate
// and carries a forward in its own register. Stage 2 finishes. Neither stage
// now contains a long path and a short path sharing a source, and each holds
// one multiply rather than two:
//
//     stage 1   t <= (a*v + 2^25) >>> 26      one 16x15, and a rides along
//     stage 2   c <= a_r - t*q                one small constant multiply
//
// Latency is 2 clocks. The caller aligns it against fqmul, which is longer.

`default_nettype none

module barrett_reduce (
    input  wire               clk,
    input  wire               rst,        // synchronous, active high
    input  wire               in_valid,   // a is live this clock
    input  wire signed [15:0] a,          // |a| < 2^15
    output wire signed [15:0] c,          // a mod q, in (-q/2, q/2]
    output wire               out_valid   // 2 clocks after in_valid
);

    localparam signed [15:0] Q = 16'sd3329;
    localparam signed [15:0] V = 16'sd20159;   // floor((2^26 + q/2)/q)

    // ---- stage 1: the quotient estimate -----------------------------------
    // An arithmetic shift, not a part-select. rounded[31:26] would be an
    // UNSIGNED slice: for negative a it would drop the sign and give a large
    // positive t, and the reduction would return nonsense for exactly half the
    // input range. >>> on a signed operand extends the sign instead.
    // t is at most 10 in magnitude for |a| < 2^15, so six bits of two's
    // complement hold it with room to spare. Declaring it 16 bits, which is the
    // obvious thing to write, makes t*q a 16x12 constant multiply in stage 2
    // instead of a 6x12 one and costs three levels of logic for nothing.
    reg signed [5:0]  s1_t;
    reg signed [15:0] s1_a;
    reg               s1_v;

    wire signed [31:0] av      = a * V;                    // |av| < 2^31
    wire signed [31:0] rounded = av + 32'sd33554432;       // + 2^25

    always @(posedge clk) begin
        if (rst) begin
            s1_t <= 6'sd0;
            s1_a <= 16'sd0;
            s1_v <= 1'b0;
        end else begin
            s1_t <= rounded >>> 26;      // t = round(a/q), |t| <= 10
            s1_a <= a;
            s1_v <= in_valid;
        end
    end

    // ---- stage 2: subtract ------------------------------------------------
    // t is at most 10 in magnitude, so t*q is a small constant multiply and
    // this stage is far shorter than the first.
    reg signed [15:0] s2_c;
    reg               s2_v;

    always @(posedge clk) begin
        if (rst) begin
            s2_c <= 16'sd0;
            s2_v <= 1'b0;
        end else begin
            s2_c <= s1_a - s1_t * Q;
            s2_v <= s1_v;
        end
    end

    assign c         = s2_c;
    assign out_valid = s2_v;

endmodule

`default_nettype wire
