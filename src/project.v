/*
 * Copyright (c) 2024 Michael Bell
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_MichaelBell_tinyQV (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
/*verilator lint_off UNUSEDSIGNAL*/
    input  wire [7:0] uio_in,   // IOs: Input path - only some bits used
/*verilator lint_on UNUSEDSIGNAL*/
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
/*verilator lint_off UNUSEDSIGNAL*/
    input  wire       ena,
/*verilator lint_on UNUSEDSIGNAL*/
    input  wire       clk,
    input  wire       rst_n
);

    // Address to peripheral map
    localparam PERI_NONE = 4'hF;
    localparam PERI_GPIO_OUT = 4'h0;
    localparam PERI_GPIO_IN = 4'h1;
    localparam PERI_GPIO_OUT_SEL = 4'h3;
    localparam PERI_UART = 4'h4;
    localparam PERI_UART_STATUS = 4'h5;
    localparam PERI_DEBUG_UART = 4'h6;
    localparam PERI_DEBUG_UART_STATUS = 4'h7;
    localparam PERI_SPI = 4'h8;
    localparam PERI_SPI_STATUS = 4'h9;
    localparam PERI_DEBUG = 4'hC;

    // Register the reset on the negative edge of clock for safety.
    // This also allows the option of async reset in the design, which might be preferable in some cases
    /* verilator lint_off SYNCASYNCNET */
    reg rst_reg_n;
    /* verilator lint_on SYNCASYNCNET */
    always @(negedge clk) rst_reg_n <= rst_n;

    // Bidirs are used for SPI interface
    wire [3:0] qspi_data_in = {uio_in[5:4], uio_in[2:1]};
    wire [3:0] qspi_data_out;
    wire [3:0] qspi_data_oe;
    wire       qspi_clk_out;
    wire       qspi_flash_select;
    wire       qspi_ram_a_select;
    wire       qspi_ram_b_select;
    assign uio_out = {qspi_ram_b_select, qspi_ram_a_select, qspi_data_out[3:2], 
                      qspi_clk_out, qspi_data_out[1:0], qspi_flash_select};
    assign uio_oe = rst_n ? {2'b11, qspi_data_oe[3:2], 1'b1, qspi_data_oe[1:0], 1'b1} : 8'h00;

    wire [27:0] addr;
    wire  [1:0] write_n;
    wire  [1:0] read_n;
    wire        read_complete;
/*verilator lint_off UNUSEDSIGNAL*/
    wire [31:0] data_to_write;  // Currently only bottom byte used.
/*verilator lint_on UNUSEDSIGNAL*/

    wire        data_ready;
    reg [31:0] data_from_read;

    wire       debug_instr_complete;
    wire       debug_instr_ready;
    wire       debug_instr_valid;
    wire       debug_fetch_restart;
    wire       debug_data_ready;
    wire       debug_interrupt_pending;
    wire       debug_branch;
    wire       debug_early_branch;
    wire       debug_ret;
    wire       debug_reg_wen;
    wire       debug_counter_0;
    wire       debug_data_continue;
    wire       debug_stall_txn;
    wire       debug_stop_txn;
    wire [3:0] debug_rd;

    // Peripheral IOs on ui_in and uo_out
    wire       spi_miso  = ui_in[2];
    wire       uart_rxd  = ui_in[7];

    wire       spi_cs;
    wire       spi_sck;
    wire       spi_mosi;
    wire       spi_dc;
    wire       uart_txd;
    wire       uart_rts;
    wire       debug_uart_txd;
    wire       debug_signal;
    reg  [7:0] gpio_out_sel;
    reg  [7:0] gpio_out;

    // All transactions to peripherals complete immediately
    assign data_ready = 1'b1;
    reg [3:0] connect_peripheral;

    // Debug
    reg debug_register_data;
    reg [3:0] debug_rd_r;

    // UART
    wire uart_tx_busy;
    wire uart_rx_valid;
    wire [7:0] uart_rx_data;
    wire uart_tx_start = write_n != 2'b11 && connect_peripheral == PERI_UART;

    // Debug UART - runs fast to reduce the width of the count necessary for the divider!
    wire debug_uart_tx_busy;
    wire debug_uart_tx_start = write_n != 2'b11 && connect_peripheral == PERI_DEBUG_UART;

    // SPI
    wire spi_start = write_n != 2'b11 && connect_peripheral == PERI_SPI;
    wire [7:0] spi_data;
    wire spi_busy;

    // Interrupt requests
    reg [1:0] ui_in_reg;
    always @(posedge clk) begin
        ui_in_reg <= ui_in[1:0];
    end
    wire [3:0] interrupt_req = {!uart_tx_busy, uart_rx_valid, ui_in_reg[1:0]};

    tinyQV i_tinyqv(
        .clk(clk),
        .rstn(rst_reg_n),

        .data_addr(addr),
        .data_write_n(write_n),
        .data_read_n(read_n),
        .data_read_complete(read_complete),
        .data_out(data_to_write),

        .data_ready(data_ready),
        .data_in(data_from_read),

        .interrupt_req(interrupt_req),

        .spi_data_in(qspi_data_in),
        .spi_data_out(qspi_data_out),
        .spi_data_oe(qspi_data_oe),
        .spi_clk_out(qspi_clk_out),
        .spi_flash_select(qspi_flash_select),
        .spi_ram_a_select(qspi_ram_a_select),
        .spi_ram_b_select(qspi_ram_b_select),

        .debug_instr_complete(debug_instr_complete),
        .debug_instr_ready(debug_instr_ready),
        .debug_instr_valid(debug_instr_valid),
        .debug_fetch_restart(debug_fetch_restart),
        .debug_data_ready(debug_data_ready),
        .debug_interrupt_pending(debug_interrupt_pending),
        .debug_branch(debug_branch),
        .debug_early_branch(debug_early_branch),
        .debug_ret(debug_ret),
        .debug_reg_wen(debug_reg_wen),
        .debug_counter_0(debug_counter_0),
        .debug_data_continue(debug_data_continue),
        .debug_stall_txn(debug_stall_txn),
        .debug_stop_txn(debug_stop_txn),
        .debug_rd(debug_rd)
    );

    assign uo_out[0] = gpio_out_sel[0] ? gpio_out[0] : uart_txd;
    assign uo_out[1] = gpio_out_sel[1] ? gpio_out[1] : uart_rts;
    assign uo_out[2] = gpio_out_sel[2] ? gpio_out[2] : 
                       debug_register_data ? debug_rd_r[0] : spi_dc;
    assign uo_out[3] = gpio_out_sel[3] ? gpio_out[3] : 
                       debug_register_data ? debug_rd_r[1] : spi_mosi;
    assign uo_out[4] = gpio_out_sel[4] ? gpio_out[4] : 
                       debug_register_data ? debug_rd_r[2] : spi_cs;
    assign uo_out[5] = gpio_out_sel[5] ? gpio_out[5] : 
                       debug_register_data ? debug_rd_r[3] : spi_sck;
    assign uo_out[6] = gpio_out_sel[6] ? gpio_out[6] : debug_uart_txd;
    assign uo_out[7] = gpio_out_sel[7] ? gpio_out[7] : debug_signal;

    always @(*) begin
        if ({addr[27:6], addr[1:0]} == 24'h800000) 
            connect_peripheral = addr[5:2];
        else
            connect_peripheral = PERI_NONE;
    end

    // Read data
    always @(*) begin
        case (connect_peripheral)
            PERI_GPIO_OUT:    data_from_read = {24'h0, uo_out};
            PERI_GPIO_IN:     data_from_read = {24'h0, ui_in};
            PERI_GPIO_OUT_SEL:data_from_read = {24'h0, gpio_out_sel};
            PERI_UART:        data_from_read = {24'h0, uart_rx_data};
            PERI_UART_STATUS: data_from_read = {30'h0, uart_rx_valid, uart_tx_busy};
            PERI_DEBUG_UART_STATUS: data_from_read = {31'h0, debug_uart_tx_busy};
            PERI_SPI:         data_from_read = {24'h0, spi_data};
            PERI_SPI_STATUS:  data_from_read = {31'h0, spi_busy};
            default:          data_from_read = 32'hFFFF_FFFF;
        endcase
    end

    // GPIO Out
    always @(posedge clk) begin
        if (!rst_reg_n) begin
            gpio_out_sel <= {!ui_in[4], 7'b0000000};
            gpio_out <= 0;
        end
        if (write_n != 2'b11) begin
            if (connect_peripheral == PERI_GPIO_OUT) gpio_out <= data_to_write[7:0];
            if (connect_peripheral == PERI_GPIO_OUT_SEL) gpio_out_sel <= data_to_write[7:0];
        end
    end

    // Debug
    always @(posedge clk) begin
        if (!rst_reg_n)
            debug_register_data <= ui_in[3];
        else if (connect_peripheral == PERI_DEBUG)
            debug_register_data <= data_to_write[0];
    end

    always @(posedge clk) begin
        debug_rd_r <= debug_rd;
    end

    reg [15:0] debug_signals;
    always @(*) begin
        debug_signals  = {debug_instr_complete,
                          debug_instr_ready,
                          debug_instr_valid,
                          debug_fetch_restart,
                          read_n != 2'b11,
                          write_n != 2'b11,
                          debug_data_ready,
                          debug_interrupt_pending,
                          debug_branch,
                          debug_early_branch,
                          debug_ret,
                          debug_reg_wen,
                          debug_counter_0,
                          debug_data_continue,
                          debug_stall_txn,
                          debug_stop_txn};
    end
    assign debug_signal = debug_signals[ui_in[6:3]];

endmodule