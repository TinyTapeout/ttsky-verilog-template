module tt_um_isalopez9_memory_game (
    input  [7:0] ui_in,
    output [7:0] uo_out,
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input        ena,
    input        clk,
    input        rst_n
);

    wire reset;
    wire prog_mode;
    wire we;
    wire start;
    wire enter;
    wire [3:0] prog_addr;
    wire [7:0] prog_data;
    wire [1:0] player_input;

    wire [1:0] led_out;
    wire show_valid;
    wire correct;
    wire error;
    wire win;
    wire [4:0] level;
    wire [2:0] state_out;

    assign reset = ~rst_n;

    // Entradas principales desde ui_in
    assign prog_mode = ui_in[0];
    assign we        = ui_in[1];
    assign start     = ui_in[2];
    assign enter     = ui_in[3];

    // Entrada del jugador desde ui_in[5:4]
    assign player_input = ui_in[5:4];

    // Direccion de programacion desde uio_in[3:0]
    assign prog_addr = uio_in[3:0];

    // Dato de programacion desde uio_in[7:0]
    assign prog_data = uio_in;

    memory_game game (
        .clk(clk),
        .reset(reset),
        .prog_mode(prog_mode),
        .we(we),
        .prog_addr(prog_addr),
        .prog_data(prog_data),
        .start(start),
        .player_input(player_input),
        .enter(enter),
        .led_out(led_out),
        .show_valid(show_valid),
        .correct(correct),
        .error(error),
        .win(win),
        .level(level),
        .state_out(state_out)
    );

    // Salidas principales
    assign uo_out[1:0] = led_out;
    assign uo_out[2]   = show_valid;
    assign uo_out[3]   = correct;
    assign uo_out[4]   = error;
    assign uo_out[5]   = win;
    assign uo_out[7:6] = state_out[1:0];

    // Salidas bidireccionales usadas como salida de debug
    assign uio_out = {3'b000, level};
    assign uio_oe = (prog_mode == 1'b1) ? 8'b00000000 : 8'b11111111;

    // Evita warning por ena si no se usa
    wire _unused;
    assign _unused = ena;

endmodule
