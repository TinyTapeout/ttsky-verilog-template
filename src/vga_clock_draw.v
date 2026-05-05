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

    wire h_lt6  = (hour < 6'd6);
    wire h_lt12 = (hour < 6'd12);
    wire h_lt18 = (hour < 6'd18);

    wire night_t = h_lt6;
    wire morn_t  = !h_lt6  && h_lt12;
    wire day_t   = !h_lt12 && h_lt18;
    wire eve_t   = !h_lt18;

    wire [5:0] bg_color =
        night_t ? 6'b000001 :
        morn_t  ? 6'b011011 :
        day_t   ? 6'b101110 :
                  6'b100101;

    wire [3:0] hour12_safe = (hour >= 6'd12) ? (hour[3:0] - 4'd12) : hour[3:0];

    wire [1:0] min_off =
        (min >= 6'd36) ? 2'd3 :
        (min >= 6'd24) ? 2'd2 :
        (min >= 6'd12) ? 2'd1 : 2'd0;

    wire [5:0] hour_pos = hour12_safe * 6'd5 + {4'd0, min_off};

    reg [7:0] sky_dx_abs;
    reg [7:0] sky_dy_abs;
    reg       sky_dx_neg;
    reg       sky_dy_neg;

    always @(*) begin
        case (hour12_safe)
            4'd0:   begin sky_dx_abs=8'd0;   sky_dy_abs=8'd170; sky_dx_neg=0; sky_dy_neg=1; end
            4'd1:   begin sky_dx_abs=8'd85;  sky_dy_abs=8'd147; sky_dx_neg=0; sky_dy_neg=1; end
            4'd2:   begin sky_dx_abs=8'd147; sky_dy_abs=8'd85;  sky_dx_neg=0; sky_dy_neg=1; end
            4'd3:   begin sky_dx_abs=8'd170; sky_dy_abs=8'd0;   sky_dx_neg=0; sky_dy_neg=0; end
            4'd4:   begin sky_dx_abs=8'd147; sky_dy_abs=8'd85;  sky_dx_neg=0; sky_dy_neg=0; end
            4'd5:   begin sky_dx_abs=8'd85;  sky_dy_abs=8'd147; sky_dx_neg=0; sky_dy_neg=0; end
            4'd6:   begin sky_dx_abs=8'd0;   sky_dy_abs=8'd170; sky_dx_neg=0; sky_dy_neg=0; end
            4'd7:   begin sky_dx_abs=8'd85;  sky_dy_abs=8'd147; sky_dx_neg=1; sky_dy_neg=0; end
            4'd8:   begin sky_dx_abs=8'd147; sky_dy_abs=8'd85;  sky_dx_neg=1; sky_dy_neg=0; end
            4'd9:   begin sky_dx_abs=8'd170; sky_dy_abs=8'd0;   sky_dx_neg=1; sky_dy_neg=0; end
            4'd10:  begin sky_dx_abs=8'd147; sky_dy_abs=8'd85;  sky_dx_neg=1; sky_dy_neg=1; end
            default:begin sky_dx_abs=8'd85;  sky_dy_abs=8'd147; sky_dx_neg=1; sky_dy_neg=1; end
        endcase
    end

    wire signed [10:0] sky_cx = sky_dx_neg
        ? -$signed({3'b0, sky_dx_abs})
        :  $signed({3'b0, sky_dx_abs});
    wire signed [10:0] sky_cy = sky_dy_neg
        ? -$signed({3'b0, sky_dy_abs})
        :  $signed({3'b0, sky_dy_abs});

    wire signed [10:0] sky_obj_dx = x - sky_cx;
    wire signed [10:0] sky_obj_dy = y - sky_cy;
    wire [10:0] sky_ax = sky_obj_dx[10] ? -sky_obj_dx : sky_obj_dx;
    wire [10:0] sky_ay = sky_obj_dy[10] ? -sky_obj_dy : sky_obj_dy;
    wire [11:0] sky_dist = sky_ax + sky_ay;

    wire sun_body  = (morn_t | day_t)  && (sky_dist <= 12'd34);
    wire moon_body = (night_t | eve_t) && (sky_dist <= 12'd24);

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

    wire sec_hand, min_hand, hour_hand;

    hand_60dir3 U_HANDS (
        .x        (x),
        .y        (y),
        .ax       (ax),
        .ay       (ay),
        .sec_pos  (sec),
        .min_pos  (min),
        .hour_pos (hour_pos),
        .sec_hand (sec_hand),
        .min_hand (min_hand),
        .hour_hand(hour_hand)
    );

    wire in_lbox_h = ctl_mode && (hpos >= 10'd2) && (hpos <= 10'd85);

    wire in_rbox = ctl_mode &&
        (hpos >= 10'd554) && (hpos <= 10'd637) &&
        (vpos >= 10'd414) && (vpos <= 10'd477);
    wire mode_box = in_rbox &&
        ((hpos <= 10'd555) || (hpos >= 10'd636) ||
         (vpos <= 10'd415) || (vpos >= 10'd476));

    wire sec_box_active  = (ctl_time == 2'b00);
    wire min_box_active  = (ctl_time == 2'b01);
    wire hour_box_active = (ctl_time == 2'b10);

    wire in_hour_box = in_lbox_h && (vpos >= 10'd414) && (vpos <= 10'd433);
    wire in_min_box  = in_lbox_h && (vpos >= 10'd437) && (vpos <= 10'd456);
    wire in_sec_box  = in_lbox_h && (vpos >= 10'd459) && (vpos <= 10'd477);

    wire hour_edge = (hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd415)||(vpos>=10'd432);
    wire min_edge  = (hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd438)||(vpos>=10'd455);
    wire sec_edge  = (hpos<=10'd3)||(hpos>=10'd84)||(vpos<=10'd460)||(vpos>=10'd476);

    wire hour_box = in_hour_box && (hour_box_active || hour_edge);
    wire min_box  = in_min_box  && (min_box_active  || min_edge);
    wire sec_box  = in_sec_box  && (sec_box_active  || sec_edge);

    reg [3:0] layer;
    always @(*) begin
        if      (!display_on) layer = 4'd0;
        else if (mode_box)    layer = 4'd1;
        else if (hour_box)    layer = 4'd2;
        else if (min_box)     layer = 4'd3;
        else if (sec_box)     layer = 4'd4;
        else if (center_dot)  layer = 4'd5;
        else if (sec_hand)    layer = 4'd6;
        else if (min_hand)    layer = 4'd7;
        else if (hour_hand)   layer = 4'd8;
        else if (major_mark)  layer = 4'd9;
        else if (face_ring)   layer = 4'd10;
        else if (sun_body)    layer = 4'd11;
        else if (moon_body)   layer = 4'd12;
        else                  layer = 4'd13;
    end

    always @(*) begin
        case (layer)
            4'd0:  rgb = 6'b000000;
            4'd1:  rgb = 6'b111111;
            4'd2:  rgb = hour_box_active ? 6'b001111 : 6'b000101;
            4'd3:  rgb = min_box_active  ? 6'b111111 : 6'b010101;
            4'd4:  rgb = sec_box_active  ? 6'b110000 : 6'b010000;
            4'd5:  rgb = 6'b111111;
            4'd6:  rgb = 6'b110000;
            4'd7:  rgb = 6'b111111;
            4'd8:  rgb = 6'b001111;
            4'd9:  rgb = 6'b111100;
            4'd10: rgb = 6'b001100;
            4'd11: rgb = 6'b111100;
            4'd12: rgb = 6'b111111;
            default: rgb = bg_color;
        endcase
    end

endmodule
