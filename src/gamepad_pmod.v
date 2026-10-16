`timescale 1ns / 1ps

module gamepad_pmod_min (
    input wire rst_n,
    input wire clk,
    input wire pmod_data,
    input wire pmod_clk,
    input wire pmod_latch,

    output wire select,
    output wire start,
    output wire up,
    output wire down,
    output wire is_present
);

  wire [11:0] gamepad_pmod_data;
  wire reg_empty;

  gamepad_pmod_driver #(
      .BIT_WIDTH(12)
  ) driver (
      .rst_n(rst_n),
      .clk(clk),
      .pmod_data(pmod_data),
      .pmod_clk(pmod_clk),
      .pmod_latch(pmod_latch),
      .data_reg(gamepad_pmod_data)
  );

  assign reg_empty  = (gamepad_pmod_data == 12'hfff);
  assign is_present = ~reg_empty;
  assign select     = ~reg_empty & gamepad_pmod_data[9];
  assign start      = ~reg_empty & gamepad_pmod_data[8];
  assign up         = ~reg_empty & gamepad_pmod_data[7];
  assign down       = ~reg_empty & gamepad_pmod_data[6];

endmodule

module gamepad_pmod_driver #(
    parameter BIT_WIDTH = 12
) (
    input wire rst_n,
    input wire clk,
    input wire pmod_data,
    input wire pmod_clk,
    input wire pmod_latch,
    output reg [BIT_WIDTH-1:0] data_reg
);

  reg pmod_clk_prev;
  reg pmod_latch_prev;
  reg [BIT_WIDTH-1:0] shift_reg;

  reg [1:0] pmod_data_sync;
  reg [1:0] pmod_clk_sync;
  reg [1:0] pmod_latch_sync;

  always @(posedge clk) begin
    if (~rst_n) begin
      pmod_data_sync  <= 2'b0;
      pmod_clk_sync   <= 2'b0;
      pmod_latch_sync <= 2'b0;
    end else begin
      pmod_data_sync  <= {pmod_data_sync[0], pmod_data};
      pmod_clk_sync   <= {pmod_clk_sync[0], pmod_clk};
      pmod_latch_sync <= {pmod_latch_sync[0], pmod_latch};
    end
  end

  always @(posedge clk) begin
    if (~rst_n) begin
      data_reg <= {BIT_WIDTH{1'b1}};
      shift_reg <= {BIT_WIDTH{1'b1}};
      pmod_clk_prev <= 1'b0;
      pmod_latch_prev <= 1'b0;
    end else begin
      pmod_clk_prev   <= pmod_clk_sync[1];
      pmod_latch_prev <= pmod_latch_sync[1];

      if (pmod_latch_sync[1] & ~pmod_latch_prev) begin
        data_reg <= shift_reg;
      end

      if (pmod_clk_sync[1] & ~pmod_clk_prev) begin
        shift_reg <= {shift_reg[BIT_WIDTH-2:0], pmod_data_sync[1]};
      end
    end
  end

endmodule

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

