module ram(
    input clk,
    input we,
    input [3:0] addr,
    input [7:0] data_in,
    output [7:0] data_out
);

    reg [7:0] ram_mem [0:15];

    always @(posedge clk) begin
        if (we) begin
            ram_mem[addr] <= data_in;
        end
    end

    assign data_out = ram_mem[addr];

endmodule
