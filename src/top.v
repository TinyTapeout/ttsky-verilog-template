`timescale 1ns / 1ps

module tt_um_electron65_vga (
    input  wire [7:0] ui_in     ,
    output wire [7:0] uo_out    ,
    input  wire [7:0] uio_in    ,
    output wire [7:0] uio_out   ,
    output wire [7:0] uio_oe    ,
    input  wire       ena       ,
    input  wire       clk       ,
    input  wire       rst_n
);

    wire nrst = rst_n;

    wire        hsync, vsync, display_on;
    wire [9:0]  hpos , vpos;

    hvsync_generator U_HV (
        .clk        (clk       ),
        .reset      (~nrst     ),
        .hsync      (hsync     ),
        .vsync      (vsync     ),
        .display_on (display_on),
        .hpos       (hpos      ),
        .vpos       (vpos      )
    );

    wire gp_select;
    wire gp_start;
    wire gp_up;
    wire gp_down;
    wire gp_present;

    gamepad_pmod_min U_GAMEPAD (
        .rst_n      (nrst       ),
        .clk        (clk        ),
        .pmod_data  (ui_in[6]   ),
        .pmod_clk   (ui_in[5]   ),
        .pmod_latch (ui_in[4]   ),
        .select     (gp_select  ),
        .start      (gp_start   ),
        .up         (gp_up      ),
        .down       (gp_down    ),
        .is_present (gp_present )
    );

    wire [3:0] button;

    assign button[0] = gp_start;
    assign button[1] = gp_select;
    assign button[2] = gp_up;
    assign button[3] = gp_down;

    wire [5:0]  sec, min, hour;
    wire        ctl_mode;
    wire [1:0]  ctl_time;

    clock_top U_CLOCK (
        .clk        (clk     ),
        .nrst       (nrst    ),
        .button     (button  ),
        .sec        (sec     ),
        .min        (min     ),
        .hour       (hour    ),
        .ctl_mode   (ctl_mode),
        .ctl_time   (ctl_time)
    );

    wire [5:0] rgb;

    vga_clock_draw U_DRAW (
        .hpos       (hpos      ),
        .vpos       (vpos      ),
        .display_on (display_on),
        .sec        (sec       ),
        .min        (min       ),
        .hour       (hour      ),
        .ctl_mode   (ctl_mode  ),
        .ctl_time   (ctl_time  ),
        .rgb        (rgb       )
    );

    assign uo_out[0] = rgb[5];
    assign uo_out[1] = rgb[3];
    assign uo_out[2] = rgb[1];
    assign uo_out[3] = vsync;
    assign uo_out[4] = rgb[4];
    assign uo_out[5] = rgb[2];
    assign uo_out[6] = rgb[0];
    assign uo_out[7] = hsync;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, uio_in, ui_in[7], ui_in[3:0], gp_present, 1'b0};

endmodule
