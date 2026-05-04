module gamepad_button_pulse (
    input  wire clk,
    input  wire nrst,

    input  wire gp_start,
    input  wire gp_select,
    input  wire gp_up,
    input  wire gp_down,

    output wire [3:0] button
);

    reg [3:0] d;

    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            d <= 4'b0000;
        end else begin
            d <= {gp_down, gp_up, gp_select, gp_start};
        end
    end

    assign button[0] = gp_start  & ~d[0];
    assign button[1] = gp_select & ~d[1];
    assign button[2] = gp_up     & ~d[2];
    assign button[3] = gp_down   & ~d[3];

endmodule
