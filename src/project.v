`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  // Reset activo en bajo → lo invertimos
  wire rst = ~rst_n;

  // Cable conecta la instancia al los terminales
  wire [3:0] count;

  // INSTANCIA DEL CONTADOR
  contador my_counter (
      .clk(clk),
      .rst(rst),
      .count(count)
  );

  // Salidas hacia los pines del chip
  assign uo_out[3:0] = count;
  assign uo_out[7:4] = 0;

  // No usamos IOs bidireccionales
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Evitar warnings
  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule