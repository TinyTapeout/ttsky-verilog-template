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

    wire night_time = (hour < 6'd6);
    wire morn_time  = (hour >= 6'd6)  && (hour < 6'd12);
    wire day_time   = (hour >= 6'd12) && (hour < 6'd18);
    wire eve_time   = (hour >= 6'd18);

    wire [5:0] bg_color = night_time ? 6'b000001 :
                          morn_time  ? 6'b011011 :
                          day_time   ? 6'b101111 :
                                      6'b100101;

    reg signed [10:0] sky_dx;
    reg signed [10:0] sky_dy;

    always @(*) begin
        case (hour)
            6'd0:  begin sky_dx = 11'sd0;    sky_dy = -11'sd170; end
            6'd1:  begin sky_dx = 11'sd44;   sky_dy = -11'sd164; end
            6'd2:  begin sky_dx = 11'sd85;   sky_dy = -11'sd147; end
            6'd3:  begin sky_dx = 11'sd120;  sky_dy = -11'sd120; end
            6'd4:  begin sky_dx = 11'sd147;  sky_dy = -11'sd85;  end
            6'd5:  begin sky_dx = 11'sd164;  sky_dy = -11'sd44;  end
            6'd6:  begin sky_dx = 11'sd170;  sky_dy = 11'sd0;    end
            6'd7:  begin sky_dx = 11'sd164;  sky_dy = -11'sd44;  end
            6'd8:  begin sky_dx = 11'sd147;  sky_dy = -11'sd85;  end
            6'd9:  begin sky_dx = 11'sd120;  sky_dy = -11'sd120; end
            6'd10: begin sky_dx = 11'sd85;   sky_dy = -11'sd147; end
            6'd11: begin sky_dx = 11'sd44;   sky_dy = -11'sd164; end
            6'd12: begin sky_dx = 11'sd0;    sky_dy = -11'sd170; end
            6'd13: begin sky_dx = -11'sd44;  sky_dy = -11'sd164; end
            6'd14: begin sky_dx = -11'sd85;  sky_dy = -11'sd147; end
            6'd15: begin sky_dx = -11'sd120; sky_dy = -11'sd120; end
            6'd16: begin sky_dx = -11'sd147; sky_dy = -11'sd85;  end
            6'd17: begin sky_dx = -11'sd164; sky_dy = -11'sd44;  end
            6'd18: begin sky_dx = -11'sd170; sky_dy = 11'sd0;    end
            6'd19: begin sky_dx = -11'sd164; sky_dy = -11'sd44;  end
            6'd20: begin sky_dx = -11'sd147; sky_dy = -11'sd85;  end
            6'd21: begin sky_dx = -11'sd120; sky_dy = -11'sd120; end
            6'd22: begin sky_dx = -11'sd85;  sky_dy = -11'sd147; end
            6'd23: begin sky_dx = -11'sd44;  sky_dy = -11'sd164; end
            default: begin sky_dx = 11'sd0;  sky_dy = -11'sd170; end
        endcase
    end

    wire signed [10:0] sun_cx = sky_dx;
    wire signed [10:0] sun_cy = sky_dy;

    wire signed [10:0] moon_cx = sky_dx;
    wire signed [10:0] moon_cy = sky_dy;

    wire signed [10:0] sun_dx = x - sun_cx;
    wire signed [10:0] sun_dy = y - sun_cy;
    wire signed [10:0] asx = sun_dx[10] ? -sun_dx : sun_dx;
    wire signed [10:0] asy = sun_dy[10] ? -sun_dy : sun_dy;

    wire signed [10:0] moon_dx = x - moon_cx;
    wire signed [10:0] moon_dy = y - moon_cy;
    wire signed [10:0] amx = moon_dx[10] ? -moon_dx : moon_dx;
    wire signed [10:0] amy = moon_dy[10] ? -moon_dy : moon_dy;

    wire sun_body = (morn_time | day_time | eve_time) &&
                    ((asx + asy) <= 11'd34);

    wire moon_full = (night_time | eve_time) &&
                     ((amx + amy) <= 11'd30);

    wire moon_cut = (moon_dx > -11'sd4) &&
                    (moon_dx < 11'sd22) &&
                    ((amx + amy) <= 11'd26);

    wire moon_body = moon_full && !moon_cut;

    wire star1 = night_time && (hpos[6:0] == 7'd20)  && (vpos[5:0] == 6'd10);
    wire star2 = night_time && (hpos[6:0] == 7'd85)  && (vpos[5:0] == 6'd25);
    wire star3 = night_time && (hpos[6:0] == 7'd110) && (vpos[5:0] == 6'd45);
    wire star4 = night_time && (hpos[7:0] == 8'd170) && (vpos[6:0] == 7'd70);
    wire star5 = night_time && (hpos[7:0] == 8'd230) && (vpos[6:0] == 7'd35);

    wire star = star1 | star2 | star3 | star4 | star5;

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
