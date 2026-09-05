// ============================================================================
//  poly_mul.v  -  Full polynomial multiply in R_q via NTT / basemul / INTT
// ----------------------------------------------------------------------------
//  End-to-end hardware for  c(x) = a(x) * b(x)  in  Z_3329[x]/(x^256 + 1),
//  bit-exact to the C++/Python reference ntt_multiply():
//
//      a_hat = barrett(ntt(a));   b_hat = barrett(ntt(b));
//      c_hat = basemul(a_hat, b_hat);
//      c     = canonicalize(barrett(invntt(c_hat)));
//
//  DESIGN NOTE (why it is built this way): the forward and inverse transforms
//  are kept as INDEPENDENT, separately verifiable modules -- this top only
//  *instantiates and sequences* them.  ntt_engine and intt_engine are untouched
//  and remain reusable on their own (that is deliberate, so the digital design
//  can keep evolving each block in isolation).  This top adds only the glue:
//  the Barrett reduction between NTT and basemul, and the final Barrett +
//  canonicalization on read-back.
//
//      +----------+   +----------+
//   a->| ntt_eng A|-->| barrett  |--\        +---------------+     +----------+
//      +----------+   +----------+   >------>| basemul_engine|---->| intt_eng |--> c
//      +----------+   +----------+   /       +---------------+     +----------+
//   b->| ntt_eng B|-->| barrett  |--/                                    |
//      +----------+   +----------+                              barrett + canon (read)
//
//  Host interface: load a (load_sel=0) and b (load_sel=1), pulse start, wait
//  done, read the 256 canonical result coefficients on rd_addr -> rd_data.
// ============================================================================
`default_nettype none

module poly_mul (
    input  wire               clk,
    input  wire               rst_n,
    // load port: stream operand a (load_sel=0) and operand b (load_sel=1)
    input  wire               load_en,
    input  wire               load_sel,
    input  wire [7:0]         load_addr,
    input  wire signed [15:0] load_data,
    // control / status
    input  wire               start,
    output reg                busy,
    output reg                done,
    // read port: canonical result c in [0, q)
    input  wire [7:0]         rd_addr,
    output wire signed [15:0] rd_data
);
    localparam signed [15:0] Q = 16'sd3329;

    // ---- FSM states --------------------------------------------------------
    localparam S_READY   = 3'd0,  // idle / result ready: accept operand loads
               S_NTT     = 3'd1,  // both forward transforms running
               S_COPY_AB = 3'd2,  // barrett-copy NTT(a),NTT(b) into basemul
               S_BASE    = 3'd3,  // pointwise multiply running
               S_COPY_C  = 3'd4,  // copy basemul result into inverse transform
               S_INTT    = 3'd5;  // inverse transform running
    reg [2:0] state;
    reg [8:0] idx;                // 0..256 copy counter
    reg       n_start, bm_start, i_start;   // one-cycle launch pulses

    // ======================================================================
    //  Sub-block: forward engine A (operand a)
    // ======================================================================
    wire               na_load_en   = (state == S_READY) && load_en && (load_sel == 1'b0);
    wire               na_busy, na_done;
    wire signed [15:0] na_rd_data;
    ntt_engine u_ntt_a (
        .clk(clk), .rst_n(rst_n),
        .load_en(na_load_en), .load_addr(load_addr), .load_data(load_data),
        .start(n_start), .busy(na_busy), .done(na_done),
        .rd_addr(idx[7:0]), .rd_data(na_rd_data)
    );

    // ======================================================================
    //  Sub-block: forward engine B (operand b)
    // ======================================================================
    wire               nb_load_en   = (state == S_READY) && load_en && (load_sel == 1'b1);
    wire               nb_busy, nb_done;
    wire signed [15:0] nb_rd_data;
    ntt_engine u_ntt_b (
        .clk(clk), .rst_n(rst_n),
        .load_en(nb_load_en), .load_addr(load_addr), .load_data(load_data),
        .start(n_start), .busy(nb_busy), .done(nb_done),
        .rd_addr(idx[7:0]), .rd_data(nb_rd_data)
    );

    // ---- Barrett reduction on the forward outputs (the NTT->basemul glue) --
    wire signed [15:0] a_bar, b_bar;
    barrett_reduce u_bar_a (.a(na_rd_data), .r(a_bar));
    barrett_reduce u_bar_b (.a(nb_rd_data), .r(b_bar));

    // ======================================================================
    //  Sub-block: pointwise multiply
    // ======================================================================
    wire               bm_busy, bm_done;
    wire signed [15:0] bm_rd_data;
    basemul_engine u_bm (
        .clk(clk), .rst_n(rst_n),
        .load_a_en((state == S_COPY_AB)), .load_a_addr(idx[7:0]), .load_a_data(a_bar),
        .load_b_en((state == S_COPY_AB)), .load_b_addr(idx[7:0]), .load_b_data(b_bar),
        .start(bm_start), .busy(bm_busy), .done(bm_done),
        .rd_addr(idx[7:0]), .rd_data(bm_rd_data)
    );

    // ======================================================================
    //  Sub-block: inverse engine
    // ======================================================================
    wire               it_busy, it_done;
    wire signed [15:0] it_rd_data;
    intt_engine u_intt (
        .clk(clk), .rst_n(rst_n),
        .load_en((state == S_COPY_C)), .load_addr(idx[7:0]), .load_data(bm_rd_data),
        .start(i_start), .busy(it_busy), .done(it_done),
        .rd_addr(rd_addr), .rd_data(it_rd_data)
    );

    // ---- Final Barrett + canonicalization on read-back ---------------------
    wire signed [15:0] c_bar;
    barrett_reduce u_bar_c (.a(it_rd_data), .r(c_bar));
    assign rd_data = c_bar + ((c_bar >>> 15) & Q);   // -> [0, q)

    // ======================================================================
    //  Orchestration FSM
    // ======================================================================
    always @(posedge clk) begin
        if (!rst_n) begin
            state    <= S_READY;
            busy     <= 1'b0;
            done     <= 1'b0;
            idx      <= 9'd0;
            n_start  <= 1'b0;
            bm_start <= 1'b0;
            i_start  <= 1'b0;
        end else begin
            n_start  <= 1'b0;   // default: pulses are one cycle
            bm_start <= 1'b0;
            i_start  <= 1'b0;

            case (state)
            // ---- ready to load operands / hold last result ----
            S_READY: begin
                if (start) begin
                    done    <= 1'b0;
                    busy    <= 1'b1;
                    n_start <= 1'b1;      // launch both forward transforms
                    state   <= S_NTT;
                end
            end

            // ---- wait for both forward transforms (guard 1st cycle) ----
            S_NTT: begin
                if (!n_start && na_done && nb_done) begin
                    idx   <= 9'd0;
                    state <= S_COPY_AB;
                end
            end

            // ---- barrett-copy 256 coeffs of each operand into basemul ----
            S_COPY_AB: begin
                if (idx == 9'd255) begin
                    bm_start <= 1'b1;
                    state    <= S_BASE;
                end
                idx <= idx + 9'd1;
            end

            // ---- wait for pointwise multiply ----
            S_BASE: begin
                if (!bm_start && bm_done) begin
                    idx   <= 9'd0;
                    state <= S_COPY_C;
                end
            end

            // ---- copy 256 basemul results into the inverse transform ----
            S_COPY_C: begin
                if (idx == 9'd255) begin
                    i_start <= 1'b1;
                    state   <= S_INTT;
                end
                idx <= idx + 9'd1;
            end

            // ---- wait for inverse transform, then publish result ----
            S_INTT: begin
                if (!i_start && it_done) begin
                    busy  <= 1'b0;
                    done  <= 1'b1;
                    state <= S_READY;
                end
            end
            default: state <= S_READY;
            endcase
        end
    end
endmodule

`default_nettype wire
