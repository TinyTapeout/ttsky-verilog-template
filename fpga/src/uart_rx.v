module uart_rx #(
    parameter CLKS_PER_BIT = 868 // 100 MHz / 115200 Baud
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg [7:0]  m_axis_tdata,
    output reg        m_axis_tvalid
);

    localparam S_IDLE = 0, S_START = 1, S_DATA = 2, S_STOP = 3;
    
    reg [1:0] state;
    reg [9:0] clk_cnt;
    reg [2:0] bit_cnt;
    
    // Double-register the async RX signal to prevent metastability
    reg rx_r, rx_rr;
    always @(posedge clk) begin
        rx_r  <= rx;
        rx_rr <= rx_r;
    end

    always @(posedge clk) begin
        if (rst) begin
            state         <= S_IDLE;
            m_axis_tvalid <= 1'b0;
            clk_cnt       <= 0;
            bit_cnt       <= 0;
            m_axis_tdata  <= 0;
        end else begin
            m_axis_tvalid <= 1'b0; // Default to 0, pulse high for 1 cycle when done
            
            case (state)
                S_IDLE: begin
                    if (rx_rr == 1'b0) begin // Start bit detected (RX goes low)
                        state   <= S_START;
                        clk_cnt <= CLKS_PER_BIT / 2; // Wait half a bit period to sample the middle
                    end
                end
                
                S_START: begin
                    if (clk_cnt > 0) begin
                        clk_cnt <= clk_cnt - 1;
                    end else begin
                        if (rx_rr == 1'b0) begin // Verify it's still a valid start bit
                            clk_cnt <= CLKS_PER_BIT - 1;
                            state   <= S_DATA;
                            bit_cnt <= 0;
                        end else begin
                            state <= S_IDLE; // False start, go back
                        end
                    end
                end
                
                S_DATA: begin
                    if (clk_cnt > 0) begin
                        clk_cnt <= clk_cnt - 1;
                    end else begin
                        clk_cnt               <= CLKS_PER_BIT - 1;
                        m_axis_tdata[bit_cnt] <= rx_rr;
                        
                        if (bit_cnt < 7) begin
                            bit_cnt <= bit_cnt + 1;
                        end else begin
                            state <= S_STOP;
                        end
                    end
                end
                
                S_STOP: begin
                    if (clk_cnt > 0) begin
                        clk_cnt <= clk_cnt - 1;
                    end else begin
                        m_axis_tvalid <= 1'b1; // Pulse valid data
                        state         <= S_IDLE;
                    end
                end
            endcase
        end
    end
endmodule