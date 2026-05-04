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

    wire [10:0] ax = x[10] ? -x : x;
    wire [10:0] ay = y[10] ? -y : y;

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
    wire signed [11:0] d1 = $signed({1'b0, ax}) - $signed({1'b0, ay[10:1]});
    wire signed [11:0] d2 = $signed({1'b0, ay}) - $signed({1'b0, ax[10:1]});

    wire [11:0] ad0 = d0[11] ? -d0 : d0;
    wire [11:0] ad1 = d1[11] ? -d1 : d1;
    wire [11:0] ad2 = d2[11] ? -d2 : d2;

    wire [10:0] len = LEN[10:0];
    wire [10:0] wid = WIDTH[10:0] + 11'd3;

    wire x_ge_0 = ~x[10];
    wire y_ge_0 = ~y[10];
    wire x_le_0 = x[10] | (x == 11'sd0);
    wire y_le_0 = y[10] | (y == 11'sd0);

    wire q0 = x_ge_0 & y_le_0;
    wire q1 = x_ge_0 & y_ge_0;
    wire q2 = x_le_0 & y_ge_0;
    wire q3 = x_le_0 & y_le_0;

    wire axis_up    = (dir == 4'd0)  & y_le_0 & (ay <= len) & (ax <= wid);
    wire axis_right = (dir == 4'd4)  & x_ge_0 & (ax <= len) & (ay <= wid);
    wire axis_down  = (dir == 4'd8)  & y_ge_0 & (ay <= len) & (ax <= wid);
    wire axis_left  = (dir == 4'd12) & x_le_0 & (ax <= len) & (ay <= wid);

    wire near_v_dir =
        (dir == 4'd1)  |
        (dir == 4'd7)  |
        (dir == 4'd9)  |
        (dir == 4'd15);

    wire diag_dir =
        (dir == 4'd2)  |
        (dir == 4'd6)  |
        (dir == 4'd10) |
        (dir == 4'd14);

    wire near_h_dir =
        (dir == 4'd3)  |
        (dir == 4'd5)  |
        (dir == 4'd11) |
        (dir == 4'd13);

    wire q_ok =
        ((dir >= 4'd1)  & (dir <= 4'd3) ) ? q0 :
        ((dir >= 4'd5)  & (dir <= 4'd7) ) ? q1 :
        ((dir >= 4'd9)  & (dir <= 4'd11)) ? q2 :
        ((dir >= 4'd13) & (dir <= 4'd15)) ? q3 :
                                             1'b0;

    wire near_v_hand = near_v_dir & q_ok & (ay <= len) & (ad1 <= wid);
    wire diag_hand   = diag_dir   & q_ok & (ax <= len) & (ay <= len) & (ad0 <= wid);
    wire near_h_hand = near_h_dir & q_ok & (ax <= len) & (ad2 <= wid);

    assign hand =
        axis_up    |
        axis_right |
        axis_down  |
        axis_left  |
        near_v_hand |
        diag_hand   |
        near_h_hand;

endmodule
