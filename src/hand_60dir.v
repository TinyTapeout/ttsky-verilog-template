`timescale 1ns / 1ps

module hand_60dir3 (
    input  wire signed [10:0] x,
    input  wire signed [10:0] y,
    input  wire [5:0]         sec_pos,
    input  wire [5:0]         min_pos,
    input  wire [5:0]         hour_pos,
    output wire               sec_hand,
    output wire               min_hand,
    output wire               hour_hand
);

    wire [10:0] ax = x[10] ? -x : x;
    wire [10:0] ay = y[10] ? -y : y;

    wire signed [11:0] d0 = $signed({1'b0, ax}) - $signed({1'b0, ay});
    wire signed [11:0] d1 = $signed({1'b0, ax}) - $signed({1'b0, ay[10:1]});
    wire signed [11:0] d2 = $signed({1'b0, ay}) - $signed({1'b0, ax[10:1]});

    wire [11:0] ad0 = d0[11] ? -d0 : d0;
    wire [11:0] ad1 = d1[11] ? -d1 : d1;
    wire [11:0] ad2 = d2[11] ? -d2 : d2;

    wire x_ge_0 = ~x[10];
    wire y_ge_0 = ~y[10];
    wire x_le_0 = x[10] | (x == 11'sd0);
    wire y_le_0 = y[10] | (y == 11'sd0);

    wire q0 = x_ge_0 & y_le_0;
    wire q1 = x_ge_0 & y_ge_0;
    wire q2 = x_le_0 & y_ge_0;
    wire q3 = x_le_0 & y_le_0;

    function [3:0] dir60;
        input [5:0] pos;
        begin
            if      ((pos <= 6'd1) || (pos >= 6'd58)) dir60 = 4'd0;
            else if (pos <= 6'd5)  dir60 = 4'd1;
            else if (pos <= 6'd9)  dir60 = 4'd2;
            else if (pos <= 6'd13) dir60 = 4'd3;
            else if (pos <= 6'd16) dir60 = 4'd4;
            else if (pos <= 6'd20) dir60 = 4'd5;
            else if (pos <= 6'd24) dir60 = 4'd6;
            else if (pos <= 6'd28) dir60 = 4'd7;
            else if (pos <= 6'd31) dir60 = 4'd8;
            else if (pos <= 6'd35) dir60 = 4'd9;
            else if (pos <= 6'd39) dir60 = 4'd10;
            else if (pos <= 6'd43) dir60 = 4'd11;
            else if (pos <= 6'd46) dir60 = 4'd12;
            else if (pos <= 6'd50) dir60 = 4'd13;
            else if (pos <= 6'd54) dir60 = 4'd14;
            else                   dir60 = 4'd15;
        end
    endfunction

    function hand_calc;
        input [3:0]  dir;
        input [10:0] len;
        input [10:0] wid;
        reg q_ok;
        begin
            q_ok =
                ((dir >= 4'd1)  & (dir <= 4'd3) ) ? q0 :
                ((dir >= 4'd5)  & (dir <= 4'd7) ) ? q1 :
                ((dir >= 4'd9)  & (dir <= 4'd11)) ? q2 :
                ((dir >= 4'd13) & (dir <= 4'd15)) ? q3 :
                                                     1'b0;

            case (dir)
                4'd0:  hand_calc = y_le_0 & (ay <= len) & (ax <= wid);
                4'd4:  hand_calc = x_ge_0 & (ax <= len) & (ay <= wid);
                4'd8:  hand_calc = y_ge_0 & (ay <= len) & (ax <= wid);
                4'd12: hand_calc = x_le_0 & (ax <= len) & (ay <= wid);

                4'd1,
                4'd7,
                4'd9,
                4'd15: hand_calc = q_ok & (ay <= len) & (ad1 <= wid);

                4'd2,
                4'd6,
                4'd10,
                4'd14: hand_calc = q_ok & (ax <= len) & (ay <= len) & (ad0 <= wid);

                4'd3,
                4'd5,
                4'd11,
                4'd13: hand_calc = q_ok & (ax <= len) & (ad2 <= wid);

                default: hand_calc = 1'b0;
            endcase
        end
    endfunction

    wire [3:0] sec_dir  = dir60(sec_pos);
    wire [3:0] min_dir  = dir60(min_pos);
    wire [3:0] hour_dir = dir60(hour_pos);

    assign sec_hand  = hand_calc(sec_dir,  11'd95, 11'd4);
    assign min_hand  = hand_calc(min_dir,  11'd75, 11'd5);
    assign hour_hand = hand_calc(hour_dir, 11'd50, 11'd6);

endmodule
