module uart_tx #(
    parameter CLKS_PER_BIT = 868 // 100 MHz / 115200 Baud
)(
    input  wire       clk,
    input  wire       rst,
    output reg        tx,
    input  wire [7:0] s_axis_tdata,
    input  wire       s_axis_tvalid,
    output reg        s_axis_tready
);

    localparam S_IDLE = 0, S_START = 1, S_DATA = 2, S_STOP = 3;
    
    reg [1:0] state;
    reg [9:0] clk_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] tx_data;

    always @(posedge clk) begin
        if (rst) begin
            state         <= S_IDLE;
            tx            <= 1'b1; // TX idles high
            s_axis_tready <= 1'b0;
            clk_cnt       <= 0;
            bit_cnt       <= 0;
            tx_data       <= 0;
        end else begin
            s_axis_tready <= 1'b0; // Default off
            
            case (state)
                S_IDLE: begin
                    tx            <= 1'b1;
                    s_axis_tready <= 1'b1; // Ready to accept new data
                    
                    if (s_axis_tvalid) begin
                        tx_data       <= s_axis_tdata;
                        s_axis_tready <= 1'b0;
                        state         <= S_START;
                        clk_cnt       <= 0;
                    end
                end
                
                S_START: begin
                    tx <= 1'b0; // Drive TX low for start bit
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state   <= S_DATA;
                        bit_cnt <= 0;
                    end
                end
                
                S_DATA: begin
                    tx <= tx_data[bit_cnt]; // Drive data bits LSB first
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (bit_cnt < 7) begin
                            bit_cnt <= bit_cnt + 1;
                        end else begin
                            state <= S_STOP;
                        end
                    end
                end
                
                S_STOP: begin
                    tx <= 1'b1; // Drive TX high for stop bit
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state   <= S_IDLE;
                    end
                end
            endcase
        end
    end
endmodule