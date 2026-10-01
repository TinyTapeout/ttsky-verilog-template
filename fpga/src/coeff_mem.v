// Coeff memory stores 256 coefficients of the polynomial being transformed.
//
// 256 coefficients, 12 bits wide (one ML-KEM polynomial, degree n=256).
//
// Two independent read/write ports (A and B), used one pair per butterfly:
//   1. read two coeffs: f[j] and f[j+len] at the addresses from the
//      controller FSM -- these become the butterfly's a and b.
//   2. write two coeffs back: a_out to address j, b_out to address j+len,
//      after the butterfly computes -- same-address read-then-write
//      (in-place Cooley-Tukey), so the FSM must hold addr_a/addr_b stable
//      across the read -> butterfly -> write cycle.
//
// Port A doubles as the single-coefficient load/dump path used by the
// Phase 3 demo controller (drive addr_a + din_a with we_a=1 to load one
// coefficient, or just read dout_a to check one out) -- port B is simply
// left unused (addr_b/din_b/we_b don't-care) for those single accesses.
//
//                    ┌──────────────────┐
//   addr_a (from FSM)│                  │ dout_a ──► butterfly.a / demo readback
//   addr_b (from FSM)│  coeff memory    │ dout_b ──► butterfly.b
//                    │   256 × 12       │
//   din_a  (a_out /  │                  │
//           load data)                  │
//   din_b  (b_out) ─►│                  │
//   we_a, we_b ──────►                  │
//   rst (sync, active-high, blocks      │
//        writes -- does NOT clear mem)  │
//                    └──────────────────┘

module coeff_mem (
    input  wire        clk,
    input  wire        rst,      // sync, active-high: while high, writes are blocked
    input  wire [7:0]  addr_a,   // = j            (256 entries -> 8-bit address)
    input  wire [7:0]  addr_b,   // = j + len
    input  wire        we_a,     // write enable, port A
    input  wire        we_b,     // write enable, port B
    input  wire [11:0] din_a,    // data in, port A  (butterfly.a_out, or load data)
    input  wire [11:0] din_b,    // data in, port B  (butterfly.b_out)
    output wire [11:0] dout_a,   // data out, port A --> butterfly.a / demo readback
    output wire [11:0] dout_b    // data out, port B --> butterfly.b
);

    // ram_style=block: a 256x12 true dual-port array is small enough that
    // Vivado's default heuristic can still choose distributed RAM/register
    // + mux-tree implementations (LUT6/MUXF7/MUXF8 chains) over a dedicated
    // RAMB18 hard macro. The real U55C build's last remaining violation
    // (WNS -0.006ns, 11 failing endpoints) routed straight through such a
    // mux tree into this array -- forcing block RAM replaces it with a
    // compact, purpose-built primitive with its own fast dedicated routing.
    //
    // Registered reads (1-cycle latency: dout_a/dout_b reflect addr_a/addr_b
    // as they were the PREVIOUS cycle) are required for BRAM inference at
    // all -- BRAM read ports are inherently synchronous, so the original
    // combinational (`assign dout_a = mem[addr_a]`) version could never map
    // to one. Every caller (control_fsm.v/intt_control_fsm.v via their
    // LATENCY-cycle stall windows, demo_top.v's S_COMPARE) already holds
    // addr_a/addr_b stable for multiple cycles per access, so this extra
    // 1-cycle latency is absorbed by bumping those stall/pipeline
    // constants, not by adding new hazard-handling logic here.
    //
    // Write and read for EACH port are combined into a single always block
    // (one block per port) -- this is Vivado's canonical true-dual-port
    // template (UG901); splitting the read into its own always block (as an
    // earlier version of this file did) left Vivado unable to match the
    // BRAM template at all, silently falling back to discrete registers +
    // wide select-muxes instead (worse than even distributed RAM).
    (* ram_style = "block" *) reg [11:0] mem [0:255];
    reg [11:0] dout_a_r, dout_b_r;
    assign dout_a = dout_a_r;
    assign dout_b = dout_b_r;

    always @(posedge clk) begin
        if (!rst && we_a) mem[addr_a] <= din_a;
        dout_a_r <= mem[addr_a];
    end

    always @(posedge clk) begin
        if (!rst && we_b) mem[addr_b] <= din_b;
        dout_b_r <= mem[addr_b];
    end

endmodule
