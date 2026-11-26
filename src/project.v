`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // [3:0] = x0, [7:4] = x1
    output wire [7:0] uo_out,   // Lower 8 bits of ReLU output
    input  wire [7:0] uio_in,   // [3:0] = w0, [7:4] = w1
    output wire [7:0] uio_out,  // Unused
    output wire [7:0] uio_oe,   // 0 = input mode
    input  wire       ena,      // Always 1 when powered
    input  wire       clk,      // Clock
    input  wire       rst_n     // Active-low reset
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Sign-extend 4-bit inputs/weights from chip pins into 8-bit Tensor Core lanes
    wire signed [7:0] x0 = {{4{ui_in[3]}},  ui_in[3:0]};
    wire signed [7:0] x1 = {{4{ui_in[7]}},  ui_in[7:4]};
    wire signed [7:0] w0 = {{4{uio_in[3]}}, uio_in[3:0]};
    wire signed [7:0] w1 = {{4{uio_in[7]}}, uio_in[7:4]};

    wire signed [19:0] acc;
    wire signed [19:0] relu_out;

    tensor_core_4x core (
        .clk(clk),
        .rst(~rst_n),
        .x0(x0), .x1(x1), .x2(x0), .x3(x1),
        .w0(w0), .w1(w1), .w2(w0), .w3(w1),
        .acc(acc),
        .relu_out(relu_out)
    );

    assign uo_out = relu_out[7:0];

    wire _unused = &{ena, acc, relu_out[19:8], 1'b0};

endmodule

module tensor_core_4x (
    input  wire               clk,
    input  wire               rst,
    input  wire signed [7:0]  x0, x1, x2, x3,
    input  wire signed [7:0]  w0, w1, w2, w3,
    output reg  signed [19:0] acc,
    output wire signed [19:0] relu_out
);
    wire signed [15:0] p0 = x0 * w0;
    wire signed [15:0] p1 = x1 * w1;
    wire signed [15:0] p2 = x2 * w2;
    wire signed [15:0] p3 = x3 * w3;

    wire signed [17:0] lane_sum = p0 + p1 + p2 + p3;

    always @(posedge clk) begin
        if (rst)
            acc <= 20'sd0;
        else
            acc <= acc + lane_sum;
    end

    assign relu_out = (acc < 0) ? 20'sd0 : acc;
endmodule
