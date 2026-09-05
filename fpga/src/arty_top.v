// Top-level module for the Arty A7-100T development board.
// Interfaces the physical pins to the UART-enabled interactive NTT demonstration.
module arty_top (
    input  wire       CLK100MHZ,
    input  wire [1:0] BTN,           // BTN[0] = unused, BTN[1] = reset
    output wire [3:0] LED,
    input  wire       uart_rx,  // Arty USB UART RX
    output wire       uart_tx    // Arty USB UART TX
);

    wire clk = CLK100MHZ;
    localparam BUSY_STRETCH_CYCLES = 27'd10_000_000; // ~100ms stretch at 100MHz

    // --- Reset Synchronizer / Debouncer ---
    reg [1:0] rst_sync;
    always @(posedge clk) begin
        rst_sync <= {rst_sync[0], BTN[1]};
    end
    wire rst = rst_sync[1]; 

    // --- Interactive UART Demo Instantiation ---
    wire [2:0] fsm_phase;
    wire       busy;

    uart_demo_top u_demo (
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .phase(fsm_phase), // Can be routed to a Pmod 7-segment later
        .busy(busy)
    );

    // ========================================================
    // --- LED Visualizations ---
    // ========================================================

    // ---- LED[0]: UART RX Activity ----
    // Flickers rapidly when the laptop is streaming coefficients
    assign LED[0] = ~uart_rx; 

    // ---- LED[1]: Busy, stretched to be humanly visible ----
    wire busy_led;
    pulse_stretch #(.STRETCH_CYCLES(BUSY_STRETCH_CYCLES)) u_busy_stretch (
        .clk           (clk),
        .rst           (rst),
        .in_level      (busy),
        .out_stretched (busy_led)
    );

    // ---- LED[2]: Toggles once per completed run ----
    // Edge detector to toggle when 'busy' falls from 1 to 0
    reg busy_d1;
    reg run_toggle;
    always @(posedge clk) begin
        if (rst) begin
            busy_d1    <= 1'b0;
            run_toggle <= 1'b0;
        end else begin
            busy_d1 <= busy;
            if (busy_d1 && !busy) begin // Falling edge of busy
                run_toggle <= ~run_toggle;
            end
        end
    end

    // ---- LED[3]: Free-running ~0.75Hz heartbeat ----
    reg [26:0] heartbeat_cnt;
    always @(posedge clk) begin
        if (rst) heartbeat_cnt <= 27'd0;
        else     heartbeat_cnt <= heartbeat_cnt + 1'b1;
    end

    assign LED[1] = busy_led;
    assign LED[2] = run_toggle;
    assign LED[3] = heartbeat_cnt[26];

endmodule