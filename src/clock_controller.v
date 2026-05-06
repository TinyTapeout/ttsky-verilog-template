//`timescale 1ns / 1ps

module clock_controller(
    input                   clk       ,
    input                   nrst      ,
    input       [4:0]       button    ,
    output                  ctl_mode  ,
    output      [1:0]       ctl_time  ,
    output  reg             ctl_add   ,
    output  reg             ctl_sub   ,
    output  reg             speed_demo
    );

wire mode, sel_t, add, sub, spd;

assign mode  = button[0];
assign sel_t = button[1];
assign add   = button[2];
assign sub   = button[3];
assign spd   = button[4];

localparam          CLOCK_MODE   = 1'b0;
localparam          SET_MODE     = 1'b1;

localparam [1:0]    SEC          = 2'b00;
localparam [1:0]    MIN          = 2'b01;
localparam [1:0]    HOUR         = 2'b10;

reg         MODE_STATE;
reg [1:0]   TIME_STATE;

assign ctl_mode = MODE_STATE;
assign ctl_time = TIME_STATE;

always @(posedge clk or negedge nrst) begin
    if(!nrst)
        MODE_STATE <= CLOCK_MODE;
    else if(mode == 1'b1)
        MODE_STATE <= ~MODE_STATE;
end

always @(posedge clk or negedge nrst) begin
    if(!nrst)
        TIME_STATE <= SEC;
    else if((MODE_STATE == SET_MODE) && (sel_t == 1'b1))begin
        if(TIME_STATE == SEC)
            TIME_STATE <= MIN;
        else if(TIME_STATE == MIN)
            TIME_STATE <= HOUR;
        else
            TIME_STATE <= SEC;
    end
end

wire enable_set =  (MODE_STATE == SET_MODE);

wire add_only =  add & ~sub;
wire sub_only = ~add &  sub;

always @(posedge clk or negedge nrst) begin
    if(!nrst) begin
        ctl_add    <= 1'b0;
        ctl_sub    <= 1'b0;
    end else begin
        ctl_add <= enable_set & add_only;
        ctl_sub <= enable_set & sub_only;
    end
end

always @(posedge clk or negedge nrst) begin
    if(!nrst)
        speed_demo <= 1'b1;
    else if(spd == 1'b1)
        speed_demo <= ~speed_demo;
end

endmodule
