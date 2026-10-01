// ntt_io.v -- byte-serial front end for the NTT/INTT datapath.
//
// Tiny Tapeout gives 8 data inputs, 8 data outputs and 8 bidirectional pins,
// which is narrower than the operand vector a butterfly needs. The host
// therefore assembles operands by addressed byte writes, pulses start, waits
// for busy to fall, and shifts the 32-bit result back out a byte at a time.
//
//   writing:  put a byte on in_byte, its register number on waddr, raise we
//
//     addr 0  a[7:0]        addr 4  k    = { 1'b0, twiddle index[6:0] }
//     addr 1  a[15:8]       addr 5  ctrl = { 4'b0, zneg, op[2:0] }
//     addr 2  b[7:0]        addr 6  reserved
//     addr 3  b[15:8]       addr 7  reserved
//
//   executing: a rising edge on start launches one operation. busy stays high
//              until the last result byte has been presented. The operand
//              registers must not be written while busy, since the datapath
//              reads them directly for the whole operation.
//
//   reading:  four bytes come back on out_byte, each qualified by out_valid,
//             low byte first:  a_out[7:0], a_out[15:8], b_out[7:0], b_out[15:8]
//
// Values are signed 16-bit and centred, which is what having both reductions on
// chip requires: Montgomery returns a centred representative with |t| < q, and
// Barrett returns one in (-q/2, q/2]. A host reading these back must interpret
// the two bytes as two's complement.
//
// ---------------------------------------------------------------------------
// The twiddle is an index, not a value
// ---------------------------------------------------------------------------
// Register 4 holds k, and the 128-entry table is on chip in twiddle_rom, in
// Montgomery form. The host does not hold the twiddles: it walks the index the
// FIPS 203 transforms already define -- up from 1 for the forward NTT, down
// from 127 for the inverse -- and writes one byte per block rather than a
// 16-bit constant it had to look up itself.
//
// zneg selects -z instead of z. basemul multiplies modulo x^2 - zeta with the
// signed pair +/-zetas[64+i], and the negative half is a sign flip on an entry
// already in the table, not a separate one. One 16-bit negate is far cheaper
// than 128 more ROM words.
//
// Registers persist between operations, so a host walking one NTT block only
// rewrites the bytes that actually changed -- usually just the four operand
// bytes, since k and ctrl are constant across a whole block.
//
// ---------------------------------------------------------------------------
// One latency for every operation
// ---------------------------------------------------------------------------
// All six ops take exactly five clocks, which is fqmul's latency. An earlier
// revision let BARRETT and ADD answer immediately, since neither needs the
// multiplier -- but that put the whole Barrett reduction inside a single-cycle
// path running from the op register into the result register, and post-layout
// timing rejected it by 1.51 ns at the slow corner. Barrett is pipelined now
// and finishes in three, so its result is held until the outputs are read, and
// the special case here disappeared with it.
//
// The host still polls busy rather than counting clocks. That costs nothing and
// keeps the protocol honest if a future revision reintroduces a second
// latency.

`default_nettype none

module ntt_io (
    input  wire               clk,
    input  wire               rst,          // synchronous, active high

    input  wire        [7:0]  in_byte,      // write data
    input  wire        [2:0]  waddr,        // register select
    input  wire               we,           // write strobe
    input  wire               start,        // rising edge launches one operation

    output reg         [7:0]  out_byte,     // result byte
    output reg                out_valid,    // out_byte is live this clock
    output wire               busy,         // in flight, or result unloading

    // to the twiddle ROM
    output wire        [6:0]  k_idx,
    input  wire signed [11:0] rom_zeta,

    // to the datapath
    output wire        [2:0]  op,
    output wire               issue,
    output wire signed [15:0] a,
    output wire signed [15:0] b,
    output wire signed [15:0] zeta,
    input  wire signed [15:0] a_out,
    input  wire signed [15:0] b_out,
    input  wire               mul_done
);

    // ---- operand registers -------------------------------------------------
    reg signed [15:0] a_reg, b_reg;
    reg        [6:0]  k_reg;
    reg        [2:0]  op_reg;
    reg               zneg_reg;

    always @(posedge clk) begin
        if (rst) begin
            a_reg    <= 16'sd0;
            b_reg    <= 16'sd0;
            k_reg    <= 7'd0;
            op_reg   <= 3'd0;
            zneg_reg <= 1'b0;
        end else if (we) begin
            case (waddr)
                3'd0: a_reg[7:0]  <= in_byte;
                3'd1: a_reg[15:8] <= in_byte;
                3'd2: b_reg[7:0]  <= in_byte;
                3'd3: b_reg[15:8] <= in_byte;
                3'd4: k_reg       <= in_byte[6:0];
                3'd5: begin
                    op_reg   <= in_byte[2:0];
                    zneg_reg <= in_byte[3];
                end
                default: ;          // addrs 6 and 7 reserved
            endcase
        end
    end

    assign a     = a_reg;
    assign b     = b_reg;
    assign op    = op_reg;
    assign k_idx = k_reg;

    // Sign-extend the 12-bit table entry, then negate it if asked. Every entry
    // satisfies |zeta| <= 1659, so the negation cannot overflow 16 bits.
    wire signed [15:0] zeta_ext = {{4{rom_zeta[11]}}, rom_zeta};
    assign zeta = zneg_reg ? -zeta_ext : zeta_ext;

    // ---- launch on the rising edge of start --------------------------------
    // Gated on in_flight, which is a register, rather than on busy -- busy is
    // partly combinational and includes launch itself, so testing it here
    // would close a combinational loop through the enable of the very signal
    // being computed.
    reg start_d;
    reg in_flight;
    wire launch = start & ~start_d & ~in_flight;

    always @(posedge clk) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end

    // Every op goes through the datapath, so issue is simply the launch.
    assign issue = launch;

    // ---- waiting for the datapath ------------------------------------------
    always @(posedge clk) begin
        if (rst)           in_flight <= 1'b0;
        else if (issue)    in_flight <= 1'b1;
        else if (mul_done) in_flight <= 1'b0;
    end

    wire result_now = in_flight & mul_done;

    // ---- unload the 32-bit result, low byte first --------------------------
    // The first byte goes straight out of the datapath, so the shift register
    // only has to hold the other three.
    reg [23:0] res;
    reg [1:0]  out_rem;

    always @(posedge clk) begin
        if (rst) begin
            res       <= 24'd0;
            out_byte  <= 8'd0;
            out_valid <= 1'b0;
            out_rem   <= 2'd0;
        end else if (result_now) begin
            res       <= {b_out, a_out[15:8]};
            out_byte  <= a_out[7:0];
            out_valid <= 1'b1;
            out_rem   <= 2'd3;
        end else if (out_rem != 2'd0) begin
            res       <= {8'h00, res[23:8]};
            out_byte  <= res[7:0];
            out_valid <= 1'b1;
            out_rem   <= out_rem - 2'd1;
        end else begin
            out_valid <= 1'b0;
        end
    end

    // High from launch until the last result byte has been presented, so the
    // host polls rather than counting clocks.
    assign busy = launch | in_flight | (out_rem != 2'd0) | out_valid;

endmodule

`default_nettype wire
