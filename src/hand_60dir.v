`timescale 1ns / 1ps

module hand_60dir #(
    parameter LEN   = 100,
    parameter WIDTH = 3
)(
    input  wire signed [10:0] x,
    input  wire signed [10:0] y,
    input  wire [5:0]         pos,
    output wire               hand
);

    wire signed [10:0] ax = x[10] ? -x : x;
    wire signed [10:0] ay = y[10] ? -y : y;

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

    wire signed [11:0] d0 = $signed({1'b0, ax}) - $signed({1'b0, ay});
    wire signed [11:0] d1 = $signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)});
    wire signed [11:0] d2 = $signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)});

    wire [11:0] ad0 = d0[11] ? -d0 : d0;
    wire [11:0] ad1 = d1[11] ? -d1 : d1;
    wire [11:0] ad2 = d2[11] ? -d2 : d2;

    wire [10:0] len = LEN[10:0];
    wire [10:0] wid = WIDTH[10:0] + 11'd3;

    reg hand_r;

    always @(*) begin
        case (dir)
            4'd0:  hand_r = (y <= 0) && (ay <= len) && (ax <= wid);
            4'd1:  hand_r = (x >= 0) && (y <= 0) && (ay <= len) && (ad1 <= wid);
            4'd2:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            4'd3:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ad2 <= wid);
            4'd4:  hand_r = (x >= 0) && (ax <= len) && (ay <= wid);
            4'd5:  hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ad2 <= wid);
            4'd6:  hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            4'd7:  hand_r = (x >= 0) && (y >= 0) && (ay <= len) && (ad1 <= wid);
            4'd8:  hand_r = (y >= 0) && (ay <= len) && (ax <= wid);
            4'd9:  hand_r = (x <= 0) && (y >= 0) && (ay <= len) && (ad1 <= wid);
            4'd10: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            4'd11: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ad2 <= wid);
            4'd12: hand_r = (x <= 0) && (ax <= len) && (ay <= wid);
            4'd13: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ad2 <= wid);
            4'd14: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            4'd15: hand_r = (x <= 0) && (y <= 0) && (ay <= len) && (ad1 <= wid);
            default: hand_r = 1'b0;
        endcase
    end

    assign hand = hand_r;

endmodule
