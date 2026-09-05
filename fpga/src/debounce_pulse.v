// debounce_pulse -- turns a raw, mechanically-bouncy pushbutton input into a
// single clean one-cycle pulse per physical press.
//
// Standard 3-stage approach:
//   1. Two-flip-flop synchronizer (btn_sync0/1) -- the raw input crosses from
//      an async physical switch into this clock domain, so it must be
//      synchronized before any logic looks at it, to avoid metastability.
//   2. Stability counter -- the synchronized signal must hold the SAME value
//      for STABLE_CYCLES consecutive cycles before it's accepted as the new
//      debounced level (btn_stable). A mechanical button can bounce for
//      several milliseconds; at the default 1,000,000 cycles @ 100 MHz
//      (10 ms) this comfortably outlasts any realistic bounce.
//   3. Edge detect on the debounced level -- `pulse` is high for exactly one
//      cycle when btn_stable transitions 0->1, giving demo_top.v's start_i
//      exactly the single-cycle pulse it expects, regardless of how long the
//      physical button is actually held down.
module debounce_pulse #(
    parameter integer STABLE_CYCLES = 1_000_000   // ~10ms @ 100MHz
) (
    input  wire clk,
    input  wire rst,       // sync, active-high
    input  wire btn_raw,
    output reg  pulse
);
    localparam integer CW = $clog2(STABLE_CYCLES + 1);

    // btn_stable MUST have a defined reset value: the update condition below
    // is `btn_sync1 != btn_stable`, and in simulation an uninitialized reg
    // reads as X -- since Verilog treats an X condition as false, `!= X` is
    // itself X, which always takes the else branch, so cnt could never
    // start counting and btn_stable would stay X forever (confirmed
    // empirically: without this reset, the module deadlocks permanently in
    // simulation). Real FPGA flip-flops do power up to a known INIT value
    // (Vivado defaults this to 0), so this wasn't a hazard on real
    // hardware, but it's not something to rely on implicitly.
    reg btn_sync0, btn_sync1;
    reg [CW-1:0] cnt;
    reg          btn_stable, btn_stable_d;

    always @(posedge clk) begin
        if (rst) begin
            btn_sync0 <= 1'b0;
            btn_sync1 <= 1'b0;
        end else begin
            btn_sync0 <= btn_raw;
            btn_sync1 <= btn_sync0;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            cnt        <= {CW{1'b0}};
            btn_stable <= 1'b0;
        end else if (btn_sync1 != btn_stable) begin
            if (cnt == STABLE_CYCLES - 1) begin
                btn_stable <= btn_sync1;
                cnt        <= {CW{1'b0}};
            end else begin
                cnt <= cnt + 1'b1;
            end
        end else begin
            cnt <= {CW{1'b0}};
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            btn_stable_d <= 1'b0;
            pulse        <= 1'b0;
        end else begin
            btn_stable_d <= btn_stable;
            pulse        <= btn_stable && !btn_stable_d;
        end
    end
endmodule
