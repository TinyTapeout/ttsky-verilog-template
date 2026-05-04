`timescale 1ns / 1ps

module gamepad_button_pulse (
    input  wire clk,
    input  wire nrst,

    input  wire gp_start,
    input  wire gp_select,
    input  wire gp_up,
    input  wire gp_down,

    output wire [3:0] button
);

    reg d0, d1, d2, d3;

    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            d0 <= 0; d1 <= 0; d2 <= 0; d3 <= 0;
        end else begin
            d0 <= gp_start;
            d1 <= gp_select;
            d2 <= gp_up;
            d3 <= gp_down;
        end
    end

    assign button[0] = gp_start  & ~d0;
    assign button[1] = gp_select & ~d1;
    assign button[2] = gp_up     & ~d2;
    assign button[3] = gp_down   & ~d3;

endmodule
