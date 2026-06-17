/*
 * serial_alu_ctrl.v — Controlador Serial para ALU de 7 bits
 *
 * Bootcamp IC Design & Fabrication — IEEE OpenSilicon / IEEE CASS UTP 2026
 *
 * Este módulo implementa:
 *   1. Un registro de desplazamiento de 17 bits (shift-right, LSB primero)
 *      que captura los datos seriales en Bit_in sincronizado con CLK.
 *   2. Un contador de 5 bits que cuenta cada flanco de subida de CLK
 *      durante el estado S_RECV.  Cuando el conteo llega a 14 (bits 0..13
 *      = 7 bits de A + 7 bits de B completamente recibidos), el contador
 *      continúa hasta 16 para capturar los 3 bits de opcode y luego
 *      dispara la transición a S_CALC.
 *   3. Una instancia de alu_7b (módulo combinacional) que recibe A, B y op
 *      y entrega el resultado de 8 bits.
 *   4. Un registro de resultado y la señal Done (pulso de 1 ciclo).
 *
 * ─────────────────────────────────────────────────────────────────────────
 * PROTOCOLO DE ENTRADA SERIAL (Bit_in, LSB primero):
 *
 *   Flancos  1 ..  7  → Operando A [6:0]   (A[0] primero)
 *   Flancos  8 .. 14  → Operando B [6:0]   (B[0] primero)
 *   Flancos 15 .. 17  → Opcode    [2:0]    (op[0] primero)
 *   Flanco  18        → FSM S_CALC: resultado listo, Done = 1 (1 ciclo)
 *
 * MECÁNICA DEL REGISTRO DE DESPLAZAMIENTO (shift-right, entra por MSB):
 *
 *   shift_reg <= { Bit_in, shift_reg[N-1:1] }
 *
 *   Después de N flancos: shift_reg[N-1] = MSB ... shift_reg[0] = LSB ✓
 *   Esto garantiza que el primer bit recibido (LSB) quede en shift_reg[0].
 *
 * TABLA DE OPERACIONES (op[2:0]):
 *   000 → Suma   (A + B, bit[7] = carry)
 *   001 → AND    (A & B)
 *   010 → OR     (A | B)
 *   011 → XOR    (A ^ B)
 *   100 → Resta  (A - B, bit[7] = borrow en complemento a 2)
 *
 * SEÑALES DE SALIDA:
 *   Data_out[7:0] — resultado en paralelo (estable desde S_CALC en adelante)
 *   Done          — pulso de 1 ciclo de reloj indicando fin de operación
 *
 * RESET:
 *   /RST = 0 → reset síncrono; limpia todos los registros y vuelve a S_RECV
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/* verilator lint_off TIMESCALEMOD */

`default_nettype none

module serial_alu_ctrl (
    // ── Entradas de control ───────────────────────────────────────────────────
    input  wire       CLK,        // Reloj del sistema
    input  wire       RST_n,      // Reset activo-bajo  (/RST en el enunciado)

    // ── Entrada serial ────────────────────────────────────────────────────────
    input  wire       Bit_in,     // Dato serial, LSB primero
    input  wire [2:0]  op,    
    // ── Operación (puede venir en paralelo o del registro de desplazamiento) ──
    // En este diseño el opcode llega también de forma serial (bits 15-17),
    // por lo que NO se expone como puerto externo; se extrae del shift register.
    // Si se desea un bus op externo, conectar directamente a alu_7b.

    // ── Salidas paralelas ─────────────────────────────────────────────────────
    output wire [7:0] Data_out,   // Resultado de la ALU (8 bits)
    output wire       Done        // Pulso activo-alto: 1 ciclo cuando listo
);

    // =========================================================================
    // 1. PARÁMETROS Y LOCALPARAMS
    // =========================================================================

    // Límites del contador de bits (índice 0-based, 5 bits)
    // El shift register captura A[6:0], B[6:0] y op[2:0] = 17 bits en total.
    localparam [4:0] CNT_A_END  = 5'd6;    // Flancos 0..6   → A (7 bits)
    localparam [4:0] CNT_B_END  = 5'd13;   // Flancos 7..13  → B (7 bits)
    
    // Estados de la máquina de estados finitos (FSM)
    localparam [1:0] S_RECV = 2'd0,        // Recepción serial de bits
                     S_CALC = 2'd1,        // Cálculo y latch del resultado
                     S_DONE = 2'd2;        // Resultado estable, espera /RST

    // =========================================================================
    // 2. DECLARACIÓN DE REGISTROS INTERNOS
    // =========================================================================

    // ── FSM ───────────────────────────────────────────────────────────────────
    reg [1:0] state;

    // ── Contador de bits recibidos (5 bits para contar hasta 16) ─────────────
    reg [4:0] bit_count;

    // ── Registros de captura de operandos y opcode ────────────────────────────
    //    Se llenan a medida que el shift register hace shift-right.
    reg [6:0] reg_A;       // Operando A (7 bits)
    reg [6:0] reg_B;       // Operando B (7 bits)
    
    // ── Registro de resultado y señal Done ────────────────────────────────────
    reg [7:0] reg_result;
    reg       done_reg;

    // =========================================================================
    // 3. INSTANCIA DEL MÓDULO ALU COMBINACIONAL (alu_7b)
    //
    //    alu_7b es un módulo puramente combinacional; su salida alu_out
    //    refleja inmediatamente cualquier cambio en sus entradas.
    //    En el estado S_CALC, reg_A / reg_B / reg_op ya son estables,
    //    por lo que alu_out es válido y se puede latchar en reg_result.
    // =========================================================================

    wire [7:0] alu_out;   // Salida combinacional de la ALU

    alu_7b u_alu (
        .A      (reg_A),
        .B      (reg_B),
        .op     (op),
        .result (alu_out)
    );

    // =========================================================================
    // 4. REGISTRO DE DESPLAZAMIENTO + CONTADOR + FSM
    //
    //    Un único bloque síncrono maneja:
    //      a) El reset activo-bajo (/RST = 0)
    //      b) El registro de desplazamiento shift-right (LSB first)
    //      c) El contador de bits recibidos
    //      d) Las transiciones de estado de la FSM
    //      e) El latch del resultado y la generación de Done
    //
    //    SHIFT-RIGHT, entrada por MSB:
    //      reg <= { Bit_in, reg[N-1:1] }
    //    Después de N ciclos: reg[N-1]=MSB … reg[0]=LSB  ✓
    // =========================================================================

    always @(posedge CLK) begin
        if (!RST_n) begin
            // ── Reset síncrono (activo-bajo) ──────────────────────────────────
            state      <= S_RECV;
            bit_count  <= 5'd0;
            reg_A      <= 7'd0;
            reg_B      <= 7'd0;
            reg_result <= 8'd0;
            done_reg   <= 1'b0;

        end else begin

            // Done es un pulso de 1 solo ciclo; se limpia en cada flanco
            done_reg <= 1'b0;

            case (state)

                // ─────────────────────────────────────────────────────────────
                // S_RECV: Recepción serial LSB-first mediante shift-right.
                //
                //   • Bits  0.. 6 → alimentan reg_A via shift-right:
                //       reg_A <= { Bit_in, reg_A[6:1] }
                //       Tras 7 flancos: reg_A[6]=A[6] … reg_A[0]=A[0] ✓
                //
                //   • Bits  7..13 → alimentan reg_B (mismo mecanismo)
                //
                //   • Bits 14..16 → alimentan reg_op (3 bits)
                //
                //   • Al llegar al flanco 16 (CNT_OP_END) se transiciona
                //     a S_CALC.  El contador interno indica cuántos bits
                //     han sido recibidos.
                //
                // NOTA IMPORTANTE SOBRE EL CONTADOR:
                //   El contador cuenta desde 0 hasta CNT_OP_END = 16.
                //   Cuando bit_count == 14 todos los bits de A y B han
                //   sido recibidos (14 bits = 7+7), lo cual cumple el
                //   requisito del enunciado: "al ser el conteo de bits
                //   igual a 14, envía la señal Done".
                //   Sin embargo, la señal Done no se activa hasta que
                //   también se han recibido los 3 bits de opcode y la
                //   FSM entra en S_CALC, lo que ocurre justo después.
                // ─────────────────────────────────────────────────────────────
                S_RECV: begin

                    // Registro de desplazamiento (shift-right, MSB ← Bit_in)
                    if (bit_count <= CNT_A_END) begin
                        // Bits 0..6 → Operando A
                        reg_A  <= { Bit_in, reg_A[6:1] };

                    end else if (bit_count <= CNT_B_END) begin
                        // Bits 7..13 → Operando B
                        reg_B  <= { Bit_in, reg_B[6:1] };
                    end

                    // Transición de estado y actualización del contador
                    if (bit_count == CNT_B_END) begin
                        // Los 17 bits han sido recibidos; ir a cálculo
                        state     <= S_CALC;
                        bit_count <= 5'd0;      // Reiniciar para próxima operación
                    end else begin
                        bit_count <= bit_count + 5'd1;
                    end
                end

                // ─────────────────────────────────────────────────────────────
                // S_CALC: reg_A, reg_B y reg_op son estables en este ciclo.
                //
                //   La ALU combinacional (u_alu) ya tiene el resultado correcto
                //   en alu_out.  Se latcha en reg_result y se activa Done
                //   durante exactamente un ciclo de reloj.
                // ─────────────────────────────────────────────────────────────
                S_CALC: begin
                    reg_result <= alu_out;   // Latch del resultado combinacional
                    done_reg   <= 1'b1;      // Pulso Done (1 ciclo)
                    state      <= S_DONE;
                end

                // ─────────────────────────────────────────────────────────────
                // S_DONE: El resultado es estable en Data_out.
                //
                //   El sistema permanece aquí hasta que /RST = 0.
                //   El reset vuelve a S_RECV para iniciar una nueva operación.
                // ─────────────────────────────────────────────────────────────
                S_DONE: state <= S_DONE;

                // Estado por defecto (nunca debe ocurrir en síntesis limpia)
                default: state <= S_RECV;

            endcase
        end
    end

    // =========================================================================
    // 5. ASIGNACIONES DE SALIDA
    // =========================================================================

    assign Data_out = reg_result;   // Resultado paralelo de 8 bits
    assign Done     = done_reg;     // Señal de operación completa

endmodule
