`timescale 1ns/1ps

module tb;

  reg  clk = 0;
  reg  rst_n = 0;

  reg  [7:0] ui_in;
  wire [7:0] uo_out;
  reg  [7:0] uio_in;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate DUT
  tt_um_alu4 dut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .clk(clk),
    .rst_n(rst_n)
  );

  // clock
  always #5 clk = ~clk;

  // compute expected outputs
  task automatic compute_expected(
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] opcode,
    input        cin,
    output [3:0] R,
    output       Z,
    output       N,
    output       C,
    output       V
  );
    reg [4:0] tmp;
    reg [4:0] tsub;
    begin
      R = 4'h0; Z = 0; N = 0; C = 0; V = 0;

      case (opcode)
        3'b000: begin // ADD
          tmp = A + B + cin;
          C = tmp[4];
          R = tmp[3:0];
          V = (~(A[3] ^ B[3])) & (R[3] ^ A[3]);
        end
        3'b001: begin // SUB: A - B - cin
          // A + (~B) + (1 - cin)
          tsub = {1'b0, A} + {1'b0, (~B)} + (5'd1 - {4'd0, cin});
          C = tsub[4];       // "no borrow" convention
          R = tsub[3:0];
          V = (A[3] ^ B[3]) & (R[3] ^ A[3]);
        end
        3'b010: begin R = A & B; end
        3'b011: begin R = A | B; end
        3'b100: begin R = A ^ B; end
        3'b101: begin C = A[3]; R = A << 1; end
        3'b110: begin C = A[0]; R = A >> 1; end
        3'b111: begin R = A; end
      endcase

      Z = (R == 4'h0);
      N = R[3];
    end
  endtask

  task automatic apply_and_check(
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    input       cin
  );
    reg [3:0] expR;
    reg expZ, expN, expC, expV;
    begin
      ui_in  = {B, A};
      uio_in = 8'h00;
      uio_in[2:0] = opcode;
      uio_in[3]   = cin;

      compute_expected(A, B, opcode, cin, expR, expZ, expN, expC, expV);

      // wait for registered output to update on next rising edge
      @(posedge clk);
      #1;

      if (uo_out[3:0] !== expR ||
          uo_out[4]   !== expZ ||
          uo_out[5]   !== expN ||
          uo_out[6]   !== expC ||
          uo_out[7]   !== expV) begin
        $display("FAIL A=%h B=%h op=%b cin=%b | got R=%h Z=%b N=%b C=%b V=%b | exp R=%h Z=%b N=%b C=%b V=%b",
                 A, B, opcode, cin,
                 uo_out[3:0], uo_out[4], uo_out[5], uo_out[6], uo_out[7],
                 expR, expZ, expN, expC, expV);
        $fatal;
      end
    end
  endtask

  integer a, b, op, ci;

  initial begin
    rst_n = 0;
    ui_in = 8'h00;
    #10 rst_n = 1;
    ui_in = 8'h12;
    #10;
    $display("uo_out = %h", uo_out);
    $finish;
    end

    // Directed edge cases
    apply_and_check(4'h0, 4'h0, 3'b000, 0); // 0+0
    apply_and_check(4'hF, 4'h1, 3'b000, 0); // carry out
    apply_and_check(4'h7, 4'h1, 3'b000, 0); // signed overflow
    apply_and_check(4'h8, 4'h8, 3'b001, 0); // overflow in sub cases
    apply_and_check(4'h0, 4'h1, 3'b001, 0); // borrow behavior
    apply_and_check(4'h8, 4'h0, 3'b101, 0); // SHL carry
    apply_and_check(4'h1, 4'h0, 3'b110, 0); // SHR carry

    // Broad randomized-ish exhaustive sweep (still small)
    for (op = 0; op < 8; op = op + 1) begin
      for (ci = 0; ci < 2; ci = ci + 1) begin
        for (a = 0; a < 16; a = a + 1) begin
          for (b = 0; b < 16; b = b + 1) begin
            apply_and_check(a[3:0], b[3:0], op[2:0], ci[0]);
          end
        end
      end
    end

    $display("PASS: All ALU tests passed.");
    $finish;
  end

endmodule
