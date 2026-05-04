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

    wire [10:0] ax = x[10] ? -x : x;
    wire [10:0] ay = y[10] ? -y : y;

    // ── 시간대 ──────────────────────────────────────────────
    wire night_time = (hour < 6'd6);
    wire morn_time  = (hour >= 6'd6)  && (hour < 6'd12);
    wire day_time   = (hour >= 6'd12) && (hour < 6'd18);
    wire eve_time   = (hour >= 6'd18);

    wire [5:0] bg_color =
        night_time ? 6'b000001 :
        morn_time  ? 6'b011011 :
        day_time   ? 6'b101110 :
                     6'b100101;

    // ── 시침 위치 계산 ───────────────────────────────────────
    wire [3:0] hour12 = (hour >= 6'd12) ? (hour - 6'd12) : hour;

    wire [5:0] hour_pos =
        {hour12, 2'b00} + hour12 +
        ((min >= 6'd36) ? 6'd3 :
         (min >= 6'd24) ? 6'd2 :
         (min >= 6'd12) ? 6'd1 : 6'd0);

    // ── 하늘 오브젝트 (해/달) ────────────────────────────────
    reg signed [10:0] sky_dx;
    reg signed [10:0] sky_dy;

    always @(*) begin
        case (hour12)
            4'd0:  begin sky_dx =  11'sd0;   sky_dy = -11'sd170; end
            4'd1:  begin sky_dx =  11'sd85;  sky_dy = -11'sd147; end
            4'd2:  begin sky_dx =  11'sd147; sky_dy = -11'sd85;  end
            4'd3:  begin sky_dx =  11'sd170; sky_dy =  11'sd0;   end
            4'd4:  begin sky_dx =  11'sd147; sky_dy =  11'sd85;  end
            4'd5:  begin sky_dx =  11'sd85;  sky_dy =  11'sd147; end
            4'd6:  begin sky_dx =  11'sd0;   sky_dy =  11'sd170; end
            4'd7:  begin sky_dx = -11'sd85;  sky_dy =  11'sd147; end
            4'd8:  begin sky_dx = -11'sd147; sky_dy =  11'sd85;  end
            4'd9:  begin sky_dx = -11'sd170; sky_dy =  11'sd0;   end
            4'd10: begin sky_dx = -11'sd147; sky_dy = -11'sd85;  end
            default: begin sky_dx = -11'sd85; sky_dy = -11'sd147; end
        endcase
    end

    wire signed [10:0] sky_obj_dx = x - sky_dx;
    wire signed [10:0] sky_obj_dy = y - sky_dy;
    wire [10:0] sky_ax = sky_obj_dx[10] ? -sky_obj_dx : sky_obj_dx;
    wire [10:0] sky_ay = sky_obj_dy[10] ? -sky_obj_dy : sky_obj_dy;
    wire [11:0] sky_dist = sky_ax + sky_ay;

    wire sun_body  = (morn_time | day_time)  && (sky_dist <= 12'd34);
    wire moon_body = (night_time | eve_time) && (sky_dist <= 12'd24);

    // ── 별 (밤) ───────────────────────────────────────────────
    wire star =
        night_time &&
        (((hpos[6:0] == 7'd20)  && (vpos[5:0] == 6'd10)) |
         ((hpos[6:0] == 7'd85)  && (vpos[5:0] == 6'd25)) |
         ((hpos[6:0] == 7'd110) && (vpos[5:0] == 6'd45)) |
         ((hpos[7:0] == 8'd170) && (vpos[6:0] == 7'd70)) |
         ((hpos[7:0] == 8'd230) && (vpos[6:0] == 7'd35)));

    // ── 새 (낮 12~18시) ─ 경사진 V자, 4행 슬라이스 ─────────────
    // 각 행마다 날개 범위를 이동시켜 경사 표현
    wire bird1 = day_time && (
        ((vpos==10'd62)&&(hpos>=10'd108)&&(hpos<=10'd117)) |
        ((vpos==10'd62)&&(hpos>=10'd123)&&(hpos<=10'd132)) |
        ((vpos==10'd63)&&(hpos>=10'd111)&&(hpos<=10'd118)) |
        ((vpos==10'd63)&&(hpos>=10'd122)&&(hpos<=10'd129)) |
        ((vpos==10'd64)&&(hpos>=10'd114)&&(hpos<=10'd119)) |
        ((vpos==10'd64)&&(hpos>=10'd121)&&(hpos<=10'd126)) |
        ((vpos==10'd65)&&(hpos>=10'd117)&&(hpos<=10'd123)));
    wire bird2 = day_time && (
        ((vpos==10'd47)&&(hpos>=10'd298)&&(hpos<=10'd307)) |
        ((vpos==10'd47)&&(hpos>=10'd313)&&(hpos<=10'd322)) |
        ((vpos==10'd48)&&(hpos>=10'd301)&&(hpos<=10'd308)) |
        ((vpos==10'd48)&&(hpos>=10'd312)&&(hpos<=10'd319)) |
        ((vpos==10'd49)&&(hpos>=10'd304)&&(hpos<=10'd309)) |
        ((vpos==10'd49)&&(hpos>=10'd311)&&(hpos<=10'd316)) |
        ((vpos==10'd50)&&(hpos>=10'd307)&&(hpos<=10'd313)));
    wire bird3 = day_time && (
        ((vpos==10'd77)&&(hpos>=10'd468)&&(hpos<=10'd477)) |
        ((vpos==10'd77)&&(hpos>=10'd483)&&(hpos<=10'd492)) |
        ((vpos==10'd78)&&(hpos>=10'd471)&&(hpos<=10'd478)) |
        ((vpos==10'd78)&&(hpos>=10'd482)&&(hpos<=10'd489)) |
        ((vpos==10'd79)&&(hpos>=10'd474)&&(hpos<=10'd479)) |
        ((vpos==10'd79)&&(hpos>=10'd481)&&(hpos<=10'd486)) |
        ((vpos==10'd80)&&(hpos>=10'd477)&&(hpos<=10'd483)));
    wire bird = bird1 | bird2 | bird3;

    // ── 반딧불 (저녁 18~24시) ─ 별과 동일한 구조, 노란색 ──────
    wire firefly = eve_time &&
        (((hpos[7:0] == 8'd55)  && (vpos[6:0] == 7'd80)) |
         ((hpos[7:0] == 8'd180) && (vpos[6:0] == 7'd35)) |
         ((hpos[7:0] == 8'd250) && (vpos[6:0] == 7'd95)) |
         ((hpos[7:0] == 8'd400) && (vpos[6:0] == 7'd60)) |
         ((hpos[7:0] == 8'd490) && (vpos[6:0] == 7'd110)) |
         ((hpos[7:0] == 8'd130) && (vpos[6:0] == 7'd120)) |
         ((hpos[7:0] == 8'd530) && (vpos[6:0] == 7'd45)));

    // ── 구름 (아침 6~12시) ─ 3봉우리 실루엣 ──────────────────
    // 각 구름: 넓은 몸통 + 왼쪽 봉우리 + 오른쪽 봉우리 (위쪽으로만)

    // 구름 중심 좌표
    localparam [9:0] C1X = 10'd80;  localparam [8:0] C1Y = 9'd55;
    localparam [9:0] C2X = 10'd210; localparam [8:0] C2Y = 9'd35;
    localparam [9:0] C3X = 10'd430; localparam [8:0] C3Y = 9'd65;
    localparam [9:0] C4X = 10'd545; localparam [8:0] C4Y = 9'd40;

    // 구름 픽셀 판별 매크로 (몸통 + 왼봉우리 + 오른봉우리)
    // 몸통:   가로±16, 세로±5
    // 왼봉우리: 중심-10, 가로±7, 세로-11~0 (위쪽만)
    // 오른봉우리: 중심+8, 가로±8, 세로-9~0 (위쪽만)
    wire cloud1 = morn_time && (
        ((hpos>=C1X-10'd16)&&(hpos<=C1X+10'd16)&&(vpos>=C1Y-9'd5) &&(vpos<=C1Y+9'd5)) |
        ((hpos>=C1X-10'd17)&&(hpos<=C1X-10'd3) &&(vpos>=C1Y-9'd13)&&(vpos<=C1Y))      |
        ((hpos>=C1X+10'd5) &&(hpos<=C1X+10'd18)&&(vpos>=C1Y-9'd10)&&(vpos<=C1Y)));
    wire cloud2 = morn_time && (
        ((hpos>=C2X-10'd16)&&(hpos<=C2X+10'd16)&&(vpos>=C2Y-9'd5) &&(vpos<=C2Y+9'd5)) |
        ((hpos>=C2X-10'd17)&&(hpos<=C2X-10'd3) &&(vpos>=C2Y-9'd13)&&(vpos<=C2Y))      |
        ((hpos>=C2X+10'd5) &&(hpos<=C2X+10'd18)&&(vpos>=C2Y-9'd10)&&(vpos<=C2Y)));
    wire cloud3 = morn_time && (
        ((hpos>=C3X-10'd16)&&(hpos<=C3X+10'd16)&&(vpos>=C3Y-9'd5) &&(vpos<=C3Y+9'd5)) |
        ((hpos>=C3X-10'd17)&&(hpos<=C3X-10'd3) &&(vpos>=C3Y-9'd13)&&(vpos<=C3Y))      |
        ((hpos>=C3X+10'd5) &&(hpos<=C3X+10'd18)&&(vpos>=C3Y-9'd10)&&(vpos<=C3Y)));
    wire cloud4 = morn_time && (
        ((hpos>=C4X-10'd16)&&(hpos<=C4X+10'd16)&&(vpos>=C4Y-9'd5) &&(vpos<=C4Y+9'd5)) |
        ((hpos>=C4X-10'd17)&&(hpos<=C4X-10'd3) &&(vpos>=C4Y-9'd13)&&(vpos<=C4Y))      |
        ((hpos>=C4X+10'd5) &&(hpos<=C4X+10'd18)&&(vpos>=C4Y-9'd10)&&(vpos<=C4Y)));

    wire cloud = cloud1 | cloud2 | cloud3 | cloud4;


    // ── 시계판 ───────────────────────────────────────────────
    wire face_ring =
        ((ay <= 11'd122) && (ay >= 11'd118) && (ax <= 11'd28)) ||
        ((ay <= 11'd118) && (ay >= 11'd110) && (ax >= 11'd28)  && (ax <= 11'd58)) ||
        ((ay <= 11'd108) && (ay >= 11'd96 ) && (ax >= 11'd58)  && (ax <= 11'd84)) ||
        ((ay <= 11'd94 ) && (ay >= 11'd76 ) && (ax >= 11'd84)  && (ax <= 11'd100)) ||
        ((ay <= 11'd76 ) && (ay >= 11'd58 ) && (ax >= 11'd100) && (ax <= 11'd112)) ||
        ((ay <= 11'd58 ) && (ay >= 11'd28 ) && (ax >= 11'd112) && (ax <= 11'd118)) ||
        ((ax <= 11'd122) && (ax >= 11'd118) && (ay <= 11'd28));

    wire center_dot = (ax <= 11'd3) && (ay <= 11'd3);

    wire major_mark =
        ((ax <= 11'd3) && (ay >= 11'd105) && (ay <= 11'd120)) ||
        ((ay <= 11'd3) && (ax >= 11'd105) && (ax <= 11'd120));

    wire sec_hand;
    wire min_hand;
    wire hour_hand;

    hand_60dir3 U_HANDS (
        .x         (x),
        .y         (y),
        .ax        (ax),
        .ay        (ay),
        .sec_pos   (sec),
        .min_pos   (min),
        .hour_pos  (hour_pos),
        .sec_hand  (sec_hand),
        .min_hand  (min_hand),
        .hour_hand (hour_hand)
    );

    // ── 수정 모드 UI — A 스타일 (스캔라인 + 코너핀) ──────────────
    // 오른쪽 하단 상태 박스: 더블 테두리 + 4코너 핀
    wire in_rbox = ctl_mode &&
        (hpos >= 10'd554) && (hpos <= 10'd637) &&
        (vpos >= 10'd414) && (vpos <= 10'd477);
    wire rbox_outer = in_rbox &&
        ((hpos <= 10'd555) || (hpos >= 10'd636) ||
         (vpos <= 10'd415) || (vpos >= 10'd476));
    wire rbox_inner = in_rbox &&
        ((hpos == 10'd558) || (hpos == 10'd633) ||
         (vpos == 10'd418) || (vpos == 10'd473));
    // 4코너 핀 (코너 8px 구간에서 테두리 밝게)
    wire rbox_corner = in_rbox && rbox_outer && (
        (hpos <= 10'd562) | (hpos >= 10'd629) |
        (vpos <= 10'd422) | (vpos >= 10'd469));
    wire mode_box = rbox_outer | rbox_inner | rbox_corner;

    // 왼쪽 하단 HOUR/MIN/SEC 박스 (각 20px 높이, 3px 간격)
    wire sec_box_active  = (ctl_time == 2'b00);
    wire min_box_active  = (ctl_time == 2'b01);
    wire hour_box_active = (ctl_time == 2'b10);

    wire in_hour_box = ctl_mode && (hpos >= 10'd2) && (hpos <= 10'd85) && (vpos >= 10'd414) && (vpos <= 10'd433);
    wire in_min_box  = ctl_mode && (hpos >= 10'd2) && (hpos <= 10'd85) && (vpos >= 10'd437) && (vpos <= 10'd456);
    wire in_sec_box  = ctl_mode && (hpos >= 10'd2) && (hpos <= 10'd85) && (vpos >= 10'd459) && (vpos <= 10'd477);

    // 테두리 1px
    wire hour_box_edge = in_hour_box &&
        ((hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd415)||(vpos>=10'd432));
    wire min_box_edge  = in_min_box  &&
        ((hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd438)||(vpos>=10'd455));
    wire sec_box_edge  = in_sec_box  &&
        ((hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd460)||(vpos>=10'd476));

    // 코너핀: 테두리 중 모서리 6px 구간
    wire hour_corner = hour_box_edge &&
        ((hpos<=10'd9)||(hpos>=10'd78)||(vpos<=10'd421)||(vpos>=10'd426));
    wire min_corner  = min_box_edge  &&
        ((hpos<=10'd9)||(hpos>=10'd78)||(vpos<=10'd444)||(vpos>=10'd449));
    wire sec_corner  = sec_box_edge  &&
        ((hpos<=10'd9)||(hpos>=10'd78)||(vpos<=10'd466)||(vpos>=10'd470));

    // 내부 채움 (테두리 제외)
    wire hour_box_fill = in_hour_box && !hour_box_edge;
    wire min_box_fill  = in_min_box  && !min_box_edge;
    wire sec_box_fill  = in_sec_box  && !sec_box_edge;

    // 스캔라인: 활성 박스 내부에서 짝수 행만 약간 밝게 → vpos[0]==0
    wire scanline = ~vpos[0];

    // 표시 여부 (활성: 전체, 비활성: 테두리만)
    wire hour_box = in_hour_box && (hour_box_active ? 1'b1 : hour_box_edge);
    wire min_box  = in_min_box  && (min_box_active  ? 1'b1 : min_box_edge);
    wire sec_box  = in_sec_box  && (sec_box_active  ? 1'b1 : sec_box_edge);

    // ── RGB 출력 ─────────────────────────────────────────────
    always @(*) begin
        if (!display_on) begin
            rgb = 6'b000000;
        end
        // 오른쪽 상태 박스
        else if (mode_box) begin
            rgb = rbox_corner ? 6'b111111 :   // 코너핀: 흰색
                  rbox_inner  ? 6'b010101 :   // 내부 테두리: 회색
                                6'b111111;    // 외부 테두리: 흰색
        end
        // HOUR 박스
        else if (hour_box) begin
            if (hour_box_active && hour_box_fill)
                rgb = scanline ? 6'b001010 : 6'b000101; // 스캔라인: 청록 내부
            else if (hour_corner)
                rgb = 6'b001111;             // 코너핀: 밝은 청록
            else if (hour_box_edge)
                rgb = hour_box_active ? 6'b001111 : 6'b000101;
            else
                rgb = 6'b000000;
        end
        // MIN 박스
        else if (min_box) begin
            if (min_box_active && min_box_fill)
                rgb = scanline ? 6'b101010 : 6'b010101; // 스캔라인: 회색 내부
            else if (min_corner)
                rgb = 6'b111111;             // 코너핀: 흰색
            else if (min_box_edge)
                rgb = min_box_active ? 6'b111111 : 6'b010101;
            else
                rgb = 6'b000000;
        end
        // SEC 박스
        else if (sec_box) begin
            if (sec_box_active && sec_box_fill)
                rgb = scanline ? 6'b100000 : 6'b010000; // 스캔라인: 빨강 내부
            else if (sec_corner)
                rgb = 6'b110000;             // 코너핀: 밝은 빨강
            else if (sec_box_edge)
                rgb = sec_box_active ? 6'b110000 : 6'b010000;
            else
                rgb = 6'b000000;
        end
        // 시계
        else if (center_dot) begin
            rgb = 6'b111111;
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
        else if (major_mark) begin
            rgb = 6'b111100;
        end
        else if (face_ring) begin
            rgb = 6'b001100;
        end
        // 하늘 오브젝트
        else if (sun_body) begin
            rgb = 6'b111100;
        end
        else if (moon_body) begin
            rgb = 6'b111111;
        end
        else if (cloud) begin
            rgb = 6'b111111;   // 흰 구름
        end
        else if (star) begin
            rgb = 6'b111111;   // 흰 별
        end
        else if (bird) begin
            rgb = 6'b000000;   // 검은 새 실루엣 (낮 배경 연두 위에)
        end
        else if (firefly) begin
            rgb = 6'b111100;   // 노란 반딧불 #ffff00
        end
        else begin
            rgb = bg_color;
        end
    end

endmodule
