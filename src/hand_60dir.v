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

    reg [4:0] dir;

    always @(*) begin
        if      ((pos <= 6'd0)  || (pos >= 6'd59)) dir = 5'd0;
        else if (pos <= 6'd2)   dir = 5'd1;
        else if (pos <= 6'd4)   dir = 5'd2;
        else if (pos <= 6'd6)   dir = 5'd3;
        else if (pos <= 6'd8)   dir = 5'd4;
        else if (pos <= 6'd10)  dir = 5'd5;
        else if (pos <= 6'd12)  dir = 5'd6;
        else if (pos <= 6'd14)  dir = 5'd7;
        else if (pos <= 6'd16)  dir = 5'd8;
        else if (pos <= 6'd18)  dir = 5'd9;
        else if (pos <= 6'd20)  dir = 5'd10;
        else if (pos <= 6'd22)  dir = 5'd11;
        else if (pos <= 6'd24)  dir = 5'd12;
        else if (pos <= 6'd26)  dir = 5'd13;
        else if (pos <= 6'd28)  dir = 5'd14;
        else if (pos <= 6'd30)  dir = 5'd15;
        else if (pos <= 6'd32)  dir = 5'd16;
        else if (pos <= 6'd34)  dir = 5'd17;
        else if (pos <= 6'd36)  dir = 5'd18;
        else if (pos <= 6'd38)  dir = 5'd19;
        else if (pos <= 6'd40)  dir = 5'd20;
        else if (pos <= 6'd42)  dir = 5'd21;
        else if (pos <= 6'd44)  dir = 5'd22;
        else if (pos <= 6'd46)  dir = 5'd23;
        else if (pos <= 6'd48)  dir = 5'd24;
        else if (pos <= 6'd50)  dir = 5'd25;
        else if (pos <= 6'd52)  dir = 5'd26;
        else if (pos <= 6'd54)  dir = 5'd27;
        else if (pos <= 6'd56)  dir = 5'd28;
        else                    dir = 5'd29;
    end

    wire signed [11:0] d0 = $signed({1'b0, ax}) - $signed({1'b0, ay});
    wire signed [11:0] d1 = $signed({1'b0, ax}) - $signed({1'b0, (ay >> 1)});
    wire signed [11:0] d2 = $signed({1'b0, ay}) - $signed({1'b0, (ax >> 1)});
    wire signed [11:0] d3 = $signed({1'b0, ax}) - $signed({1'b0, (ay >> 2)});
    wire signed [11:0] d4 = $signed({1'b0, ay}) - $signed({1'b0, (ax >> 2)});
    wire signed [11:0] d5 = $signed({1'b0, ax}) - $signed({1'b0, (ay - (ay >> 2))});
    wire signed [11:0] d6 = $signed({1'b0, ay}) - $signed({1'b0, (ax - (ax >> 2))});

    wire [11:0] ad0 = d0[11] ? -d0 : d0;
    wire [11:0] ad1 = d1[11] ? -d1 : d1;
    wire [11:0] ad2 = d2[11] ? -d2 : d2;
    wire [11:0] ad3 = d3[11] ? -d3 : d3;
    wire [11:0] ad4 = d4[11] ? -d4 : d4;
    wire [11:0] ad5 = d5[11] ? -d5 : d5;
    wire [11:0] ad6 = d6[11] ? -d6 : d6;

    wire [10:0] len = LEN[10:0];
    wire [10:0] wid = WIDTH[10:0] + 11'd3;

    reg hand_r;

    always @(*) begin
        case (dir)
            5'd0:  hand_r = (y <= 0) && (ay <= len) && (ax <= wid);
            5'd1:  hand_r = (x >= 0) && (y <= 0) && (ay <= len) && (ad3 <= wid);
            5'd2:  hand_r = (x >= 0) && (y <= 0) && (ay <= len) && (ad1 <= wid);
            5'd3:  hand_r = (x >= 0) && (y <= 0) && (ay <= len) && (ad5 <= wid);
            5'd4:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            5'd5:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ad6 <= wid);
            5'd6:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ad2 <= wid);
            5'd7:  hand_r = (x >= 0) && (y <= 0) && (ax <= len) && (ad4 <= wid);
            5'd8:  hand_r = (x >= 0) && (ax <= len) && (ay <= wid);
            5'd9:  hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ad4 <= wid);
            5'd10: hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ad2 <= wid);
            5'd11: hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ad6 <= wid);
            5'd12: hand_r = (x >= 0) && (y >= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            5'd13: hand_r = (x >= 0) && (y >= 0) && (ay <= len) && (ad5 <= wid);
            5'd14: hand_r = (x >= 0) && (y >= 0) && (ay <= len) && (ad1 <= wid);
            5'd15: hand_r = (y >= 0) && (ay <= len) && (ax <= wid);
            5'd16: hand_r = (x <= 0) && (y >= 0) && (ay <= len) && (ad1 <= wid);
            5'd17: hand_r = (x <= 0) && (y >= 0) && (ay <= len) && (ad5 <= wid);
            5'd18: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            5'd19: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ad6 <= wid);
            5'd20: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ad2 <= wid);
            5'd21: hand_r = (x <= 0) && (y >= 0) && (ax <= len) && (ad4 <= wid);
            5'd22: hand_r = (x <= 0) && (ax <= len) && (ay <= wid);
            5'd23: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ad4 <= wid);
            5'd24: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ad2 <= wid);
            5'd25: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ad6 <= wid);
            5'd26: hand_r = (x <= 0) && (y <= 0) && (ax <= len) && (ay <= len) && (ad0 <= wid);
            5'd27: hand_r = (x <= 0) && (y <= 0) && (ay <= len) && (ad5 <= wid);
            5'd28: hand_r = (x <= 0) && (y <= 0) && (ay <= len) && (ad1 <= wid);
            5'd29: hand_r = (x <= 0) && (y <= 0) && (ay <= len) && (ad3 <= wid);
            default: hand_r = 1'b0;
        endcase
    end

    assign hand = hand_r;

endmodule
