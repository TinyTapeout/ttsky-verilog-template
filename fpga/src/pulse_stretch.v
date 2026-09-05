// pulse_stretch -- holds a brief input pulse (or even a level) high for a
// fixed, human-visible duration on the output.
//
// demo_top's actual run takes on the order of ~16000 cycles -- at 100 MHz
// that's ~160 microseconds, far too fast for an LED to visibly register as
// anything but a very faint flicker. Every time `in_level` is asserted, this
// module (re-)arms a down-counter and holds `out_stretched` high until it
// expires, giving a physical LED a clearly visible flash (default
// STRETCH_CYCLES = 25,000,000 = 0.25s @ 100MHz) regardless of how brief the
// underlying event actually was.
module pulse_stretch #(
    parameter integer STRETCH_CYCLES = 25_000_000   // ~0.25s @ 100MHz
) (
    input  wire clk,
    input  wire rst,
    input  wire in_level,
    output reg  out_stretched
);
    localparam integer CW = $clog2(STRETCH_CYCLES + 1);
    reg [CW-1:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            cnt           <= {CW{1'b0}};
            out_stretched <= 1'b0;
        end else if (in_level) begin
            cnt           <= STRETCH_CYCLES[CW-1:0] - 1'b1;
            out_stretched <= 1'b1;
        end else if (cnt != {CW{1'b0}}) begin
            cnt           <= cnt - 1'b1;
            out_stretched <= 1'b1;
        end else begin
            out_stretched <= 1'b0;
        end
    end
endmodule
