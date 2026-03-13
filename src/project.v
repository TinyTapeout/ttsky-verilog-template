module tt_um_alu4 (
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       clk,
    input  wire       rst_n
);

// We don't drive bidirectional pins in this design
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire [3:0] A      = ui_in[3:0];
    wire [3:0] B      = ui_in[7:4];
    wire [2:0] opcode = uio_in[2:0];
    wire       cin    = uio_in[3];

    reg  [3:0] R;
    reg        Z, N, C, V;

// combinational ALU core
    always @(*) begin
        R = 4'h0;
        Z = 1'b0;
        N = 1'b0;
        C = 1'b0;
        V = 1'b0;

        case (opcode)
            3'b000: begin // ADD
                {C, R} = A + B + cin;
                // signed overflow for add: if A and B same sign and R different sign
                V = (~(A[3] ^ B[3])) & (R[3] ^ A[3]);
            end
            3'b001: begin // SUB: A - B - cin
                // Use 5-bit math to detect borrow: if MSB carry out is 0, borrow occurred
                // Compute A + (~B) + (1 - cin)
                // Equivalent to A - B - cin
                {C, R} = {1'b0, A} + {1'b0, (~B)} + (5'd1 - {4'd0, cin});
                // Here C acts like "no borrow" (carry out from two's complement addition).
                // signed overflow for sub: if A and B different sign and R sign differs from A
                V = (A[3] ^ B[3]) & (R[3] ^ A[3]);
            end
            3'b010: begin // AND
                R = A & B;
            end
            3'b011: begin // OR
                R = A | B;
            end
            3'b100: begin // XOR
                R = A ^ B;
            end
            3'b101: begin // SHL
                C = A[3];
                R = A << 1;
            end
            3'b110: begin // SHR
                C = A[0];
                R = A >> 1;
            end
            3'b111: begin // PASS A
                R = A;
            end
            default: begin
                R = 4'h0;
            end
        endcase

        Z = (R == 4'h0);
        N = R[3];
    end

    // register outputs (TinyTapeout designs usually clock outputs)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out <= 8'h00;
        end else begin
            uo_out[3:0] <= R;
            uo_out[4]   <= Z;
            uo_out[5]   <= N;
            uo_out[6]   <= C;
            uo_out[7]   <= V;
        end
    end

endmodule
