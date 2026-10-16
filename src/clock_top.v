`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2026 05:06:16 PM
// Design Name: 
// Module Name: clock_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_top(
    input               clk     ,
    input               nrst    ,
    input       [3:0]   button  ,
    output wire [5:0]   sec     ,
    output wire [5:0]   min     ,
    output wire [5:0]   hour    ,
    output wire         ctl_mode,
    output wire [1:0]   ctl_time
    );

wire w_ctl_add, w_ctl_sub;

clock_controller U1_CLOCK_CONTROLLER(
    .clk     (clk      ),
    .nrst    (nrst     ),
    .button  (button   ),
    .ctl_mode(ctl_mode ),
    .ctl_time(ctl_time ),
    .ctl_add (w_ctl_add),
    .ctl_sub (w_ctl_sub)
);

clock U1_CLOCK(
    .clk     (clk      ),
    .nrst    (nrst     ),
    .ctl_time(ctl_time ),
    .ctl_add (w_ctl_add),
    .ctl_sub (w_ctl_sub),
    .sec     (sec      ),
    .min     (min      ),
    .hour    (hour     )
);

endmodule
