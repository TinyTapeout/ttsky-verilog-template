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

    wire signed [10:0] ax = (x < 0) ? -x : x;
    wire signed [10:0] ay = (y < 0) ? -y : y;

    // 진짜 원형에 가까운 원: x^2 + y^2
    wire [21:0] x2 = ax * ax;
    wire [21:0] y2 = ay * ay;
    wire [22:0] r2 = x2 + y2;

    wire face_ring  = (r2 > 23'd21025) && (r2 < 23'd23409); // 145^2 ~ 153^2
    wire center_dot = (r2 < 23'd36);

    // 12/3/6/9 눈금
    wire mark12 = (ax < 5) && (y < -130) && (y > -155);
    wire mark06 = (ax < 5) && (y >  130) && (y <  155);
    wire mark03 = (ay < 5) && (x >  130) && (x <  155);
    wire mark09 = (ay < 5) && (x < -130) && (x > -155);

    wire major_mark = mark12 | mark03 | mark06 | mark09;

    // 60단계
    wire [5:0] sec_pos = sec;
    wire [5:0] min_pos = min;

    wire [5:0] hour12 = (hour >= 12) ? (hour - 12) : hour;
    wire [6:0] hour_pos_tmp = hour12 * 5 + (min / 12);
    wire [5:0] hour_pos = hour_pos_tmp[5:0];

    wire sec_hand;
    wire min_hand;
    wire hour_hand;

    hand_60dir #(.LEN(120), .WIDTH(2)) U_SEC (
        .x(x),
        .y(y),
        .pos(sec_pos),
        .hand(sec_hand)
    );

    hand_60dir #(.LEN(100), .WIDTH(4)) U_MIN (
        .x(x),
        .y(y),
        .pos(min_pos),
        .hand(min_hand)
    );

    hand_60dir #(.LEN(70), .WIDTH(6)) U_HOUR (
        .x(x),
        .y(y),
        .pos(hour_pos),
        .hand(hour_hand)
    );

    always @(*) begin
        if (!display_on) begin
            rgb = 6'b000000;
        end
        else if (sec_hand) begin
            rgb = 6'b110000;
        end
        else if (min_hand) begin
            rgb = 6'b111111;
        end
        else if (hour_hand) begin
            rgb = 6'b001111;
        end
        else if (center_dot) begin
            rgb = 6'b111111;
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

endmodule
