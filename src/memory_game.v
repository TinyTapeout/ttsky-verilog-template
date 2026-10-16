module memory_game(
    input clk,
    input reset,

    // Modo de programacion de la memoria
    input prog_mode,          // 1 = programar RAM, 0 = jugar
    input we,
    input [3:0] prog_addr,
    input [7:0] prog_data,

    // Control del juego
    input start,
    input [1:0] player_input,
    input enter,

    // Salidas
    output reg [1:0] led_out,
    output reg show_valid,
    output reg correct,
    output reg error,
    output reg win,
    output reg [4:0] level,
    output [2:0] state_out
);

    // Estados de la maquina de estados
    localparam IDLE       = 3'd0;
    localparam SHOW       = 3'd1;
    localparam WAIT_INPUT = 3'd2;
    localparam CHECK      = 3'd3;
    localparam ERROR      = 3'd4;
    localparam WIN        = 3'd5;

    reg [2:0] state;
    reg [3:0] index;

    wire [3:0] ram_addr;
    wire [7:0] ram_data;

    // Cuando prog_mode = 1, la direccion viene desde fuera.
    // Cuando prog_mode = 0, la direccion la controla el juego.
    assign ram_addr = (prog_mode == 1'b1) ? prog_addr : index;

    ram sequence_ram(
        .clk(clk),
        .we((prog_mode == 1'b1) ? we : 1'b0),
        .addr(ram_addr),
        .data_in(prog_data),
        .data_out(ram_data)
    );

    assign state_out = state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            index <= 4'd0;
            level <= 5'd1;
            led_out <= 2'd0;
            show_valid <= 1'b0;
            correct <= 1'b0;
            error <= 1'b0;
            win <= 1'b0;
        end else begin

            // Valores por defecto para senales tipo pulso
            correct <= 1'b0;
            show_valid <= 1'b0;

            if (prog_mode == 1'b1) begin
                // Mientras se programa la memoria, el juego queda en espera.
                state <= IDLE;
                index <= 4'd0;
                led_out <= 2'd0;
                error <= 1'b0;
                win <= 1'b0;
                level <= 5'd1;
            end else begin

                case (state)

                    IDLE: begin
                        led_out <= 2'd0;
                        error <= 1'b0;
                        win <= 1'b0;
                        index <= 4'd0;

                        if (start == 1'b1) begin
                            level <= 5'd1;
                            state <= SHOW;
                        end
                    end

                    SHOW: begin
                        // Muestra la secuencia guardada en RAM.
                        led_out <= ram_data[1:0];
                        show_valid <= 1'b1;

                        if (index == level - 1'b1) begin
                            index <= 4'd0;
                            state <= WAIT_INPUT;
                        end else begin
                            index <= index + 1'b1;
                        end
                    end

                    WAIT_INPUT: begin
                        led_out <= 2'd0;

                        if (enter == 1'b1) begin
                            state <= CHECK;
                        end
                    end

                    CHECK: begin
                        if (player_input == ram_data[1:0]) begin
                            correct <= 1'b1;

                            if (index == level - 1'b1) begin
                                if (level == 5'd16) begin
                                    state <= WIN;
                                end else begin
                                    level <= level + 1'b1;
                                    index <= 4'd0;
                                    state <= SHOW;
                                end
                            end else begin
                                index <= index + 1'b1;
                                state <= WAIT_INPUT;
                            end

                        end else begin
                            state <= ERROR;
                        end
                    end

                    ERROR: begin
                        error <= 1'b1;
                        led_out <= 2'd0;
                    end

                    WIN: begin
                        win <= 1'b1;
                        led_out <= 2'd0;
                    end

                    default: begin
                        state <= IDLE;
                    end

                endcase
            end
        end
    end

endmodule
