package riscvPkg;
   typedef enum logic [2:0] {FETCH, DECODE, EXECUTE, MEMORY, WRITEBACK, HALT} cpu_state;
   typedef enum logic [4:0] {ADD, SUB, AND, OR, XOR, ADDI, SUBI, ANDI, ORI, XORI, LW, SW, CMP, JE, JL, SHIFT} cpu_op;
   typedef enum logic [2:0] {ADDS, SUBS, ANDS, ORS, XORS} aluOp;

endpackage



