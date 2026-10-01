// Instead of generating the twiddle ROM coefficients in the Arty's BRAM blocks,
// we use a laptop that generates the twiddle ROM coefficients, stores locally inside 
// our laptop, then feed said coefficients into the forward NTT engine without needing 
// to store them on the FPGA. This would reduce computation time and we would mimic 
// how an FPGA would interface with the ASIC - ASIC receives coefficients from the FPGA 
// since we stored most of the coefficients off chip to conserve utilization area.
module uart_demo_top(
    input wire          clk,
    input wire          rst,
    input wire          uart_rx,
    output wire         uart_tx, 
    output wire [2:0]   phase,      // status LEDs
    output wire         busy
);

    // --- UART RX/TX instantiation (Assuming standard 8-n-1 open-source IP)
    wire [7:0]          rx_data;
    wire                rx_valid;
    reg                 tx_valid;
    reg [7:0]           tx_data;
    wire                tx_ready; 

    uart_rx u_uart_rx (.clk(clk), .rst(rst), .rx(uart_rx), .m_axis_tdata(rx_data), .m_axis_tvalid(rx_valid));
    
    
    uart_tx u_uart_tx (.clk(clk), .rst(rst), .tx(uart_tx), .s_axis_tdata(tx_data), .s_axis_tvalid(tx_valid), .s_axis_tready(tx_ready));

    // --- Shared Memory and Engines (identical to demo_top.v)
    wire [7:0]  mem_addr_a, mem_addr_b;
    wire        mem_we_a, mem_we_b;
    wire [11:0] mem_din_a, mem_din_b, mem_dout_a, mem_dout_b;

    coeff_mem u_mem (
        .clk(clk), .rst(rst), .addr_a(mem_addr_a), .addr_b(mem_addr_b),
        .we_a(mem_we_a), .we_b(mem_we_b), .din_a(mem_din_a), .din_b(mem_din_b),
        .dout_a(mem_dout_a), .dout_b(mem_dout_b)
    );

    // Control FSM instantiation: 
    reg [11:0] orig_mem [0:255];
    wire [11:0] orig_dout_c = orig_mem[ext_addr];

    // ---- forward (NTT) engine ----
    wire [7:0] fwd_addr_a, fwd_addr_b;
    wire       fwd_we, fwd_busy, fwd_done;
    wire [6:0] fwd_k;
    reg        fwd_start;

    control_fsm u_fwd_fsm (
        .clk (clk), .rst (rst), .start_i (fwd_start),
        .addr_a (fwd_addr_a), .addr_b (fwd_addr_b), .we (fwd_we), .k (fwd_k),
        .busy (fwd_busy), .done (fwd_done)
    );

    wire [11:0] fwd_zeta;
    twiddle_rom u_fwd_rom (.k (fwd_k), .zeta (fwd_zeta));

    wire [11:0] fwd_a_out, fwd_b_out;
    butterfly u_fwd_bf (
        .clk (clk),
        .a (mem_dout_a), .b (mem_dout_b), .zeta (fwd_zeta),
        .a_out (fwd_a_out), .b_out (fwd_b_out)
    );

    // INV Engine
    wire [7:0] inv_addr_a, inv_addr_b;
    wire       inv_we, inv_busy, inv_done, inv_scale_phase;
    wire [6:0] inv_k;
    reg        inv_start;
    wire [11:0] gs_a_out, gs_b_out, scale_out;

    intt_control_fsm u_inv_fsm (
        .clk (clk), .rst (rst), .start_i (inv_start),
        .addr_a (inv_addr_a), .addr_b (inv_addr_b), .we (inv_we), .k (inv_k),
        .scale_phase (inv_scale_phase), .busy (inv_busy), .done (inv_done)
    );

    wire [11:0] inv_zeta;
    twiddle_rom u_inv_rom (.k (inv_k), .zeta (inv_zeta));

    intt_butterfly u_inv_bf (
        .clk (clk),
        .a (mem_dout_a), .b (mem_dout_b), .zeta (inv_zeta),
        .a_out (gs_a_out), .b_out (gs_b_out)
    );

    localparam [11:0] N_INV = 12'd3303;   // 128^-1 mod 3329
    mod_mult u_scale (.clk (clk), .a (mem_dout_a), .b (N_INV), .c (scale_out));

    // --- UART Command FSM ---
    localparam S_IDLE=0, S_WR_ADDR=1, S_WR_LSB=2, S_WR_MSB=3;
    localparam S_RD_ADDR=4, S_RD_SEND_LSB=5, S_RD_SEND_MSB=6;
    localparam S_WAIT_NTT=7, S_WAIT_INTT=8, S_SEND_ACK=9;
    localparam S_RD_WAIT=10, S_RD_WAIT_MSB = 11;                //<-- wait one cycle between bytes s.t. tx_ready goes low again

    reg [3:0]   state; 
    reg [7:0]   ext_addr; 
    reg [7:0]   data_lsb;
    reg         ext_we; 
    reg [11:0]  ext_din;

    assign busy = fwd_busy | inv_busy;
    assign phase = state[2:0];

    always @(posedge clk) begin 
        if (rst) begin
            state <= S_IDLE;
            ext_we <= 0;
            fwd_start <= 0;
            inv_start <= 0;
            tx_valid <= 0;
        end else begin 
            ext_we <= 0;
            fwd_start <= 0; 
            inv_start <= 0; 
            tx_valid <= 0; 

            case (state)
                S_IDLE: begin 
                    if (rx_valid) begin 
                        if (rx_data == 8'h01) state <= S_WR_ADDR;
                        else if (rx_data == 8'h02) state <= S_RD_ADDR;
                        else if (rx_data == 8'h03) begin 
                            fwd_start <= 1; 
                            state     <= S_WAIT_NTT; 
                        end
                        else if (rx_data == 8'h04) begin 
                            inv_start <= 1; 
                            state     <= S_WAIT_INTT;
                        end
                    end
                end

                // Write Sequence 
                S_WR_ADDR: if (rx_valid) begin 
                    ext_addr <= rx_data;
                    state    <= S_WR_LSB; 
                end

                S_WR_LSB: if (rx_valid) begin 
                    data_lsb <= rx_data; 
                    state <= S_WR_MSB; 
                end
                
                S_WR_MSB: if (rx_valid) begin 
                    ext_din <= {rx_data[3:0], data_lsb};
                    ext_we  <= 1;       //Pulse Write Enable 
                    state <= S_IDLE; 
                end

                // Read Sequence (Note: mem_dout_a has 1 cycle latency, keep this in mind)
                S_RD_ADDR: if (rx_valid) begin 
                    ext_addr <= rx_data;
                    state    <= S_RD_WAIT;
                end

                S_RD_WAIT: state <= S_RD_SEND_LSB;

                S_RD_SEND_LSB: begin 
                    

                    // Wait until UART registers valid data: 
                    if (tx_ready) begin 
                        tx_data <= mem_dout_a[7:0];
                        tx_valid <= 1;                  // assert valid
                        state <= S_RD_WAIT_MSB;
                    end
                    
                end

                // 1 cycle pause allowing UART to pull tx_ready low while it transmits the LSB: 
                S_RD_WAIT_MSB: begin 
                    if (!tx_ready) begin 
                        state <= S_RD_SEND_MSB;
                    end
                end

                S_RD_SEND_MSB: if (tx_ready) begin
                    tx_data <= {4'h0, mem_dout_a[11:8]};
                    tx_valid <= 1; 
                    
                    state <= S_IDLE; 
                    
                end

                // Execution Sequences
                S_WAIT_NTT: if (fwd_done) state <= S_SEND_ACK; 
                S_WAIT_INTT: if (inv_done) state <= S_SEND_ACK;
                S_SEND_ACK: begin 
                    tx_data <= 8'hAA; 
                    tx_valid <= 1; 
                    if (tx_ready) begin 
                        state <= S_IDLE;
                    end
                     
                end
            endcase

        end
    end

    // Mux Memory Ports (Based on demo_top.v): 

    // Port A muxes: 
    assign mem_addr_a = fwd_busy ? fwd_addr_a : (inv_busy ? inv_addr_a : ext_addr);
    assign mem_we_a   = fwd_busy ? fwd_we     : (inv_busy ? inv_we     : ext_we);
    assign mem_din_a  = fwd_busy ? fwd_a_out  : (inv_busy ? (inv_scale_phase ? scale_out : gs_a_out) : ext_din);

    // Port B muxes: 
    assign mem_addr_b = fwd_busy ? fwd_addr_b : (inv_busy ? inv_addr_b : 8'd0);
    assign mem_we_b   = fwd_busy ? fwd_we     : (inv_busy ? (inv_we && !inv_scale_phase) : 1'b0);
    assign mem_din_b  = fwd_busy ? fwd_b_out  : gs_b_out;
    
endmodule