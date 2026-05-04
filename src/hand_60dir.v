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

    // dir60_rom: 비교기 대신 64-entry ROM으로 교체
    // 출력 인코딩: bit[3:2]=사분면(q0~q3), bit[1:0]=계산패턴(axis/ad1/ad0/ad2)
    // → hand_calc에서 비교기 없이 bit-slice만으로 패턴/사분면 선택 가능
    function [3:0] dir60_rom;
        input [5:0] pos;
        reg [3:0] rom [0:63];
        begin
            rom[ 0]=4'b0000; rom[ 1]=4'b0000;                          // pos  0~ 1 : 12시 축
            rom[ 2]=4'b0001; rom[ 3]=4'b0001; rom[ 4]=4'b0001; rom[ 5]=4'b0001; // pos  2~ 5 : q0 ad1
            rom[ 6]=4'b0010; rom[ 7]=4'b0010; rom[ 8]=4'b0010; rom[ 9]=4'b0010; // pos  6~ 9 : q0 ad0
            rom[10]=4'b0011; rom[11]=4'b0011; rom[12]=4'b0011; rom[13]=4'b0011; // pos 10~13 : q0 ad2
            rom[14]=4'b0100; rom[15]=4'b0100; rom[16]=4'b0100;                  // pos 14~16 : 3시 축
            rom[17]=4'b0111; rom[18]=4'b0111; rom[19]=4'b0111; rom[20]=4'b0111; // pos 17~20 : q1 ad2
            rom[21]=4'b0110; rom[22]=4'b0110; rom[23]=4'b0110; rom[24]=4'b0110; // pos 21~24 : q1 ad0
            rom[25]=4'b0101; rom[26]=4'b0101; rom[27]=4'b0101; rom[28]=4'b0101; // pos 25~28 : q1 ad1
            rom[29]=4'b1000; rom[30]=4'b1000; rom[31]=4'b1000;                  // pos 29~31 : 6시 축
            rom[32]=4'b1001; rom[33]=4'b1001; rom[34]=4'b1001; rom[35]=4'b1001; // pos 32~35 : q2 ad1
            rom[36]=4'b1010; rom[37]=4'b1010; rom[38]=4'b1010; rom[39]=4'b1010; // pos 36~39 : q2 ad0
            rom[40]=4'b1011; rom[41]=4'b1011; rom[42]=4'b1011; rom[43]=4'b1011; // pos 40~43 : q2 ad2
            rom[44]=4'b1100; rom[45]=4'b1100; rom[46]=4'b1100;                  // pos 44~46 : 9시 축
            rom[47]=4'b1111; rom[48]=4'b1111; rom[49]=4'b1111; rom[50]=4'b1111; // pos 47~50 : q3 ad2
            rom[51]=4'b1110; rom[52]=4'b1110; rom[53]=4'b1110; rom[54]=4'b1110; // pos 51~54 : q3 ad0
            rom[55]=4'b1101; rom[56]=4'b1101; rom[57]=4'b1101;                  // pos 55~57 : q3 ad1
            rom[58]=4'b0000; rom[59]=4'b0000; rom[60]=4'b0000; rom[61]=4'b0000; // pos 58~63 : 12시 축
            rom[62]=4'b0000; rom[63]=4'b0000;
            dir60_rom = rom[pos];
        end
    endfunction

    wire [3:0] sec_dir  = dir60_rom(sec_pos);
    wire [3:0] min_dir  = dir60_rom(min_pos);
    wire [3:0] hour_dir = dir60_rom(hour_pos);

    // hand_calc: dir[3:2]로 사분면, dir[1:0]로 패턴 선택
    // 비교기 없이 bit-slice MUX만 사용
    function hand_calc;
        input [3:0]  dir;
        input [10:0] len;
        input [10:0] wid;
        reg q_ok;
        begin
            // dir[3:2]로 사분면 직접 선택 (비교기 없음)
            case (dir[3:2])
                2'b00: q_ok = q0;
                2'b01: q_ok = q1;
                2'b10: q_ok = q2;
                2'b11: q_ok = q3;
            endcase

            // dir[1:0]로 계산 패턴 선택
            case (dir[1:0])
                2'b00: begin                                               // 축방향
                    case (dir[3:2])
                        2'b00: hand_calc = y_le_0 & (ay <= len) & (ax <= wid); // 12시
                        2'b01: hand_calc = x_ge_0 & (ax <= len) & (ay <= wid); //  3시
                        2'b10: hand_calc = y_ge_0 & (ay <= len) & (ax <= wid); //  6시
                        2'b11: hand_calc = x_le_0 & (ax <= len) & (ay <= wid); //  9시
                    endcase
                end
                2'b01: hand_calc = q_ok & (ay <= len) & (ad1 <= wid);
                2'b10: hand_calc = q_ok & (ax <= len) & (ay <= len) & (ad0 <= wid);
                2'b11: hand_calc = q_ok & (ax <= len) & (ad2 <= wid);
            endcase
        end
    endfunction

    assign sec_hand  = hand_calc(sec_dir,  11'd95, 11'd4);
    assign min_hand  = hand_calc(min_dir,  11'd75, 11'd5);
    assign hour_hand = hand_calc(hour_dir, 11'd50, 11'd6);

endmodule
