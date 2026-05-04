`timescale 1ns / 1ps
`default_nettype none

module hand_60dir #(
    parameter LEN   = 100,
    parameter WIDTH = 3
)(
    input  wire signed [10:0] x,
    input  wire signed [10:0] y,
    input  wire [5:0]         pos,
    output wire               hand
);

    localparam [10:0] L    = LEN;
    localparam [10:0] W    = WIDTH + 2;
    localparam [11:0] ERR  = WIDTH + 4;

    wire [10:0] ax;
    wire [10:0] ay;

    assign ax = x[10] ? (~x + 11'd1) : x;
    assign ay = y[10] ? (~y + 11'd1) : y;

    function [11:0] abs12;
        input signed [11:0] v;
        begin
            abs12 = v[11] ? (~v + 12'd1) : v;
        end
    endfunction

    reg [3:0] dir;

    always @(*) begin
        if      ((pos <= 6'd1) || (pos >= 6'd58)) dir = 4'd0;
        else if (pos <= 6'd5)  dir = 4'd1;
        else if (pos <= 6'd9)  dir = 4'd2;
        else if (pos <= 6'd13) dir = 4'd3;
        else if (pos <= 6'd16) dir = 4'd4;
        else if (pos <= 6'd20) dir = 4'd5;
        else if (pos <= 6'd24) dir = 4'd6;
        else if (pos <= 6'd28) dir = 4'd7;
        else if (pos <= 6'd31) dir = 4'd8;
        else if (pos <= 6'd35) dir = 4'd9;
        else if (pos <= 6'd39) dir = 4'd10;
        else if (pos <= 6'd43) dir = 4'd11;
        else if (pos <= 6'd46) dir = 4'd12;
        else if (pos <= 6'd50) dir = 4'd13;
        else if (pos <= 6'd54) dir = 4'd14;
        else                   dir = 4'd15;
    end

    reg hand_r;

    always @(*) begin
        hand_r = 1'b0;

        case (dir)
            // Up
            4'd0: begin
                hand_r = (y <= 0) && (ay <= L) && (ax <= W);
            end

            // Up-right, near up
            4'd1: begin
                hand_r = (x >= 0) && (y <= 0) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)})) <= ERR);
            end

            // Up-right diagonal
            4'd2: begin
                hand_r = (x >= 0) && (y <= 0) && (ax <= L) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, ay})) <= ERR);
            end

            // Right-up, near right
            4'd3: begin
                hand_r = (x >= 0) && (y <= 0) && (ax <= L) &&
                         (abs12($signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)})) <= ERR);
            end

            // Right
            4'd4: begin
                hand_r = (x >= 0) && (ax <= L) && (ay <= W);
            end

            // Right-down, near right
            4'd5: begin
                hand_r = (x >= 0) && (y >= 0) && (ax <= L) &&
                         (abs12($signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)})) <= ERR);
            end

            // Down-right diagonal
            4'd6: begin
                hand_r = (x >= 0) && (y >= 0) && (ax <= L) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, ay})) <= ERR);
            end

            // Down-right, near down
            4'd7: begin
                hand_r = (x >= 0) && (y >= 0) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)})) <= ERR);
            end

            // Down
            4'd8: begin
                hand_r = (y >= 0) && (ay <= L) && (ax <= W);
            end

            // Down-left, near down
            4'd9: begin
                hand_r = (x <= 0) && (y >= 0) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)})) <= ERR);
            end

            // Down-left diagonal
            4'd10: begin
                hand_r = (x <= 0) && (y >= 0) && (ax <= L) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, ay})) <= ERR);
            end

            // Left-down, near left
            4'd11: begin
                hand_r = (x <= 0) && (y >= 0) && (ax <= L) &&
                         (abs12($signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)})) <= ERR);
            end

            // Left
            4'd12: begin
                hand_r = (x <= 0) && (ax <= L) && (ay <= W);
            end

            // Left-up, near left
            4'd13: begin
                hand_r = (x <= 0) && (y <= 0) && (ax <= L) &&
                         (abs12($signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)})) <= ERR);
            end

            // Up-left diagonal
            4'd14: begin
                hand_r = (x <= 0) && (y <= 0) && (ax <= L) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, ay})) <= ERR);
            end

            // Up-left, near up
            4'd15: begin
                hand_r = (x <= 0) && (y <= 0) && (ay <= L) &&
                         (abs12($signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)})) <= ERR);
            end

            default: begin
                hand_r = 1'b0;
            end
        endcase
    end

    assign hand = hand_r;

endmodule

`default_nettype wire
