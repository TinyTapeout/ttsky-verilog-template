`timescale 1ns / 1ps

module hand_60dir3 (
    input  wire signed [10:0] x         ,
    input  wire signed [10:0] y         ,
    input  wire        [10:0] ax        ,
    input  wire        [10:0] ay        ,
    input  wire        [ 5:0] sec_pos   ,
    input  wire        [ 5:0] min_pos   ,
    input  wire        [ 5:0] hour_pos  ,
    output wire               sec_hand  ,
    output wire               min_hand  ,
    output wire               hour_hand
);

    wire signed [11:0] d0  = $signed({1'b0, ax}) - $signed({1'b0, ay});
    wire        [11:0] ad0 = d0[11] ? -d0 : d0;

    wire x_ge_0 = ~x[10];
    wire y_ge_0 = ~y[10];
    wire x_le_0 = x[10] | ~|x;
    wire y_le_0 = y[10] | ~|y;

    wire q0 = x_ge_0 & y_le_0;
    wire q1 = x_ge_0 & y_ge_0;
    wire q2 = x_le_0 & y_ge_0;
    wire q3 = x_le_0 & y_le_0;

    wire s_ge8  = (sec_pos  >= 6'd8 );
    wire s_ge15 = (sec_pos  >= 6'd15);
    wire s_ge23 = (sec_pos  >= 6'd23);
    wire s_ge30 = (sec_pos  >= 6'd30);
    wire s_ge38 = (sec_pos  >= 6'd38);
    wire s_ge45 = (sec_pos  >= 6'd45);
    wire s_ge53 = (sec_pos  >= 6'd53);

    wire m_ge8  = (min_pos  >= 6'd8 );
    wire m_ge15 = (min_pos  >= 6'd15);
    wire m_ge23 = (min_pos  >= 6'd23);
    wire m_ge30 = (min_pos  >= 6'd30);
    wire m_ge38 = (min_pos  >= 6'd38);
    wire m_ge45 = (min_pos  >= 6'd45);
    wire m_ge53 = (min_pos  >= 6'd53);

    wire h_ge8  = (hour_pos >= 6'd8 );
    wire h_ge15 = (hour_pos >= 6'd15);
    wire h_ge23 = (hour_pos >= 6'd23);
    wire h_ge30 = (hour_pos >= 6'd30);
    wire h_ge38 = (hour_pos >= 6'd38);
    wire h_ge45 = (hour_pos >= 6'd45);
    wire h_ge53 = (hour_pos >= 6'd53);

    wire [2:0] sec_dir;
    assign sec_dir[2] = s_ge30;
    assign sec_dir[1] = (s_ge15 & ~s_ge30) | s_ge45;
    assign sec_dir[0] = (s_ge8  & ~s_ge15) | (s_ge23 & ~s_ge30) | (s_ge38 & ~s_ge45) | s_ge53;

    wire [2:0] min_dir;
    assign min_dir[2] = m_ge30;
    assign min_dir[1] = (m_ge15 & ~m_ge30) | m_ge45;
    assign min_dir[0] = (m_ge8  & ~m_ge15) | (m_ge23 & ~m_ge30) | (m_ge38 & ~m_ge45) | m_ge53;

    wire [2:0] hour_dir;
    assign hour_dir[2] = h_ge30;
    assign hour_dir[1] = (h_ge15 & ~h_ge30) | h_ge45;
    assign hour_dir[0] = (h_ge8  & ~h_ge15) | (h_ge23 & ~h_ge30) | (h_ge38 & ~h_ge45) | h_ge53;

    wire s_eq0 = (sec_dir == 3'd0);
    wire s_eq1 = (sec_dir == 3'd1);
    wire s_eq2 = (sec_dir == 3'd2);
    wire s_eq3 = (sec_dir == 3'd3);
    wire s_eq4 = (sec_dir == 3'd4);
    wire s_eq5 = (sec_dir == 3'd5);
    wire s_eq6 = (sec_dir == 3'd6);
    wire s_eq7 = (sec_dir == 3'd7);

    assign sec_hand =
        (s_eq0 & y_le_0 & (ay <= 11'd95) & (ax <= 11'd4)) |
        (s_eq1 & q0     & (ax <= 11'd95) & (ay <= 11'd95) & (ad0 <= 12'd4)) |
        (s_eq2 & x_ge_0 & (ax <= 11'd95) & (ay <= 11'd4)) |
        (s_eq3 & q1     & (ax <= 11'd95) & (ay <= 11'd95) & (ad0 <= 12'd4)) |
        (s_eq4 & y_ge_0 & (ay <= 11'd95) & (ax <= 11'd4)) |
        (s_eq5 & q2     & (ax <= 11'd95) & (ay <= 11'd95) & (ad0 <= 12'd4)) |
        (s_eq6 & x_le_0 & (ax <= 11'd95) & (ay <= 11'd4)) |
        (s_eq7 & q3     & (ax <= 11'd95) & (ay <= 11'd95) & (ad0 <= 12'd4));

    wire mq0 = (min_dir == 3'd0);
    wire mq1 = (min_dir == 3'd1);
    wire mq2 = (min_dir == 3'd2);
    wire mq3 = (min_dir == 3'd3);
    wire mq4 = (min_dir == 3'd4);
    wire mq5 = (min_dir == 3'd5);
    wire mq6 = (min_dir == 3'd6);
    wire mq7 = (min_dir == 3'd7);

    assign min_hand =
        (mq0 & y_le_0 & (ay <= 11'd75) & (ax <= 11'd5)) |
        (mq1 & q0     & (ax <= 11'd75) & (ay <= 11'd75) & (ad0 <= 12'd5)) |
        (mq2 & x_ge_0 & (ax <= 11'd75) & (ay <= 11'd5)) |
        (mq3 & q1     & (ax <= 11'd75) & (ay <= 11'd75) & (ad0 <= 12'd5)) |
        (mq4 & y_ge_0 & (ay <= 11'd75) & (ax <= 11'd5)) |
        (mq5 & q2     & (ax <= 11'd75) & (ay <= 11'd75) & (ad0 <= 12'd5)) |
        (mq6 & x_le_0 & (ax <= 11'd75) & (ay <= 11'd5)) |
        (mq7 & q3     & (ax <= 11'd75) & (ay <= 11'd75) & (ad0 <= 12'd5));

    wire hq0 = (hour_dir == 3'd0);
    wire hq1 = (hour_dir == 3'd1);
    wire hq2 = (hour_dir == 3'd2);
    wire hq3 = (hour_dir == 3'd3);
    wire hq4 = (hour_dir == 3'd4);
    wire hq5 = (hour_dir == 3'd5);
    wire hq6 = (hour_dir == 3'd6);
    wire hq7 = (hour_dir == 3'd7);

    assign hour_hand =
        (hq0 & y_le_0 & (ay <= 11'd50) & (ax <= 11'd6)) |
        (hq1 & q0     & (ax <= 11'd50) & (ay <= 11'd50) & (ad0 <= 12'd6)) |
        (hq2 & x_ge_0 & (ax <= 11'd50) & (ay <= 11'd6)) |
        (hq3 & q1     & (ax <= 11'd50) & (ay <= 11'd50) & (ad0 <= 12'd6)) |
        (hq4 & y_ge_0 & (ay <= 11'd50) & (ax <= 11'd6)) |
        (hq5 & q2     & (ax <= 11'd50) & (ay <= 11'd50) & (ad0 <= 12'd6)) |
        (hq6 & x_le_0 & (ax <= 11'd50) & (ay <= 11'd6)) |
        (hq7 & q3     & (ax <= 11'd50) & (ay <= 11'd50) & (ad0 <= 12'd6));

endmodule
