`timescale 1ns / 1ps

module vga_clock_draw (
    input  wire [9:0] hpos,
    input  wire [9:0] vpos,
    input  wire       display_on,

    input  wire [5:0] sec,
    input  wire [5:0] min,
    input  wire [5:0] hour,

    input  wire       ctl_mode,
    input  wire [1:0] ctl_time,

    output reg  [5:0] rgb
);

    wire signed [10:0] x = $signed({1'b0, hpos}) - 11'sd320;
    wire signed [10:0] y = $signed({1'b0, vpos}) - 11'sd240;

    wire signed [10:0] ax = x[10] ? -x : x;
    wire signed [10:0] ay = y[10] ? -y : y;

    wire ring_a = ((ay <= 11'd122) && (ay >= 11'd118) && (ax <= 11'd28)) ||
                  ((ay <= 11'd118) && (ay >= 11'd110) && (ax >= 11'd28) && (ax <= 11'd58)) ||
                  ((ay <= 11'd108) && (ay >= 11'd96 ) && (ax >= 11'd58) && (ax <= 11'd84)) ||
                  ((ay <= 11'd94 ) && (ay >= 11'd76 ) && (ax >= 11'd84) && (ax <= 11'd100)) ||
                  ((ay <= 11'd76 ) && (ay >= 11'd58 ) && (ax >= 11'd100) && (ax <= 11'd112)) ||
                  ((ay <= 11'd58 ) && (ay >= 11'd28 ) && (ax >= 11'd112) && (ax <= 11'd118)) ||
                  ((ax <= 11'd122) && (ax >= 11'd118) && (ay <= 11'd28));

    wire face_ring = ring_a;

    wire center_dot = (ax <= 11'd3) && (ay <= 11'd3);

    wire mark12 = (ax <= 11'd3) && (y <= -11'sd105) && (y >= -11'sd120);
    wire mark06 = (ax <= 11'd3) && (y >=  11'sd105) && (y <=  11'sd120);
    wire mark03 = (ay <= 11'd3) && (x >=  11'sd105) && (x <=  11'sd120);
    wire mark09 = (ay <= 11'd3) && (x <= -11'sd105) && (x >= -11'sd120);

    wire major_mark = mark12 | mark03 | mark06 | mark09;

    wire [5:0] sec_pos = sec;
    wire [5:0] min_pos = min;

    wire [3:0] hour12 = (hour >= 6'd12) ? (hour - 6'd12) : hour;
    wire [5:0] hour_pos = {hour12, 2'b00} + hour12 +
                           ((min >= 6'd36) ? 6'd3 :
                            (min >= 6'd24) ? 6'd2 :
                            (min >= 6'd12) ? 6'd1 : 6'd0);

    wire sec_hand;
    wire min_hand;
    wire hour_hand;

    hand_60dir #(.LEN(95), .WIDTH(1)) U_SEC (
        .x(x),
        .y(y),
        .pos(sec_pos),
        .hand(sec_hand)
    );

    hand_60dir #(.LEN(75), .WIDTH(2)) U_MIN (
        .x(x),
        .y(y),
        .pos(min_pos),
        .hand(min_hand)
    );

    hand_60dir #(.LEN(50), .WIDTH(3)) U_HOUR (
        .x(x),
        .y(y),
        .pos(hour_pos),
        .hand(hour_hand)
    );

    always @(*) begin
        if (!display_on) begin
            rgb = 6'b000000;
        end
        else if (center_dot) begin
            rgb = 6'b111111;
        end
        else if (sec_hand) begin
            rgb = 6'b111111;
        end
        else if (min_hand) begin
            rgb = 6'b111100;
        end
        else if (hour_hand) begin
            rgb = 6'b001111;
        end
        else if (major_mark) begin
            rgb = 6'b111100;
        end
        else if (face_ring) begin
            rgb = 6'b001100;
        end
        else if (ctl_mode) begin
            rgb = 6'b000010;
        end
        else begin
            rgb = 6'b000000;
        end
    end

    wire _unused = &{ctl_time, 1'b0};

endmodule
