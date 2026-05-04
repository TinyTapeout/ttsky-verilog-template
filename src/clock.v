`timescale 1ns / 1ps
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
    input               clk     ,
    input               nrst    ,
    input       [1:0]   ctl_time,
    input               ctl_add ,
    input               ctl_sub ,
    output wire [5:0]   sec     ,
    output wire [5:0]   min     ,
    output wire [5:0]   hour
);
    localparam [1:0] SEC  = 2'b00;
    localparam [1:0] MIN  = 2'b01;
    localparam [1:0] HOUR = 2'b10;

    wire        tick_sec, tick_min;
    wire        w_tick;

    //ADD or SUB SEC
    wire sec_add  = ctl_add && (ctl_time == SEC);
    wire sec_sub  = ctl_sub && (ctl_time == SEC);
    //ADD or SUB MIN
    wire min_add  = ctl_add && (ctl_time == MIN);
    wire min_sub  = ctl_sub && (ctl_time == MIN);
    //ADD or SUB HOUR
    wire hour_add = ctl_add && (ctl_time == HOUR);
    wire hour_sub = ctl_sub && (ctl_time == HOUR);

    tick_gen #(
        .COUNT(27'd25_000)
        //.COUNT(27'd50_000_000)
        //.COUNT(27'd10) //TEST FOR TESTBENCH ONLY
    ) U1_tick (
        .clk    (clk     ),
        .nrst   (nrst    ),
        .tick   (w_tick  )
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

module tick_gen #(
    parameter [26:0] COUNT = 27'd50_000_000
)(
    input                clk ,
    input                nrst,
    output  reg          tick
);

    reg [26:0] cnt;

    always @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            cnt     <= 27'b0;
            tick    <= 1'b0;
        end
        else if (cnt == COUNT - 1) begin
            cnt     <= 27'b0;
            tick    <=  1'b1;
        end
        else begin
            cnt     <= cnt + 27'b1;
            tick    <= 1'b0;      
        end

    end   
endmodule

//Original User Time Counter
/*
module utime #(
    parameter [5:0] COUNT = 6'd60
)(
    input                clk ,
    input                nrst,
    input                flag,
    output  reg [5:0]    cnt ,
    output  reg          tick
);
    always @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            cnt     <= 6'b0;
            tick    <= 1'b0;
        end
        else begin
            tick    <= 1'b0;                        
            
            if(flag == 1'b1) begin
                if(cnt == COUNT - 1) begin
                    cnt <= 6'b0;
                    tick <= 1'b1;
                end
                else
                    cnt <= cnt + 6'b1;
            end
        end
    end

endmodule
*/

//Add/SUB User Time Counter
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
            //ADD TIME                     
            if(add == 1'b1) begin
                if(cnt == COUNT - 1)
                    cnt <= 6'b0;
                else
                    cnt <= cnt + 6'd1; 
            end
            //SUBTRACT TIME
            else if(sub == 1'b1) begin
                if(cnt == 6'd0)
                    cnt <= COUNT - 1;
                else
                    cnt <= cnt - 6'd1;
            end       
            //NORMAL COUNT TIME
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
