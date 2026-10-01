`timescale 1ns / 1ps

module tb_uart_demo();

    // --- Clocks and Resets ---
    reg clk;
    reg rst;

    // --- UART Physical Lines ---
    reg host_tx;      // Connects to FPGA's uart_rx (PC sending to FPGA)
    wire fpga_tx;     // Connects to FPGA's uart_tx (FPGA sending to PC)
    
    // --- DUT Outputs ---
    wire [2:0] phase;
    wire busy;

    // --- Timing Parameters ---
    // 100 MHz clock = 10ns period
    // 115200 baud = ~8.68us per bit = 8681 ns
    localparam CLK_PERIOD = 10;
    localparam BIT_PERIOD = 8681; 

    // --- Instantiate the DUT (Device Under Test) ---
    uart_demo_top dut (
        .clk(clk),
        .rst(rst),
        .uart_rx(host_tx),
        .uart_tx(fpga_tx),
        .phase(phase),
        .busy(busy)
    );

    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; 
    end

    // --- UART Host Emulation Tasks ---
    // Task to send a byte to the FPGA
    task send_byte(input [7:0] data, input integer add_gap);
        integer i;
        begin
            // Start bit (pull low)
            host_tx = 0;
            #(BIT_PERIOD);
            
            // 8 Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                host_tx = data[i];
                #(BIT_PERIOD);
            end
            
            // Stop bit (pull high)
            host_tx = 1;
            #(BIT_PERIOD);
            
            // Small gap between bytes
            if (add_gap) #(BIT_PERIOD * 2);
        end
    endtask

    // Task to receive a byte from the FPGA
    task receive_byte(output [7:0] data);
        integer i;
        begin
            // Wait for start bit (falling edge)
            wait (fpga_tx == 1'b0);
            
            // Wait half a bit period to sample in the center of the pulse
            #(BIT_PERIOD / 2);
            
            // Verify we are still in start bit
            if (fpga_tx !== 1'b0) $display("Framing error: Start bit lost");
            
            // Read 8 Data bits
            for (i = 0; i < 8; i = i + 1) begin
                #(BIT_PERIOD);
                data[i] = fpga_tx;
            end
            
            // Wait for stop bit
            #(BIT_PERIOD);
        end
    endtask

    // --- Main Test Sequence ---
    reg [7:0] captured_lsb;
    reg [7:0] captured_msb;

    initial begin
        // Initialize lines
        host_tx = 1; // UART lines idle high
        rst = 1;
        
        // Hold reset for 100ns, then release
        #100;
        rst = 0;
        #500; // Wait a bit for subsystems to stabilize
        
        $display("--- Starting UART Write Test ---");
        // Sequence: CMD 0x01 (Write) -> Addr (0x05) -> LSB (0xBC) -> MSB (0x0A)
        // This writes 12-bit value 0x0ABC to address 5
        send_byte(8'h01, 1); 
        send_byte(8'h05, 1); 
        send_byte(8'hBC, 1); 
        send_byte(8'h0A, 1); 
        
        $display("--- Memory Write Complete. Starting UART Read Test ---");
        // Sequence: CMD 0x02 (Read) -> Addr (0x05)
        send_byte(8'h02, 1);
        send_byte(8'h05, 0);
        
        // Wait for the FPGA to respond with two bytes
        receive_byte(captured_lsb);
        $display("Received LSB: %h", captured_lsb);
        
        receive_byte(captured_msb);
        $display("Received MSB: %h", captured_msb);
        
        if ({captured_msb[3:0], captured_lsb} == 12'h0ABC)
            $display("SUCCESS: Data read matches data written!");
        else
            $display("FAIL: Data mismatch.");

        $display("--- Starting NTT Execution Test ---");
        // Sequence: CMD 0x03 (Start NTT)
        send_byte(8'h03, 0);
        
        // (Optional) Wait for ACK byte if you want to test the full pipeline
        // receive_byte(captured_lsb);
        // $display("Received ACK: %h", captured_lsb);

        #50000;
        $display("Simulation Complete.");
        $finish;
    end

endmodule