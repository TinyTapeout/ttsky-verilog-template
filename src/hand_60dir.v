`timescale 1ns / 1ps

module hand_60dir3 (
    input  wire signed [10:0] x,
    input  wire signed [10:0] y,
    input  wire        [10:0] ax,
    input  wire        [10:0] ay,
    input  wire [5:0]         sec_pos,
    input  wire [5:0]         min_pos,
    input  wire [5:0]         hour_pos,
    output wire               sec_hand,
    output wire               min_hand,
    output wire               hour_hand
);

    // ax, ay는 상위 모듈(vga_clock_draw)에서 전달받음

    // 45도 대각선 판별용 (d1, d2 및 ad1, ad2 제거됨)
    wire signed [11:0] d0  = $signed({1'b0, ax}) - $signed({1'b0, ay});
    wire        [11:0] ad0 = d0[11] ? -d0 : d0;

    wire x_ge_0 = ~x[10];
    wire y_ge_0 = ~y[10];
    wire x_le_0 = x[10] | (x == 11'sd0);
    wire y_le_0 = y[10] | (y == 11'sd0);

    wire q0 = x_ge_0 & y_le_0;  // 12시~3시 사분면
    wire q1 = x_ge_0 & y_ge_0;  //  3시~6시 사분면
    wire q2 = x_le_0 & y_ge_0;  //  6시~9시 사분면
    wire q3 = x_le_0 & y_le_0;  //  9시~12시 사분면

    // pos(0~59) → 8방향(0~7, 45도 단위)
    function [2:0] to_dir8;
        input [5:0] pos;
        begin
            if      (pos < 6'd8 ) to_dir8 = 3'd0;  //   0도 (12시)
            else if (pos < 6'd15) to_dir8 = 3'd1;  //  45도
            else if (pos < 6'd23) to_dir8 = 3'd2;  //  90도 (3시)
            else if (pos < 6'd30) to_dir8 = 3'd3;  // 135도
            else if (pos < 6'd38) to_dir8 = 3'd4;  // 180도 (6시)
            else if (pos < 6'd45) to_dir8 = 3'd5;  // 225도
            else if (pos < 6'd53) to_dir8 = 3'd6;  // 270도 (9시)
            else                  to_dir8 = 3'd7;  // 315도
        end
    endfunction

    wire [2:0] sec_dir  = to_dir8(sec_pos);
    wire [2:0] min_dir  = to_dir8(min_pos);
    wire [2:0] hour_dir = to_dir8(hour_pos);

    // 8방향 픽셀 판별
    // 축 방향(0,2,4,6): 좁은 직사각형
    // 대각선 방향(1,3,5,7): 사분면 내 ax≈ay (ad0<=wid)
    function hand_calc8;
        input [2:0]  dir;
        input [10:0] len;
        input [10:0] wid;
        begin
            case (dir)
                3'd0: hand_calc8 = y_le_0 & (ay <= len) & (ax <= wid);               // 12시
                3'd1: hand_calc8 = q0     & (ax <= len) & (ay <= len) & (ad0 <= wid); //  45도
                3'd2: hand_calc8 = x_ge_0 & (ax <= len) & (ay <= wid);               //  3시
                3'd3: hand_calc8 = q1     & (ax <= len) & (ay <= len) & (ad0 <= wid); // 135도
                3'd4: hand_calc8 = y_ge_0 & (ay <= len) & (ax <= wid);               //  6시
                3'd5: hand_calc8 = q2     & (ax <= len) & (ay <= len) & (ad0 <= wid); // 225도
                3'd6: hand_calc8 = x_le_0 & (ax <= len) & (ay <= wid);               //  9시
                3'd7: hand_calc8 = q3     & (ax <= len) & (ay <= len) & (ad0 <= wid); // 315도
            endcase
        end
    endfunction

    assign sec_hand  = hand_calc8(sec_dir,  11'd95, 11'd4);
    assign min_hand  = hand_calc8(min_dir,  11'd75, 11'd5);
    assign hour_hand = hand_calc8(hour_dir, 11'd50, 11'd6);

endmodule
