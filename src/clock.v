`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2026 02:29:12 PM
// Design Name: 
// Module Name: clock_controller
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


module clock_controller(
    input                   clk     ,
    input                   nrst    ,
    input       [3:0]       button  ,
    output                  ctl_mode,
    output      [1:0]       ctl_time,
    output  reg             ctl_add ,
    output  reg             ctl_sub
    );

wire mode, sel_t, add, sub;

assign mode  = button[0];
assign sel_t = button[1];
assign add   = button[2];
assign sub   = button[3];

//MODE STATE
localparam          CLOCK_MODE   = 1'b0;
localparam          SET_MODE     = 1'b1;
//TIME STATE
localparam [1:0]    SEC          = 2'b00;
localparam [1:0]    MIN          = 2'b01;
localparam [1:0]    HOUR         = 2'b10;

//STATES
reg         MODE_STATE;
reg [1:0]   TIME_STATE;

assign ctl_mode = MODE_STATE;
assign ctl_time = TIME_STATE;

//MODE STATE MACHINE
always @(posedge clk or negedge nrst) begin
    if(!nrst)
        MODE_STATE <= CLOCK_MODE;
    else if(mode == 1'b1) begin
        if(MODE_STATE == CLOCK_MODE) begin
            MODE_STATE <= SET_MODE;
        end else if(MODE_STATE == SET_MODE) begin
            MODE_STATE <= CLOCK_MODE;
        end else
            MODE_STATE <= MODE_STATE;
    end
    else
        MODE_STATE <= MODE_STATE;
end

//TIME SET STATE MACHINE
always @(posedge clk or negedge nrst) begin
    if(!nrst)
        TIME_STATE <= SEC;
    else if((MODE_STATE == SET_MODE) && (sel_t == 1'b1))begin
        if(TIME_STATE == SEC) begin
            TIME_STATE <= MIN;
        end else if(TIME_STATE == MIN) begin
            TIME_STATE <= HOUR;
        end else if(TIME_STATE == HOUR) begin
            TIME_STATE <= SEC;
        end
        else begin
            TIME_STATE <= TIME_STATE;
        end
    end
    else
        TIME_STATE <= TIME_STATE;
end

wire enable_set =  ((MODE_STATE == SET_MODE) && ((TIME_STATE == SEC) || (TIME_STATE == MIN) || (TIME_STATE == HOUR)));

wire add_only =  add & ~sub;
wire sub_only = ~add &  sub;

// CLOCK CONTROLLER
always @(posedge clk or negedge nrst) begin
    if(!nrst) begin
        ctl_add <= 1'b0;
        ctl_sub <= 1'b0;
    end else begin
        ctl_add <= enable_set & add_only;
        ctl_sub <= enable_set & sub_only; 
    end
end

endmodule
