//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2026 08:39:52 PM
// Design Name: 
// Module Name: clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clock(
    input               clk       ,
    input               nrst      ,
    input       [1:0]   ctl_time  ,
    input               ctl_add   ,
    input               ctl_sub   ,
    input               speed_demo,
    output wire [5:0]   sec       ,
    output wire [5:0]   min       ,
    output wire [5:0]   hour
);
    localparam [1:0] SEC  = 2'b00;
    localparam [1:0] MIN  = 2'b01;
    localparam [1:0] HOUR = 2'b10;

    wire        tick_sec, tick_min;
    wire        w_tick;

    wire sec_add  = ctl_add && (ctl_time == SEC);
    wire sec_sub  = ctl_sub && (ctl_time == SEC);

    wire min_add  = ctl_add && (ctl_time == MIN);
    wire min_sub  = ctl_sub && (ctl_time == MIN);

    wire hour_add = ctl_add && (ctl_time == HOUR);
    wire hour_sub = ctl_sub && (ctl_time == HOUR);

    tick_gen U1_tick (
        .clk       (clk       ),
        .nrst      (nrst      ),
        .speed_demo(speed_demo),
        .tick      (w_tick    )
    );

    utime_ctl #(
        .COUNT(6'd60)
    ) U_sec (
        .clk    (clk     ),
        .nrst   (nrst    ),
        .flag   (w_tick  ),
        .add    (sec_add ),
        .sub    (sec_sub ),
        .cnt    (sec     ),
        .tick   (tick_sec)
    );

    utime_ctl #(
        .COUNT(6'd60)
    ) U_min (
        .clk    (clk     ),
        .nrst   (nrst    ),
        .flag   (tick_sec),
        .add    (min_add ),
        .sub    (min_sub ),
        .cnt    (min     ),
        .tick   (tick_min)
    );

    wire tick_hour;

    utime_ctl #(
        .COUNT(6'd24)
    ) U_hour (
        .clk    (clk      ),
        .nrst   (nrst     ),
        .flag   (tick_min ),
        .add    (hour_add ),
        .sub    (hour_sub ),
        .cnt    (hour     ),
        .tick   (tick_hour)
    );

endmodule

module tick_gen (
    input                clk       ,
    input                nrst      ,
    input                speed_demo,
    output  reg          tick
);
    localparam [26:0] COUNT_DEMO  = 27'd2_500_00;
    localparam [26:0] COUNT_CLOCK = 27'd25_000_000;

    reg [26:0] cnt;
    wire [26:0] count_sel = speed_demo ? COUNT_DEMO : COUNT_CLOCK;

    reg speed_demo_prev;

    always @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            cnt            <= 27'b0;
            tick           <= 1'b0;
            speed_demo_prev <= 1'b1;
        end
        else if (speed_demo != speed_demo_prev) begin
            cnt            <= 27'b0;
            tick           <= 1'b0;
            speed_demo_prev <= speed_demo;
        end
        else if (cnt == count_sel - 1) begin
            cnt     <= 27'b0;
            tick    <=  1'b1;
        end
        else begin
            cnt     <= cnt + 27'b1;
            tick    <= 1'b0;
        end
    end
endmodule

module utime_ctl #(
    parameter [5:0] COUNT = 6'd60
)(
    input                clk ,
    input                nrst,
    input                flag,
    input                add ,
    input                sub ,
    output reg  [5:0]    cnt ,
    output reg           tick
);

    always @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            cnt     <= 6'b0;
            tick    <= 1'b0;
        end
        else begin
            tick    <= 1'b0;
            if(add == 1'b1) begin
                if(cnt == COUNT - 1)
                    cnt <= 6'b0;
                else
                    cnt <= cnt + 6'd1;
            end
            else if(sub == 1'b1) begin
                if(cnt == 6'd0)
                    cnt <= COUNT - 1;
                else
                    cnt <= cnt - 6'd1;
            end
            else if(flag == 1'b1) begin
                if(cnt == COUNT - 1) begin
                    cnt  <= 6'b0;
                    tick <= 1'b1;
                end
                else
                    cnt <= cnt + 6'b1;
            end
        end
    end

endmodule
