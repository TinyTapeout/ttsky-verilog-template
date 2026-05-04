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

    wire night_time = (hour < 6'd6);
    wire morn_time  = (hour >= 6'd6)  && (hour < 6'd12);
    wire day_time   = (hour >= 6'd12) && (hour < 6'd18);
    wire eve_time   = (hour >= 6'd18);

    wire [5:0] bg_color =
        night_time ? 6'b000001 :
        morn_time  ? 6'b011011 :
        day_time   ? 6'b101111 :
                     6'b100101;

    wire [3:0] hour12 = (hour >= 6'd12) ? (hour - 6'd12) : hour;

    wire [5:0] hour_pos =
        {hour12, 2'b00} + hour12 +
        ((min >= 6'd36) ? 6'd3 :
         (min >= 6'd24) ? 6'd2 :
         (min >= 6'd12) ? 6'd1 : 6'd0);

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

    wire sun_body  = (morn_time | day_time)   && (sky_dist <= 12'd34);
    wire moon_body = (night_time | eve_time)  && (sky_dist <= 12'd24);

    wire star =
        night_time &&
        (((hpos[6:0] == 7'd20)  && (vpos[5:0] == 6'd10)) |
         ((hpos[6:0] == 7'd85)  && (vpos[5:0] == 6'd25)) |
         ((hpos[6:0] == 7'd110) && (vpos[5:0] == 6'd45)) |
         ((hpos[7:0] == 8'd170) && (vpos[6:0] == 7'd70)) |
         ((hpos[7:0] == 8'd230) && (vpos[6:0] == 7'd35)));

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
        ((ax <= 11'd3) && (y <= -11'sd105) && (y >= -11'sd120)) ||
        ((ax <= 11'd3) && (y >=  11'sd105) && (y <=  11'sd120)) ||
        ((ay <= 11'd3) && (x >=  11'sd105) && (x <=  11'sd120)) ||
        ((ay <= 11'd3) && (x <= -11'sd105) && (x >= -11'sd120));

    wire sec_hand;
    wire min_hand;
    wire hour_hand;

    hand_60dir3 U_HANDS (
        .x         (x),
        .y         (y),
        .sec_pos   (sec),
        .min_pos   (min),
        .hour_pos  (hour_pos),
        .sec_hand  (sec_hand),
        .min_hand  (min_hand),
        .hour_hand (hour_hand)
    );

    always @(*) begin
        if (!display_on) begin
            rgb = 6'b000000;
        end
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
        else if (sun_body) begin
            rgb = 6'b111100;
        end
        else if (moon_body) begin
            rgb = 6'b111111;
        end
        else if (star) begin
            rgb = 6'b111111;
        end
        else if (ctl_mode) begin
            rgb = 6'b000010;
        end
        else begin
            rgb = bg_color;
        end
    end

    wire _unused = &{ctl_time, 1'b0};

endmodule
