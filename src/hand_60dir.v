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

    // dir60_rom: case문으로 구현 → Yosys가 순수 조합 LUT으로 합성
    // (reg 배열 + 대입 방식은 Yosys가 FF로 오합성함)
    // 출력 인코딩: bit[3:2]=사분면(q0~q3), bit[1:0]=패턴(axis/ad1/ad0/ad2)
    function [3:0] dir60_rom;
        input [5:0] pos;
        begin
            case (pos)
                6'd0,  6'd1:                          dir60_rom = 4'b0000; // 12시 축
                6'd2,  6'd3,  6'd4,  6'd5:            dir60_rom = 4'b0001; // q0 ad1
                6'd6,  6'd7,  6'd8,  6'd9:            dir60_rom = 4'b0010; // q0 ad0
                6'd10, 6'd11, 6'd12, 6'd13:           dir60_rom = 4'b0011; // q0 ad2
                6'd14, 6'd15, 6'd16:                  dir60_rom = 4'b0100; // 3시 축
                6'd17, 6'd18, 6'd19, 6'd20:           dir60_rom = 4'b0111; // q1 ad2
                6'd21, 6'd22, 6'd23, 6'd24:           dir60_rom = 4'b0110; // q1 ad0
                6'd25, 6'd26, 6'd27, 6'd28:           dir60_rom = 4'b0101; // q1 ad1
                6'd29, 6'd30, 6'd31:                  dir60_rom = 4'b1000; // 6시 축
                6'd32, 6'd33, 6'd34, 6'd35:           dir60_rom = 4'b1001; // q2 ad1
                6'd36, 6'd37, 6'd38, 6'd39:           dir60_rom = 4'b1010; // q2 ad0
                6'd40, 6'd41, 6'd42, 6'd43:           dir60_rom = 4'b1011; // q2 ad2
                6'd44, 6'd45, 6'd46:                  dir60_rom = 4'b1100; // 9시 축
                6'd47, 6'd48, 6'd49, 6'd50:           dir60_rom = 4'b1111; // q3 ad2
                6'd51, 6'd52, 6'd53, 6'd54:           dir60_rom = 4'b1110; // q3 ad0
                6'd55, 6'd56, 6'd57:                  dir60_rom = 4'b1101; // q3 ad1
                default:                              dir60_rom = 4'b0000; // pos 58~63: 12시 축
            endcase
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
            case (dir[3:2])
                2'b00: q_ok = q0;
                2'b01: q_ok = q1;
                2'b10: q_ok = q2;
                2'b11: q_ok = q3;
            endcase

            case (dir[1:0])
                2'b00: begin
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
