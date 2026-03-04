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

