`timescale 1ns / 1ps

/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_electron65_vga (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high)
    input  wire       ena,      // always 1
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n (active low)
);

    // =========================
    // Reset
    // =========================
    wire nrst = rst_n;

    // =========================
    // VGA timing
    // =========================
    wire hsync, vsync, display_on;
    wire [9:0] hpos, vpos;

    hvsync_generator U_HV (
        .clk(clk),
        .reset(~nrst),
        .hsync(hsync),
        .vsync(vsync),
        .display_on(display_on),
        .hpos(hpos),
        .vpos(vpos)
    );

    // =========================
    // Gamepad PMOD (TT 기본 핀맵)
    // =========================
    wire pmod_latch = ui_in[4];
    wire pmod_clk   = ui_in[5];
    wire pmod_data  = ui_in[6];

    wire [1:0] gp_start, gp_select, gp_up, gp_down;
    wire [1:0] gp_b, gp_y, gp_left, gp_right, gp_a, gp_x, gp_l, gp_r;
    wire [1:0] gp_present;

    gamepad_pmod_dual U_GAMEPAD (
        .rst_n(nrst),
        .clk(clk),
        .pmod_data(pmod_data),
        .pmod_clk(pmod_clk),
        .pmod_latch(pmod_latch),

        .b(gp_b),
        .y(gp_y),
        .select(gp_select),
        .start(gp_start),
        .up(gp_up),
        .down(gp_down),
        .left(gp_left),
        .right(gp_right),
        .a(gp_a),
        .x(gp_x),
        .l(gp_l),
        .r(gp_r),
        .is_present(gp_present)
    );

    // =========================
    // Button pulse
    // =========================
    wire [3:0] button;

    gamepad_button_pulse U_BTN (
        .clk(clk),
        .nrst(nrst),

        .gp_start(gp_start[0]),
        .gp_select(gp_select[0]),
        .gp_up(gp_up[0]),
        .gp_down(gp_down[0]),

        .button(button)
    );

    // =========================
    // Clock logic
    // =========================
    wire [5:0] sec, min, hour;
    wire ctl_mode;
    wire [1:0] ctl_time;

    clock_top U_CLOCK (
        .clk(clk),
        .nrst(nrst),
        .button(button),
        .sec(sec),
        .min(min),
        .hour(hour),
        .ctl_mode(ctl_mode),
        .ctl_time(ctl_time)
    );

    // =========================
    // VGA draw
    // =========================
    wire [5:0] rgb;

    vga_clock_draw U_DRAW (
        .hpos(hpos),
        .vpos(vpos),
        .display_on(display_on),
        .sec(sec),
        .min(min),
        .hour(hour),
        .ctl_mode(ctl_mode),
        .ctl_time(ctl_time),
        .rgb(rgb)
    );

    // =========================
    // Output (TT VGA mapping)
    // =========================
    assign uo_out[0] = rgb[5]; // R1
    assign uo_out[1] = rgb[3]; // G1
    assign uo_out[2] = rgb[1]; // B1
    assign uo_out[3] = vsync;
    assign uo_out[4] = rgb[4]; // R0
    assign uo_out[5] = rgb[2]; // G0
    assign uo_out[6] = rgb[0]; // B0
    assign uo_out[7] = hsync;

    // =========================
    // IO unused
    // =========================
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // =========================
    // unused 방지
    // =========================
    wire _unused = &{
        ena,
        uio_in,
        ui_in[7], ui_in[3:0],   // unused ui pins
        gp_present,
        gp_b, gp_y, gp_left, gp_right,
        gp_a, gp_x, gp_l, gp_r,
        1'b0
    };

endmodule
