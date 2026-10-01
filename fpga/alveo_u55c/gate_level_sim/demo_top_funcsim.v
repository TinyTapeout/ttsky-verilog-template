// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Fri Aug 21 16:55:15 2026
// Host        : coder-mboudames-tt26 running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim ./demo_top_funcsim.v
// Design      : demo_top
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcu55c-fsvh2892-2L-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module butterfly
   (Q,
    DINADIN,
    \c_r_reg[9] ,
    \c_r_reg[7] ,
    clk_IBUF_BUFG,
    DOUTADOUT,
    DSP_ALU_INST,
    DI,
    S,
    mem_reg_bram_0,
    DOUTBDOUT,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1);
  output [9:0]Q;
  output [11:0]DINADIN;
  output [0:0]\c_r_reg[9] ;
  output [6:0]\c_r_reg[7] ;
  input clk_IBUF_BUFG;
  input [11:0]DOUTADOUT;
  input [11:0]DSP_ALU_INST;
  input [5:0]DI;
  input [0:0]S;
  input [3:0]mem_reg_bram_0;
  input [10:0]DOUTBDOUT;
  input [0:0]mem_reg_bram_0_0;
  input [11:0]mem_reg_bram_0_1;

  wire [5:0]DI;
  wire [11:0]DINADIN;
  wire [11:0]DOUTADOUT;
  wire [10:0]DOUTBDOUT;
  wire [11:0]DSP_ALU_INST;
  wire [9:0]Q;
  wire [0:0]S;
  wire [6:0]\c_r_reg[7] ;
  wire [0:0]\c_r_reg[9] ;
  wire clk_IBUF_BUFG;
  wire [3:0]mem_reg_bram_0;
  wire [0:0]mem_reg_bram_0_0;
  wire [11:0]mem_reg_bram_0_1;
  wire u_mult_n_0;
  wire u_mult_n_1;
  wire u_mult_n_15;
  wire u_mult_n_2;
  wire u_mult_n_20;
  wire u_mult_n_21;
  wire u_mult_n_22;
  wire u_mult_n_23;
  wire u_mult_n_24;
  wire u_mult_n_25;
  wire u_mult_n_26;
  wire u_mult_n_27;
  wire u_mult_n_3;
  wire u_mult_n_4;
  wire u_sub_n_0;
  wire u_sub_n_1;
  wire u_sub_n_13;
  wire u_sub_n_2;
  wire u_sub_n_3;
  wire u_sub_n_4;

  mod_mult_3 u_mult
       (.DI(u_mult_n_15),
        .DINADIN(DINADIN[11:8]),
        .DOUTADOUT(DOUTADOUT),
        .DOUTBDOUT(DOUTBDOUT),
        .DSP_ALU_INST(DSP_ALU_INST),
        .O({u_sub_n_0,u_sub_n_1,u_sub_n_2,u_sub_n_3,u_sub_n_4}),
        .Q(Q),
        .S({u_mult_n_0,u_mult_n_1,u_mult_n_2,u_mult_n_3,u_mult_n_4}),
        .\c_r_reg[6]_0 ({u_mult_n_21,u_mult_n_22,u_mult_n_23,u_mult_n_24,u_mult_n_25,u_mult_n_26,u_mult_n_27}),
        .\c_r_reg[7]_0 (\c_r_reg[7] ),
        .\c_r_reg[9]_0 (\c_r_reg[9] ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .diff_carry__0(u_mult_n_20),
        .mem_reg_bram_0(mem_reg_bram_0_0),
        .mem_reg_bram_0_0(mem_reg_bram_0_1[11:8]),
        .mem_reg_bram_0_1(u_sub_n_13),
        .mem_reg_bram_0_i_110(DI[0]));
  mod_sub_4 u_sub
       (.DI({DI[5:1],u_mult_n_15,Q[1],DI[0]}),
        .DINADIN(DINADIN[7:0]),
        .O({u_sub_n_0,u_sub_n_1,u_sub_n_2,u_sub_n_3,u_sub_n_4}),
        .S({u_mult_n_21,u_mult_n_22,u_mult_n_23,u_mult_n_24,u_mult_n_25,u_mult_n_26,u_mult_n_27,S}),
        .\c_r_reg[1] (u_sub_n_13),
        .mem_reg_bram_0(mem_reg_bram_0),
        .mem_reg_bram_0_0({u_mult_n_0,u_mult_n_1,u_mult_n_2,u_mult_n_3,u_mult_n_4}),
        .mem_reg_bram_0_1(u_mult_n_20),
        .mem_reg_bram_0_2(mem_reg_bram_0_0),
        .mem_reg_bram_0_3(mem_reg_bram_0_1[7:0]));
endmodule

module coeff_mem
   (DOUTADOUT,
    DOUTBDOUT,
    ext_dout_OBUF,
    DI,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    mem_reg_bram_0_2,
    mem_reg_bram_0_3,
    \load_i_reg[7] ,
    \FSM_onehot_state_reg[4] ,
    \FSM_onehot_state_reg[3] ,
    \FSM_onehot_state_reg[5] ,
    \cmp_i_reg[4] ,
    \FSM_onehot_state_reg[2] ,
    \load_i_reg[3] ,
    \FSM_onehot_state_reg[1] ,
    \FSM_onehot_state_reg[3]_0 ,
    \FSM_onehot_state_reg[4]_0 ,
    \FSM_onehot_state_reg[5]_0 ,
    \load_i_reg[6] ,
    \FSM_onehot_state_reg[3]_1 ,
    diff_carry__0,
    diff_carry__0_0,
    S,
    \FSM_onehot_state_reg[0] ,
    \FSM_onehot_state_reg[4]_1 ,
    mem_reg_bram_0_4,
    clk_IBUF_BUFG,
    ADDRARDADDR,
    ADDRBWRADDR,
    DINADIN,
    WEA,
    WEBWE,
    \ext_dout_OBUF[0]_inst_i_1_0 ,
    \ext_dout_OBUF[0]_inst_i_1_1 ,
    ext_addr_IBUF,
    \ext_dout_OBUF[0]_inst_i_1_2 ,
    \ext_dout_OBUF[0]_inst_i_1_3 ,
    \ext_dout_OBUF[1]_inst_i_1_0 ,
    \ext_dout_OBUF[1]_inst_i_1_1 ,
    \ext_dout_OBUF[1]_inst_i_1_2 ,
    \ext_dout_OBUF[1]_inst_i_1_3 ,
    \ext_dout_OBUF[2]_inst_i_1_0 ,
    \ext_dout_OBUF[2]_inst_i_1_1 ,
    \ext_dout_OBUF[2]_inst_i_1_2 ,
    \ext_dout_OBUF[2]_inst_i_1_3 ,
    \ext_dout_OBUF[3]_inst_i_1_0 ,
    \ext_dout_OBUF[3]_inst_i_1_1 ,
    \ext_dout_OBUF[3]_inst_i_1_2 ,
    \ext_dout_OBUF[3]_inst_i_1_3 ,
    \ext_dout_OBUF[4]_inst_i_1_0 ,
    \ext_dout_OBUF[4]_inst_i_1_1 ,
    \ext_dout_OBUF[4]_inst_i_1_2 ,
    \ext_dout_OBUF[4]_inst_i_1_3 ,
    \ext_dout_OBUF[5]_inst_i_1_0 ,
    \ext_dout_OBUF[5]_inst_i_1_1 ,
    \ext_dout_OBUF[5]_inst_i_1_2 ,
    \ext_dout_OBUF[5]_inst_i_1_3 ,
    \ext_dout_OBUF[6]_inst_i_1_0 ,
    \ext_dout_OBUF[6]_inst_i_1_1 ,
    \ext_dout_OBUF[6]_inst_i_1_2 ,
    \ext_dout_OBUF[6]_inst_i_1_3 ,
    \ext_dout_OBUF[7]_inst_i_1_0 ,
    \ext_dout_OBUF[7]_inst_i_1_1 ,
    \ext_dout_OBUF[7]_inst_i_1_2 ,
    \ext_dout_OBUF[7]_inst_i_1_3 ,
    \ext_dout_OBUF[8]_inst_i_1_0 ,
    \ext_dout_OBUF[8]_inst_i_1_1 ,
    \ext_dout_OBUF[8]_inst_i_1_2 ,
    \ext_dout_OBUF[8]_inst_i_1_3 ,
    \ext_dout_OBUF[9]_inst_i_1_0 ,
    \ext_dout_OBUF[9]_inst_i_1_1 ,
    \ext_dout_OBUF[9]_inst_i_1_2 ,
    \ext_dout_OBUF[9]_inst_i_1_3 ,
    \ext_dout_OBUF[10]_inst_i_1_0 ,
    \ext_dout_OBUF[10]_inst_i_1_1 ,
    \ext_dout_OBUF[10]_inst_i_1_2 ,
    \ext_dout_OBUF[10]_inst_i_1_3 ,
    \ext_dout_OBUF[11]_inst_i_1_0 ,
    \ext_dout_OBUF[11]_inst_i_1_1 ,
    \ext_dout_OBUF[11]_inst_i_1_2 ,
    \ext_dout_OBUF[11]_inst_i_1_3 ,
    mismatch_i_4_0,
    mismatch_i_4_1,
    Q,
    mismatch_i_4_2,
    mismatch_i_4_3,
    mismatch_i_4_4,
    mismatch_i_4_5,
    mismatch_i_4_6,
    mismatch_i_4_7,
    mismatch_i_4_8,
    mismatch_i_4_9,
    mismatch_i_4_10,
    mismatch_i_4_11,
    mismatch_i_3_0,
    mismatch_i_3_1,
    mismatch_i_3_2,
    mismatch_i_3_3,
    mismatch_i_3_4,
    mismatch_i_3_5,
    mismatch_i_3_6,
    mismatch_i_3_7,
    mismatch_i_3_8,
    mismatch_i_3_9,
    mismatch_i_3_10,
    mismatch_i_3_11,
    mismatch_i_6_0,
    mismatch_i_6_1,
    mismatch_i_6_2,
    mismatch_i_6_3,
    mismatch_i_6_4,
    mismatch_i_6_5,
    mismatch_i_6_6,
    mismatch_i_6_7,
    mismatch_i_6_8,
    mismatch_i_6_9,
    mismatch_i_6_10,
    mismatch_i_6_11,
    mismatch_i_5_0,
    mismatch_i_5_1,
    mismatch_i_5_2,
    mismatch_i_5_3,
    mismatch_i_5_4,
    mismatch_i_5_5,
    mismatch_i_5_6,
    mismatch_i_5_7,
    mismatch_i_5_8,
    mismatch_i_5_9,
    mismatch_i_5_10,
    mismatch_i_5_11,
    ext_addr_sel_IBUF,
    mem_reg_bram_0_5,
    mem_reg_bram_0_i_146_0,
    mem_reg_bram_0_6,
    mem_reg_bram_0_7,
    load_val,
    mem_reg_bram_0_8,
    mem_reg_bram_0_9,
    mem_reg_bram_0_10,
    mem_reg_bram_0_11,
    mem_reg_bram_0_12,
    mem_reg_bram_0_13,
    mem_reg_bram_0_14,
    mem_reg_bram_0_15,
    mem_reg_bram_0_16,
    O,
    T_r_reg_i_5,
    mem_reg_bram_0_i_178_0,
    mem_reg_bram_0_i_154_0,
    mem_reg_bram_0_17,
    mem_reg_bram_0_i_153_0,
    start_i_IBUF,
    mismatch_reg,
    mismatch_reg_0);
  output [11:0]DOUTADOUT;
  output [11:0]DOUTBDOUT;
  output [11:0]ext_dout_OBUF;
  output [4:0]DI;
  output [3:0]mem_reg_bram_0_0;
  output [5:0]mem_reg_bram_0_1;
  output [3:0]mem_reg_bram_0_2;
  output [4:0]mem_reg_bram_0_3;
  output \load_i_reg[7] ;
  output \FSM_onehot_state_reg[4] ;
  output \FSM_onehot_state_reg[3] ;
  output \FSM_onehot_state_reg[5] ;
  output \cmp_i_reg[4] ;
  output \FSM_onehot_state_reg[2] ;
  output \load_i_reg[3] ;
  output \FSM_onehot_state_reg[1] ;
  output \FSM_onehot_state_reg[3]_0 ;
  output \FSM_onehot_state_reg[4]_0 ;
  output \FSM_onehot_state_reg[5]_0 ;
  output \load_i_reg[6] ;
  output \FSM_onehot_state_reg[3]_1 ;
  output [3:0]diff_carry__0;
  output diff_carry__0_0;
  output [7:0]S;
  output \FSM_onehot_state_reg[0] ;
  output \FSM_onehot_state_reg[4]_1 ;
  output [0:0]mem_reg_bram_0_4;
  input clk_IBUF_BUFG;
  input [7:0]ADDRARDADDR;
  input [7:0]ADDRBWRADDR;
  input [11:0]DINADIN;
  input [0:0]WEA;
  input [0:0]WEBWE;
  input \ext_dout_OBUF[0]_inst_i_1_0 ;
  input \ext_dout_OBUF[0]_inst_i_1_1 ;
  input [5:0]ext_addr_IBUF;
  input \ext_dout_OBUF[0]_inst_i_1_2 ;
  input \ext_dout_OBUF[0]_inst_i_1_3 ;
  input \ext_dout_OBUF[1]_inst_i_1_0 ;
  input \ext_dout_OBUF[1]_inst_i_1_1 ;
  input \ext_dout_OBUF[1]_inst_i_1_2 ;
  input \ext_dout_OBUF[1]_inst_i_1_3 ;
  input \ext_dout_OBUF[2]_inst_i_1_0 ;
  input \ext_dout_OBUF[2]_inst_i_1_1 ;
  input \ext_dout_OBUF[2]_inst_i_1_2 ;
  input \ext_dout_OBUF[2]_inst_i_1_3 ;
  input \ext_dout_OBUF[3]_inst_i_1_0 ;
  input \ext_dout_OBUF[3]_inst_i_1_1 ;
  input \ext_dout_OBUF[3]_inst_i_1_2 ;
  input \ext_dout_OBUF[3]_inst_i_1_3 ;
  input \ext_dout_OBUF[4]_inst_i_1_0 ;
  input \ext_dout_OBUF[4]_inst_i_1_1 ;
  input \ext_dout_OBUF[4]_inst_i_1_2 ;
  input \ext_dout_OBUF[4]_inst_i_1_3 ;
  input \ext_dout_OBUF[5]_inst_i_1_0 ;
  input \ext_dout_OBUF[5]_inst_i_1_1 ;
  input \ext_dout_OBUF[5]_inst_i_1_2 ;
  input \ext_dout_OBUF[5]_inst_i_1_3 ;
  input \ext_dout_OBUF[6]_inst_i_1_0 ;
  input \ext_dout_OBUF[6]_inst_i_1_1 ;
  input \ext_dout_OBUF[6]_inst_i_1_2 ;
  input \ext_dout_OBUF[6]_inst_i_1_3 ;
  input \ext_dout_OBUF[7]_inst_i_1_0 ;
  input \ext_dout_OBUF[7]_inst_i_1_1 ;
  input \ext_dout_OBUF[7]_inst_i_1_2 ;
  input \ext_dout_OBUF[7]_inst_i_1_3 ;
  input \ext_dout_OBUF[8]_inst_i_1_0 ;
  input \ext_dout_OBUF[8]_inst_i_1_1 ;
  input \ext_dout_OBUF[8]_inst_i_1_2 ;
  input \ext_dout_OBUF[8]_inst_i_1_3 ;
  input \ext_dout_OBUF[9]_inst_i_1_0 ;
  input \ext_dout_OBUF[9]_inst_i_1_1 ;
  input \ext_dout_OBUF[9]_inst_i_1_2 ;
  input \ext_dout_OBUF[9]_inst_i_1_3 ;
  input \ext_dout_OBUF[10]_inst_i_1_0 ;
  input \ext_dout_OBUF[10]_inst_i_1_1 ;
  input \ext_dout_OBUF[10]_inst_i_1_2 ;
  input \ext_dout_OBUF[10]_inst_i_1_3 ;
  input \ext_dout_OBUF[11]_inst_i_1_0 ;
  input \ext_dout_OBUF[11]_inst_i_1_1 ;
  input \ext_dout_OBUF[11]_inst_i_1_2 ;
  input \ext_dout_OBUF[11]_inst_i_1_3 ;
  input mismatch_i_4_0;
  input mismatch_i_4_1;
  input [1:0]Q;
  input mismatch_i_4_2;
  input mismatch_i_4_3;
  input mismatch_i_4_4;
  input mismatch_i_4_5;
  input mismatch_i_4_6;
  input mismatch_i_4_7;
  input mismatch_i_4_8;
  input mismatch_i_4_9;
  input mismatch_i_4_10;
  input mismatch_i_4_11;
  input mismatch_i_3_0;
  input mismatch_i_3_1;
  input mismatch_i_3_2;
  input mismatch_i_3_3;
  input mismatch_i_3_4;
  input mismatch_i_3_5;
  input mismatch_i_3_6;
  input mismatch_i_3_7;
  input mismatch_i_3_8;
  input mismatch_i_3_9;
  input mismatch_i_3_10;
  input mismatch_i_3_11;
  input mismatch_i_6_0;
  input mismatch_i_6_1;
  input mismatch_i_6_2;
  input mismatch_i_6_3;
  input mismatch_i_6_4;
  input mismatch_i_6_5;
  input mismatch_i_6_6;
  input mismatch_i_6_7;
  input mismatch_i_6_8;
  input mismatch_i_6_9;
  input mismatch_i_6_10;
  input mismatch_i_6_11;
  input mismatch_i_5_0;
  input mismatch_i_5_1;
  input mismatch_i_5_2;
  input mismatch_i_5_3;
  input mismatch_i_5_4;
  input mismatch_i_5_5;
  input mismatch_i_5_6;
  input mismatch_i_5_7;
  input mismatch_i_5_8;
  input mismatch_i_5_9;
  input mismatch_i_5_10;
  input mismatch_i_5_11;
  input ext_addr_sel_IBUF;
  input [5:0]mem_reg_bram_0_5;
  input [9:0]mem_reg_bram_0_i_146_0;
  input [5:0]mem_reg_bram_0_6;
  input [0:0]mem_reg_bram_0_7;
  input [5:0]load_val;
  input mem_reg_bram_0_8;
  input mem_reg_bram_0_9;
  input mem_reg_bram_0_10;
  input mem_reg_bram_0_11;
  input [11:0]mem_reg_bram_0_12;
  input [1:0]mem_reg_bram_0_13;
  input mem_reg_bram_0_14;
  input mem_reg_bram_0_15;
  input mem_reg_bram_0_16;
  input [4:0]O;
  input T_r_reg_i_5;
  input [6:0]mem_reg_bram_0_i_178_0;
  input [0:0]mem_reg_bram_0_i_154_0;
  input [6:0]mem_reg_bram_0_17;
  input [0:0]mem_reg_bram_0_i_153_0;
  input start_i_IBUF;
  input mismatch_reg;
  input mismatch_reg_0;

  wire [7:0]ADDRARDADDR;
  wire [7:0]ADDRBWRADDR;
  wire [4:0]DI;
  wire [11:0]DINADIN;
  wire [11:0]DOUTADOUT;
  wire [11:0]DOUTBDOUT;
  wire \FSM_onehot_state_reg[0] ;
  wire \FSM_onehot_state_reg[1] ;
  wire \FSM_onehot_state_reg[2] ;
  wire \FSM_onehot_state_reg[3] ;
  wire \FSM_onehot_state_reg[3]_0 ;
  wire \FSM_onehot_state_reg[3]_1 ;
  wire \FSM_onehot_state_reg[4] ;
  wire \FSM_onehot_state_reg[4]_0 ;
  wire \FSM_onehot_state_reg[4]_1 ;
  wire \FSM_onehot_state_reg[5] ;
  wire \FSM_onehot_state_reg[5]_0 ;
  wire [4:0]O;
  wire [1:0]Q;
  wire [7:0]S;
  wire T_r_reg_i_5;
  wire [0:0]WEA;
  wire [0:0]WEBWE;
  wire clk_IBUF_BUFG;
  wire \cmp_i_reg[4] ;
  wire [3:0]diff_carry__0;
  wire diff_carry__0_0;
  wire [5:0]ext_addr_IBUF;
  wire ext_addr_sel_IBUF;
  wire [11:0]ext_dout_OBUF;
  wire \ext_dout_OBUF[0]_inst_i_1_0 ;
  wire \ext_dout_OBUF[0]_inst_i_1_1 ;
  wire \ext_dout_OBUF[0]_inst_i_1_2 ;
  wire \ext_dout_OBUF[0]_inst_i_1_3 ;
  wire \ext_dout_OBUF[10]_inst_i_1_0 ;
  wire \ext_dout_OBUF[10]_inst_i_1_1 ;
  wire \ext_dout_OBUF[10]_inst_i_1_2 ;
  wire \ext_dout_OBUF[10]_inst_i_1_3 ;
  wire \ext_dout_OBUF[11]_inst_i_1_0 ;
  wire \ext_dout_OBUF[11]_inst_i_1_1 ;
  wire \ext_dout_OBUF[11]_inst_i_1_2 ;
  wire \ext_dout_OBUF[11]_inst_i_1_3 ;
  wire \ext_dout_OBUF[1]_inst_i_1_0 ;
  wire \ext_dout_OBUF[1]_inst_i_1_1 ;
  wire \ext_dout_OBUF[1]_inst_i_1_2 ;
  wire \ext_dout_OBUF[1]_inst_i_1_3 ;
  wire \ext_dout_OBUF[2]_inst_i_1_0 ;
  wire \ext_dout_OBUF[2]_inst_i_1_1 ;
  wire \ext_dout_OBUF[2]_inst_i_1_2 ;
  wire \ext_dout_OBUF[2]_inst_i_1_3 ;
  wire \ext_dout_OBUF[3]_inst_i_1_0 ;
  wire \ext_dout_OBUF[3]_inst_i_1_1 ;
  wire \ext_dout_OBUF[3]_inst_i_1_2 ;
  wire \ext_dout_OBUF[3]_inst_i_1_3 ;
  wire \ext_dout_OBUF[4]_inst_i_1_0 ;
  wire \ext_dout_OBUF[4]_inst_i_1_1 ;
  wire \ext_dout_OBUF[4]_inst_i_1_2 ;
  wire \ext_dout_OBUF[4]_inst_i_1_3 ;
  wire \ext_dout_OBUF[5]_inst_i_1_0 ;
  wire \ext_dout_OBUF[5]_inst_i_1_1 ;
  wire \ext_dout_OBUF[5]_inst_i_1_2 ;
  wire \ext_dout_OBUF[5]_inst_i_1_3 ;
  wire \ext_dout_OBUF[6]_inst_i_1_0 ;
  wire \ext_dout_OBUF[6]_inst_i_1_1 ;
  wire \ext_dout_OBUF[6]_inst_i_1_2 ;
  wire \ext_dout_OBUF[6]_inst_i_1_3 ;
  wire \ext_dout_OBUF[7]_inst_i_1_0 ;
  wire \ext_dout_OBUF[7]_inst_i_1_1 ;
  wire \ext_dout_OBUF[7]_inst_i_1_2 ;
  wire \ext_dout_OBUF[7]_inst_i_1_3 ;
  wire \ext_dout_OBUF[8]_inst_i_1_0 ;
  wire \ext_dout_OBUF[8]_inst_i_1_1 ;
  wire \ext_dout_OBUF[8]_inst_i_1_2 ;
  wire \ext_dout_OBUF[8]_inst_i_1_3 ;
  wire \ext_dout_OBUF[9]_inst_i_1_0 ;
  wire \ext_dout_OBUF[9]_inst_i_1_1 ;
  wire \ext_dout_OBUF[9]_inst_i_1_2 ;
  wire \ext_dout_OBUF[9]_inst_i_1_3 ;
  wire \load_i_reg[3] ;
  wire \load_i_reg[6] ;
  wire \load_i_reg[7] ;
  wire [5:0]load_val;
  wire [3:0]mem_reg_bram_0_0;
  wire [5:0]mem_reg_bram_0_1;
  wire mem_reg_bram_0_10;
  wire mem_reg_bram_0_11;
  wire [11:0]mem_reg_bram_0_12;
  wire [1:0]mem_reg_bram_0_13;
  wire mem_reg_bram_0_14;
  wire mem_reg_bram_0_15;
  wire mem_reg_bram_0_16;
  wire [6:0]mem_reg_bram_0_17;
  wire [3:0]mem_reg_bram_0_2;
  wire [4:0]mem_reg_bram_0_3;
  wire [0:0]mem_reg_bram_0_4;
  wire [5:0]mem_reg_bram_0_5;
  wire [5:0]mem_reg_bram_0_6;
  wire [0:0]mem_reg_bram_0_7;
  wire mem_reg_bram_0_8;
  wire mem_reg_bram_0_9;
  wire mem_reg_bram_0_i_100_n_0;
  wire mem_reg_bram_0_i_101_n_0;
  wire mem_reg_bram_0_i_102_n_0;
  wire mem_reg_bram_0_i_103_n_0;
  wire mem_reg_bram_0_i_104_n_0;
  wire mem_reg_bram_0_i_105_n_0;
  wire mem_reg_bram_0_i_107_n_0;
  wire mem_reg_bram_0_i_108_n_0;
  wire mem_reg_bram_0_i_109_n_0;
  wire mem_reg_bram_0_i_110_n_0;
  wire mem_reg_bram_0_i_110_n_1;
  wire mem_reg_bram_0_i_110_n_10;
  wire mem_reg_bram_0_i_110_n_11;
  wire mem_reg_bram_0_i_110_n_12;
  wire mem_reg_bram_0_i_110_n_13;
  wire mem_reg_bram_0_i_110_n_14;
  wire mem_reg_bram_0_i_110_n_15;
  wire mem_reg_bram_0_i_110_n_2;
  wire mem_reg_bram_0_i_110_n_3;
  wire mem_reg_bram_0_i_110_n_4;
  wire mem_reg_bram_0_i_110_n_5;
  wire mem_reg_bram_0_i_110_n_6;
  wire mem_reg_bram_0_i_110_n_7;
  wire mem_reg_bram_0_i_110_n_8;
  wire mem_reg_bram_0_i_110_n_9;
  wire mem_reg_bram_0_i_111_n_0;
  wire mem_reg_bram_0_i_112_n_0;
  wire mem_reg_bram_0_i_113_n_0;
  wire mem_reg_bram_0_i_114_n_0;
  wire mem_reg_bram_0_i_115_n_0;
  wire mem_reg_bram_0_i_116_n_0;
  wire mem_reg_bram_0_i_137_n_0;
  wire mem_reg_bram_0_i_144_n_12;
  wire mem_reg_bram_0_i_144_n_13;
  wire mem_reg_bram_0_i_144_n_14;
  wire mem_reg_bram_0_i_144_n_15;
  wire mem_reg_bram_0_i_144_n_3;
  wire mem_reg_bram_0_i_144_n_5;
  wire mem_reg_bram_0_i_144_n_6;
  wire mem_reg_bram_0_i_144_n_7;
  wire mem_reg_bram_0_i_145_n_0;
  wire [9:0]mem_reg_bram_0_i_146_0;
  wire mem_reg_bram_0_i_146_n_12;
  wire mem_reg_bram_0_i_146_n_13;
  wire mem_reg_bram_0_i_146_n_14;
  wire mem_reg_bram_0_i_146_n_15;
  wire mem_reg_bram_0_i_146_n_3;
  wire mem_reg_bram_0_i_146_n_5;
  wire mem_reg_bram_0_i_146_n_6;
  wire mem_reg_bram_0_i_146_n_7;
  wire mem_reg_bram_0_i_147_n_0;
  wire mem_reg_bram_0_i_148_n_0;
  wire mem_reg_bram_0_i_149_n_0;
  wire mem_reg_bram_0_i_150_n_0;
  wire [0:0]mem_reg_bram_0_i_153_0;
  wire mem_reg_bram_0_i_153_n_0;
  wire [0:0]mem_reg_bram_0_i_154_0;
  wire mem_reg_bram_0_i_154_n_0;
  wire mem_reg_bram_0_i_155_n_0;
  wire mem_reg_bram_0_i_155_n_1;
  wire mem_reg_bram_0_i_155_n_10;
  wire mem_reg_bram_0_i_155_n_11;
  wire mem_reg_bram_0_i_155_n_12;
  wire mem_reg_bram_0_i_155_n_13;
  wire mem_reg_bram_0_i_155_n_14;
  wire mem_reg_bram_0_i_155_n_15;
  wire mem_reg_bram_0_i_155_n_2;
  wire mem_reg_bram_0_i_155_n_3;
  wire mem_reg_bram_0_i_155_n_4;
  wire mem_reg_bram_0_i_155_n_5;
  wire mem_reg_bram_0_i_155_n_6;
  wire mem_reg_bram_0_i_155_n_7;
  wire mem_reg_bram_0_i_155_n_8;
  wire mem_reg_bram_0_i_155_n_9;
  wire mem_reg_bram_0_i_156_n_0;
  wire mem_reg_bram_0_i_157_n_0;
  wire mem_reg_bram_0_i_158_n_0;
  wire mem_reg_bram_0_i_159_n_0;
  wire mem_reg_bram_0_i_160_n_0;
  wire mem_reg_bram_0_i_161_n_0;
  wire mem_reg_bram_0_i_162_n_0;
  wire mem_reg_bram_0_i_163_n_0;
  wire mem_reg_bram_0_i_164_n_0;
  wire mem_reg_bram_0_i_172_n_0;
  wire mem_reg_bram_0_i_175_n_0;
  wire mem_reg_bram_0_i_177_n_0;
  wire [6:0]mem_reg_bram_0_i_178_0;
  wire mem_reg_bram_0_i_178_n_0;
  wire mem_reg_bram_0_i_184_n_0;
  wire mem_reg_bram_0_i_185_n_0;
  wire mem_reg_bram_0_i_187_n_0;
  wire mem_reg_bram_0_i_188_n_0;
  wire mem_reg_bram_0_i_189_n_0;
  wire mem_reg_bram_0_i_191_n_0;
  wire mem_reg_bram_0_i_192_n_0;
  wire mem_reg_bram_0_i_193_n_0;
  wire mem_reg_bram_0_i_200_n_0;
  wire mem_reg_bram_0_i_202_n_0;
  wire mem_reg_bram_0_i_203_n_0;
  wire mem_reg_bram_0_i_204_n_0;
  wire mem_reg_bram_0_i_205_n_0;
  wire mem_reg_bram_0_i_206_n_0;
  wire mem_reg_bram_0_i_207_n_0;
  wire mem_reg_bram_0_i_29_n_0;
  wire mem_reg_bram_0_i_30_n_0;
  wire mem_reg_bram_0_i_31_n_0;
  wire mem_reg_bram_0_i_32_n_0;
  wire mem_reg_bram_0_i_33_n_0;
  wire mem_reg_bram_0_i_34_n_0;
  wire mem_reg_bram_0_i_35_n_0;
  wire mem_reg_bram_0_i_36_n_0;
  wire mem_reg_bram_0_i_37_n_0;
  wire mem_reg_bram_0_i_38_n_0;
  wire mem_reg_bram_0_i_39_n_0;
  wire mem_reg_bram_0_i_40_n_0;
  wire mem_reg_bram_0_i_91_n_0;
  wire mem_reg_bram_0_i_93_n_0;
  wire mem_reg_bram_0_i_94_n_0;
  wire mem_reg_bram_0_i_95_n_0;
  wire mem_reg_bram_0_i_97_n_0;
  wire mem_reg_bram_0_i_99_n_0;
  wire [11:0]mismatch1;
  wire mismatch_i_2_n_0;
  wire mismatch_i_3_0;
  wire mismatch_i_3_1;
  wire mismatch_i_3_10;
  wire mismatch_i_3_11;
  wire mismatch_i_3_2;
  wire mismatch_i_3_3;
  wire mismatch_i_3_4;
  wire mismatch_i_3_5;
  wire mismatch_i_3_6;
  wire mismatch_i_3_7;
  wire mismatch_i_3_8;
  wire mismatch_i_3_9;
  wire mismatch_i_3_n_0;
  wire mismatch_i_4_0;
  wire mismatch_i_4_1;
  wire mismatch_i_4_10;
  wire mismatch_i_4_11;
  wire mismatch_i_4_2;
  wire mismatch_i_4_3;
  wire mismatch_i_4_4;
  wire mismatch_i_4_5;
  wire mismatch_i_4_6;
  wire mismatch_i_4_7;
  wire mismatch_i_4_8;
  wire mismatch_i_4_9;
  wire mismatch_i_4_n_0;
  wire mismatch_i_5_0;
  wire mismatch_i_5_1;
  wire mismatch_i_5_10;
  wire mismatch_i_5_11;
  wire mismatch_i_5_2;
  wire mismatch_i_5_3;
  wire mismatch_i_5_4;
  wire mismatch_i_5_5;
  wire mismatch_i_5_6;
  wire mismatch_i_5_7;
  wire mismatch_i_5_8;
  wire mismatch_i_5_9;
  wire mismatch_i_5_n_0;
  wire mismatch_i_6_0;
  wire mismatch_i_6_1;
  wire mismatch_i_6_10;
  wire mismatch_i_6_11;
  wire mismatch_i_6_2;
  wire mismatch_i_6_3;
  wire mismatch_i_6_4;
  wire mismatch_i_6_5;
  wire mismatch_i_6_6;
  wire mismatch_i_6_7;
  wire mismatch_i_6_8;
  wire mismatch_i_6_9;
  wire mismatch_i_6_n_0;
  wire mismatch_reg;
  wire mismatch_reg_0;
  wire [11:0]orig_dout_c;
  wire start_i_IBUF;
  wire [15:0]NLW_mem_reg_bram_0_CASDOUTA_UNCONNECTED;
  wire [15:0]NLW_mem_reg_bram_0_CASDOUTB_UNCONNECTED;
  wire [1:0]NLW_mem_reg_bram_0_CASDOUTPA_UNCONNECTED;
  wire [1:0]NLW_mem_reg_bram_0_CASDOUTPB_UNCONNECTED;
  wire [15:12]NLW_mem_reg_bram_0_DOUTADOUT_UNCONNECTED;
  wire [15:12]NLW_mem_reg_bram_0_DOUTBDOUT_UNCONNECTED;
  wire [1:0]NLW_mem_reg_bram_0_DOUTPADOUTP_UNCONNECTED;
  wire [1:0]NLW_mem_reg_bram_0_DOUTPBDOUTP_UNCONNECTED;
  wire [7:3]NLW_mem_reg_bram_0_i_144_CO_UNCONNECTED;
  wire [7:4]NLW_mem_reg_bram_0_i_144_O_UNCONNECTED;
  wire [7:3]NLW_mem_reg_bram_0_i_146_CO_UNCONNECTED;
  wire [7:4]NLW_mem_reg_bram_0_i_146_O_UNCONNECTED;

  LUT6 #(
    .INIT(64'h30338A88FFFF0000)) 
    T_r_reg_i_1
       (.I0(O[4]),
        .I1(O[1]),
        .I2(T_r_reg_i_5),
        .I3(O[0]),
        .I4(O[3]),
        .I5(O[2]),
        .O(diff_carry__0[3]));
  LUT6 #(
    .INIT(64'h303375778A888A88)) 
    T_r_reg_i_2
       (.I0(O[4]),
        .I1(O[1]),
        .I2(T_r_reg_i_5),
        .I3(O[0]),
        .I4(O[3]),
        .I5(O[2]),
        .O(diff_carry__0[2]));
  LUT6 #(
    .INIT(64'h1011555555555555)) 
    T_r_reg_i_27
       (.I0(O[4]),
        .I1(O[1]),
        .I2(T_r_reg_i_5),
        .I3(O[0]),
        .I4(O[3]),
        .I5(O[2]),
        .O(diff_carry__0_0));
  LUT6 #(
    .INIT(64'h2C226C666C666C66)) 
    T_r_reg_i_3
       (.I0(O[4]),
        .I1(O[1]),
        .I2(T_r_reg_i_5),
        .I3(O[0]),
        .I4(O[3]),
        .I5(O[2]),
        .O(diff_carry__0[1]));
  LUT6 #(
    .INIT(64'hF00EF50AF50AF50A)) 
    T_r_reg_i_4
       (.I0(O[4]),
        .I1(O[1]),
        .I2(T_r_reg_i_5),
        .I3(O[0]),
        .I4(O[3]),
        .I5(O[2]),
        .O(diff_carry__0[0]));
  LUT2 #(
    .INIT(4'hB)) 
    diff_carry__0_i_1
       (.I0(DOUTBDOUT[10]),
        .I1(mem_reg_bram_0_i_146_0[8]),
        .O(mem_reg_bram_0_0[3]));
  LUT2 #(
    .INIT(4'hB)) 
    diff_carry__0_i_1__0
       (.I0(DOUTADOUT[10]),
        .I1(DOUTBDOUT[10]),
        .O(mem_reg_bram_0_2[3]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry__0_i_2
       (.I0(DOUTBDOUT[10]),
        .I1(mem_reg_bram_0_i_146_0[8]),
        .O(mem_reg_bram_0_0[2]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry__0_i_2__0
       (.I0(DOUTBDOUT[10]),
        .I1(DOUTADOUT[10]),
        .O(mem_reg_bram_0_2[2]));
  LUT2 #(
    .INIT(4'hB)) 
    diff_carry__0_i_3
       (.I0(DOUTBDOUT[8]),
        .I1(mem_reg_bram_0_i_146_0[7]),
        .O(mem_reg_bram_0_0[1]));
  LUT2 #(
    .INIT(4'hB)) 
    diff_carry__0_i_3__0
       (.I0(DOUTADOUT[8]),
        .I1(DOUTBDOUT[8]),
        .O(mem_reg_bram_0_2[1]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry__0_i_4
       (.I0(DOUTBDOUT[8]),
        .I1(mem_reg_bram_0_i_146_0[7]),
        .O(mem_reg_bram_0_0[0]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry__0_i_4__0
       (.I0(DOUTBDOUT[8]),
        .I1(DOUTADOUT[8]),
        .O(mem_reg_bram_0_2[0]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry__0_i_5__0
       (.I0(DOUTBDOUT[11]),
        .I1(DOUTADOUT[11]),
        .O(mem_reg_bram_0_3[4]));
  LUT4 #(
    .INIT(16'hD22D)) 
    diff_carry__0_i_6__0
       (.I0(DOUTBDOUT[10]),
        .I1(DOUTADOUT[10]),
        .I2(DOUTADOUT[11]),
        .I3(DOUTBDOUT[11]),
        .O(mem_reg_bram_0_3[3]));
  LUT4 #(
    .INIT(16'h6966)) 
    diff_carry__0_i_7__0
       (.I0(DOUTADOUT[10]),
        .I1(DOUTBDOUT[10]),
        .I2(DOUTBDOUT[9]),
        .I3(DOUTADOUT[9]),
        .O(mem_reg_bram_0_3[2]));
  LUT4 #(
    .INIT(16'h2DD2)) 
    diff_carry__0_i_8__0
       (.I0(DOUTBDOUT[8]),
        .I1(DOUTADOUT[8]),
        .I2(DOUTBDOUT[9]),
        .I3(DOUTADOUT[9]),
        .O(mem_reg_bram_0_3[1]));
  LUT4 #(
    .INIT(16'h6966)) 
    diff_carry__0_i_9__0
       (.I0(DOUTADOUT[8]),
        .I1(DOUTBDOUT[8]),
        .I2(DOUTBDOUT[7]),
        .I3(DOUTADOUT[7]),
        .O(mem_reg_bram_0_3[0]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_1
       (.I0(DOUTBDOUT[6]),
        .I1(mem_reg_bram_0_i_146_0[6]),
        .O(DI[4]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_10__0
       (.I0(DOUTBDOUT[3]),
        .I1(DOUTADOUT[3]),
        .I2(DOUTBDOUT[4]),
        .I3(DOUTADOUT[4]),
        .O(S[4]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_11__0
       (.I0(DOUTBDOUT[2]),
        .I1(DOUTADOUT[2]),
        .I2(DOUTBDOUT[3]),
        .I3(DOUTADOUT[3]),
        .O(S[3]));
  LUT3 #(
    .INIT(8'h96)) 
    diff_carry_i_12
       (.I0(DOUTBDOUT[1]),
        .I1(DOUTBDOUT[2]),
        .I2(DOUTADOUT[2]),
        .O(S[2]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry_i_13__0
       (.I0(DOUTBDOUT[1]),
        .I1(DOUTADOUT[1]),
        .O(S[1]));
  LUT2 #(
    .INIT(4'h9)) 
    diff_carry_i_14
       (.I0(DOUTADOUT[0]),
        .I1(DOUTBDOUT[0]),
        .O(S[0]));
  LUT2 #(
    .INIT(4'h9)) 
    diff_carry_i_14__0
       (.I0(DOUTBDOUT[0]),
        .I1(mem_reg_bram_0_i_146_0[0]),
        .O(mem_reg_bram_0_4));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_1__0
       (.I0(DOUTADOUT[6]),
        .I1(DOUTBDOUT[6]),
        .O(mem_reg_bram_0_1[5]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_2
       (.I0(DOUTBDOUT[5]),
        .I1(mem_reg_bram_0_i_146_0[5]),
        .O(DI[3]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_2__0
       (.I0(DOUTADOUT[5]),
        .I1(DOUTBDOUT[5]),
        .O(mem_reg_bram_0_1[4]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_3
       (.I0(DOUTBDOUT[4]),
        .I1(mem_reg_bram_0_i_146_0[4]),
        .O(DI[2]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_3__0
       (.I0(DOUTADOUT[4]),
        .I1(DOUTBDOUT[4]),
        .O(mem_reg_bram_0_1[3]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_4
       (.I0(DOUTBDOUT[3]),
        .I1(mem_reg_bram_0_i_146_0[3]),
        .O(DI[1]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_4__0
       (.I0(DOUTADOUT[3]),
        .I1(DOUTBDOUT[3]),
        .O(mem_reg_bram_0_1[2]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_5
       (.I0(DOUTBDOUT[2]),
        .I1(mem_reg_bram_0_i_146_0[2]),
        .O(DI[0]));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry_i_5__0
       (.I0(DOUTADOUT[2]),
        .I1(DOUTBDOUT[2]),
        .O(mem_reg_bram_0_1[1]));
  LUT1 #(
    .INIT(2'h1)) 
    diff_carry_i_6__0
       (.I0(DOUTBDOUT[1]),
        .O(mem_reg_bram_0_1[0]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_7__0
       (.I0(DOUTBDOUT[6]),
        .I1(DOUTADOUT[6]),
        .I2(DOUTBDOUT[7]),
        .I3(DOUTADOUT[7]),
        .O(S[7]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_8__0
       (.I0(DOUTBDOUT[5]),
        .I1(DOUTADOUT[5]),
        .I2(DOUTBDOUT[6]),
        .I3(DOUTADOUT[6]),
        .O(S[6]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_9__0
       (.I0(DOUTBDOUT[4]),
        .I1(DOUTADOUT[4]),
        .I2(DOUTBDOUT[5]),
        .I3(DOUTADOUT[5]),
        .O(S[5]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[0]_inst_i_1 
       (.I0(orig_dout_c[0]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[0]),
        .O(ext_dout_OBUF[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[0]_inst_i_2 
       (.I0(\ext_dout_OBUF[0]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[0]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[0]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[0]_inst_i_1_3 ),
        .O(orig_dout_c[0]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[10]_inst_i_1 
       (.I0(orig_dout_c[10]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[10]),
        .O(ext_dout_OBUF[10]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[10]_inst_i_2 
       (.I0(\ext_dout_OBUF[10]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[10]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[10]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[10]_inst_i_1_3 ),
        .O(orig_dout_c[10]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[11]_inst_i_1 
       (.I0(orig_dout_c[11]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[11]),
        .O(ext_dout_OBUF[11]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[11]_inst_i_2 
       (.I0(\ext_dout_OBUF[11]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[11]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[11]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[11]_inst_i_1_3 ),
        .O(orig_dout_c[11]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[1]_inst_i_1 
       (.I0(orig_dout_c[1]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[1]),
        .O(ext_dout_OBUF[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[1]_inst_i_2 
       (.I0(\ext_dout_OBUF[1]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[1]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[1]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[1]_inst_i_1_3 ),
        .O(orig_dout_c[1]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[2]_inst_i_1 
       (.I0(orig_dout_c[2]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[2]),
        .O(ext_dout_OBUF[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[2]_inst_i_2 
       (.I0(\ext_dout_OBUF[2]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[2]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[2]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[2]_inst_i_1_3 ),
        .O(orig_dout_c[2]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[3]_inst_i_1 
       (.I0(orig_dout_c[3]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[3]),
        .O(ext_dout_OBUF[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[3]_inst_i_2 
       (.I0(\ext_dout_OBUF[3]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[3]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[3]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[3]_inst_i_1_3 ),
        .O(orig_dout_c[3]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[4]_inst_i_1 
       (.I0(orig_dout_c[4]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[4]),
        .O(ext_dout_OBUF[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[4]_inst_i_2 
       (.I0(\ext_dout_OBUF[4]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[4]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[4]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[4]_inst_i_1_3 ),
        .O(orig_dout_c[4]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[5]_inst_i_1 
       (.I0(orig_dout_c[5]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[5]),
        .O(ext_dout_OBUF[5]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[5]_inst_i_2 
       (.I0(\ext_dout_OBUF[5]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[5]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[5]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[5]_inst_i_1_3 ),
        .O(orig_dout_c[5]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[6]_inst_i_1 
       (.I0(orig_dout_c[6]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[6]),
        .O(ext_dout_OBUF[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[6]_inst_i_2 
       (.I0(\ext_dout_OBUF[6]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[6]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[6]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[6]_inst_i_1_3 ),
        .O(orig_dout_c[6]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[7]_inst_i_1 
       (.I0(orig_dout_c[7]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[7]),
        .O(ext_dout_OBUF[7]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[7]_inst_i_2 
       (.I0(\ext_dout_OBUF[7]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[7]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[7]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[7]_inst_i_1_3 ),
        .O(orig_dout_c[7]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[8]_inst_i_1 
       (.I0(orig_dout_c[8]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[8]),
        .O(ext_dout_OBUF[8]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[8]_inst_i_2 
       (.I0(\ext_dout_OBUF[8]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[8]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[8]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[8]_inst_i_1_3 ),
        .O(orig_dout_c[8]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \ext_dout_OBUF[9]_inst_i_1 
       (.I0(orig_dout_c[9]),
        .I1(ext_addr_sel_IBUF),
        .I2(DOUTBDOUT[9]),
        .O(ext_dout_OBUF[9]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \ext_dout_OBUF[9]_inst_i_2 
       (.I0(\ext_dout_OBUF[9]_inst_i_1_0 ),
        .I1(\ext_dout_OBUF[9]_inst_i_1_1 ),
        .I2(ext_addr_IBUF[5]),
        .I3(\ext_dout_OBUF[9]_inst_i_1_2 ),
        .I4(ext_addr_IBUF[4]),
        .I5(\ext_dout_OBUF[9]_inst_i_1_3 ),
        .O(orig_dout_c[9]));
  (* \MEM.PORTA.DATA_BIT_LAYOUT  = "p0_d12" *) 
  (* \MEM.PORTB.DATA_BIT_LAYOUT  = "p0_d12" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-6 {cell *THIS*}} {SYNTH-7 {cell *THIS*}}" *) 
  (* RDADDR_COLLISION_HWCONFIG = "DELAYED_WRITE" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "u_mem/mem_reg_bram_0" *) 
  (* RTL_RAM_TYPE = "RAM_TDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "11" *) 
  RAMB18E2 #(
    .CASCADE_ORDER_A("NONE"),
    .CASCADE_ORDER_B("NONE"),
    .CLOCK_DOMAINS("COMMON"),
    .DOA_REG(0),
    .DOB_REG(0),
    .ENADDRENA("FALSE"),
    .ENADDRENB("FALSE"),
    .INIT_A(18'h00000),
    .INIT_B(18'h00000),
    .INIT_FILE("NONE"),
    .RDADDRCHANGEA("FALSE"),
    .RDADDRCHANGEB("FALSE"),
    .READ_WIDTH_A(18),
    .READ_WIDTH_B(18),
    .RSTREG_PRIORITY_A("RSTREG"),
    .RSTREG_PRIORITY_B("RSTREG"),
    .SIM_COLLISION_CHECK("ALL"),
    .SLEEP_ASYNC("FALSE"),
    .SRVAL_A(18'h00000),
    .SRVAL_B(18'h00000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(18),
    .WRITE_WIDTH_B(18)) 
    mem_reg_bram_0
       (.ADDRARDADDR({1'b1,1'b1,ADDRARDADDR,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1,1'b1}),
        .ADDRENA(1'b1),
        .ADDRENB(1'b1),
        .CASDIMUXA(1'b0),
        .CASDIMUXB(1'b0),
        .CASDINA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASDINB({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CASDINPA({1'b0,1'b0}),
        .CASDINPB({1'b0,1'b0}),
        .CASDOMUXA(1'b0),
        .CASDOMUXB(1'b0),
        .CASDOMUXEN_A(1'b1),
        .CASDOMUXEN_B(1'b1),
        .CASDOUTA(NLW_mem_reg_bram_0_CASDOUTA_UNCONNECTED[15:0]),
        .CASDOUTB(NLW_mem_reg_bram_0_CASDOUTB_UNCONNECTED[15:0]),
        .CASDOUTPA(NLW_mem_reg_bram_0_CASDOUTPA_UNCONNECTED[1:0]),
        .CASDOUTPB(NLW_mem_reg_bram_0_CASDOUTPB_UNCONNECTED[1:0]),
        .CASOREGIMUXA(1'b0),
        .CASOREGIMUXB(1'b0),
        .CASOREGIMUXEN_A(1'b1),
        .CASOREGIMUXEN_B(1'b1),
        .CLKARDCLK(clk_IBUF_BUFG),
        .CLKBWRCLK(clk_IBUF_BUFG),
        .DINADIN({1'b0,1'b0,1'b0,1'b0,DINADIN}),
        .DINBDIN({1'b0,1'b0,1'b0,1'b0,mem_reg_bram_0_i_29_n_0,mem_reg_bram_0_i_30_n_0,mem_reg_bram_0_i_31_n_0,mem_reg_bram_0_i_32_n_0,mem_reg_bram_0_i_33_n_0,mem_reg_bram_0_i_34_n_0,mem_reg_bram_0_i_35_n_0,mem_reg_bram_0_i_36_n_0,mem_reg_bram_0_i_37_n_0,mem_reg_bram_0_i_38_n_0,mem_reg_bram_0_i_39_n_0,mem_reg_bram_0_i_40_n_0}),
        .DINPADINP({1'b0,1'b0}),
        .DINPBDINP({1'b0,1'b0}),
        .DOUTADOUT({NLW_mem_reg_bram_0_DOUTADOUT_UNCONNECTED[15:12],DOUTADOUT}),
        .DOUTBDOUT({NLW_mem_reg_bram_0_DOUTBDOUT_UNCONNECTED[15:12],DOUTBDOUT}),
        .DOUTPADOUTP(NLW_mem_reg_bram_0_DOUTPADOUTP_UNCONNECTED[1:0]),
        .DOUTPBDOUTP(NLW_mem_reg_bram_0_DOUTPBDOUTP_UNCONNECTED[1:0]),
        .ENARDEN(1'b1),
        .ENBWREN(1'b1),
        .REGCEAREGCE(1'b1),
        .REGCEB(1'b1),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SLEEP(1'b0),
        .WEA({WEA,WEA}),
        .WEBWE({1'b0,1'b0,WEBWE,WEBWE}));
  LUT6 #(
    .INIT(64'h0000FFFF77077707)) 
    mem_reg_bram_0_i_100
       (.I0(mem_reg_bram_0_i_155_n_8),
        .I1(mem_reg_bram_0_i_156_n_0),
        .I2(mem_reg_bram_0_i_157_n_0),
        .I3(mem_reg_bram_0_i_158_n_0),
        .I4(mem_reg_bram_0_12[7]),
        .I5(mem_reg_bram_0_11),
        .O(mem_reg_bram_0_i_100_n_0));
  LUT6 #(
    .INIT(64'h5555FFFF5557FFFD)) 
    mem_reg_bram_0_i_101
       (.I0(mem_reg_bram_0_i_159_n_0),
        .I1(mem_reg_bram_0_i_110_n_10),
        .I2(mem_reg_bram_0_i_110_n_9),
        .I3(mem_reg_bram_0_i_160_n_0),
        .I4(mem_reg_bram_0_i_110_n_8),
        .I5(mem_reg_bram_0_i_161_n_0),
        .O(mem_reg_bram_0_i_101_n_0));
  LUT6 #(
    .INIT(64'hBBBB8888BB8B88B8)) 
    mem_reg_bram_0_i_102
       (.I0(mem_reg_bram_0_12[6]),
        .I1(mem_reg_bram_0_11),
        .I2(mem_reg_bram_0_i_162_n_0),
        .I3(mem_reg_bram_0_i_155_n_12),
        .I4(mem_reg_bram_0_i_155_n_9),
        .I5(mem_reg_bram_0_i_163_n_0),
        .O(mem_reg_bram_0_i_102_n_0));
  LUT6 #(
    .INIT(64'h7777FFFF777FFFF7)) 
    mem_reg_bram_0_i_103
       (.I0(mem_reg_bram_0_5[2]),
        .I1(\FSM_onehot_state_reg[5] ),
        .I2(mem_reg_bram_0_i_110_n_10),
        .I3(mem_reg_bram_0_i_160_n_0),
        .I4(mem_reg_bram_0_i_110_n_9),
        .I5(mem_reg_bram_0_i_161_n_0),
        .O(mem_reg_bram_0_i_103_n_0));
  LUT6 #(
    .INIT(64'hEEEEEE0E000000E0)) 
    mem_reg_bram_0_i_104
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[2]),
        .I2(mem_reg_bram_0_i_111_n_0),
        .I3(mem_reg_bram_0_i_110_n_12),
        .I4(mem_reg_bram_0_i_110_n_11),
        .I5(mem_reg_bram_0_i_110_n_10),
        .O(mem_reg_bram_0_i_104_n_0));
  LUT6 #(
    .INIT(64'h00000000FFE100E1)) 
    mem_reg_bram_0_i_105
       (.I0(mem_reg_bram_0_i_155_n_11),
        .I1(mem_reg_bram_0_i_164_n_0),
        .I2(mem_reg_bram_0_i_155_n_10),
        .I3(mem_reg_bram_0_11),
        .I4(mem_reg_bram_0_12[5]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_105_n_0));
  LUT6 #(
    .INIT(64'hAABAABBBABBBAABA)) 
    mem_reg_bram_0_i_107
       (.I0(\FSM_onehot_state_reg[5] ),
        .I1(\FSM_onehot_state_reg[2] ),
        .I2(mem_reg_bram_0_11),
        .I3(mem_reg_bram_0_12[4]),
        .I4(mem_reg_bram_0_i_164_n_0),
        .I5(mem_reg_bram_0_i_155_n_11),
        .O(mem_reg_bram_0_i_107_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT5 #(
    .INIT(32'h77F7FF7F)) 
    mem_reg_bram_0_i_108
       (.I0(mem_reg_bram_0_5[2]),
        .I1(\FSM_onehot_state_reg[5] ),
        .I2(mem_reg_bram_0_i_111_n_0),
        .I3(mem_reg_bram_0_i_110_n_12),
        .I4(mem_reg_bram_0_i_110_n_11),
        .O(mem_reg_bram_0_i_108_n_0));
  LUT6 #(
    .INIT(64'h88888BB8BBBB8BB8)) 
    mem_reg_bram_0_i_109
       (.I0(mem_reg_bram_0_16),
        .I1(\FSM_onehot_state_reg[2] ),
        .I2(mem_reg_bram_0_i_155_n_12),
        .I3(mem_reg_bram_0_i_163_n_0),
        .I4(mem_reg_bram_0_11),
        .I5(mem_reg_bram_0_12[3]),
        .O(mem_reg_bram_0_i_109_n_0));
  CARRY8 mem_reg_bram_0_i_110
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({mem_reg_bram_0_i_110_n_0,mem_reg_bram_0_i_110_n_1,mem_reg_bram_0_i_110_n_2,mem_reg_bram_0_i_110_n_3,mem_reg_bram_0_i_110_n_4,mem_reg_bram_0_i_110_n_5,mem_reg_bram_0_i_110_n_6,mem_reg_bram_0_i_110_n_7}),
        .DI(DOUTBDOUT[7:0]),
        .O({mem_reg_bram_0_i_110_n_8,mem_reg_bram_0_i_110_n_9,mem_reg_bram_0_i_110_n_10,mem_reg_bram_0_i_110_n_11,mem_reg_bram_0_i_110_n_12,mem_reg_bram_0_i_110_n_13,mem_reg_bram_0_i_110_n_14,mem_reg_bram_0_i_110_n_15}),
        .S({mem_reg_bram_0_17[6:1],mem_reg_bram_0_i_172_n_0,mem_reg_bram_0_17[0]}));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    mem_reg_bram_0_i_111
       (.I0(mem_reg_bram_0_i_110_n_14),
        .I1(mem_reg_bram_0_i_110_n_15),
        .I2(mem_reg_bram_0_i_161_n_0),
        .I3(mem_reg_bram_0_i_110_n_13),
        .O(mem_reg_bram_0_i_111_n_0));
  LUT6 #(
    .INIT(64'h88888BB8BBBB8BB8)) 
    mem_reg_bram_0_i_112
       (.I0(mem_reg_bram_0_15),
        .I1(\FSM_onehot_state_reg[2] ),
        .I2(mem_reg_bram_0_i_155_n_13),
        .I3(mem_reg_bram_0_i_175_n_0),
        .I4(mem_reg_bram_0_11),
        .I5(mem_reg_bram_0_12[2]),
        .O(mem_reg_bram_0_i_112_n_0));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT3 #(
    .INIT(8'h01)) 
    mem_reg_bram_0_i_113
       (.I0(mem_reg_bram_0_i_161_n_0),
        .I1(mem_reg_bram_0_i_110_n_15),
        .I2(mem_reg_bram_0_i_110_n_14),
        .O(mem_reg_bram_0_i_113_n_0));
  LUT6 #(
    .INIT(64'h88888BB8BBBB8BB8)) 
    mem_reg_bram_0_i_114
       (.I0(mem_reg_bram_0_14),
        .I1(\FSM_onehot_state_reg[2] ),
        .I2(mem_reg_bram_0_i_155_n_14),
        .I3(mem_reg_bram_0_i_177_n_0),
        .I4(mem_reg_bram_0_11),
        .I5(mem_reg_bram_0_12[1]),
        .O(mem_reg_bram_0_i_114_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_115
       (.I0(mem_reg_bram_0_i_110_n_15),
        .I1(mem_reg_bram_0_i_161_n_0),
        .O(mem_reg_bram_0_i_115_n_0));
  LUT6 #(
    .INIT(64'hE00EFFFFE00E0000)) 
    mem_reg_bram_0_i_116
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[2]),
        .I2(mem_reg_bram_0_i_161_n_0),
        .I3(mem_reg_bram_0_i_110_n_15),
        .I4(\FSM_onehot_state_reg[5] ),
        .I5(mem_reg_bram_0_i_178_n_0),
        .O(mem_reg_bram_0_i_116_n_0));
  LUT6 #(
    .INIT(64'h0000000000000007)) 
    mem_reg_bram_0_i_137
       (.I0(mem_reg_bram_0_5[1]),
        .I1(mem_reg_bram_0_6[3]),
        .I2(mem_reg_bram_0_5[2]),
        .I3(mem_reg_bram_0_5[3]),
        .I4(mem_reg_bram_0_5[4]),
        .I5(mem_reg_bram_0_5[5]),
        .O(mem_reg_bram_0_i_137_n_0));
  LUT6 #(
    .INIT(64'hFF55FF55F150FD50)) 
    mem_reg_bram_0_i_142
       (.I0(ext_addr_IBUF[1]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(\FSM_onehot_state_reg[2] ),
        .I4(mem_reg_bram_0_6[1]),
        .I5(mem_reg_bram_0_5[4]),
        .O(\FSM_onehot_state_reg[1] ));
  CARRY8 mem_reg_bram_0_i_144
       (.CI(mem_reg_bram_0_i_155_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_mem_reg_bram_0_i_144_CO_UNCONNECTED[7:5],mem_reg_bram_0_i_144_n_3,NLW_mem_reg_bram_0_i_144_CO_UNCONNECTED[3],mem_reg_bram_0_i_144_n_5,mem_reg_bram_0_i_144_n_6,mem_reg_bram_0_i_144_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,DOUTBDOUT[11:8]}),
        .O({NLW_mem_reg_bram_0_i_144_O_UNCONNECTED[7:4],mem_reg_bram_0_i_144_n_12,mem_reg_bram_0_i_144_n_13,mem_reg_bram_0_i_144_n_14,mem_reg_bram_0_i_144_n_15}),
        .S({1'b0,1'b0,1'b0,1'b1,mem_reg_bram_0_i_184_n_0,mem_reg_bram_0_i_185_n_0,mem_reg_bram_0_i_154_0,mem_reg_bram_0_i_187_n_0}));
  LUT6 #(
    .INIT(64'hEAEAEAEA0000EA00)) 
    mem_reg_bram_0_i_145
       (.I0(mem_reg_bram_0_i_144_n_3),
        .I1(mem_reg_bram_0_i_144_n_13),
        .I2(mem_reg_bram_0_i_144_n_12),
        .I3(mem_reg_bram_0_i_144_n_15),
        .I4(mem_reg_bram_0_i_157_n_0),
        .I5(mem_reg_bram_0_i_144_n_14),
        .O(mem_reg_bram_0_i_145_n_0));
  CARRY8 mem_reg_bram_0_i_146
       (.CI(mem_reg_bram_0_i_110_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_mem_reg_bram_0_i_146_CO_UNCONNECTED[7:5],mem_reg_bram_0_i_146_n_3,NLW_mem_reg_bram_0_i_146_CO_UNCONNECTED[3],mem_reg_bram_0_i_146_n_5,mem_reg_bram_0_i_146_n_6,mem_reg_bram_0_i_146_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,DOUTBDOUT[11:8]}),
        .O({NLW_mem_reg_bram_0_i_146_O_UNCONNECTED[7:4],mem_reg_bram_0_i_146_n_12,mem_reg_bram_0_i_146_n_13,mem_reg_bram_0_i_146_n_14,mem_reg_bram_0_i_146_n_15}),
        .S({1'b0,1'b0,1'b0,1'b1,mem_reg_bram_0_i_188_n_0,mem_reg_bram_0_i_189_n_0,mem_reg_bram_0_i_153_0,mem_reg_bram_0_i_191_n_0}));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    mem_reg_bram_0_i_147
       (.I0(mem_reg_bram_0_i_110_n_15),
        .I1(mem_reg_bram_0_i_110_n_8),
        .I2(mem_reg_bram_0_i_192_n_0),
        .I3(mem_reg_bram_0_i_193_n_0),
        .I4(mem_reg_bram_0_i_110_n_13),
        .I5(mem_reg_bram_0_i_110_n_14),
        .O(mem_reg_bram_0_i_147_n_0));
  LUT6 #(
    .INIT(64'hFFFF00F088880080)) 
    mem_reg_bram_0_i_148
       (.I0(mem_reg_bram_0_i_146_n_13),
        .I1(mem_reg_bram_0_i_146_n_12),
        .I2(mem_reg_bram_0_i_146_n_15),
        .I3(mem_reg_bram_0_i_147_n_0),
        .I4(mem_reg_bram_0_i_146_n_14),
        .I5(mem_reg_bram_0_i_146_n_3),
        .O(mem_reg_bram_0_i_148_n_0));
  LUT6 #(
    .INIT(64'hD3DD939993999399)) 
    mem_reg_bram_0_i_149
       (.I0(mem_reg_bram_0_i_146_n_3),
        .I1(mem_reg_bram_0_i_146_n_14),
        .I2(mem_reg_bram_0_i_147_n_0),
        .I3(mem_reg_bram_0_i_146_n_15),
        .I4(mem_reg_bram_0_i_146_n_12),
        .I5(mem_reg_bram_0_i_146_n_13),
        .O(mem_reg_bram_0_i_149_n_0));
  LUT6 #(
    .INIT(64'h6565656520AAAAAA)) 
    mem_reg_bram_0_i_150
       (.I0(mem_reg_bram_0_i_144_n_14),
        .I1(mem_reg_bram_0_i_157_n_0),
        .I2(mem_reg_bram_0_i_144_n_15),
        .I3(mem_reg_bram_0_i_144_n_12),
        .I4(mem_reg_bram_0_i_144_n_13),
        .I5(mem_reg_bram_0_i_144_n_3),
        .O(mem_reg_bram_0_i_150_n_0));
  LUT6 #(
    .INIT(64'h0FF10AF50AF50AF5)) 
    mem_reg_bram_0_i_153
       (.I0(mem_reg_bram_0_i_146_n_3),
        .I1(mem_reg_bram_0_i_146_n_14),
        .I2(mem_reg_bram_0_i_147_n_0),
        .I3(mem_reg_bram_0_i_146_n_15),
        .I4(mem_reg_bram_0_i_146_n_12),
        .I5(mem_reg_bram_0_i_146_n_13),
        .O(mem_reg_bram_0_i_153_n_0));
  LUT6 #(
    .INIT(64'hC3C3C3C3C2F0F0F0)) 
    mem_reg_bram_0_i_154
       (.I0(mem_reg_bram_0_i_144_n_14),
        .I1(mem_reg_bram_0_i_157_n_0),
        .I2(mem_reg_bram_0_i_144_n_15),
        .I3(mem_reg_bram_0_i_144_n_12),
        .I4(mem_reg_bram_0_i_144_n_13),
        .I5(mem_reg_bram_0_i_144_n_3),
        .O(mem_reg_bram_0_i_154_n_0));
  CARRY8 mem_reg_bram_0_i_155
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({mem_reg_bram_0_i_155_n_0,mem_reg_bram_0_i_155_n_1,mem_reg_bram_0_i_155_n_2,mem_reg_bram_0_i_155_n_3,mem_reg_bram_0_i_155_n_4,mem_reg_bram_0_i_155_n_5,mem_reg_bram_0_i_155_n_6,mem_reg_bram_0_i_155_n_7}),
        .DI(DOUTBDOUT[7:0]),
        .O({mem_reg_bram_0_i_155_n_8,mem_reg_bram_0_i_155_n_9,mem_reg_bram_0_i_155_n_10,mem_reg_bram_0_i_155_n_11,mem_reg_bram_0_i_155_n_12,mem_reg_bram_0_i_155_n_13,mem_reg_bram_0_i_155_n_14,mem_reg_bram_0_i_155_n_15}),
        .S({mem_reg_bram_0_i_178_0[6:1],mem_reg_bram_0_i_200_n_0,mem_reg_bram_0_i_178_0[0]}));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    mem_reg_bram_0_i_156
       (.I0(mem_reg_bram_0_i_155_n_14),
        .I1(mem_reg_bram_0_i_158_n_0),
        .I2(mem_reg_bram_0_i_155_n_15),
        .I3(mem_reg_bram_0_i_155_n_13),
        .I4(mem_reg_bram_0_i_202_n_0),
        .O(mem_reg_bram_0_i_156_n_0));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    mem_reg_bram_0_i_157
       (.I0(mem_reg_bram_0_i_202_n_0),
        .I1(mem_reg_bram_0_i_155_n_13),
        .I2(mem_reg_bram_0_i_155_n_14),
        .I3(mem_reg_bram_0_i_155_n_15),
        .I4(mem_reg_bram_0_i_155_n_8),
        .O(mem_reg_bram_0_i_157_n_0));
  LUT6 #(
    .INIT(64'h00000000FFFF0455)) 
    mem_reg_bram_0_i_158
       (.I0(mem_reg_bram_0_i_144_n_14),
        .I1(mem_reg_bram_0_i_202_n_0),
        .I2(mem_reg_bram_0_i_203_n_0),
        .I3(mem_reg_bram_0_i_144_n_15),
        .I4(mem_reg_bram_0_i_204_n_0),
        .I5(mem_reg_bram_0_i_144_n_3),
        .O(mem_reg_bram_0_i_158_n_0));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT4 #(
    .INIT(16'h0100)) 
    mem_reg_bram_0_i_159
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[2]),
        .O(mem_reg_bram_0_i_159_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    mem_reg_bram_0_i_160
       (.I0(mem_reg_bram_0_i_110_n_12),
        .I1(mem_reg_bram_0_i_110_n_11),
        .I2(mem_reg_bram_0_i_110_n_15),
        .I3(mem_reg_bram_0_i_110_n_14),
        .I4(mem_reg_bram_0_i_110_n_13),
        .O(mem_reg_bram_0_i_160_n_0));
  LUT6 #(
    .INIT(64'h0010111155555555)) 
    mem_reg_bram_0_i_161
       (.I0(mem_reg_bram_0_i_146_n_3),
        .I1(mem_reg_bram_0_i_146_n_14),
        .I2(mem_reg_bram_0_i_205_n_0),
        .I3(mem_reg_bram_0_i_206_n_0),
        .I4(mem_reg_bram_0_i_146_n_15),
        .I5(mem_reg_bram_0_i_207_n_0),
        .O(mem_reg_bram_0_i_161_n_0));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_162
       (.I0(mem_reg_bram_0_i_155_n_10),
        .I1(mem_reg_bram_0_i_155_n_11),
        .O(mem_reg_bram_0_i_162_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    mem_reg_bram_0_i_163
       (.I0(mem_reg_bram_0_i_155_n_13),
        .I1(mem_reg_bram_0_i_155_n_15),
        .I2(mem_reg_bram_0_i_158_n_0),
        .I3(mem_reg_bram_0_i_155_n_14),
        .O(mem_reg_bram_0_i_163_n_0));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    mem_reg_bram_0_i_164
       (.I0(mem_reg_bram_0_i_155_n_12),
        .I1(mem_reg_bram_0_i_155_n_14),
        .I2(mem_reg_bram_0_i_158_n_0),
        .I3(mem_reg_bram_0_i_155_n_15),
        .I4(mem_reg_bram_0_i_155_n_13),
        .O(mem_reg_bram_0_i_164_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_172
       (.I0(DOUTBDOUT[1]),
        .I1(mem_reg_bram_0_i_146_0[1]),
        .O(mem_reg_bram_0_i_172_n_0));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    mem_reg_bram_0_i_175
       (.I0(mem_reg_bram_0_i_155_n_14),
        .I1(mem_reg_bram_0_i_158_n_0),
        .I2(mem_reg_bram_0_i_155_n_15),
        .O(mem_reg_bram_0_i_175_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_reg_bram_0_i_177
       (.I0(mem_reg_bram_0_i_155_n_15),
        .I1(mem_reg_bram_0_i_158_n_0),
        .O(mem_reg_bram_0_i_177_n_0));
  LUT6 #(
    .INIT(64'h000000009F999099)) 
    mem_reg_bram_0_i_178
       (.I0(mem_reg_bram_0_i_155_n_15),
        .I1(mem_reg_bram_0_i_158_n_0),
        .I2(mem_reg_bram_0_13[0]),
        .I3(mem_reg_bram_0_13[1]),
        .I4(mem_reg_bram_0_12[0]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_178_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_184
       (.I0(DOUTBDOUT[11]),
        .I1(DOUTADOUT[11]),
        .O(mem_reg_bram_0_i_184_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_185
       (.I0(DOUTBDOUT[10]),
        .I1(DOUTADOUT[10]),
        .O(mem_reg_bram_0_i_185_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_187
       (.I0(DOUTBDOUT[8]),
        .I1(DOUTADOUT[8]),
        .O(mem_reg_bram_0_i_187_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_188
       (.I0(DOUTBDOUT[11]),
        .I1(mem_reg_bram_0_i_146_0[9]),
        .O(mem_reg_bram_0_i_188_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_189
       (.I0(DOUTBDOUT[10]),
        .I1(mem_reg_bram_0_i_146_0[8]),
        .O(mem_reg_bram_0_i_189_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_191
       (.I0(DOUTBDOUT[8]),
        .I1(mem_reg_bram_0_i_146_0[7]),
        .O(mem_reg_bram_0_i_191_n_0));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_192
       (.I0(mem_reg_bram_0_i_110_n_9),
        .I1(mem_reg_bram_0_i_110_n_10),
        .O(mem_reg_bram_0_i_192_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT2 #(
    .INIT(4'hE)) 
    mem_reg_bram_0_i_193
       (.I0(mem_reg_bram_0_i_110_n_11),
        .I1(mem_reg_bram_0_i_110_n_12),
        .O(mem_reg_bram_0_i_193_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_200
       (.I0(DOUTBDOUT[1]),
        .I1(DOUTADOUT[1]),
        .O(mem_reg_bram_0_i_200_n_0));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    mem_reg_bram_0_i_202
       (.I0(mem_reg_bram_0_i_155_n_11),
        .I1(mem_reg_bram_0_i_155_n_10),
        .I2(mem_reg_bram_0_i_155_n_12),
        .I3(mem_reg_bram_0_i_155_n_9),
        .O(mem_reg_bram_0_i_202_n_0));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    mem_reg_bram_0_i_203
       (.I0(mem_reg_bram_0_i_155_n_8),
        .I1(mem_reg_bram_0_i_155_n_15),
        .I2(mem_reg_bram_0_i_155_n_14),
        .I3(mem_reg_bram_0_i_155_n_13),
        .O(mem_reg_bram_0_i_203_n_0));
  LUT2 #(
    .INIT(4'h7)) 
    mem_reg_bram_0_i_204
       (.I0(mem_reg_bram_0_i_144_n_12),
        .I1(mem_reg_bram_0_i_144_n_13),
        .O(mem_reg_bram_0_i_204_n_0));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    mem_reg_bram_0_i_205
       (.I0(mem_reg_bram_0_i_110_n_10),
        .I1(mem_reg_bram_0_i_110_n_9),
        .I2(mem_reg_bram_0_i_110_n_8),
        .I3(mem_reg_bram_0_i_110_n_15),
        .O(mem_reg_bram_0_i_205_n_0));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    mem_reg_bram_0_i_206
       (.I0(mem_reg_bram_0_i_110_n_14),
        .I1(mem_reg_bram_0_i_110_n_13),
        .I2(mem_reg_bram_0_i_110_n_12),
        .I3(mem_reg_bram_0_i_110_n_11),
        .O(mem_reg_bram_0_i_206_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    mem_reg_bram_0_i_207
       (.I0(mem_reg_bram_0_i_146_n_12),
        .I1(mem_reg_bram_0_i_146_n_13),
        .O(mem_reg_bram_0_i_207_n_0));
  LUT6 #(
    .INIT(64'h000002A20A0A02A2)) 
    mem_reg_bram_0_i_29
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(mem_reg_bram_0_i_91_n_0),
        .I2(\FSM_onehot_state_reg[2] ),
        .I3(mem_reg_bram_0_10),
        .I4(\FSM_onehot_state_reg[5] ),
        .I5(mem_reg_bram_0_i_93_n_0),
        .O(mem_reg_bram_0_i_29_n_0));
  LUT6 #(
    .INIT(64'h1111111011101110)) 
    mem_reg_bram_0_i_30
       (.I0(mem_reg_bram_0_5[5]),
        .I1(mem_reg_bram_0_5[4]),
        .I2(mem_reg_bram_0_i_94_n_0),
        .I3(mem_reg_bram_0_i_95_n_0),
        .I4(\FSM_onehot_state_reg[3] ),
        .I5(load_val[5]),
        .O(mem_reg_bram_0_i_30_n_0));
  LUT6 #(
    .INIT(64'h0000454400004444)) 
    mem_reg_bram_0_i_31
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mem_reg_bram_0_i_97_n_0),
        .I2(mem_reg_bram_0_9),
        .I3(mem_reg_bram_0_5[1]),
        .I4(mem_reg_bram_0_5[5]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_31_n_0));
  LUT6 #(
    .INIT(64'h0054004400440044)) 
    mem_reg_bram_0_i_32
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mem_reg_bram_0_i_99_n_0),
        .I2(mem_reg_bram_0_5[1]),
        .I3(mem_reg_bram_0_5[5]),
        .I4(\FSM_onehot_state_reg[2] ),
        .I5(load_val[4]),
        .O(mem_reg_bram_0_i_32_n_0));
  LUT6 #(
    .INIT(64'h0000880AAAAAAAAA)) 
    mem_reg_bram_0_i_33
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(load_val[3]),
        .I2(mem_reg_bram_0_i_100_n_0),
        .I3(\FSM_onehot_state_reg[2] ),
        .I4(\FSM_onehot_state_reg[5] ),
        .I5(mem_reg_bram_0_i_101_n_0),
        .O(mem_reg_bram_0_i_33_n_0));
  LUT6 #(
    .INIT(64'h00008A80AAAAAAAA)) 
    mem_reg_bram_0_i_34
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(load_val[2]),
        .I2(\FSM_onehot_state_reg[2] ),
        .I3(mem_reg_bram_0_i_102_n_0),
        .I4(\FSM_onehot_state_reg[5] ),
        .I5(mem_reg_bram_0_i_103_n_0),
        .O(mem_reg_bram_0_i_34_n_0));
  LUT6 #(
    .INIT(64'h8A80AAAA8A808A80)) 
    mem_reg_bram_0_i_35
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(mem_reg_bram_0_i_104_n_0),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_i_105_n_0),
        .I4(mem_reg_bram_0_8),
        .I5(\FSM_onehot_state_reg[3] ),
        .O(mem_reg_bram_0_i_35_n_0));
  LUT6 #(
    .INIT(64'h0000110111111111)) 
    mem_reg_bram_0_i_36
       (.I0(mem_reg_bram_0_5[5]),
        .I1(mem_reg_bram_0_5[4]),
        .I2(\FSM_onehot_state_reg[2] ),
        .I3(load_val[1]),
        .I4(mem_reg_bram_0_i_107_n_0),
        .I5(mem_reg_bram_0_i_108_n_0),
        .O(mem_reg_bram_0_i_36_n_0));
  LUT6 #(
    .INIT(64'h0202020202A2A202)) 
    mem_reg_bram_0_i_37
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(mem_reg_bram_0_i_109_n_0),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_i_110_n_12),
        .I4(mem_reg_bram_0_i_111_n_0),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_37_n_0));
  LUT6 #(
    .INIT(64'h0202020202A2A202)) 
    mem_reg_bram_0_i_38
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(mem_reg_bram_0_i_112_n_0),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_i_110_n_13),
        .I4(mem_reg_bram_0_i_113_n_0),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_38_n_0));
  LUT6 #(
    .INIT(64'h0202020202A2A202)) 
    mem_reg_bram_0_i_39
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(mem_reg_bram_0_i_114_n_0),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_i_110_n_14),
        .I4(mem_reg_bram_0_i_115_n_0),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_39_n_0));
  LUT6 #(
    .INIT(64'h0054004400440044)) 
    mem_reg_bram_0_i_40
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mem_reg_bram_0_i_116_n_0),
        .I2(mem_reg_bram_0_5[1]),
        .I3(mem_reg_bram_0_5[5]),
        .I4(\FSM_onehot_state_reg[2] ),
        .I5(load_val[0]),
        .O(mem_reg_bram_0_i_40_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_43
       (.I0(mem_reg_bram_0_5[2]),
        .I1(mem_reg_bram_0_5[3]),
        .O(\FSM_onehot_state_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'h01)) 
    mem_reg_bram_0_i_45
       (.I0(mem_reg_bram_0_5[5]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[3]),
        .O(\FSM_onehot_state_reg[5] ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT4 #(
    .INIT(16'h1110)) 
    mem_reg_bram_0_i_47
       (.I0(mem_reg_bram_0_5[5]),
        .I1(mem_reg_bram_0_5[4]),
        .I2(mem_reg_bram_0_5[3]),
        .I3(mem_reg_bram_0_5[2]),
        .O(\FSM_onehot_state_reg[5]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_66
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mem_reg_bram_0_5[5]),
        .O(\FSM_onehot_state_reg[4] ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT4 #(
    .INIT(16'h1110)) 
    mem_reg_bram_0_i_68
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[2]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[4]),
        .O(\FSM_onehot_state_reg[3]_0 ));
  LUT6 #(
    .INIT(64'hD1D1FFD1D1D1D1D1)) 
    mem_reg_bram_0_i_69
       (.I0(\FSM_onehot_state_reg[4] ),
        .I1(\FSM_onehot_state_reg[3] ),
        .I2(mem_reg_bram_0_6[5]),
        .I3(\FSM_onehot_state_reg[5] ),
        .I4(mem_reg_bram_0_5[2]),
        .I5(ext_addr_IBUF[5]),
        .O(\load_i_reg[7] ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT5 #(
    .INIT(32'hFAFAFA02)) 
    mem_reg_bram_0_i_71
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[2]),
        .I4(mem_reg_bram_0_5[3]),
        .O(\FSM_onehot_state_reg[4]_1 ));
  LUT6 #(
    .INIT(64'h000C000C000C000A)) 
    mem_reg_bram_0_i_73
       (.I0(ext_addr_IBUF[4]),
        .I1(mem_reg_bram_0_6[4]),
        .I2(mem_reg_bram_0_5[3]),
        .I3(mem_reg_bram_0_5[2]),
        .I4(mem_reg_bram_0_5[5]),
        .I5(mem_reg_bram_0_5[1]),
        .O(\load_i_reg[6] ));
  LUT6 #(
    .INIT(64'h4C4C4C4C5D5D4DFD)) 
    mem_reg_bram_0_i_76
       (.I0(ext_addr_IBUF[3]),
        .I1(mem_reg_bram_0_i_137_n_0),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_7),
        .I4(mem_reg_bram_0_5[2]),
        .I5(\FSM_onehot_state_reg[4] ),
        .O(\cmp_i_reg[4] ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    mem_reg_bram_0_i_78
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[2]),
        .O(\FSM_onehot_state_reg[3]_1 ));
  LUT6 #(
    .INIT(64'h0000005300000000)) 
    mem_reg_bram_0_i_79
       (.I0(ext_addr_IBUF[2]),
        .I1(mem_reg_bram_0_6[2]),
        .I2(\FSM_onehot_state_reg[5] ),
        .I3(mem_reg_bram_0_5[5]),
        .I4(mem_reg_bram_0_5[4]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(\load_i_reg[3] ));
  LUT6 #(
    .INIT(64'h0F330F220F333322)) 
    mem_reg_bram_0_i_83
       (.I0(mem_reg_bram_0_5[4]),
        .I1(ext_addr_IBUF[0]),
        .I2(mem_reg_bram_0_6[0]),
        .I3(\FSM_onehot_state_reg[2] ),
        .I4(mem_reg_bram_0_5[5]),
        .I5(mem_reg_bram_0_5[1]),
        .O(\FSM_onehot_state_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hF70404F704F704F7)) 
    mem_reg_bram_0_i_91
       (.I0(mem_reg_bram_0_12[11]),
        .I1(mem_reg_bram_0_13[1]),
        .I2(mem_reg_bram_0_13[0]),
        .I3(mem_reg_bram_0_i_144_n_12),
        .I4(mem_reg_bram_0_i_145_n_0),
        .I5(mem_reg_bram_0_i_144_n_13),
        .O(mem_reg_bram_0_i_91_n_0));
  LUT6 #(
    .INIT(64'hCFCC75770000FFFF)) 
    mem_reg_bram_0_i_93
       (.I0(mem_reg_bram_0_i_146_n_3),
        .I1(mem_reg_bram_0_i_146_n_14),
        .I2(mem_reg_bram_0_i_147_n_0),
        .I3(mem_reg_bram_0_i_146_n_15),
        .I4(mem_reg_bram_0_i_146_n_12),
        .I5(mem_reg_bram_0_i_146_n_13),
        .O(mem_reg_bram_0_i_93_n_0));
  LUT6 #(
    .INIT(64'h0000010001000000)) 
    mem_reg_bram_0_i_94
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[1]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[2]),
        .I4(mem_reg_bram_0_i_146_n_13),
        .I5(mem_reg_bram_0_i_148_n_0),
        .O(mem_reg_bram_0_i_94_n_0));
  LUT6 #(
    .INIT(64'h0000000040454540)) 
    mem_reg_bram_0_i_95
       (.I0(\FSM_onehot_state_reg[5] ),
        .I1(mem_reg_bram_0_12[10]),
        .I2(mem_reg_bram_0_11),
        .I3(mem_reg_bram_0_i_144_n_13),
        .I4(mem_reg_bram_0_i_145_n_0),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_95_n_0));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT4 #(
    .INIT(16'h1110)) 
    mem_reg_bram_0_i_96
       (.I0(mem_reg_bram_0_5[3]),
        .I1(mem_reg_bram_0_5[2]),
        .I2(mem_reg_bram_0_5[5]),
        .I3(mem_reg_bram_0_5[1]),
        .O(\FSM_onehot_state_reg[3] ));
  LUT6 #(
    .INIT(64'h0000000077744474)) 
    mem_reg_bram_0_i_97
       (.I0(mem_reg_bram_0_i_149_n_0),
        .I1(\FSM_onehot_state_reg[5] ),
        .I2(mem_reg_bram_0_i_150_n_0),
        .I3(mem_reg_bram_0_11),
        .I4(mem_reg_bram_0_12[9]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_97_n_0));
  LUT6 #(
    .INIT(64'h0000000077744474)) 
    mem_reg_bram_0_i_99
       (.I0(mem_reg_bram_0_i_153_n_0),
        .I1(\FSM_onehot_state_reg[5] ),
        .I2(mem_reg_bram_0_i_154_n_0),
        .I3(mem_reg_bram_0_11),
        .I4(mem_reg_bram_0_12[8]),
        .I5(\FSM_onehot_state_reg[2] ),
        .O(mem_reg_bram_0_i_99_n_0));
  LUT5 #(
    .INIT(32'hF7F7F080)) 
    mismatch_i_1
       (.I0(start_i_IBUF),
        .I1(mem_reg_bram_0_5[0]),
        .I2(mismatch_i_2_n_0),
        .I3(mismatch_reg),
        .I4(mismatch_reg_0),
        .O(\FSM_onehot_state_reg[0] ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_10
       (.I0(mismatch_i_4_0),
        .I1(mismatch_i_4_1),
        .I2(Q[1]),
        .I3(mismatch_i_4_2),
        .I4(Q[0]),
        .I5(mismatch_i_4_3),
        .O(mismatch1[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_11
       (.I0(mismatch_i_4_4),
        .I1(mismatch_i_4_5),
        .I2(Q[1]),
        .I3(mismatch_i_4_6),
        .I4(Q[0]),
        .I5(mismatch_i_4_7),
        .O(mismatch1[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_12
       (.I0(mismatch_i_4_8),
        .I1(mismatch_i_4_9),
        .I2(Q[1]),
        .I3(mismatch_i_4_10),
        .I4(Q[0]),
        .I5(mismatch_i_4_11),
        .O(mismatch1[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_13
       (.I0(mismatch_i_5_0),
        .I1(mismatch_i_5_1),
        .I2(Q[1]),
        .I3(mismatch_i_5_2),
        .I4(Q[0]),
        .I5(mismatch_i_5_3),
        .O(mismatch1[9]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_14
       (.I0(mismatch_i_5_4),
        .I1(mismatch_i_5_5),
        .I2(Q[1]),
        .I3(mismatch_i_5_6),
        .I4(Q[0]),
        .I5(mismatch_i_5_7),
        .O(mismatch1[10]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_15
       (.I0(mismatch_i_5_8),
        .I1(mismatch_i_5_9),
        .I2(Q[1]),
        .I3(mismatch_i_5_10),
        .I4(Q[0]),
        .I5(mismatch_i_5_11),
        .O(mismatch1[11]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_16
       (.I0(mismatch_i_6_0),
        .I1(mismatch_i_6_1),
        .I2(Q[1]),
        .I3(mismatch_i_6_2),
        .I4(Q[0]),
        .I5(mismatch_i_6_3),
        .O(mismatch1[6]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_17
       (.I0(mismatch_i_6_8),
        .I1(mismatch_i_6_9),
        .I2(Q[1]),
        .I3(mismatch_i_6_10),
        .I4(Q[0]),
        .I5(mismatch_i_6_11),
        .O(mismatch1[8]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_18
       (.I0(mismatch_i_6_4),
        .I1(mismatch_i_6_5),
        .I2(Q[1]),
        .I3(mismatch_i_6_6),
        .I4(Q[0]),
        .I5(mismatch_i_6_7),
        .O(mismatch1[7]));
  LUT5 #(
    .INIT(32'hAAAAA8AA)) 
    mismatch_i_2
       (.I0(mem_reg_bram_0_5[4]),
        .I1(mismatch_i_3_n_0),
        .I2(mismatch_i_4_n_0),
        .I3(mismatch_i_5_n_0),
        .I4(mismatch_i_6_n_0),
        .O(mismatch_i_2_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    mismatch_i_3
       (.I0(mismatch1[3]),
        .I1(DOUTBDOUT[3]),
        .I2(DOUTBDOUT[4]),
        .I3(mismatch1[4]),
        .I4(DOUTBDOUT[5]),
        .I5(mismatch1[5]),
        .O(mismatch_i_3_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    mismatch_i_4
       (.I0(mismatch1[0]),
        .I1(DOUTBDOUT[0]),
        .I2(DOUTBDOUT[1]),
        .I3(mismatch1[1]),
        .I4(DOUTBDOUT[2]),
        .I5(mismatch1[2]),
        .O(mismatch_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    mismatch_i_5
       (.I0(mismatch1[9]),
        .I1(DOUTBDOUT[9]),
        .I2(DOUTBDOUT[10]),
        .I3(mismatch1[10]),
        .I4(DOUTBDOUT[11]),
        .I5(mismatch1[11]),
        .O(mismatch_i_5_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    mismatch_i_6
       (.I0(mismatch1[6]),
        .I1(DOUTBDOUT[6]),
        .I2(DOUTBDOUT[8]),
        .I3(mismatch1[8]),
        .I4(DOUTBDOUT[7]),
        .I5(mismatch1[7]),
        .O(mismatch_i_6_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_7
       (.I0(mismatch_i_3_0),
        .I1(mismatch_i_3_1),
        .I2(Q[1]),
        .I3(mismatch_i_3_2),
        .I4(Q[0]),
        .I5(mismatch_i_3_3),
        .O(mismatch1[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_8
       (.I0(mismatch_i_3_4),
        .I1(mismatch_i_3_5),
        .I2(Q[1]),
        .I3(mismatch_i_3_6),
        .I4(Q[0]),
        .I5(mismatch_i_3_7),
        .O(mismatch1[4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    mismatch_i_9
       (.I0(mismatch_i_3_8),
        .I1(mismatch_i_3_9),
        .I2(Q[1]),
        .I3(mismatch_i_3_10),
        .I4(Q[0]),
        .I5(mismatch_i_3_11),
        .O(mismatch1[5]));
endmodule

module control_fsm
   (\k_r_reg_rep[0]_0 ,
    \k_r_reg_rep[0]_1 ,
    \k_r_reg_rep[0]_2 ,
    \k_r_reg_rep[0]_3 ,
    \k_r_reg_rep[0]_4 ,
    \k_r_reg_rep[0]_5 ,
    \k_r_reg_rep[0]_6 ,
    \k_r_reg_rep[0]_7 ,
    \k_r_reg_rep[0]_8 ,
    \k_r_reg_rep[0]_9 ,
    \k_r_reg_rep[0]_10 ,
    \k_r_reg_rep[0]_11 ,
    \k_r_reg_rep[0]_12 ,
    \k_r_reg_rep[0]_13 ,
    \k_r_reg_rep[0]_14 ,
    \k_r_reg_rep[0]_15 ,
    \k_r_reg_rep[0]_16 ,
    \k_r_reg_rep[0]_17 ,
    \k_r_reg_rep[0]_18 ,
    \k_r_reg_rep[0]_19 ,
    \k_r_reg_rep[0]_20 ,
    \k_r_reg_rep[0]_21 ,
    \k_r_reg_rep[0]_22 ,
    \k_r_reg_rep[0]_23 ,
    inv_start,
    Q,
    ADDRBWRADDR,
    ADDRARDADDR,
    \j_off_reg[0]_0 ,
    \phase_cnt_reg[1]_0 ,
    \len_r_reg[0]_0 ,
    \j_off_reg[3]_0 ,
    \start_r_reg[6]_0 ,
    \j_off_reg[6]_0 ,
    \j_off_reg[3]_1 ,
    \j_off_reg[0]_1 ,
    \j_off_reg[7]_0 ,
    WEBWE,
    \len_r_reg[4]_0 ,
    \k_r_reg_rep[6]_0 ,
    mem_reg_bram_0,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    ext_addr_IBUF,
    mem_reg_bram_0_2,
    mem_reg_bram_0_3,
    mem_reg_bram_0_4,
    mem_reg_bram_0_5,
    mem_reg_bram_0_6,
    mem_reg_bram_0_7,
    mem_reg_bram_0_8,
    mem_reg_bram_0_9,
    mem_reg_bram_0_10,
    mem_reg_bram_0_11,
    mem_reg_bram_0_12,
    mem_reg_bram_0_13,
    mem_reg_bram_0_14,
    mem_reg_bram_0_15,
    mem_reg_bram_0_16,
    mem_reg_bram_0_17,
    mem_reg_bram_0_i_80_0,
    \phase_cnt_reg[0]_0 ,
    mem_reg_bram_0_18,
    rst_IBUF,
    mem_reg_bram_0_19,
    mem_reg_bram_0_20,
    clk_IBUF_BUFG);
  output \k_r_reg_rep[0]_0 ;
  output \k_r_reg_rep[0]_1 ;
  output \k_r_reg_rep[0]_2 ;
  output \k_r_reg_rep[0]_3 ;
  output \k_r_reg_rep[0]_4 ;
  output \k_r_reg_rep[0]_5 ;
  output \k_r_reg_rep[0]_6 ;
  output \k_r_reg_rep[0]_7 ;
  output \k_r_reg_rep[0]_8 ;
  output \k_r_reg_rep[0]_9 ;
  output \k_r_reg_rep[0]_10 ;
  output \k_r_reg_rep[0]_11 ;
  output \k_r_reg_rep[0]_12 ;
  output \k_r_reg_rep[0]_13 ;
  output \k_r_reg_rep[0]_14 ;
  output \k_r_reg_rep[0]_15 ;
  output \k_r_reg_rep[0]_16 ;
  output \k_r_reg_rep[0]_17 ;
  output \k_r_reg_rep[0]_18 ;
  output \k_r_reg_rep[0]_19 ;
  output \k_r_reg_rep[0]_20 ;
  output \k_r_reg_rep[0]_21 ;
  output \k_r_reg_rep[0]_22 ;
  output \k_r_reg_rep[0]_23 ;
  output inv_start;
  output [0:0]Q;
  output [5:0]ADDRBWRADDR;
  output [1:0]ADDRARDADDR;
  output [0:0]\j_off_reg[0]_0 ;
  output \phase_cnt_reg[1]_0 ;
  output \len_r_reg[0]_0 ;
  output \j_off_reg[3]_0 ;
  output \start_r_reg[6]_0 ;
  output \j_off_reg[6]_0 ;
  output \j_off_reg[3]_1 ;
  output \j_off_reg[0]_1 ;
  output \j_off_reg[7]_0 ;
  output [0:0]WEBWE;
  output \len_r_reg[4]_0 ;
  output [0:0]\k_r_reg_rep[6]_0 ;
  input [3:0]mem_reg_bram_0;
  input [4:0]mem_reg_bram_0_0;
  input mem_reg_bram_0_1;
  input [4:0]ext_addr_IBUF;
  input mem_reg_bram_0_2;
  input mem_reg_bram_0_3;
  input mem_reg_bram_0_4;
  input mem_reg_bram_0_5;
  input mem_reg_bram_0_6;
  input mem_reg_bram_0_7;
  input mem_reg_bram_0_8;
  input mem_reg_bram_0_9;
  input mem_reg_bram_0_10;
  input mem_reg_bram_0_11;
  input mem_reg_bram_0_12;
  input [0:0]mem_reg_bram_0_13;
  input mem_reg_bram_0_14;
  input [1:0]mem_reg_bram_0_15;
  input mem_reg_bram_0_16;
  input mem_reg_bram_0_17;
  input mem_reg_bram_0_i_80_0;
  input \phase_cnt_reg[0]_0 ;
  input mem_reg_bram_0_18;
  input rst_IBUF;
  input mem_reg_bram_0_19;
  input mem_reg_bram_0_20;
  input clk_IBUF_BUFG;

  wire [1:0]ADDRARDADDR;
  wire [5:0]ADDRBWRADDR;
  wire \FSM_onehot_state[2]_i_10_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_2_n_0 ;
  wire \FSM_onehot_state[2]_i_3_n_0 ;
  wire \FSM_onehot_state[2]_i_4_n_0 ;
  wire \FSM_onehot_state[2]_i_5_n_0 ;
  wire \FSM_onehot_state[2]_i_6_n_0 ;
  wire \FSM_onehot_state[2]_i_7_n_0 ;
  wire \FSM_onehot_state[2]_i_8_n_0 ;
  wire \FSM_onehot_state[2]_i_9_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire [0:0]Q;
  wire [0:0]WEBWE;
  wire clk_IBUF_BUFG;
  wire [4:0]ext_addr_IBUF;
  wire inv_start;
  wire \j_off[0]_i_1_n_0 ;
  wire \j_off[1]_i_1_n_0 ;
  wire \j_off[2]_i_1_n_0 ;
  wire \j_off[3]_i_1_n_0 ;
  wire \j_off[4]_i_1_n_0 ;
  wire \j_off[5]_i_1_n_0 ;
  wire \j_off[5]_i_2_n_0 ;
  wire \j_off[6]_i_1_n_0 ;
  wire \j_off[7]_i_1_n_0 ;
  wire \j_off[7]_i_2_n_0 ;
  wire \j_off[7]_i_3_n_0 ;
  wire \j_off[7]_i_4_n_0 ;
  wire [0:0]\j_off_reg[0]_0 ;
  wire \j_off_reg[0]_1 ;
  wire \j_off_reg[3]_0 ;
  wire \j_off_reg[3]_1 ;
  wire \j_off_reg[6]_0 ;
  wire \j_off_reg[7]_0 ;
  wire \j_off_reg_n_0_[1] ;
  wire \j_off_reg_n_0_[2] ;
  wire \j_off_reg_n_0_[3] ;
  wire \j_off_reg_n_0_[4] ;
  wire \j_off_reg_n_0_[5] ;
  wire \j_off_reg_n_0_[6] ;
  wire \j_off_reg_n_0_[7] ;
  wire [6:0]k_r;
  wire \k_r[1]_i_1__0_n_0 ;
  wire \k_r[5]_i_1__0_n_0 ;
  wire \k_r[6]_i_2__0_n_0 ;
  wire \k_r_reg_n_0_[0] ;
  wire \k_r_reg_n_0_[1] ;
  wire \k_r_reg_n_0_[2] ;
  wire \k_r_reg_n_0_[3] ;
  wire \k_r_reg_n_0_[4] ;
  wire \k_r_reg_n_0_[5] ;
  wire \k_r_reg_n_0_[6] ;
  wire \k_r_reg_rep[0]_0 ;
  wire \k_r_reg_rep[0]_1 ;
  wire \k_r_reg_rep[0]_10 ;
  wire \k_r_reg_rep[0]_11 ;
  wire \k_r_reg_rep[0]_12 ;
  wire \k_r_reg_rep[0]_13 ;
  wire \k_r_reg_rep[0]_14 ;
  wire \k_r_reg_rep[0]_15 ;
  wire \k_r_reg_rep[0]_16 ;
  wire \k_r_reg_rep[0]_17 ;
  wire \k_r_reg_rep[0]_18 ;
  wire \k_r_reg_rep[0]_19 ;
  wire \k_r_reg_rep[0]_2 ;
  wire \k_r_reg_rep[0]_20 ;
  wire \k_r_reg_rep[0]_21 ;
  wire \k_r_reg_rep[0]_22 ;
  wire \k_r_reg_rep[0]_23 ;
  wire \k_r_reg_rep[0]_3 ;
  wire \k_r_reg_rep[0]_4 ;
  wire \k_r_reg_rep[0]_5 ;
  wire \k_r_reg_rep[0]_6 ;
  wire \k_r_reg_rep[0]_7 ;
  wire \k_r_reg_rep[0]_8 ;
  wire \k_r_reg_rep[0]_9 ;
  wire [0:0]\k_r_reg_rep[6]_0 ;
  wire \k_r_reg_rep_n_0_[0] ;
  wire \k_r_reg_rep_n_0_[1] ;
  wire \k_r_reg_rep_n_0_[2] ;
  wire \k_r_reg_rep_n_0_[3] ;
  wire \k_r_reg_rep_n_0_[4] ;
  wire \k_r_reg_rep_n_0_[5] ;
  wire [2:0]layer;
  wire \layer[1]_i_1_n_0 ;
  wire \layer[2]_i_1_n_0 ;
  wire \layer[2]_i_3_n_0 ;
  wire \layer[2]_i_4_n_0 ;
  wire \layer_reg_n_0_[0] ;
  wire \layer_reg_n_0_[1] ;
  wire \layer_reg_n_0_[2] ;
  wire \len_r[0]_i_1_n_0 ;
  wire \len_r[1]_i_1_n_0 ;
  wire \len_r[2]_i_1__0_n_0 ;
  wire \len_r[3]_i_1__0_n_0 ;
  wire \len_r[4]_i_1__0_n_0 ;
  wire \len_r[5]_i_1__0_n_0 ;
  wire \len_r[6]_i_1__0_n_0 ;
  wire \len_r_reg[0]_0 ;
  wire \len_r_reg[4]_0 ;
  wire [3:0]mem_reg_bram_0;
  wire [4:0]mem_reg_bram_0_0;
  wire mem_reg_bram_0_1;
  wire mem_reg_bram_0_10;
  wire mem_reg_bram_0_11;
  wire mem_reg_bram_0_12;
  wire [0:0]mem_reg_bram_0_13;
  wire mem_reg_bram_0_14;
  wire [1:0]mem_reg_bram_0_15;
  wire mem_reg_bram_0_16;
  wire mem_reg_bram_0_17;
  wire mem_reg_bram_0_18;
  wire mem_reg_bram_0_19;
  wire mem_reg_bram_0_2;
  wire mem_reg_bram_0_20;
  wire mem_reg_bram_0_3;
  wire mem_reg_bram_0_4;
  wire mem_reg_bram_0_5;
  wire mem_reg_bram_0_6;
  wire mem_reg_bram_0_7;
  wire mem_reg_bram_0_8;
  wire mem_reg_bram_0_9;
  wire mem_reg_bram_0_i_121_n_0;
  wire mem_reg_bram_0_i_122_n_0;
  wire mem_reg_bram_0_i_123_n_0;
  wire mem_reg_bram_0_i_125_n_0;
  wire mem_reg_bram_0_i_127_n_0;
  wire mem_reg_bram_0_i_132_n_0;
  wire mem_reg_bram_0_i_133_n_0;
  wire mem_reg_bram_0_i_135_n_0;
  wire mem_reg_bram_0_i_139_n_0;
  wire mem_reg_bram_0_i_140_n_0;
  wire mem_reg_bram_0_i_179_n_0;
  wire mem_reg_bram_0_i_61_n_0;
  wire mem_reg_bram_0_i_62_n_0;
  wire mem_reg_bram_0_i_63_n_0;
  wire mem_reg_bram_0_i_72_n_0;
  wire mem_reg_bram_0_i_74_n_0;
  wire mem_reg_bram_0_i_75_n_0;
  wire mem_reg_bram_0_i_77_n_0;
  wire mem_reg_bram_0_i_80_0;
  wire mem_reg_bram_0_i_80_n_0;
  wire mem_reg_bram_0_i_81_n_0;
  wire [2:0]phase_cnt;
  wire \phase_cnt[2]_i_1_n_0 ;
  wire \phase_cnt_reg[0]_0 ;
  wire \phase_cnt_reg[1]_0 ;
  wire \phase_cnt_reg_n_0_[0] ;
  wire \phase_cnt_reg_n_0_[1] ;
  wire \phase_cnt_reg_n_0_[2] ;
  wire rst_IBUF;
  wire \start_r[1]_i_1_n_0 ;
  wire \start_r[2]_i_1_n_0 ;
  wire \start_r[3]_i_1_n_0 ;
  wire \start_r[3]_i_2_n_0 ;
  wire \start_r[4]_i_1_n_0 ;
  wire \start_r[4]_i_2_n_0 ;
  wire \start_r[5]_i_1_n_0 ;
  wire \start_r[5]_i_2_n_0 ;
  wire \start_r[6]_i_1_n_0 ;
  wire \start_r[6]_i_2_n_0 ;
  wire \start_r[7]_i_1_n_0 ;
  wire \start_r[7]_i_2_n_0 ;
  wire \start_r[7]_i_3_n_0 ;
  wire \start_r_reg[6]_0 ;
  wire \start_r_reg_n_0_[1] ;
  wire \start_r_reg_n_0_[2] ;
  wire \start_r_reg_n_0_[3] ;
  wire \start_r_reg_n_0_[4] ;
  wire \start_r_reg_n_0_[5] ;
  wire \start_r_reg_n_0_[6] ;
  wire \start_r_reg_n_0_[7] ;
  wire [8:1]two_len_ext;

  LUT5 #(
    .INIT(32'hFFFFF111)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(\FSM_onehot_state[2]_i_2_n_0 ),
        .I1(\FSM_onehot_state[2]_i_3_n_0 ),
        .I2(\phase_cnt_reg[0]_0 ),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(Q),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \FSM_onehot_state[2]_i_10 
       (.I0(two_len_ext[5]),
        .I1(two_len_ext[2]),
        .I2(two_len_ext[1]),
        .I3(two_len_ext[3]),
        .I4(two_len_ext[4]),
        .I5(two_len_ext[6]),
        .O(\FSM_onehot_state[2]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hDFFFFFFF)) 
    \FSM_onehot_state[2]_i_2 
       (.I0(\FSM_onehot_state[2]_i_4_n_0 ),
        .I1(\phase_cnt_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\phase_cnt_reg_n_0_[2] ),
        .I4(\phase_cnt_reg_n_0_[1] ),
        .O(\FSM_onehot_state[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hBFFF)) 
    \FSM_onehot_state[2]_i_3 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[2] ),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\layer[2]_i_4_n_0 ),
        .O(\FSM_onehot_state[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000004404004)) 
    \FSM_onehot_state[2]_i_4 
       (.I0(\FSM_onehot_state[2]_i_5_n_0 ),
        .I1(\FSM_onehot_state[2]_i_6_n_0 ),
        .I2(\j_off_reg_n_0_[3] ),
        .I3(two_len_ext[4]),
        .I4(\FSM_onehot_state[2]_i_7_n_0 ),
        .I5(\FSM_onehot_state[2]_i_8_n_0 ),
        .O(\FSM_onehot_state[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBFFDEFF7FB7FFEDF)) 
    \FSM_onehot_state[2]_i_5 
       (.I0(\j_off_reg[0]_0 ),
        .I1(\j_off_reg_n_0_[2] ),
        .I2(two_len_ext[2]),
        .I3(two_len_ext[1]),
        .I4(two_len_ext[3]),
        .I5(\j_off_reg_n_0_[1] ),
        .O(\FSM_onehot_state[2]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h42841821)) 
    \FSM_onehot_state[2]_i_6 
       (.I0(\j_off_reg_n_0_[4] ),
        .I1(two_len_ext[6]),
        .I2(two_len_ext[5]),
        .I3(\FSM_onehot_state[2]_i_9_n_0 ),
        .I4(\j_off_reg_n_0_[5] ),
        .O(\FSM_onehot_state[2]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \FSM_onehot_state[2]_i_7 
       (.I0(two_len_ext[3]),
        .I1(two_len_ext[1]),
        .I2(two_len_ext[2]),
        .O(\FSM_onehot_state[2]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hF96F6FF6)) 
    \FSM_onehot_state[2]_i_8 
       (.I0(two_len_ext[8]),
        .I1(\j_off_reg_n_0_[7] ),
        .I2(two_len_ext[7]),
        .I3(\FSM_onehot_state[2]_i_10_n_0 ),
        .I4(\j_off_reg_n_0_[6] ),
        .O(\FSM_onehot_state[2]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \FSM_onehot_state[2]_i_9 
       (.I0(two_len_ext[2]),
        .I1(two_len_ext[1]),
        .I2(two_len_ext[3]),
        .I3(two_len_ext[4]),
        .O(\FSM_onehot_state[2]_i_9_n_0 ));
  (* FSM_ENCODED_STATES = "S_IDLE:001,S_RUN:010,S_DONE:100," *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[2]_i_1_n_0 ),
        .D(Q),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:001,S_RUN:010,S_DONE:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[2]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:001,S_RUN:010,S_DONE:100," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_onehot_state[2]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[1] ),
        .Q(Q),
        .R(rst_IBUF));
  LUT6 #(
    .INIT(64'h4707B6D7B4864E4A)) 
    g0_b0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_0 ));
  LUT6 #(
    .INIT(64'hF1D781826F169330)) 
    g0_b1
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_1 ));
  LUT6 #(
    .INIT(64'h6452C21C418CA34A)) 
    g0_b10
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_10 ));
  LUT6 #(
    .INIT(64'h33A114E43A52301C)) 
    g0_b11
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_11 ));
  LUT6 #(
    .INIT(64'hA17D00DCE69A2B24)) 
    g0_b2
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_2 ));
  LUT6 #(
    .INIT(64'hDE53CB1A32276A48)) 
    g0_b3
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_3 ));
  LUT6 #(
    .INIT(64'h03729E0CF5A4EABC)) 
    g0_b4
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_4 ));
  LUT6 #(
    .INIT(64'h32E4FA55E2B57360)) 
    g0_b5
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_5 ));
  LUT6 #(
    .INIT(64'h45C88C4A185896FA)) 
    g0_b6
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_6 ));
  LUT6 #(
    .INIT(64'hDC5A075C415AB40A)) 
    g0_b7
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_7 ));
  LUT6 #(
    .INIT(64'h94FFD623F99F0AC0)) 
    g0_b8
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_8 ));
  LUT6 #(
    .INIT(64'h8B249B08EC10DAF6)) 
    g0_b9
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_9 ));
  LUT6 #(
    .INIT(64'h68543FB4B5DF4D3F)) 
    g1_b0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_12 ));
  LUT6 #(
    .INIT(64'hB5FCD3520193C224)) 
    g1_b1
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_13 ));
  LUT6 #(
    .INIT(64'h0F1A018D005B0590)) 
    g1_b10
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_22 ));
  LUT6 #(
    .INIT(64'hB061D46A2E84E64A)) 
    g1_b11
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_23 ));
  LUT6 #(
    .INIT(64'h7AF30FBC5EDD7294)) 
    g1_b2
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_14 ));
  LUT6 #(
    .INIT(64'h930002C251A8A88A)) 
    g1_b3
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_15 ));
  LUT6 #(
    .INIT(64'h77D53E3F18FA1469)) 
    g1_b4
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_16 ));
  LUT6 #(
    .INIT(64'hF3B1FBF721FFBA50)) 
    g1_b5
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_17 ));
  LUT6 #(
    .INIT(64'hE4F30CB6188EFEFE)) 
    g1_b6
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_18 ));
  LUT6 #(
    .INIT(64'h03454C2E956DDD62)) 
    g1_b7
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_19 ));
  LUT6 #(
    .INIT(64'h648442346F70C100)) 
    g1_b8
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_20 ));
  LUT6 #(
    .INIT(64'h65C1AC8591BFD23E)) 
    g1_b9
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_21 ));
  LUT2 #(
    .INIT(4'h8)) 
    inv_start_i_1
       (.I0(Q),
        .I1(mem_reg_bram_0[0]),
        .O(inv_start));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \j_off[0]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg[0]_0 ),
        .O(\j_off[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \j_off[1]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg[0]_0 ),
        .I2(\j_off_reg_n_0_[1] ),
        .O(\j_off[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \j_off[2]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg_n_0_[1] ),
        .I2(\j_off_reg[0]_0 ),
        .I3(\j_off_reg_n_0_[2] ),
        .O(\j_off[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \j_off[3]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg[0]_0 ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[3] ),
        .O(\j_off[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \j_off[4]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg_n_0_[2] ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\j_off_reg[0]_0 ),
        .I4(\j_off_reg_n_0_[3] ),
        .I5(\j_off_reg_n_0_[4] ),
        .O(\j_off[4]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h28)) 
    \j_off[5]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off[5]_i_2_n_0 ),
        .I2(\j_off_reg_n_0_[5] ),
        .O(\j_off[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \j_off[5]_i_2 
       (.I0(\j_off_reg_n_0_[3] ),
        .I1(\j_off_reg[0]_0 ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[4] ),
        .O(\j_off[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \j_off[6]_i_1 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off[7]_i_4_n_0 ),
        .I2(\j_off_reg_n_0_[6] ),
        .O(\j_off[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF400040004000)) 
    \j_off[7]_i_1 
       (.I0(\phase_cnt_reg_n_0_[0] ),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .I4(\FSM_onehot_state_reg_n_0_[0] ),
        .I5(\phase_cnt_reg[0]_0 ),
        .O(\j_off[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \j_off[7]_i_2 
       (.I0(\j_off[7]_i_3_n_0 ),
        .I1(\j_off_reg_n_0_[6] ),
        .I2(\j_off[7]_i_4_n_0 ),
        .I3(\j_off_reg_n_0_[7] ),
        .O(\j_off[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \j_off[7]_i_3 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_state[2]_i_4_n_0 ),
        .O(\j_off[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \j_off[7]_i_4 
       (.I0(\j_off_reg_n_0_[4] ),
        .I1(\j_off_reg_n_0_[2] ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\j_off_reg[0]_0 ),
        .I4(\j_off_reg_n_0_[3] ),
        .I5(\j_off_reg_n_0_[5] ),
        .O(\j_off[7]_i_4_n_0 ));
  FDRE \j_off_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[0]_i_1_n_0 ),
        .Q(\j_off_reg[0]_0 ),
        .R(rst_IBUF));
  FDRE \j_off_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[1]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[2]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[3]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[4]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[5]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[6]_i_1_n_0 ),
        .Q(\j_off_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1_n_0 ),
        .D(\j_off[7]_i_2_n_0 ),
        .Q(\j_off_reg_n_0_[7] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    \k_r[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .O(k_r[0]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \k_r[1]_i_1__0 
       (.I0(\k_r_reg_n_0_[1] ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\k_r[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \k_r[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\k_r_reg_n_0_[1] ),
        .I3(\k_r_reg_n_0_[2] ),
        .O(k_r[2]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \k_r[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\k_r_reg_n_0_[1] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\k_r_reg_n_0_[2] ),
        .I4(\k_r_reg_n_0_[3] ),
        .O(k_r[3]));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \k_r[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\k_r_reg_n_0_[2] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\k_r_reg_n_0_[1] ),
        .I4(\k_r_reg_n_0_[3] ),
        .I5(\k_r_reg_n_0_[4] ),
        .O(k_r[4]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \k_r[5]_i_1__0 
       (.I0(\k_r[6]_i_2__0_n_0 ),
        .I1(\k_r_reg_n_0_[5] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\k_r[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \k_r[6]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\k_r_reg_n_0_[5] ),
        .I2(\k_r[6]_i_2__0_n_0 ),
        .I3(\k_r_reg_n_0_[6] ),
        .O(k_r[6]));
  LUT5 #(
    .INIT(32'h80000000)) 
    \k_r[6]_i_2__0 
       (.I0(\k_r_reg_n_0_[3] ),
        .I1(\k_r_reg_n_0_[1] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\k_r_reg_n_0_[2] ),
        .I4(\k_r_reg_n_0_[4] ),
        .O(\k_r[6]_i_2__0_n_0 ));
  FDSE \k_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[0]),
        .Q(\k_r_reg_n_0_[0] ),
        .S(rst_IBUF));
  FDRE \k_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\k_r[1]_i_1__0_n_0 ),
        .Q(\k_r_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \k_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[2]),
        .Q(\k_r_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \k_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[3]),
        .Q(\k_r_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \k_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[4]),
        .Q(\k_r_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \k_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\k_r[5]_i_1__0_n_0 ),
        .Q(\k_r_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \k_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[6]),
        .Q(\k_r_reg_n_0_[6] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[0]),
        .Q(\k_r_reg_rep_n_0_[0] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\k_r[1]_i_1__0_n_0 ),
        .Q(\k_r_reg_rep_n_0_[1] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[2]),
        .Q(\k_r_reg_rep_n_0_[2] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[3]),
        .Q(\k_r_reg_rep_n_0_[3] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[4]),
        .Q(\k_r_reg_rep_n_0_[4] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\k_r[5]_i_1__0_n_0 ),
        .Q(\k_r_reg_rep_n_0_[5] ),
        .R(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDRE \k_r_reg_rep[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(k_r[6]),
        .Q(\k_r_reg_rep[6]_0 ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \layer[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[0] ),
        .O(layer[0]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \layer[1]_i_1 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\layer[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAEFFFAAAAAAAA)) 
    \layer[2]_i_1 
       (.I0(\layer[2]_i_3_n_0 ),
        .I1(\layer_reg_n_0_[0] ),
        .I2(\layer_reg_n_0_[2] ),
        .I3(\layer_reg_n_0_[1] ),
        .I4(\FSM_onehot_state[2]_i_2_n_0 ),
        .I5(\layer[2]_i_4_n_0 ),
        .O(\layer[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \layer[2]_i_2 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\layer_reg_n_0_[0] ),
        .I3(\layer_reg_n_0_[2] ),
        .O(layer[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \layer[2]_i_3 
       (.I0(\phase_cnt_reg[0]_0 ),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .O(\layer[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h55565666666A6AAA)) 
    \layer[2]_i_4 
       (.I0(two_len_ext[8]),
        .I1(two_len_ext[7]),
        .I2(\start_r_reg_n_0_[6] ),
        .I3(\start_r[6]_i_2_n_0 ),
        .I4(two_len_ext[6]),
        .I5(\start_r_reg_n_0_[7] ),
        .O(\layer[2]_i_4_n_0 ));
  FDRE \layer_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(layer[0]),
        .Q(\layer_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \layer_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\layer[1]_i_1_n_0 ),
        .Q(\layer_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \layer_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(layer[2]),
        .Q(\layer_reg_n_0_[2] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[0]_i_1 
       (.I0(two_len_ext[2]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\len_r[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[1]_i_1 
       (.I0(two_len_ext[3]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\len_r[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[2]_i_1__0 
       (.I0(two_len_ext[4]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\len_r[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[3]_i_1__0 
       (.I0(two_len_ext[5]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\len_r[3]_i_1__0_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[4]_i_1__0 
       (.I0(two_len_ext[6]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\len_r[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[5]_i_1__0 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(two_len_ext[7]),
        .O(\len_r[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[6]_i_1__0 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(two_len_ext[8]),
        .O(\len_r[6]_i_1__0_n_0 ));
  FDRE \len_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[0]_i_1_n_0 ),
        .Q(two_len_ext[1]),
        .R(rst_IBUF));
  FDRE \len_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[1]_i_1_n_0 ),
        .Q(two_len_ext[2]),
        .R(rst_IBUF));
  FDRE \len_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[2]_i_1__0_n_0 ),
        .Q(two_len_ext[3]),
        .R(rst_IBUF));
  FDRE \len_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[3]_i_1__0_n_0 ),
        .Q(two_len_ext[4]),
        .R(rst_IBUF));
  FDRE \len_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[4]_i_1__0_n_0 ),
        .Q(two_len_ext[5]),
        .R(rst_IBUF));
  FDRE \len_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[5]_i_1__0_n_0 ),
        .Q(two_len_ext[6]),
        .R(rst_IBUF));
  FDRE \len_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\len_r[6]_i_1__0_n_0 ),
        .Q(two_len_ext[7]),
        .R(rst_IBUF));
  FDSE \len_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(two_len_ext[8]),
        .S(rst_IBUF));
  LUT6 #(
    .INIT(64'hB8F3B8F3B8F3B8C0)) 
    mem_reg_bram_0_i_10
       (.I0(mem_reg_bram_0_0[4]),
        .I1(mem_reg_bram_0_1),
        .I2(ext_addr_IBUF[4]),
        .I3(mem_reg_bram_0_2),
        .I4(mem_reg_bram_0_i_72_n_0),
        .I5(mem_reg_bram_0_3),
        .O(ADDRBWRADDR[5]));
  LUT6 #(
    .INIT(64'hFB08FFF3FB080C00)) 
    mem_reg_bram_0_i_11
       (.I0(mem_reg_bram_0_0[3]),
        .I1(mem_reg_bram_0_4),
        .I2(mem_reg_bram_0_5),
        .I3(ext_addr_IBUF[3]),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_i_74_n_0),
        .O(ADDRBWRADDR[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    mem_reg_bram_0_i_117
       (.I0(\phase_cnt_reg_n_0_[1] ),
        .I1(\phase_cnt_reg_n_0_[2] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\phase_cnt_reg_n_0_[0] ),
        .O(\phase_cnt_reg[1]_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFFEEEF)) 
    mem_reg_bram_0_i_12
       (.I0(mem_reg_bram_0[3]),
        .I1(mem_reg_bram_0[2]),
        .I2(mem_reg_bram_0[1]),
        .I3(mem_reg_bram_0[0]),
        .I4(mem_reg_bram_0_i_75_n_0),
        .I5(mem_reg_bram_0_8),
        .O(ADDRBWRADDR[3]));
  LUT6 #(
    .INIT(64'hE81717E817E8E817)) 
    mem_reg_bram_0_i_121
       (.I0(\start_r_reg_n_0_[6] ),
        .I1(\j_off_reg_n_0_[6] ),
        .I2(two_len_ext[7]),
        .I3(\start_r_reg_n_0_[7] ),
        .I4(\j_off_reg_n_0_[7] ),
        .I5(two_len_ext[8]),
        .O(mem_reg_bram_0_i_121_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_122
       (.I0(\j_off_reg_n_0_[5] ),
        .I1(two_len_ext[6]),
        .I2(\start_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_122_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h17717117)) 
    mem_reg_bram_0_i_123
       (.I0(mem_reg_bram_0_i_179_n_0),
        .I1(\j_off_reg[3]_1 ),
        .I2(\start_r_reg_n_0_[5] ),
        .I3(two_len_ext[6]),
        .I4(\j_off_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_123_n_0));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_125
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(two_len_ext[5]),
        .I2(\j_off_reg_n_0_[4] ),
        .O(mem_reg_bram_0_i_125_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_127
       (.I0(\start_r_reg_n_0_[2] ),
        .I1(two_len_ext[3]),
        .I2(\j_off_reg_n_0_[2] ),
        .O(mem_reg_bram_0_i_127_n_0));
  LUT6 #(
    .INIT(64'h0000AA8A0000A888)) 
    mem_reg_bram_0_i_13
       (.I0(mem_reg_bram_0_i_77_n_0),
        .I1(mem_reg_bram_0_5),
        .I2(mem_reg_bram_0_6),
        .I3(mem_reg_bram_0_0[2]),
        .I4(mem_reg_bram_0_7),
        .I5(ext_addr_IBUF[2]),
        .O(ADDRBWRADDR[2]));
  LUT5 #(
    .INIT(32'h69996669)) 
    mem_reg_bram_0_i_130
       (.I0(\j_off_reg_n_0_[7] ),
        .I1(\start_r_reg_n_0_[7] ),
        .I2(\start_r_reg_n_0_[6] ),
        .I3(\j_off_reg_n_0_[6] ),
        .I4(mem_reg_bram_0_i_132_n_0),
        .O(\j_off_reg[7]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h001717FF)) 
    mem_reg_bram_0_i_132
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(mem_reg_bram_0_i_135_n_0),
        .I3(\start_r_reg_n_0_[5] ),
        .I4(\j_off_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_132_n_0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h17E8E817)) 
    mem_reg_bram_0_i_133
       (.I0(mem_reg_bram_0_i_135_n_0),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(\start_r_reg_n_0_[4] ),
        .I3(\j_off_reg_n_0_[5] ),
        .I4(\start_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_133_n_0));
  LUT6 #(
    .INIT(64'hEEE8E888E888E888)) 
    mem_reg_bram_0_i_135
       (.I0(\start_r_reg_n_0_[3] ),
        .I1(\j_off_reg_n_0_[3] ),
        .I2(\start_r_reg_n_0_[2] ),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\start_r_reg_n_0_[1] ),
        .I5(\j_off_reg_n_0_[1] ),
        .O(mem_reg_bram_0_i_135_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hE888)) 
    mem_reg_bram_0_i_139
       (.I0(\start_r_reg_n_0_[2] ),
        .I1(\j_off_reg_n_0_[2] ),
        .I2(\start_r_reg_n_0_[1] ),
        .I3(\j_off_reg_n_0_[1] ),
        .O(mem_reg_bram_0_i_139_n_0));
  LUT6 #(
    .INIT(64'hFB08FFF3FB080C00)) 
    mem_reg_bram_0_i_14
       (.I0(mem_reg_bram_0_0[1]),
        .I1(mem_reg_bram_0_4),
        .I2(mem_reg_bram_0_5),
        .I3(ext_addr_IBUF[1]),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_i_80_n_0),
        .O(ADDRBWRADDR[1]));
  LUT6 #(
    .INIT(64'h8778FFFF87780000)) 
    mem_reg_bram_0_i_140
       (.I0(\j_off_reg_n_0_[1] ),
        .I1(\start_r_reg_n_0_[1] ),
        .I2(\j_off_reg_n_0_[2] ),
        .I3(\start_r_reg_n_0_[2] ),
        .I4(mem_reg_bram_0_9),
        .I5(mem_reg_bram_0_i_80_0),
        .O(mem_reg_bram_0_i_140_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF0000B800)) 
    mem_reg_bram_0_i_15
       (.I0(mem_reg_bram_0_0[0]),
        .I1(mem_reg_bram_0_2),
        .I2(ext_addr_IBUF[0]),
        .I3(mem_reg_bram_0_4),
        .I4(mem_reg_bram_0_5),
        .I5(mem_reg_bram_0_i_81_n_0),
        .O(ADDRBWRADDR[0]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_179
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(two_len_ext[5]),
        .O(mem_reg_bram_0_i_179_n_0));
  LUT6 #(
    .INIT(64'h00000000404F0000)) 
    mem_reg_bram_0_i_42
       (.I0(mem_reg_bram_0_4),
        .I1(\phase_cnt_reg[1]_0 ),
        .I2(mem_reg_bram_0_9),
        .I3(mem_reg_bram_0_18),
        .I4(mem_reg_bram_0_5),
        .I5(rst_IBUF),
        .O(WEBWE));
  LUT6 #(
    .INIT(64'h65A6A665A66565A6)) 
    mem_reg_bram_0_i_46
       (.I0(mem_reg_bram_0_i_121_n_0),
        .I1(mem_reg_bram_0_i_122_n_0),
        .I2(mem_reg_bram_0_i_123_n_0),
        .I3(\j_off_reg_n_0_[6] ),
        .I4(two_len_ext[7]),
        .I5(\start_r_reg_n_0_[6] ),
        .O(\j_off_reg[6]_0 ));
  LUT6 #(
    .INIT(64'h02A2A202A20202A2)) 
    mem_reg_bram_0_i_5
       (.I0(mem_reg_bram_0_10),
        .I1(mem_reg_bram_0_14),
        .I2(mem_reg_bram_0_9),
        .I3(mem_reg_bram_0_i_61_n_0),
        .I4(mem_reg_bram_0_i_62_n_0),
        .I5(mem_reg_bram_0_i_63_n_0),
        .O(ADDRARDADDR[1]));
  LUT5 #(
    .INIT(32'h96696996)) 
    mem_reg_bram_0_i_51
       (.I0(mem_reg_bram_0_i_123_n_0),
        .I1(\start_r_reg_n_0_[6] ),
        .I2(two_len_ext[7]),
        .I3(\j_off_reg_n_0_[6] ),
        .I4(mem_reg_bram_0_i_122_n_0),
        .O(\start_r_reg[6]_0 ));
  LUT6 #(
    .INIT(64'hE81717E817E8E817)) 
    mem_reg_bram_0_i_54
       (.I0(two_len_ext[5]),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(\start_r_reg_n_0_[4] ),
        .I3(\j_off_reg_n_0_[5] ),
        .I4(two_len_ext[6]),
        .I5(\start_r_reg_n_0_[5] ),
        .O(\len_r_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hFEEAEAA8EAA8A880)) 
    mem_reg_bram_0_i_55
       (.I0(mem_reg_bram_0_i_125_n_0),
        .I1(mem_reg_bram_0_i_61_n_0),
        .I2(mem_reg_bram_0_i_63_n_0),
        .I3(\j_off_reg_n_0_[3] ),
        .I4(two_len_ext[4]),
        .I5(\start_r_reg_n_0_[3] ),
        .O(\j_off_reg[3]_1 ));
  LUT6 #(
    .INIT(64'h566A6AA96AA9A995)) 
    mem_reg_bram_0_i_59
       (.I0(mem_reg_bram_0_i_125_n_0),
        .I1(mem_reg_bram_0_i_61_n_0),
        .I2(mem_reg_bram_0_i_63_n_0),
        .I3(\j_off_reg_n_0_[3] ),
        .I4(two_len_ext[4]),
        .I5(\start_r_reg_n_0_[3] ),
        .O(\j_off_reg[3]_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_61
       (.I0(\j_off_reg_n_0_[2] ),
        .I1(two_len_ext[3]),
        .I2(\start_r_reg_n_0_[2] ),
        .O(mem_reg_bram_0_i_61_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'h69)) 
    mem_reg_bram_0_i_62
       (.I0(\start_r_reg_n_0_[3] ),
        .I1(two_len_ext[4]),
        .I2(\j_off_reg_n_0_[3] ),
        .O(mem_reg_bram_0_i_62_n_0));
  LUT6 #(
    .INIT(64'hFFF8F88080000000)) 
    mem_reg_bram_0_i_63
       (.I0(\j_off_reg[0]_0 ),
        .I1(two_len_ext[1]),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(two_len_ext[2]),
        .I4(\start_r_reg_n_0_[1] ),
        .I5(mem_reg_bram_0_i_127_n_0),
        .O(mem_reg_bram_0_i_63_n_0));
  LUT6 #(
    .INIT(64'h870F0F780F7878F0)) 
    mem_reg_bram_0_i_65
       (.I0(two_len_ext[1]),
        .I1(\j_off_reg[0]_0 ),
        .I2(mem_reg_bram_0_i_127_n_0),
        .I3(\start_r_reg_n_0_[1] ),
        .I4(\j_off_reg_n_0_[1] ),
        .I5(two_len_ext[2]),
        .O(\len_r_reg[0]_0 ));
  LUT5 #(
    .INIT(32'h87787887)) 
    mem_reg_bram_0_i_67
       (.I0(\j_off_reg[0]_0 ),
        .I1(two_len_ext[1]),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(two_len_ext[2]),
        .I4(\start_r_reg_n_0_[1] ),
        .O(\j_off_reg[0]_1 ));
  LUT6 #(
    .INIT(64'h0151510151010151)) 
    mem_reg_bram_0_i_72
       (.I0(mem_reg_bram_0_4),
        .I1(mem_reg_bram_0_20),
        .I2(mem_reg_bram_0_9),
        .I3(\start_r_reg_n_0_[6] ),
        .I4(\j_off_reg_n_0_[6] ),
        .I5(mem_reg_bram_0_i_132_n_0),
        .O(mem_reg_bram_0_i_72_n_0));
  LUT6 #(
    .INIT(64'hF0FFF00055335533)) 
    mem_reg_bram_0_i_74
       (.I0(mem_reg_bram_0_i_133_n_0),
        .I1(mem_reg_bram_0_16),
        .I2(ext_addr_IBUF[3]),
        .I3(mem_reg_bram_0_9),
        .I4(mem_reg_bram_0_15[1]),
        .I5(mem_reg_bram_0_4),
        .O(mem_reg_bram_0_i_74_n_0));
  LUT5 #(
    .INIT(32'h96FF9600)) 
    mem_reg_bram_0_i_75
       (.I0(mem_reg_bram_0_i_135_n_0),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(\start_r_reg_n_0_[4] ),
        .I3(mem_reg_bram_0_9),
        .I4(mem_reg_bram_0_17),
        .O(mem_reg_bram_0_i_75_n_0));
  LUT6 #(
    .INIT(64'hE22E2EE2FFFFFFFF)) 
    mem_reg_bram_0_i_77
       (.I0(mem_reg_bram_0_19),
        .I1(mem_reg_bram_0_9),
        .I2(\start_r_reg_n_0_[3] ),
        .I3(\j_off_reg_n_0_[3] ),
        .I4(mem_reg_bram_0_i_139_n_0),
        .I5(mem_reg_bram_0_10),
        .O(mem_reg_bram_0_i_77_n_0));
  LUT6 #(
    .INIT(64'h0040444044400040)) 
    mem_reg_bram_0_i_8
       (.I0(mem_reg_bram_0_4),
        .I1(mem_reg_bram_0_5),
        .I2(mem_reg_bram_0_13),
        .I3(mem_reg_bram_0_9),
        .I4(\j_off_reg[0]_0 ),
        .I5(two_len_ext[1]),
        .O(ADDRARDADDR[0]));
  LUT6 #(
    .INIT(64'hFFFFFFB8000000B8)) 
    mem_reg_bram_0_i_80
       (.I0(ext_addr_IBUF[1]),
        .I1(mem_reg_bram_0_9),
        .I2(mem_reg_bram_0_15[0]),
        .I3(mem_reg_bram_0[0]),
        .I4(mem_reg_bram_0[1]),
        .I5(mem_reg_bram_0_i_140_n_0),
        .O(mem_reg_bram_0_i_80_n_0));
  LUT6 #(
    .INIT(64'h0000000060FF6FFF)) 
    mem_reg_bram_0_i_81
       (.I0(\start_r_reg_n_0_[1] ),
        .I1(\j_off_reg_n_0_[1] ),
        .I2(mem_reg_bram_0_9),
        .I3(mem_reg_bram_0_10),
        .I4(mem_reg_bram_0_11),
        .I5(mem_reg_bram_0_12),
        .O(mem_reg_bram_0_i_81_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h0070)) 
    \phase_cnt[0]_i_1 
       (.I0(\phase_cnt_reg_n_0_[2] ),
        .I1(\phase_cnt_reg_n_0_[1] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\phase_cnt_reg_n_0_[0] ),
        .O(phase_cnt[0]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h04C0)) 
    \phase_cnt[1]_i_1 
       (.I0(\phase_cnt_reg_n_0_[2] ),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\phase_cnt_reg_n_0_[0] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .O(phase_cnt[1]));
  LUT3 #(
    .INIT(8'hEA)) 
    \phase_cnt[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(\phase_cnt_reg[0]_0 ),
        .O(\phase_cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h2280)) 
    \phase_cnt[2]_i_2 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\phase_cnt_reg_n_0_[1] ),
        .I2(\phase_cnt_reg_n_0_[0] ),
        .I3(\phase_cnt_reg_n_0_[2] ),
        .O(phase_cnt[2]));
  FDRE \phase_cnt_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1_n_0 ),
        .D(phase_cnt[0]),
        .Q(\phase_cnt_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \phase_cnt_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1_n_0 ),
        .D(phase_cnt[1]),
        .Q(\phase_cnt_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \phase_cnt_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1_n_0 ),
        .D(phase_cnt[2]),
        .Q(\phase_cnt_reg_n_0_[2] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h1400)) 
    \start_r[1]_i_1 
       (.I0(\layer[2]_i_4_n_0 ),
        .I1(\start_r_reg_n_0_[1] ),
        .I2(two_len_ext[1]),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\start_r[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000802A2A80)) 
    \start_r[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(two_len_ext[1]),
        .I2(\start_r_reg_n_0_[1] ),
        .I3(two_len_ext[2]),
        .I4(\start_r_reg_n_0_[2] ),
        .I5(\layer[2]_i_4_n_0 ),
        .O(\start_r[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\start_r[3]_i_2_n_0 ),
        .I2(two_len_ext[3]),
        .I3(\start_r_reg_n_0_[3] ),
        .I4(\layer[2]_i_4_n_0 ),
        .O(\start_r[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hEA80)) 
    \start_r[3]_i_2 
       (.I0(\start_r_reg_n_0_[2] ),
        .I1(two_len_ext[1]),
        .I2(\start_r_reg_n_0_[1] ),
        .I3(two_len_ext[2]),
        .O(\start_r[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\start_r[4]_i_2_n_0 ),
        .I2(two_len_ext[4]),
        .I3(\start_r_reg_n_0_[4] ),
        .I4(\layer[2]_i_4_n_0 ),
        .O(\start_r[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEEEEAAAA8888000)) 
    \start_r[4]_i_2 
       (.I0(two_len_ext[3]),
        .I1(\start_r_reg_n_0_[2] ),
        .I2(two_len_ext[1]),
        .I3(\start_r_reg_n_0_[1] ),
        .I4(two_len_ext[2]),
        .I5(\start_r_reg_n_0_[3] ),
        .O(\start_r[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[5]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\start_r[5]_i_2_n_0 ),
        .I2(two_len_ext[5]),
        .I3(\start_r_reg_n_0_[5] ),
        .I4(\layer[2]_i_4_n_0 ),
        .O(\start_r[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \start_r[5]_i_2 
       (.I0(\start_r[4]_i_2_n_0 ),
        .I1(\start_r_reg_n_0_[4] ),
        .I2(two_len_ext[4]),
        .O(\start_r[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[6]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\start_r[6]_i_2_n_0 ),
        .I2(two_len_ext[6]),
        .I3(\start_r_reg_n_0_[6] ),
        .I4(\layer[2]_i_4_n_0 ),
        .O(\start_r[6]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFEEAA880)) 
    \start_r[6]_i_2 
       (.I0(two_len_ext[5]),
        .I1(\start_r[4]_i_2_n_0 ),
        .I2(\start_r_reg_n_0_[4] ),
        .I3(two_len_ext[4]),
        .I4(\start_r_reg_n_0_[5] ),
        .O(\start_r[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBABBBBBBBBBBBBBB)) 
    \start_r[7]_i_1 
       (.I0(\layer[2]_i_3_n_0 ),
        .I1(\FSM_onehot_state[2]_i_2_n_0 ),
        .I2(\layer_reg_n_0_[0] ),
        .I3(\layer_reg_n_0_[2] ),
        .I4(\layer_reg_n_0_[1] ),
        .I5(\layer[2]_i_4_n_0 ),
        .O(\start_r[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h80040440)) 
    \start_r[7]_i_2 
       (.I0(two_len_ext[8]),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\start_r[7]_i_3_n_0 ),
        .I3(\start_r_reg_n_0_[7] ),
        .I4(two_len_ext[7]),
        .O(\start_r[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \start_r[7]_i_3 
       (.I0(\start_r_reg_n_0_[6] ),
        .I1(\start_r[6]_i_2_n_0 ),
        .I2(two_len_ext[6]),
        .O(\start_r[7]_i_3_n_0 ));
  FDRE \start_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[1]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[2]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[3]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[4]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[5]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[6]_i_1_n_0 ),
        .Q(\start_r_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1_n_0 ),
        .D(\start_r[7]_i_2_n_0 ),
        .Q(\start_r_reg_n_0_[7] ),
        .R(rst_IBUF));
endmodule

(* LATENCY = "6" *) (* N_INV = "12'b110011100111" *) (* S_COMPARE = "3'b100" *) 
(* S_DONE = "3'b101" *) (* S_IDLE = "3'b000" *) (* S_LOAD = "3'b001" *) 
(* S_RUN_INTT = "3'b011" *) (* S_RUN_NTT = "3'b010" *) 
(* NotValidForBitStream *)
module demo_top
   (clk,
    rst,
    start_i,
    busy,
    done,
    pass_o,
    phase,
    cycle_count,
    ext_addr_sel,
    ext_addr,
    ext_dout);
  input clk;
  input rst;
  input start_i;
  output busy;
  output done;
  output pass_o;
  output [2:0]phase;
  output [31:0]cycle_count;
  input ext_addr_sel;
  input [7:0]ext_addr;
  output [11:0]ext_dout;

  wire [11:8]B;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire [11:0]b;
  wire busy;
  wire busy_OBUF;
  wire [11:0]c_r;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire cmp_i;
  wire \cmp_i[0]_i_1_n_0 ;
  wire \cmp_i[1]_i_1_n_0 ;
  wire \cmp_i[2]_i_1_n_0 ;
  wire \cmp_i[3]_i_1_n_0 ;
  wire \cmp_i[4]_i_1_n_0 ;
  wire \cmp_i[5]_i_1_n_0 ;
  wire \cmp_i[5]_i_2_n_0 ;
  wire \cmp_i[6]_i_1_n_0 ;
  wire \cmp_i[7]_i_2_n_0 ;
  wire [7:0]cmp_i_d1;
  wire cmp_i_d1__0;
  wire \cmp_i_reg_n_0_[0] ;
  wire \cmp_i_reg_n_0_[1] ;
  wire \cmp_i_reg_n_0_[2] ;
  wire \cmp_i_reg_n_0_[3] ;
  wire \cmp_i_reg_n_0_[4] ;
  wire \cmp_i_reg_n_0_[5] ;
  wire \cmp_i_reg_n_0_[6] ;
  wire \cmp_i_reg_n_0_[7] ;
  wire cmp_last_d1;
  wire cmp_last_d1_i_1_n_0;
  wire cmp_valid_d1_reg_n_0;
  wire \cycle_cnt_r[0]_i_1_n_0 ;
  wire \cycle_cnt_r[0]_i_3_n_0 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_0 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_1 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_10 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_11 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_12 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_13 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_14 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_15 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_2 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_3 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_4 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_5 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_6 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_7 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_8 ;
  wire \cycle_cnt_r_reg[0]_i_2_n_9 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_0 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_1 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_10 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_11 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_12 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_13 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_14 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_15 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_2 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_3 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_4 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_5 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_6 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_7 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_8 ;
  wire \cycle_cnt_r_reg[16]_i_1_n_9 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_1 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_10 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_11 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_12 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_13 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_14 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_15 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_2 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_3 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_4 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_5 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_6 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_7 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_8 ;
  wire \cycle_cnt_r_reg[24]_i_1_n_9 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_0 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_1 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_10 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_11 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_12 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_13 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_14 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_15 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_2 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_3 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_4 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_5 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_6 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_7 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_8 ;
  wire \cycle_cnt_r_reg[8]_i_1_n_9 ;
  wire [31:0]cycle_count;
  wire [31:0]cycle_count_OBUF;
  wire done;
  wire done_OBUF;
  wire [7:0]ext_addr;
  wire [7:0]ext_addr_IBUF;
  wire ext_addr_sel;
  wire ext_addr_sel_IBUF;
  wire [11:0]ext_dout;
  wire [11:0]ext_dout_OBUF;
  wire fwd_done;
  wire fwd_start;
  wire fwd_start_reg_n_0;
  wire inv_start;
  wire inv_start_reg_n_0;
  wire [7:0]load_i;
  wire \load_i[0]_i_1_n_0 ;
  wire \load_i[1]_i_1_n_0 ;
  wire \load_i[2]_i_1_n_0 ;
  wire \load_i[3]_i_1_n_0 ;
  wire \load_i[4]_i_1_n_0 ;
  wire \load_i[5]_i_1_n_0 ;
  wire \load_i[5]_i_2_n_0 ;
  wire \load_i[6]_i_1_n_0 ;
  wire \load_i[7]_i_1_n_0 ;
  wire \load_i[7]_i_2_n_0 ;
  wire load_phase_cnt;
  wire \load_phase_cnt[0]_i_1_n_0 ;
  wire \load_phase_cnt[1]_i_1_n_0 ;
  wire \load_phase_cnt[2]_i_2_n_0 ;
  wire \load_phase_cnt_reg_n_0_[0] ;
  wire \load_phase_cnt_reg_n_0_[1] ;
  wire \load_phase_cnt_reg_n_0_[2] ;
  wire [11:0]load_val;
  wire [11:0]mem_din_b;
  wire [11:0]mem_dout_a;
  wire [11:0]mem_dout_b;
  wire mismatch_reg_n_0;
  wire orig_mem;
  wire orig_mem_reg_r1_0_63_0_6_i_8_n_0;
  wire orig_mem_reg_r1_0_63_0_6_n_0;
  wire orig_mem_reg_r1_0_63_0_6_n_1;
  wire orig_mem_reg_r1_0_63_0_6_n_2;
  wire orig_mem_reg_r1_0_63_0_6_n_3;
  wire orig_mem_reg_r1_0_63_0_6_n_4;
  wire orig_mem_reg_r1_0_63_0_6_n_5;
  wire orig_mem_reg_r1_0_63_0_6_n_6;
  wire orig_mem_reg_r1_0_63_7_11_n_0;
  wire orig_mem_reg_r1_0_63_7_11_n_1;
  wire orig_mem_reg_r1_0_63_7_11_n_2;
  wire orig_mem_reg_r1_0_63_7_11_n_3;
  wire orig_mem_reg_r1_0_63_7_11_n_4;
  wire orig_mem_reg_r1_128_191_0_6_i_1_n_0;
  wire orig_mem_reg_r1_128_191_0_6_n_0;
  wire orig_mem_reg_r1_128_191_0_6_n_1;
  wire orig_mem_reg_r1_128_191_0_6_n_2;
  wire orig_mem_reg_r1_128_191_0_6_n_3;
  wire orig_mem_reg_r1_128_191_0_6_n_4;
  wire orig_mem_reg_r1_128_191_0_6_n_5;
  wire orig_mem_reg_r1_128_191_0_6_n_6;
  wire orig_mem_reg_r1_128_191_7_11_n_0;
  wire orig_mem_reg_r1_128_191_7_11_n_1;
  wire orig_mem_reg_r1_128_191_7_11_n_2;
  wire orig_mem_reg_r1_128_191_7_11_n_3;
  wire orig_mem_reg_r1_128_191_7_11_n_4;
  wire orig_mem_reg_r1_192_255_0_6_i_1_n_0;
  wire orig_mem_reg_r1_192_255_0_6_n_0;
  wire orig_mem_reg_r1_192_255_0_6_n_1;
  wire orig_mem_reg_r1_192_255_0_6_n_2;
  wire orig_mem_reg_r1_192_255_0_6_n_3;
  wire orig_mem_reg_r1_192_255_0_6_n_4;
  wire orig_mem_reg_r1_192_255_0_6_n_5;
  wire orig_mem_reg_r1_192_255_0_6_n_6;
  wire orig_mem_reg_r1_192_255_7_11_n_0;
  wire orig_mem_reg_r1_192_255_7_11_n_1;
  wire orig_mem_reg_r1_192_255_7_11_n_2;
  wire orig_mem_reg_r1_192_255_7_11_n_3;
  wire orig_mem_reg_r1_192_255_7_11_n_4;
  wire orig_mem_reg_r1_64_127_0_6_i_1_n_0;
  wire orig_mem_reg_r1_64_127_0_6_n_0;
  wire orig_mem_reg_r1_64_127_0_6_n_1;
  wire orig_mem_reg_r1_64_127_0_6_n_2;
  wire orig_mem_reg_r1_64_127_0_6_n_3;
  wire orig_mem_reg_r1_64_127_0_6_n_4;
  wire orig_mem_reg_r1_64_127_0_6_n_5;
  wire orig_mem_reg_r1_64_127_0_6_n_6;
  wire orig_mem_reg_r1_64_127_7_11_n_0;
  wire orig_mem_reg_r1_64_127_7_11_n_1;
  wire orig_mem_reg_r1_64_127_7_11_n_2;
  wire orig_mem_reg_r1_64_127_7_11_n_3;
  wire orig_mem_reg_r1_64_127_7_11_n_4;
  wire orig_mem_reg_r2_0_63_0_6_n_0;
  wire orig_mem_reg_r2_0_63_0_6_n_1;
  wire orig_mem_reg_r2_0_63_0_6_n_2;
  wire orig_mem_reg_r2_0_63_0_6_n_3;
  wire orig_mem_reg_r2_0_63_0_6_n_4;
  wire orig_mem_reg_r2_0_63_0_6_n_5;
  wire orig_mem_reg_r2_0_63_0_6_n_6;
  wire orig_mem_reg_r2_0_63_7_11_n_0;
  wire orig_mem_reg_r2_0_63_7_11_n_1;
  wire orig_mem_reg_r2_0_63_7_11_n_2;
  wire orig_mem_reg_r2_0_63_7_11_n_3;
  wire orig_mem_reg_r2_0_63_7_11_n_4;
  wire orig_mem_reg_r2_128_191_0_6_n_0;
  wire orig_mem_reg_r2_128_191_0_6_n_1;
  wire orig_mem_reg_r2_128_191_0_6_n_2;
  wire orig_mem_reg_r2_128_191_0_6_n_3;
  wire orig_mem_reg_r2_128_191_0_6_n_4;
  wire orig_mem_reg_r2_128_191_0_6_n_5;
  wire orig_mem_reg_r2_128_191_0_6_n_6;
  wire orig_mem_reg_r2_128_191_7_11_n_0;
  wire orig_mem_reg_r2_128_191_7_11_n_1;
  wire orig_mem_reg_r2_128_191_7_11_n_2;
  wire orig_mem_reg_r2_128_191_7_11_n_3;
  wire orig_mem_reg_r2_128_191_7_11_n_4;
  wire orig_mem_reg_r2_192_255_0_6_n_0;
  wire orig_mem_reg_r2_192_255_0_6_n_1;
  wire orig_mem_reg_r2_192_255_0_6_n_2;
  wire orig_mem_reg_r2_192_255_0_6_n_3;
  wire orig_mem_reg_r2_192_255_0_6_n_4;
  wire orig_mem_reg_r2_192_255_0_6_n_5;
  wire orig_mem_reg_r2_192_255_0_6_n_6;
  wire orig_mem_reg_r2_192_255_7_11_n_0;
  wire orig_mem_reg_r2_192_255_7_11_n_1;
  wire orig_mem_reg_r2_192_255_7_11_n_2;
  wire orig_mem_reg_r2_192_255_7_11_n_3;
  wire orig_mem_reg_r2_192_255_7_11_n_4;
  wire orig_mem_reg_r2_64_127_0_6_n_0;
  wire orig_mem_reg_r2_64_127_0_6_n_1;
  wire orig_mem_reg_r2_64_127_0_6_n_2;
  wire orig_mem_reg_r2_64_127_0_6_n_3;
  wire orig_mem_reg_r2_64_127_0_6_n_4;
  wire orig_mem_reg_r2_64_127_0_6_n_5;
  wire orig_mem_reg_r2_64_127_0_6_n_6;
  wire orig_mem_reg_r2_64_127_7_11_n_0;
  wire orig_mem_reg_r2_64_127_7_11_n_1;
  wire orig_mem_reg_r2_64_127_7_11_n_2;
  wire orig_mem_reg_r2_64_127_7_11_n_3;
  wire orig_mem_reg_r2_64_127_7_11_n_4;
  wire p_0_in;
  wire p_0_in0_out;
  wire pass_o;
  wire pass_o_OBUF;
  wire [2:0]phase;
  wire [2:0]phase_OBUF;
  wire rst;
  wire rst_IBUF;
  wire start_i;
  wire start_i_IBUF;
  wire [1:0]state__0;
  wire u_fwd_bf_n_22;
  wire u_fwd_bf_n_23;
  wire u_fwd_bf_n_24;
  wire u_fwd_bf_n_25;
  wire u_fwd_bf_n_26;
  wire u_fwd_bf_n_27;
  wire u_fwd_bf_n_28;
  wire u_fwd_bf_n_29;
  wire u_fwd_fsm_n_0;
  wire u_fwd_fsm_n_1;
  wire u_fwd_fsm_n_10;
  wire u_fwd_fsm_n_11;
  wire u_fwd_fsm_n_12;
  wire u_fwd_fsm_n_13;
  wire u_fwd_fsm_n_14;
  wire u_fwd_fsm_n_15;
  wire u_fwd_fsm_n_16;
  wire u_fwd_fsm_n_17;
  wire u_fwd_fsm_n_18;
  wire u_fwd_fsm_n_19;
  wire u_fwd_fsm_n_2;
  wire u_fwd_fsm_n_20;
  wire u_fwd_fsm_n_21;
  wire u_fwd_fsm_n_22;
  wire u_fwd_fsm_n_23;
  wire u_fwd_fsm_n_26;
  wire u_fwd_fsm_n_27;
  wire u_fwd_fsm_n_28;
  wire u_fwd_fsm_n_29;
  wire u_fwd_fsm_n_3;
  wire u_fwd_fsm_n_30;
  wire u_fwd_fsm_n_31;
  wire u_fwd_fsm_n_32;
  wire u_fwd_fsm_n_33;
  wire u_fwd_fsm_n_34;
  wire u_fwd_fsm_n_35;
  wire u_fwd_fsm_n_36;
  wire u_fwd_fsm_n_37;
  wire u_fwd_fsm_n_38;
  wire u_fwd_fsm_n_39;
  wire u_fwd_fsm_n_4;
  wire u_fwd_fsm_n_40;
  wire u_fwd_fsm_n_41;
  wire u_fwd_fsm_n_42;
  wire u_fwd_fsm_n_43;
  wire u_fwd_fsm_n_44;
  wire u_fwd_fsm_n_45;
  wire u_fwd_fsm_n_5;
  wire u_fwd_fsm_n_6;
  wire u_fwd_fsm_n_7;
  wire u_fwd_fsm_n_8;
  wire u_fwd_fsm_n_9;
  wire u_fwd_rom_n_0;
  wire u_fwd_rom_n_1;
  wire u_fwd_rom_n_10;
  wire u_fwd_rom_n_11;
  wire u_fwd_rom_n_2;
  wire u_fwd_rom_n_3;
  wire u_fwd_rom_n_4;
  wire u_fwd_rom_n_5;
  wire u_fwd_rom_n_6;
  wire u_fwd_rom_n_7;
  wire u_fwd_rom_n_8;
  wire u_fwd_rom_n_9;
  wire u_inv_bf_n_0;
  wire u_inv_bf_n_1;
  wire u_inv_bf_n_18;
  wire u_inv_bf_n_19;
  wire u_inv_bf_n_2;
  wire u_inv_bf_n_20;
  wire u_inv_bf_n_21;
  wire u_inv_bf_n_22;
  wire u_inv_bf_n_23;
  wire u_inv_bf_n_24;
  wire u_inv_bf_n_25;
  wire u_inv_bf_n_3;
  wire u_inv_bf_n_4;
  wire u_inv_bf_n_5;
  wire u_inv_fsm_n_0;
  wire u_inv_fsm_n_1;
  wire u_inv_fsm_n_10;
  wire u_inv_fsm_n_11;
  wire u_inv_fsm_n_12;
  wire u_inv_fsm_n_13;
  wire u_inv_fsm_n_14;
  wire u_inv_fsm_n_15;
  wire u_inv_fsm_n_16;
  wire u_inv_fsm_n_17;
  wire u_inv_fsm_n_18;
  wire u_inv_fsm_n_19;
  wire u_inv_fsm_n_2;
  wire u_inv_fsm_n_20;
  wire u_inv_fsm_n_21;
  wire u_inv_fsm_n_22;
  wire u_inv_fsm_n_23;
  wire u_inv_fsm_n_24;
  wire u_inv_fsm_n_25;
  wire u_inv_fsm_n_26;
  wire u_inv_fsm_n_27;
  wire u_inv_fsm_n_28;
  wire u_inv_fsm_n_29;
  wire u_inv_fsm_n_3;
  wire u_inv_fsm_n_30;
  wire u_inv_fsm_n_31;
  wire u_inv_fsm_n_32;
  wire u_inv_fsm_n_33;
  wire u_inv_fsm_n_34;
  wire u_inv_fsm_n_35;
  wire u_inv_fsm_n_36;
  wire u_inv_fsm_n_4;
  wire u_inv_fsm_n_40;
  wire u_inv_fsm_n_41;
  wire u_inv_fsm_n_42;
  wire u_inv_fsm_n_43;
  wire u_inv_fsm_n_44;
  wire u_inv_fsm_n_45;
  wire u_inv_fsm_n_46;
  wire u_inv_fsm_n_47;
  wire u_inv_fsm_n_48;
  wire u_inv_fsm_n_49;
  wire u_inv_fsm_n_5;
  wire u_inv_fsm_n_50;
  wire u_inv_fsm_n_51;
  wire u_inv_fsm_n_6;
  wire u_inv_fsm_n_7;
  wire u_inv_fsm_n_8;
  wire u_inv_fsm_n_9;
  wire u_inv_rom_n_0;
  wire u_inv_rom_n_1;
  wire u_inv_rom_n_10;
  wire u_inv_rom_n_11;
  wire u_inv_rom_n_2;
  wire u_inv_rom_n_3;
  wire u_inv_rom_n_4;
  wire u_inv_rom_n_5;
  wire u_inv_rom_n_6;
  wire u_inv_rom_n_7;
  wire u_inv_rom_n_8;
  wire u_inv_rom_n_9;
  wire u_load_mul_n_12;
  wire u_load_mul_n_13;
  wire u_load_mul_n_14;
  wire u_load_mul_n_15;
  wire u_load_mul_n_16;
  wire u_load_mul_n_17;
  wire u_mem_n_36;
  wire u_mem_n_37;
  wire u_mem_n_38;
  wire u_mem_n_39;
  wire u_mem_n_40;
  wire u_mem_n_41;
  wire u_mem_n_42;
  wire u_mem_n_43;
  wire u_mem_n_44;
  wire u_mem_n_45;
  wire u_mem_n_46;
  wire u_mem_n_47;
  wire u_mem_n_48;
  wire u_mem_n_49;
  wire u_mem_n_50;
  wire u_mem_n_51;
  wire u_mem_n_52;
  wire u_mem_n_53;
  wire u_mem_n_54;
  wire u_mem_n_55;
  wire u_mem_n_56;
  wire u_mem_n_57;
  wire u_mem_n_58;
  wire u_mem_n_59;
  wire u_mem_n_60;
  wire u_mem_n_61;
  wire u_mem_n_62;
  wire u_mem_n_63;
  wire u_mem_n_64;
  wire u_mem_n_65;
  wire u_mem_n_66;
  wire u_mem_n_67;
  wire u_mem_n_68;
  wire u_mem_n_69;
  wire u_mem_n_70;
  wire u_mem_n_71;
  wire u_mem_n_72;
  wire u_mem_n_77;
  wire u_mem_n_78;
  wire u_mem_n_79;
  wire u_mem_n_80;
  wire u_mem_n_81;
  wire u_mem_n_82;
  wire u_mem_n_83;
  wire u_mem_n_84;
  wire u_mem_n_85;
  wire u_mem_n_86;
  wire u_mem_n_87;
  wire u_mem_n_88;
  wire u_scale_n_0;
  wire u_scale_n_1;
  wire u_scale_n_10;
  wire u_scale_n_11;
  wire u_scale_n_2;
  wire u_scale_n_3;
  wire u_scale_n_4;
  wire u_scale_n_5;
  wire u_scale_n_6;
  wire u_scale_n_7;
  wire u_scale_n_8;
  wire u_scale_n_9;
  wire [7:7]\NLW_cycle_cnt_r_reg[24]_i_1_CO_UNCONNECTED ;
  wire NLW_orig_mem_reg_r1_0_63_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_0_63_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_0_63_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_0_63_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_128_191_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_128_191_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_128_191_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_128_191_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_192_255_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_192_255_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_192_255_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_192_255_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_64_127_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_64_127_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_64_127_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r1_64_127_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_0_63_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_0_63_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_0_63_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_0_63_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_128_191_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_128_191_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_128_191_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_128_191_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_192_255_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_192_255_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_192_255_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_192_255_7_11_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_64_127_0_6_DOH_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_64_127_7_11_DOF_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_64_127_7_11_DOG_UNCONNECTED;
  wire NLW_orig_mem_reg_r2_64_127_7_11_DOH_UNCONNECTED;

  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(done_OBUF),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(orig_mem),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(orig_mem),
        .Q(\FSM_onehot_state_reg_n_0_[2] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(\FSM_onehot_state_reg_n_0_[2] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .Q(cmp_i_d1__0),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:000001,S_LOAD:000010,S_RUN_NTT:000100,S_RUN_INTT:001000,S_COMPARE:010000,S_DONE:100000," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(u_inv_fsm_n_25),
        .D(cmp_i_d1__0),
        .Q(done_OBUF),
        .R(rst_IBUF));
  OBUF busy_OBUF_inst
       (.I(busy_OBUF),
        .O(busy));
  LUT2 #(
    .INIT(4'h1)) 
    busy_OBUF_inst_i_1
       (.I0(done_OBUF),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .O(busy_OBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(1'b1),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \cmp_i[0]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i_reg_n_0_[0] ),
        .O(\cmp_i[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \cmp_i[1]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i_reg_n_0_[0] ),
        .I2(\cmp_i_reg_n_0_[1] ),
        .O(\cmp_i[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \cmp_i[2]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i_reg_n_0_[1] ),
        .I2(\cmp_i_reg_n_0_[0] ),
        .I3(\cmp_i_reg_n_0_[2] ),
        .O(\cmp_i[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \cmp_i[3]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i_reg_n_0_[0] ),
        .I2(\cmp_i_reg_n_0_[1] ),
        .I3(\cmp_i_reg_n_0_[2] ),
        .I4(\cmp_i_reg_n_0_[3] ),
        .O(\cmp_i[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \cmp_i[4]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i_reg_n_0_[2] ),
        .I2(\cmp_i_reg_n_0_[1] ),
        .I3(\cmp_i_reg_n_0_[0] ),
        .I4(\cmp_i_reg_n_0_[3] ),
        .I5(\cmp_i_reg_n_0_[4] ),
        .O(\cmp_i[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \cmp_i[5]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(\cmp_i[5]_i_2_n_0 ),
        .I2(\cmp_i_reg_n_0_[5] ),
        .O(\cmp_i[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \cmp_i[5]_i_2 
       (.I0(\cmp_i_reg_n_0_[3] ),
        .I1(\cmp_i_reg_n_0_[0] ),
        .I2(\cmp_i_reg_n_0_[1] ),
        .I3(\cmp_i_reg_n_0_[2] ),
        .I4(\cmp_i_reg_n_0_[4] ),
        .O(\cmp_i[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \cmp_i[6]_i_1 
       (.I0(cmp_i_d1__0),
        .I1(u_inv_fsm_n_40),
        .I2(\cmp_i_reg_n_0_[6] ),
        .O(\cmp_i[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \cmp_i[7]_i_2 
       (.I0(cmp_i_d1__0),
        .I1(u_inv_fsm_n_40),
        .I2(\cmp_i_reg_n_0_[6] ),
        .I3(\cmp_i_reg_n_0_[7] ),
        .O(\cmp_i[7]_i_2_n_0 ));
  FDRE \cmp_i_d1_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[0] ),
        .Q(cmp_i_d1[0]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[1] ),
        .Q(cmp_i_d1[1]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[2] ),
        .Q(cmp_i_d1[2]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[3] ),
        .Q(cmp_i_d1[3]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[4] ),
        .Q(cmp_i_d1[4]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[5] ),
        .Q(cmp_i_d1[5]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[6] ),
        .Q(cmp_i_d1[6]),
        .R(rst_IBUF));
  FDRE \cmp_i_d1_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(\cmp_i_reg_n_0_[7] ),
        .Q(cmp_i_d1[7]),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[0]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[1]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[2]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[3]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[4]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[5]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[6]_i_1_n_0 ),
        .Q(\cmp_i_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \cmp_i_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i),
        .D(\cmp_i[7]_i_2_n_0 ),
        .Q(\cmp_i_reg_n_0_[7] ),
        .R(rst_IBUF));
  LUT3 #(
    .INIT(8'h80)) 
    cmp_last_d1_i_1
       (.I0(\cmp_i_reg_n_0_[6] ),
        .I1(u_inv_fsm_n_40),
        .I2(\cmp_i_reg_n_0_[7] ),
        .O(cmp_last_d1_i_1_n_0));
  FDRE cmp_last_d1_reg
       (.C(clk_IBUF_BUFG),
        .CE(cmp_i_d1__0),
        .D(cmp_last_d1_i_1_n_0),
        .Q(cmp_last_d1),
        .R(rst_IBUF));
  FDRE cmp_valid_d1_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(u_inv_fsm_n_48),
        .Q(cmp_valid_d1_reg_n_0),
        .R(rst_IBUF));
  LUT3 #(
    .INIT(8'hEA)) 
    \cycle_cnt_r[0]_i_1 
       (.I0(rst_IBUF),
        .I1(start_i_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .O(\cycle_cnt_r[0]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \cycle_cnt_r[0]_i_3 
       (.I0(cycle_count_OBUF[0]),
        .O(\cycle_cnt_r[0]_i_3_n_0 ));
  FDRE \cycle_cnt_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_15 ),
        .Q(cycle_count_OBUF[0]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "16" *) 
  CARRY8 \cycle_cnt_r_reg[0]_i_2 
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({\cycle_cnt_r_reg[0]_i_2_n_0 ,\cycle_cnt_r_reg[0]_i_2_n_1 ,\cycle_cnt_r_reg[0]_i_2_n_2 ,\cycle_cnt_r_reg[0]_i_2_n_3 ,\cycle_cnt_r_reg[0]_i_2_n_4 ,\cycle_cnt_r_reg[0]_i_2_n_5 ,\cycle_cnt_r_reg[0]_i_2_n_6 ,\cycle_cnt_r_reg[0]_i_2_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .O({\cycle_cnt_r_reg[0]_i_2_n_8 ,\cycle_cnt_r_reg[0]_i_2_n_9 ,\cycle_cnt_r_reg[0]_i_2_n_10 ,\cycle_cnt_r_reg[0]_i_2_n_11 ,\cycle_cnt_r_reg[0]_i_2_n_12 ,\cycle_cnt_r_reg[0]_i_2_n_13 ,\cycle_cnt_r_reg[0]_i_2_n_14 ,\cycle_cnt_r_reg[0]_i_2_n_15 }),
        .S({cycle_count_OBUF[7:1],\cycle_cnt_r[0]_i_3_n_0 }));
  FDRE \cycle_cnt_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_13 ),
        .Q(cycle_count_OBUF[10]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_12 ),
        .Q(cycle_count_OBUF[11]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_11 ),
        .Q(cycle_count_OBUF[12]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_10 ),
        .Q(cycle_count_OBUF[13]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_9 ),
        .Q(cycle_count_OBUF[14]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_8 ),
        .Q(cycle_count_OBUF[15]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_15 ),
        .Q(cycle_count_OBUF[16]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "16" *) 
  CARRY8 \cycle_cnt_r_reg[16]_i_1 
       (.CI(\cycle_cnt_r_reg[8]_i_1_n_0 ),
        .CI_TOP(1'b0),
        .CO({\cycle_cnt_r_reg[16]_i_1_n_0 ,\cycle_cnt_r_reg[16]_i_1_n_1 ,\cycle_cnt_r_reg[16]_i_1_n_2 ,\cycle_cnt_r_reg[16]_i_1_n_3 ,\cycle_cnt_r_reg[16]_i_1_n_4 ,\cycle_cnt_r_reg[16]_i_1_n_5 ,\cycle_cnt_r_reg[16]_i_1_n_6 ,\cycle_cnt_r_reg[16]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\cycle_cnt_r_reg[16]_i_1_n_8 ,\cycle_cnt_r_reg[16]_i_1_n_9 ,\cycle_cnt_r_reg[16]_i_1_n_10 ,\cycle_cnt_r_reg[16]_i_1_n_11 ,\cycle_cnt_r_reg[16]_i_1_n_12 ,\cycle_cnt_r_reg[16]_i_1_n_13 ,\cycle_cnt_r_reg[16]_i_1_n_14 ,\cycle_cnt_r_reg[16]_i_1_n_15 }),
        .S(cycle_count_OBUF[23:16]));
  FDRE \cycle_cnt_r_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_14 ),
        .Q(cycle_count_OBUF[17]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_13 ),
        .Q(cycle_count_OBUF[18]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_12 ),
        .Q(cycle_count_OBUF[19]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_14 ),
        .Q(cycle_count_OBUF[1]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_11 ),
        .Q(cycle_count_OBUF[20]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_10 ),
        .Q(cycle_count_OBUF[21]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_9 ),
        .Q(cycle_count_OBUF[22]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[16]_i_1_n_8 ),
        .Q(cycle_count_OBUF[23]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_15 ),
        .Q(cycle_count_OBUF[24]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "16" *) 
  CARRY8 \cycle_cnt_r_reg[24]_i_1 
       (.CI(\cycle_cnt_r_reg[16]_i_1_n_0 ),
        .CI_TOP(1'b0),
        .CO({\NLW_cycle_cnt_r_reg[24]_i_1_CO_UNCONNECTED [7],\cycle_cnt_r_reg[24]_i_1_n_1 ,\cycle_cnt_r_reg[24]_i_1_n_2 ,\cycle_cnt_r_reg[24]_i_1_n_3 ,\cycle_cnt_r_reg[24]_i_1_n_4 ,\cycle_cnt_r_reg[24]_i_1_n_5 ,\cycle_cnt_r_reg[24]_i_1_n_6 ,\cycle_cnt_r_reg[24]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\cycle_cnt_r_reg[24]_i_1_n_8 ,\cycle_cnt_r_reg[24]_i_1_n_9 ,\cycle_cnt_r_reg[24]_i_1_n_10 ,\cycle_cnt_r_reg[24]_i_1_n_11 ,\cycle_cnt_r_reg[24]_i_1_n_12 ,\cycle_cnt_r_reg[24]_i_1_n_13 ,\cycle_cnt_r_reg[24]_i_1_n_14 ,\cycle_cnt_r_reg[24]_i_1_n_15 }),
        .S(cycle_count_OBUF[31:24]));
  FDRE \cycle_cnt_r_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_14 ),
        .Q(cycle_count_OBUF[25]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_13 ),
        .Q(cycle_count_OBUF[26]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_12 ),
        .Q(cycle_count_OBUF[27]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_11 ),
        .Q(cycle_count_OBUF[28]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_10 ),
        .Q(cycle_count_OBUF[29]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_13 ),
        .Q(cycle_count_OBUF[2]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_9 ),
        .Q(cycle_count_OBUF[30]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[24]_i_1_n_8 ),
        .Q(cycle_count_OBUF[31]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_12 ),
        .Q(cycle_count_OBUF[3]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_11 ),
        .Q(cycle_count_OBUF[4]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_10 ),
        .Q(cycle_count_OBUF[5]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_9 ),
        .Q(cycle_count_OBUF[6]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[0]_i_2_n_8 ),
        .Q(cycle_count_OBUF[7]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  FDRE \cycle_cnt_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_15 ),
        .Q(cycle_count_OBUF[8]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "16" *) 
  CARRY8 \cycle_cnt_r_reg[8]_i_1 
       (.CI(\cycle_cnt_r_reg[0]_i_2_n_0 ),
        .CI_TOP(1'b0),
        .CO({\cycle_cnt_r_reg[8]_i_1_n_0 ,\cycle_cnt_r_reg[8]_i_1_n_1 ,\cycle_cnt_r_reg[8]_i_1_n_2 ,\cycle_cnt_r_reg[8]_i_1_n_3 ,\cycle_cnt_r_reg[8]_i_1_n_4 ,\cycle_cnt_r_reg[8]_i_1_n_5 ,\cycle_cnt_r_reg[8]_i_1_n_6 ,\cycle_cnt_r_reg[8]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\cycle_cnt_r_reg[8]_i_1_n_8 ,\cycle_cnt_r_reg[8]_i_1_n_9 ,\cycle_cnt_r_reg[8]_i_1_n_10 ,\cycle_cnt_r_reg[8]_i_1_n_11 ,\cycle_cnt_r_reg[8]_i_1_n_12 ,\cycle_cnt_r_reg[8]_i_1_n_13 ,\cycle_cnt_r_reg[8]_i_1_n_14 ,\cycle_cnt_r_reg[8]_i_1_n_15 }),
        .S(cycle_count_OBUF[15:8]));
  FDRE \cycle_cnt_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(busy_OBUF),
        .D(\cycle_cnt_r_reg[8]_i_1_n_14 ),
        .Q(cycle_count_OBUF[9]),
        .R(\cycle_cnt_r[0]_i_1_n_0 ));
  OBUF \cycle_count_OBUF[0]_inst 
       (.I(cycle_count_OBUF[0]),
        .O(cycle_count[0]));
  OBUF \cycle_count_OBUF[10]_inst 
       (.I(cycle_count_OBUF[10]),
        .O(cycle_count[10]));
  OBUF \cycle_count_OBUF[11]_inst 
       (.I(cycle_count_OBUF[11]),
        .O(cycle_count[11]));
  OBUF \cycle_count_OBUF[12]_inst 
       (.I(cycle_count_OBUF[12]),
        .O(cycle_count[12]));
  OBUF \cycle_count_OBUF[13]_inst 
       (.I(cycle_count_OBUF[13]),
        .O(cycle_count[13]));
  OBUF \cycle_count_OBUF[14]_inst 
       (.I(cycle_count_OBUF[14]),
        .O(cycle_count[14]));
  OBUF \cycle_count_OBUF[15]_inst 
       (.I(cycle_count_OBUF[15]),
        .O(cycle_count[15]));
  OBUF \cycle_count_OBUF[16]_inst 
       (.I(cycle_count_OBUF[16]),
        .O(cycle_count[16]));
  OBUF \cycle_count_OBUF[17]_inst 
       (.I(cycle_count_OBUF[17]),
        .O(cycle_count[17]));
  OBUF \cycle_count_OBUF[18]_inst 
       (.I(cycle_count_OBUF[18]),
        .O(cycle_count[18]));
  OBUF \cycle_count_OBUF[19]_inst 
       (.I(cycle_count_OBUF[19]),
        .O(cycle_count[19]));
  OBUF \cycle_count_OBUF[1]_inst 
       (.I(cycle_count_OBUF[1]),
        .O(cycle_count[1]));
  OBUF \cycle_count_OBUF[20]_inst 
       (.I(cycle_count_OBUF[20]),
        .O(cycle_count[20]));
  OBUF \cycle_count_OBUF[21]_inst 
       (.I(cycle_count_OBUF[21]),
        .O(cycle_count[21]));
  OBUF \cycle_count_OBUF[22]_inst 
       (.I(cycle_count_OBUF[22]),
        .O(cycle_count[22]));
  OBUF \cycle_count_OBUF[23]_inst 
       (.I(cycle_count_OBUF[23]),
        .O(cycle_count[23]));
  OBUF \cycle_count_OBUF[24]_inst 
       (.I(cycle_count_OBUF[24]),
        .O(cycle_count[24]));
  OBUF \cycle_count_OBUF[25]_inst 
       (.I(cycle_count_OBUF[25]),
        .O(cycle_count[25]));
  OBUF \cycle_count_OBUF[26]_inst 
       (.I(cycle_count_OBUF[26]),
        .O(cycle_count[26]));
  OBUF \cycle_count_OBUF[27]_inst 
       (.I(cycle_count_OBUF[27]),
        .O(cycle_count[27]));
  OBUF \cycle_count_OBUF[28]_inst 
       (.I(cycle_count_OBUF[28]),
        .O(cycle_count[28]));
  OBUF \cycle_count_OBUF[29]_inst 
       (.I(cycle_count_OBUF[29]),
        .O(cycle_count[29]));
  OBUF \cycle_count_OBUF[2]_inst 
       (.I(cycle_count_OBUF[2]),
        .O(cycle_count[2]));
  OBUF \cycle_count_OBUF[30]_inst 
       (.I(cycle_count_OBUF[30]),
        .O(cycle_count[30]));
  OBUF \cycle_count_OBUF[31]_inst 
       (.I(cycle_count_OBUF[31]),
        .O(cycle_count[31]));
  OBUF \cycle_count_OBUF[3]_inst 
       (.I(cycle_count_OBUF[3]),
        .O(cycle_count[3]));
  OBUF \cycle_count_OBUF[4]_inst 
       (.I(cycle_count_OBUF[4]),
        .O(cycle_count[4]));
  OBUF \cycle_count_OBUF[5]_inst 
       (.I(cycle_count_OBUF[5]),
        .O(cycle_count[5]));
  OBUF \cycle_count_OBUF[6]_inst 
       (.I(cycle_count_OBUF[6]),
        .O(cycle_count[6]));
  OBUF \cycle_count_OBUF[7]_inst 
       (.I(cycle_count_OBUF[7]),
        .O(cycle_count[7]));
  OBUF \cycle_count_OBUF[8]_inst 
       (.I(cycle_count_OBUF[8]),
        .O(cycle_count[8]));
  OBUF \cycle_count_OBUF[9]_inst 
       (.I(cycle_count_OBUF[9]),
        .O(cycle_count[9]));
  OBUF done_OBUF_inst
       (.I(done_OBUF),
        .O(done));
  IBUF \ext_addr_IBUF[0]_inst 
       (.I(ext_addr[0]),
        .O(ext_addr_IBUF[0]));
  IBUF \ext_addr_IBUF[1]_inst 
       (.I(ext_addr[1]),
        .O(ext_addr_IBUF[1]));
  IBUF \ext_addr_IBUF[2]_inst 
       (.I(ext_addr[2]),
        .O(ext_addr_IBUF[2]));
  IBUF \ext_addr_IBUF[3]_inst 
       (.I(ext_addr[3]),
        .O(ext_addr_IBUF[3]));
  IBUF \ext_addr_IBUF[4]_inst 
       (.I(ext_addr[4]),
        .O(ext_addr_IBUF[4]));
  IBUF \ext_addr_IBUF[5]_inst 
       (.I(ext_addr[5]),
        .O(ext_addr_IBUF[5]));
  IBUF \ext_addr_IBUF[6]_inst 
       (.I(ext_addr[6]),
        .O(ext_addr_IBUF[6]));
  IBUF \ext_addr_IBUF[7]_inst 
       (.I(ext_addr[7]),
        .O(ext_addr_IBUF[7]));
  IBUF ext_addr_sel_IBUF_inst
       (.I(ext_addr_sel),
        .O(ext_addr_sel_IBUF));
  OBUF \ext_dout_OBUF[0]_inst 
       (.I(ext_dout_OBUF[0]),
        .O(ext_dout[0]));
  OBUF \ext_dout_OBUF[10]_inst 
       (.I(ext_dout_OBUF[10]),
        .O(ext_dout[10]));
  OBUF \ext_dout_OBUF[11]_inst 
       (.I(ext_dout_OBUF[11]),
        .O(ext_dout[11]));
  OBUF \ext_dout_OBUF[1]_inst 
       (.I(ext_dout_OBUF[1]),
        .O(ext_dout[1]));
  OBUF \ext_dout_OBUF[2]_inst 
       (.I(ext_dout_OBUF[2]),
        .O(ext_dout[2]));
  OBUF \ext_dout_OBUF[3]_inst 
       (.I(ext_dout_OBUF[3]),
        .O(ext_dout[3]));
  OBUF \ext_dout_OBUF[4]_inst 
       (.I(ext_dout_OBUF[4]),
        .O(ext_dout[4]));
  OBUF \ext_dout_OBUF[5]_inst 
       (.I(ext_dout_OBUF[5]),
        .O(ext_dout[5]));
  OBUF \ext_dout_OBUF[6]_inst 
       (.I(ext_dout_OBUF[6]),
        .O(ext_dout[6]));
  OBUF \ext_dout_OBUF[7]_inst 
       (.I(ext_dout_OBUF[7]),
        .O(ext_dout[7]));
  OBUF \ext_dout_OBUF[8]_inst 
       (.I(ext_dout_OBUF[8]),
        .O(ext_dout[8]));
  OBUF \ext_dout_OBUF[9]_inst 
       (.I(ext_dout_OBUF[9]),
        .O(ext_dout[9]));
  LUT6 #(
    .INIT(64'h0000800000000000)) 
    fwd_start_i_1
       (.I0(u_inv_fsm_n_26),
        .I1(load_i[7]),
        .I2(\load_phase_cnt_reg_n_0_[0] ),
        .I3(\load_phase_cnt_reg_n_0_[2] ),
        .I4(\load_phase_cnt_reg_n_0_[1] ),
        .I5(orig_mem),
        .O(fwd_start));
  FDRE fwd_start_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(fwd_start),
        .Q(fwd_start_reg_n_0),
        .R(rst_IBUF));
  FDRE inv_start_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(inv_start),
        .Q(inv_start_reg_n_0),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \load_i[0]_i_1 
       (.I0(orig_mem),
        .I1(load_i[0]),
        .O(\load_i[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \load_i[1]_i_1 
       (.I0(load_i[1]),
        .I1(load_i[0]),
        .I2(orig_mem),
        .O(\load_i[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \load_i[2]_i_1 
       (.I0(orig_mem),
        .I1(load_i[0]),
        .I2(load_i[1]),
        .I3(load_i[2]),
        .O(\load_i[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT5 #(
    .INIT(32'h7F800000)) 
    \load_i[3]_i_1 
       (.I0(load_i[1]),
        .I1(load_i[0]),
        .I2(load_i[2]),
        .I3(load_i[3]),
        .I4(orig_mem),
        .O(\load_i[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \load_i[4]_i_1 
       (.I0(orig_mem),
        .I1(load_i[3]),
        .I2(load_i[2]),
        .I3(load_i[0]),
        .I4(load_i[1]),
        .I5(load_i[4]),
        .O(\load_i[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \load_i[5]_i_1 
       (.I0(orig_mem),
        .I1(\load_i[5]_i_2_n_0 ),
        .I2(load_i[5]),
        .O(\load_i[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \load_i[5]_i_2 
       (.I0(load_i[4]),
        .I1(load_i[1]),
        .I2(load_i[0]),
        .I3(load_i[2]),
        .I4(load_i[3]),
        .O(\load_i[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \load_i[6]_i_1 
       (.I0(orig_mem),
        .I1(u_inv_fsm_n_49),
        .I2(load_i[6]),
        .O(\load_i[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888F888F888F888)) 
    \load_i[7]_i_1 
       (.I0(start_i_IBUF),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(orig_mem),
        .I3(p_0_in),
        .I4(load_i[7]),
        .I5(u_inv_fsm_n_26),
        .O(\load_i[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \load_i[7]_i_2 
       (.I0(orig_mem),
        .I1(u_inv_fsm_n_49),
        .I2(load_i[6]),
        .I3(load_i[7]),
        .O(\load_i[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \load_i[7]_i_3 
       (.I0(\load_phase_cnt_reg_n_0_[0] ),
        .I1(\load_phase_cnt_reg_n_0_[2] ),
        .I2(\load_phase_cnt_reg_n_0_[1] ),
        .O(p_0_in));
  FDRE \load_i_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[0]_i_1_n_0 ),
        .Q(load_i[0]),
        .R(rst_IBUF));
  FDRE \load_i_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[1]_i_1_n_0 ),
        .Q(load_i[1]),
        .R(rst_IBUF));
  FDRE \load_i_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[2]_i_1_n_0 ),
        .Q(load_i[2]),
        .R(rst_IBUF));
  FDRE \load_i_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[3]_i_1_n_0 ),
        .Q(load_i[3]),
        .R(rst_IBUF));
  FDRE \load_i_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[4]_i_1_n_0 ),
        .Q(load_i[4]),
        .R(rst_IBUF));
  FDRE \load_i_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[5]_i_1_n_0 ),
        .Q(load_i[5]),
        .R(rst_IBUF));
  FDRE \load_i_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[6]_i_1_n_0 ),
        .Q(load_i[6]),
        .R(rst_IBUF));
  FDRE \load_i_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\load_i[7]_i_1_n_0 ),
        .D(\load_i[7]_i_2_n_0 ),
        .Q(load_i[7]),
        .R(rst_IBUF));
  LUT2 #(
    .INIT(4'h2)) 
    \load_phase_cnt[0]_i_1 
       (.I0(orig_mem),
        .I1(\load_phase_cnt_reg_n_0_[0] ),
        .O(\load_phase_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT4 #(
    .INIT(16'h04C0)) 
    \load_phase_cnt[1]_i_1 
       (.I0(\load_phase_cnt_reg_n_0_[2] ),
        .I1(orig_mem),
        .I2(\load_phase_cnt_reg_n_0_[1] ),
        .I3(\load_phase_cnt_reg_n_0_[0] ),
        .O(\load_phase_cnt[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hEA)) 
    \load_phase_cnt[2]_i_1 
       (.I0(orig_mem),
        .I1(start_i_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .O(load_phase_cnt));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT4 #(
    .INIT(16'h2280)) 
    \load_phase_cnt[2]_i_2 
       (.I0(orig_mem),
        .I1(\load_phase_cnt_reg_n_0_[0] ),
        .I2(\load_phase_cnt_reg_n_0_[1] ),
        .I3(\load_phase_cnt_reg_n_0_[2] ),
        .O(\load_phase_cnt[2]_i_2_n_0 ));
  FDRE \load_phase_cnt_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(load_phase_cnt),
        .D(\load_phase_cnt[0]_i_1_n_0 ),
        .Q(\load_phase_cnt_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \load_phase_cnt_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(load_phase_cnt),
        .D(\load_phase_cnt[1]_i_1_n_0 ),
        .Q(\load_phase_cnt_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \load_phase_cnt_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(load_phase_cnt),
        .D(\load_phase_cnt[2]_i_2_n_0 ),
        .Q(\load_phase_cnt_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE mismatch_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(u_mem_n_86),
        .Q(mismatch_reg_n_0),
        .R(rst_IBUF));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_0_63_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r1_0_63_0_6
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_0_63_0_6_n_0),
        .DOB(orig_mem_reg_r1_0_63_0_6_n_1),
        .DOC(orig_mem_reg_r1_0_63_0_6_n_2),
        .DOD(orig_mem_reg_r1_0_63_0_6_n_3),
        .DOE(orig_mem_reg_r1_0_63_0_6_n_4),
        .DOF(orig_mem_reg_r1_0_63_0_6_n_5),
        .DOG(orig_mem_reg_r1_0_63_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r1_0_63_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_0_63_0_6_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    orig_mem_reg_r1_0_63_0_6_i_13
       (.I0(\load_phase_cnt_reg_n_0_[1] ),
        .I1(\load_phase_cnt_reg_n_0_[2] ),
        .I2(\load_phase_cnt_reg_n_0_[0] ),
        .I3(rst_IBUF),
        .I4(orig_mem),
        .O(p_0_in0_out));
  LUT3 #(
    .INIT(8'h02)) 
    orig_mem_reg_r1_0_63_0_6_i_8
       (.I0(p_0_in0_out),
        .I1(load_i[6]),
        .I2(load_i[7]),
        .O(orig_mem_reg_r1_0_63_0_6_i_8_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_0_63_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r1_0_63_7_11
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_0_63_7_11_n_0),
        .DOB(orig_mem_reg_r1_0_63_7_11_n_1),
        .DOC(orig_mem_reg_r1_0_63_7_11_n_2),
        .DOD(orig_mem_reg_r1_0_63_7_11_n_3),
        .DOE(orig_mem_reg_r1_0_63_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r1_0_63_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r1_0_63_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r1_0_63_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_0_63_0_6_i_8_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_128_191_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "128" *) 
  (* ram_addr_end = "191" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r1_128_191_0_6
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_128_191_0_6_n_0),
        .DOB(orig_mem_reg_r1_128_191_0_6_n_1),
        .DOC(orig_mem_reg_r1_128_191_0_6_n_2),
        .DOD(orig_mem_reg_r1_128_191_0_6_n_3),
        .DOE(orig_mem_reg_r1_128_191_0_6_n_4),
        .DOF(orig_mem_reg_r1_128_191_0_6_n_5),
        .DOG(orig_mem_reg_r1_128_191_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r1_128_191_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_128_191_0_6_i_1_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    orig_mem_reg_r1_128_191_0_6_i_1
       (.I0(load_i[6]),
        .I1(load_i[7]),
        .I2(p_0_in0_out),
        .O(orig_mem_reg_r1_128_191_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_128_191_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "128" *) 
  (* ram_addr_end = "191" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r1_128_191_7_11
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_128_191_7_11_n_0),
        .DOB(orig_mem_reg_r1_128_191_7_11_n_1),
        .DOC(orig_mem_reg_r1_128_191_7_11_n_2),
        .DOD(orig_mem_reg_r1_128_191_7_11_n_3),
        .DOE(orig_mem_reg_r1_128_191_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r1_128_191_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r1_128_191_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r1_128_191_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_128_191_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_192_255_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "192" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r1_192_255_0_6
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_192_255_0_6_n_0),
        .DOB(orig_mem_reg_r1_192_255_0_6_n_1),
        .DOC(orig_mem_reg_r1_192_255_0_6_n_2),
        .DOD(orig_mem_reg_r1_192_255_0_6_n_3),
        .DOE(orig_mem_reg_r1_192_255_0_6_n_4),
        .DOF(orig_mem_reg_r1_192_255_0_6_n_5),
        .DOG(orig_mem_reg_r1_192_255_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r1_192_255_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_192_255_0_6_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    orig_mem_reg_r1_192_255_0_6_i_1
       (.I0(p_0_in0_out),
        .I1(load_i[6]),
        .I2(load_i[7]),
        .O(orig_mem_reg_r1_192_255_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_192_255_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "192" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r1_192_255_7_11
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_192_255_7_11_n_0),
        .DOB(orig_mem_reg_r1_192_255_7_11_n_1),
        .DOC(orig_mem_reg_r1_192_255_7_11_n_2),
        .DOD(orig_mem_reg_r1_192_255_7_11_n_3),
        .DOE(orig_mem_reg_r1_192_255_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r1_192_255_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r1_192_255_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r1_192_255_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_192_255_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_64_127_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "64" *) 
  (* ram_addr_end = "127" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r1_64_127_0_6
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_64_127_0_6_n_0),
        .DOB(orig_mem_reg_r1_64_127_0_6_n_1),
        .DOC(orig_mem_reg_r1_64_127_0_6_n_2),
        .DOD(orig_mem_reg_r1_64_127_0_6_n_3),
        .DOE(orig_mem_reg_r1_64_127_0_6_n_4),
        .DOF(orig_mem_reg_r1_64_127_0_6_n_5),
        .DOG(orig_mem_reg_r1_64_127_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r1_64_127_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_64_127_0_6_i_1_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    orig_mem_reg_r1_64_127_0_6_i_1
       (.I0(load_i[7]),
        .I1(load_i[6]),
        .I2(p_0_in0_out),
        .O(orig_mem_reg_r1_64_127_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r1_64_127_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "64" *) 
  (* ram_addr_end = "127" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r1_64_127_7_11
       (.ADDRA(ext_addr_IBUF[5:0]),
        .ADDRB(ext_addr_IBUF[5:0]),
        .ADDRC(ext_addr_IBUF[5:0]),
        .ADDRD(ext_addr_IBUF[5:0]),
        .ADDRE(ext_addr_IBUF[5:0]),
        .ADDRF(ext_addr_IBUF[5:0]),
        .ADDRG(ext_addr_IBUF[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r1_64_127_7_11_n_0),
        .DOB(orig_mem_reg_r1_64_127_7_11_n_1),
        .DOC(orig_mem_reg_r1_64_127_7_11_n_2),
        .DOD(orig_mem_reg_r1_64_127_7_11_n_3),
        .DOE(orig_mem_reg_r1_64_127_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r1_64_127_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r1_64_127_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r1_64_127_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_64_127_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_0_63_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r2_0_63_0_6
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_0_63_0_6_n_0),
        .DOB(orig_mem_reg_r2_0_63_0_6_n_1),
        .DOC(orig_mem_reg_r2_0_63_0_6_n_2),
        .DOD(orig_mem_reg_r2_0_63_0_6_n_3),
        .DOE(orig_mem_reg_r2_0_63_0_6_n_4),
        .DOF(orig_mem_reg_r2_0_63_0_6_n_5),
        .DOG(orig_mem_reg_r2_0_63_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r2_0_63_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_0_63_0_6_i_8_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_0_63_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "63" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r2_0_63_7_11
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_0_63_7_11_n_0),
        .DOB(orig_mem_reg_r2_0_63_7_11_n_1),
        .DOC(orig_mem_reg_r2_0_63_7_11_n_2),
        .DOD(orig_mem_reg_r2_0_63_7_11_n_3),
        .DOE(orig_mem_reg_r2_0_63_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r2_0_63_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r2_0_63_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r2_0_63_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_0_63_0_6_i_8_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_128_191_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "128" *) 
  (* ram_addr_end = "191" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r2_128_191_0_6
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_128_191_0_6_n_0),
        .DOB(orig_mem_reg_r2_128_191_0_6_n_1),
        .DOC(orig_mem_reg_r2_128_191_0_6_n_2),
        .DOD(orig_mem_reg_r2_128_191_0_6_n_3),
        .DOE(orig_mem_reg_r2_128_191_0_6_n_4),
        .DOF(orig_mem_reg_r2_128_191_0_6_n_5),
        .DOG(orig_mem_reg_r2_128_191_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r2_128_191_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_128_191_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_128_191_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "128" *) 
  (* ram_addr_end = "191" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r2_128_191_7_11
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_128_191_7_11_n_0),
        .DOB(orig_mem_reg_r2_128_191_7_11_n_1),
        .DOC(orig_mem_reg_r2_128_191_7_11_n_2),
        .DOD(orig_mem_reg_r2_128_191_7_11_n_3),
        .DOE(orig_mem_reg_r2_128_191_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r2_128_191_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r2_128_191_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r2_128_191_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_128_191_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_192_255_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "192" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r2_192_255_0_6
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_192_255_0_6_n_0),
        .DOB(orig_mem_reg_r2_192_255_0_6_n_1),
        .DOC(orig_mem_reg_r2_192_255_0_6_n_2),
        .DOD(orig_mem_reg_r2_192_255_0_6_n_3),
        .DOE(orig_mem_reg_r2_192_255_0_6_n_4),
        .DOF(orig_mem_reg_r2_192_255_0_6_n_5),
        .DOG(orig_mem_reg_r2_192_255_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r2_192_255_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_192_255_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_192_255_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "192" *) 
  (* ram_addr_end = "255" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r2_192_255_7_11
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_192_255_7_11_n_0),
        .DOB(orig_mem_reg_r2_192_255_7_11_n_1),
        .DOC(orig_mem_reg_r2_192_255_7_11_n_2),
        .DOD(orig_mem_reg_r2_192_255_7_11_n_3),
        .DOE(orig_mem_reg_r2_192_255_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r2_192_255_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r2_192_255_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r2_192_255_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_192_255_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_64_127_0_6" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "64" *) 
  (* ram_addr_end = "127" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "6" *) 
  RAM64M8 orig_mem_reg_r2_64_127_0_6
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[0]),
        .DIB(load_val[1]),
        .DIC(load_val[2]),
        .DID(load_val[3]),
        .DIE(load_val[4]),
        .DIF(load_val[5]),
        .DIG(load_val[6]),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_64_127_0_6_n_0),
        .DOB(orig_mem_reg_r2_64_127_0_6_n_1),
        .DOC(orig_mem_reg_r2_64_127_0_6_n_2),
        .DOD(orig_mem_reg_r2_64_127_0_6_n_3),
        .DOE(orig_mem_reg_r2_64_127_0_6_n_4),
        .DOF(orig_mem_reg_r2_64_127_0_6_n_5),
        .DOG(orig_mem_reg_r2_64_127_0_6_n_6),
        .DOH(NLW_orig_mem_reg_r2_64_127_0_6_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_64_127_0_6_i_1_n_0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "3072" *) 
  (* RTL_RAM_NAME = "orig_mem_reg_r2_64_127_7_11" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "64" *) 
  (* ram_addr_end = "127" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "11" *) 
  RAM64M8 orig_mem_reg_r2_64_127_7_11
       (.ADDRA(cmp_i_d1[5:0]),
        .ADDRB(cmp_i_d1[5:0]),
        .ADDRC(cmp_i_d1[5:0]),
        .ADDRD(cmp_i_d1[5:0]),
        .ADDRE(cmp_i_d1[5:0]),
        .ADDRF(cmp_i_d1[5:0]),
        .ADDRG(cmp_i_d1[5:0]),
        .ADDRH(load_i[5:0]),
        .DIA(load_val[7]),
        .DIB(load_val[8]),
        .DIC(load_val[9]),
        .DID(load_val[10]),
        .DIE(load_val[11]),
        .DIF(1'b0),
        .DIG(1'b0),
        .DIH(1'b0),
        .DOA(orig_mem_reg_r2_64_127_7_11_n_0),
        .DOB(orig_mem_reg_r2_64_127_7_11_n_1),
        .DOC(orig_mem_reg_r2_64_127_7_11_n_2),
        .DOD(orig_mem_reg_r2_64_127_7_11_n_3),
        .DOE(orig_mem_reg_r2_64_127_7_11_n_4),
        .DOF(NLW_orig_mem_reg_r2_64_127_7_11_DOF_UNCONNECTED),
        .DOG(NLW_orig_mem_reg_r2_64_127_7_11_DOG_UNCONNECTED),
        .DOH(NLW_orig_mem_reg_r2_64_127_7_11_DOH_UNCONNECTED),
        .WCLK(clk_IBUF_BUFG),
        .WE(orig_mem_reg_r1_64_127_0_6_i_1_n_0));
  OBUF pass_o_OBUF_inst
       (.I(pass_o_OBUF),
        .O(pass_o));
  LUT1 #(
    .INIT(2'h1)) 
    pass_o_OBUF_inst_i_1
       (.I0(mismatch_reg_n_0),
        .O(pass_o_OBUF));
  OBUF \phase_OBUF[0]_inst 
       (.I(phase_OBUF[0]),
        .O(phase[0]));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \phase_OBUF[0]_inst_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(orig_mem),
        .I2(done_OBUF),
        .O(phase_OBUF[0]));
  OBUF \phase_OBUF[1]_inst 
       (.I(phase_OBUF[1]),
        .O(phase[1]));
  LUT2 #(
    .INIT(4'hE)) 
    \phase_OBUF[1]_inst_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\FSM_onehot_state_reg_n_0_[2] ),
        .O(phase_OBUF[1]));
  OBUF \phase_OBUF[2]_inst 
       (.I(phase_OBUF[2]),
        .O(phase[2]));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \phase_OBUF[2]_inst_i_1 
       (.I0(done_OBUF),
        .I1(cmp_i_d1__0),
        .O(phase_OBUF[2]));
  IBUF rst_IBUF_inst
       (.I(rst),
        .O(rst_IBUF));
  IBUF start_i_IBUF_inst
       (.I(start_i),
        .O(start_i_IBUF));
  butterfly u_fwd_bf
       (.DI({u_mem_n_36,u_mem_n_37,u_mem_n_38,u_mem_n_39,u_mem_n_40,mem_dout_a[0]}),
        .DINADIN(mem_din_b),
        .DOUTADOUT(mem_dout_b),
        .DOUTBDOUT(mem_dout_a[11:1]),
        .DSP_ALU_INST({u_fwd_rom_n_0,u_fwd_rom_n_1,u_fwd_rom_n_2,u_fwd_rom_n_3,u_fwd_rom_n_4,u_fwd_rom_n_5,u_fwd_rom_n_6,u_fwd_rom_n_7,u_fwd_rom_n_8,u_fwd_rom_n_9,u_fwd_rom_n_10,u_fwd_rom_n_11}),
        .Q({b[11:10],b[8],b[6:0]}),
        .S(u_mem_n_88),
        .\c_r_reg[7] ({u_fwd_bf_n_23,u_fwd_bf_n_24,u_fwd_bf_n_25,u_fwd_bf_n_26,u_fwd_bf_n_27,u_fwd_bf_n_28,u_fwd_bf_n_29}),
        .\c_r_reg[9] (u_fwd_bf_n_22),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .mem_reg_bram_0({u_mem_n_41,u_mem_n_42,u_mem_n_43,u_mem_n_44}),
        .mem_reg_bram_0_0(\FSM_onehot_state_reg_n_0_[2] ),
        .mem_reg_bram_0_1(c_r));
  control_fsm u_fwd_fsm
       (.ADDRARDADDR({u_fwd_fsm_n_32,u_fwd_fsm_n_33}),
        .ADDRBWRADDR({u_fwd_fsm_n_26,u_fwd_fsm_n_27,u_fwd_fsm_n_28,u_fwd_fsm_n_29,u_fwd_fsm_n_30,u_fwd_fsm_n_31}),
        .Q(fwd_done),
        .WEBWE(u_fwd_fsm_n_43),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .ext_addr_IBUF({ext_addr_IBUF[6:5],ext_addr_IBUF[3:1]}),
        .inv_start(inv_start),
        .\j_off_reg[0]_0 (u_fwd_fsm_n_34),
        .\j_off_reg[0]_1 (u_fwd_fsm_n_41),
        .\j_off_reg[3]_0 (u_fwd_fsm_n_37),
        .\j_off_reg[3]_1 (u_fwd_fsm_n_40),
        .\j_off_reg[6]_0 (u_fwd_fsm_n_39),
        .\j_off_reg[7]_0 (u_fwd_fsm_n_42),
        .\k_r_reg_rep[0]_0 (u_fwd_fsm_n_0),
        .\k_r_reg_rep[0]_1 (u_fwd_fsm_n_1),
        .\k_r_reg_rep[0]_10 (u_fwd_fsm_n_10),
        .\k_r_reg_rep[0]_11 (u_fwd_fsm_n_11),
        .\k_r_reg_rep[0]_12 (u_fwd_fsm_n_12),
        .\k_r_reg_rep[0]_13 (u_fwd_fsm_n_13),
        .\k_r_reg_rep[0]_14 (u_fwd_fsm_n_14),
        .\k_r_reg_rep[0]_15 (u_fwd_fsm_n_15),
        .\k_r_reg_rep[0]_16 (u_fwd_fsm_n_16),
        .\k_r_reg_rep[0]_17 (u_fwd_fsm_n_17),
        .\k_r_reg_rep[0]_18 (u_fwd_fsm_n_18),
        .\k_r_reg_rep[0]_19 (u_fwd_fsm_n_19),
        .\k_r_reg_rep[0]_2 (u_fwd_fsm_n_2),
        .\k_r_reg_rep[0]_20 (u_fwd_fsm_n_20),
        .\k_r_reg_rep[0]_21 (u_fwd_fsm_n_21),
        .\k_r_reg_rep[0]_22 (u_fwd_fsm_n_22),
        .\k_r_reg_rep[0]_23 (u_fwd_fsm_n_23),
        .\k_r_reg_rep[0]_3 (u_fwd_fsm_n_3),
        .\k_r_reg_rep[0]_4 (u_fwd_fsm_n_4),
        .\k_r_reg_rep[0]_5 (u_fwd_fsm_n_5),
        .\k_r_reg_rep[0]_6 (u_fwd_fsm_n_6),
        .\k_r_reg_rep[0]_7 (u_fwd_fsm_n_7),
        .\k_r_reg_rep[0]_8 (u_fwd_fsm_n_8),
        .\k_r_reg_rep[0]_9 (u_fwd_fsm_n_9),
        .\k_r_reg_rep[6]_0 (u_fwd_fsm_n_45),
        .\len_r_reg[0]_0 (u_fwd_fsm_n_36),
        .\len_r_reg[4]_0 (u_fwd_fsm_n_44),
        .mem_reg_bram_0({done_OBUF,cmp_i_d1__0,\FSM_onehot_state_reg_n_0_[3] ,\FSM_onehot_state_reg_n_0_[2] }),
        .mem_reg_bram_0_0({\cmp_i_reg_n_0_[6] ,\cmp_i_reg_n_0_[5] ,\cmp_i_reg_n_0_[3] ,\cmp_i_reg_n_0_[2] ,\cmp_i_reg_n_0_[1] }),
        .mem_reg_bram_0_1(u_mem_n_68),
        .mem_reg_bram_0_10(u_mem_n_70),
        .mem_reg_bram_0_11(u_inv_fsm_n_43),
        .mem_reg_bram_0_12(u_mem_n_67),
        .mem_reg_bram_0_13(u_inv_fsm_n_36),
        .mem_reg_bram_0_14(u_inv_fsm_n_47),
        .mem_reg_bram_0_15({load_i[5],load_i[2]}),
        .mem_reg_bram_0_16(u_inv_fsm_n_42),
        .mem_reg_bram_0_17(u_inv_fsm_n_46),
        .mem_reg_bram_0_18(u_inv_fsm_n_24),
        .mem_reg_bram_0_19(u_inv_fsm_n_45),
        .mem_reg_bram_0_2(u_mem_n_87),
        .mem_reg_bram_0_20(u_inv_fsm_n_41),
        .mem_reg_bram_0_3(u_mem_n_71),
        .mem_reg_bram_0_4(u_mem_n_65),
        .mem_reg_bram_0_5(u_mem_n_61),
        .mem_reg_bram_0_6(u_mem_n_72),
        .mem_reg_bram_0_7(u_mem_n_66),
        .mem_reg_bram_0_8(u_mem_n_64),
        .mem_reg_bram_0_9(u_mem_n_63),
        .mem_reg_bram_0_i_80_0(u_inv_fsm_n_44),
        .\phase_cnt_reg[0]_0 (fwd_start_reg_n_0),
        .\phase_cnt_reg[1]_0 (u_fwd_fsm_n_35),
        .rst_IBUF(rst_IBUF),
        .\start_r_reg[6]_0 (u_fwd_fsm_n_38));
  twiddle_rom u_fwd_rom
       (.DSP_A_B_DATA_INST(u_fwd_fsm_n_45),
        .DSP_A_B_DATA_INST_0(u_fwd_fsm_n_0),
        .DSP_A_B_DATA_INST_1(u_fwd_fsm_n_12),
        .DSP_A_B_DATA_INST_10(u_fwd_fsm_n_5),
        .DSP_A_B_DATA_INST_11(u_fwd_fsm_n_17),
        .DSP_A_B_DATA_INST_12(u_fwd_fsm_n_6),
        .DSP_A_B_DATA_INST_13(u_fwd_fsm_n_18),
        .DSP_A_B_DATA_INST_14(u_fwd_fsm_n_7),
        .DSP_A_B_DATA_INST_15(u_fwd_fsm_n_19),
        .DSP_A_B_DATA_INST_16(u_fwd_fsm_n_8),
        .DSP_A_B_DATA_INST_17(u_fwd_fsm_n_20),
        .DSP_A_B_DATA_INST_18(u_fwd_fsm_n_9),
        .DSP_A_B_DATA_INST_19(u_fwd_fsm_n_21),
        .DSP_A_B_DATA_INST_2(u_fwd_fsm_n_1),
        .DSP_A_B_DATA_INST_20(u_fwd_fsm_n_10),
        .DSP_A_B_DATA_INST_21(u_fwd_fsm_n_22),
        .DSP_A_B_DATA_INST_22(u_fwd_fsm_n_11),
        .DSP_A_B_DATA_INST_23(u_fwd_fsm_n_23),
        .DSP_A_B_DATA_INST_3(u_fwd_fsm_n_13),
        .DSP_A_B_DATA_INST_4(u_fwd_fsm_n_2),
        .DSP_A_B_DATA_INST_5(u_fwd_fsm_n_14),
        .DSP_A_B_DATA_INST_6(u_fwd_fsm_n_3),
        .DSP_A_B_DATA_INST_7(u_fwd_fsm_n_15),
        .DSP_A_B_DATA_INST_8(u_fwd_fsm_n_4),
        .DSP_A_B_DATA_INST_9(u_fwd_fsm_n_16),
        .\k_r_reg_rep[6] ({u_fwd_rom_n_0,u_fwd_rom_n_1,u_fwd_rom_n_2,u_fwd_rom_n_3,u_fwd_rom_n_4,u_fwd_rom_n_5,u_fwd_rom_n_6,u_fwd_rom_n_7,u_fwd_rom_n_8,u_fwd_rom_n_9,u_fwd_rom_n_10,u_fwd_rom_n_11}));
  intt_butterfly u_inv_bf
       (.A({u_inv_rom_n_0,u_inv_rom_n_1,u_inv_rom_n_2,u_inv_rom_n_3,u_inv_rom_n_4,u_inv_rom_n_5,u_inv_rom_n_6,u_inv_rom_n_7,u_inv_rom_n_8,u_inv_rom_n_9,u_inv_rom_n_10,u_inv_rom_n_11}),
        .DI({u_mem_n_45,u_mem_n_46,u_mem_n_47,u_mem_n_48,u_mem_n_49,u_mem_n_50,mem_dout_a[1],mem_dout_b[0]}),
        .DOUTADOUT({mem_dout_b[9],mem_dout_b[7:2]}),
        .DOUTBDOUT({mem_dout_a[9],mem_dout_a[7:2],mem_dout_a[0]}),
        .DSP_ALU_INST(B),
        .DSP_A_B_DATA_INST(u_mem_n_77),
        .O({u_inv_bf_n_0,u_inv_bf_n_1,u_inv_bf_n_2,u_inv_bf_n_3,u_inv_bf_n_4}),
        .Q(c_r),
        .S({u_mem_n_78,u_mem_n_79,u_mem_n_80,u_mem_n_81,u_mem_n_82,u_mem_n_83,u_mem_n_84,u_mem_n_85}),
        .T_r_reg_i_27({u_mem_n_51,u_mem_n_52,u_mem_n_53,u_mem_n_54}),
        .T_r_reg_i_27_0({u_mem_n_55,u_mem_n_56,u_mem_n_57,u_mem_n_58,u_mem_n_59}),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .mem_reg_bram_0(u_inv_bf_n_5),
        .mem_reg_bram_0_0({u_inv_bf_n_18,u_inv_bf_n_19,u_inv_bf_n_20,u_inv_bf_n_21,u_inv_bf_n_22,u_inv_bf_n_23,u_inv_bf_n_24}),
        .mem_reg_bram_0_1(u_inv_bf_n_25));
  intt_control_fsm u_inv_fsm
       (.ADDRARDADDR({u_inv_fsm_n_29,u_inv_fsm_n_30,u_inv_fsm_n_31,u_inv_fsm_n_32,u_inv_fsm_n_33,u_inv_fsm_n_34}),
        .ADDRBWRADDR({u_inv_fsm_n_27,u_inv_fsm_n_28}),
        .E(u_inv_fsm_n_25),
        .\FSM_onehot_state[5]_i_2_0 (u_mem_n_62),
        .\FSM_onehot_state[5]_i_2_1 (load_i),
        .\FSM_onehot_state[5]_i_2_2 (fwd_done),
        .\FSM_onehot_state_reg[3] (cmp_i),
        .\FSM_onehot_state_reg[4] (u_inv_fsm_n_48),
        .\FSM_onehot_state_reg[5] (u_mem_n_61),
        .\FSM_onehot_state_reg[5]_0 (u_mem_n_63),
        .\FSM_sequential_state_reg[1]_0 (u_inv_fsm_n_35),
        .\FSM_sequential_state_reg[1]_1 (state__0),
        .Q({\load_phase_cnt_reg_n_0_[2] ,\load_phase_cnt_reg_n_0_[1] ,\load_phase_cnt_reg_n_0_[0] }),
        .WEA(u_inv_fsm_n_50),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .\cmp_i_reg[4] (u_inv_fsm_n_40),
        .cmp_last_d1(cmp_last_d1),
        .cmp_valid_d1_reg(cmp_valid_d1_reg_n_0),
        .ext_addr_IBUF({ext_addr_IBUF[7],ext_addr_IBUF[0]}),
        .\j_off_reg[0]_0 (u_inv_fsm_n_36),
        .\j_off_reg[1]_0 (u_inv_fsm_n_43),
        .\k_r_reg_rep[0]_0 (u_inv_fsm_n_0),
        .\k_r_reg_rep[0]_1 (u_inv_fsm_n_1),
        .\k_r_reg_rep[0]_10 (u_inv_fsm_n_10),
        .\k_r_reg_rep[0]_11 (u_inv_fsm_n_11),
        .\k_r_reg_rep[0]_12 (u_inv_fsm_n_12),
        .\k_r_reg_rep[0]_13 (u_inv_fsm_n_13),
        .\k_r_reg_rep[0]_14 (u_inv_fsm_n_14),
        .\k_r_reg_rep[0]_15 (u_inv_fsm_n_15),
        .\k_r_reg_rep[0]_16 (u_inv_fsm_n_16),
        .\k_r_reg_rep[0]_17 (u_inv_fsm_n_17),
        .\k_r_reg_rep[0]_18 (u_inv_fsm_n_18),
        .\k_r_reg_rep[0]_19 (u_inv_fsm_n_19),
        .\k_r_reg_rep[0]_2 (u_inv_fsm_n_2),
        .\k_r_reg_rep[0]_20 (u_inv_fsm_n_20),
        .\k_r_reg_rep[0]_21 (u_inv_fsm_n_21),
        .\k_r_reg_rep[0]_22 (u_inv_fsm_n_22),
        .\k_r_reg_rep[0]_23 (u_inv_fsm_n_23),
        .\k_r_reg_rep[0]_3 (u_inv_fsm_n_3),
        .\k_r_reg_rep[0]_4 (u_inv_fsm_n_4),
        .\k_r_reg_rep[0]_5 (u_inv_fsm_n_5),
        .\k_r_reg_rep[0]_6 (u_inv_fsm_n_6),
        .\k_r_reg_rep[0]_7 (u_inv_fsm_n_7),
        .\k_r_reg_rep[0]_8 (u_inv_fsm_n_8),
        .\k_r_reg_rep[0]_9 (u_inv_fsm_n_9),
        .\k_r_reg_rep[6]_0 (u_inv_fsm_n_51),
        .\len_r_reg[1]_0 (u_inv_fsm_n_47),
        .\load_i_reg[3] (u_inv_fsm_n_49),
        .\load_i_reg[6] (u_inv_fsm_n_26),
        .\load_phase_cnt_reg[0] (u_inv_fsm_n_24),
        .mem_reg_bram_0({done_OBUF,cmp_i_d1__0,\FSM_onehot_state_reg_n_0_[3] ,\FSM_onehot_state_reg_n_0_[2] }),
        .mem_reg_bram_0_0({\cmp_i_reg_n_0_[7] ,\cmp_i_reg_n_0_[6] ,\cmp_i_reg_n_0_[5] ,\cmp_i_reg_n_0_[4] ,\cmp_i_reg_n_0_[3] ,\cmp_i_reg_n_0_[2] ,\cmp_i_reg_n_0_[1] ,\cmp_i_reg_n_0_[0] }),
        .mem_reg_bram_0_1(u_mem_n_68),
        .mem_reg_bram_0_10(u_fwd_fsm_n_40),
        .mem_reg_bram_0_11(u_fwd_fsm_n_38),
        .mem_reg_bram_0_12(u_fwd_fsm_n_39),
        .mem_reg_bram_0_13(u_fwd_fsm_n_34),
        .mem_reg_bram_0_14(u_fwd_fsm_n_35),
        .mem_reg_bram_0_15(u_fwd_fsm_n_36),
        .mem_reg_bram_0_16(u_fwd_fsm_n_42),
        .mem_reg_bram_0_2(u_mem_n_60),
        .mem_reg_bram_0_3(u_mem_n_87),
        .mem_reg_bram_0_4(u_mem_n_69),
        .mem_reg_bram_0_5(u_mem_n_65),
        .mem_reg_bram_0_6(u_fwd_fsm_n_41),
        .mem_reg_bram_0_7(u_mem_n_70),
        .mem_reg_bram_0_8(u_fwd_fsm_n_37),
        .mem_reg_bram_0_9(u_fwd_fsm_n_44),
        .\phase_cnt_reg[0]_0 (inv_start_reg_n_0),
        .rst_IBUF(rst_IBUF),
        .\scale_i_reg[2]_0 (u_inv_fsm_n_44),
        .\scale_i_reg[3]_0 (u_inv_fsm_n_45),
        .\scale_i_reg[4]_0 (u_inv_fsm_n_46),
        .\scale_i_reg[5]_0 (u_inv_fsm_n_42),
        .\scale_i_reg[6]_0 (u_inv_fsm_n_41),
        .start_i_IBUF(start_i_IBUF));
  twiddle_rom_0 u_inv_rom
       (.A({u_inv_rom_n_0,u_inv_rom_n_1,u_inv_rom_n_2,u_inv_rom_n_3,u_inv_rom_n_4,u_inv_rom_n_5,u_inv_rom_n_6,u_inv_rom_n_7,u_inv_rom_n_8,u_inv_rom_n_9,u_inv_rom_n_10,u_inv_rom_n_11}),
        .DSP_A_B_DATA_INST(u_inv_fsm_n_51),
        .DSP_A_B_DATA_INST_0(u_inv_fsm_n_0),
        .DSP_A_B_DATA_INST_1(u_inv_fsm_n_12),
        .DSP_A_B_DATA_INST_10(u_inv_fsm_n_5),
        .DSP_A_B_DATA_INST_11(u_inv_fsm_n_17),
        .DSP_A_B_DATA_INST_12(u_inv_fsm_n_6),
        .DSP_A_B_DATA_INST_13(u_inv_fsm_n_18),
        .DSP_A_B_DATA_INST_14(u_inv_fsm_n_7),
        .DSP_A_B_DATA_INST_15(u_inv_fsm_n_19),
        .DSP_A_B_DATA_INST_16(u_inv_fsm_n_8),
        .DSP_A_B_DATA_INST_17(u_inv_fsm_n_20),
        .DSP_A_B_DATA_INST_18(u_inv_fsm_n_9),
        .DSP_A_B_DATA_INST_19(u_inv_fsm_n_21),
        .DSP_A_B_DATA_INST_2(u_inv_fsm_n_1),
        .DSP_A_B_DATA_INST_20(u_inv_fsm_n_10),
        .DSP_A_B_DATA_INST_21(u_inv_fsm_n_22),
        .DSP_A_B_DATA_INST_22(u_inv_fsm_n_11),
        .DSP_A_B_DATA_INST_23(u_inv_fsm_n_23),
        .DSP_A_B_DATA_INST_3(u_inv_fsm_n_13),
        .DSP_A_B_DATA_INST_4(u_inv_fsm_n_2),
        .DSP_A_B_DATA_INST_5(u_inv_fsm_n_14),
        .DSP_A_B_DATA_INST_6(u_inv_fsm_n_3),
        .DSP_A_B_DATA_INST_7(u_inv_fsm_n_15),
        .DSP_A_B_DATA_INST_8(u_inv_fsm_n_4),
        .DSP_A_B_DATA_INST_9(u_inv_fsm_n_16));
  mod_mult u_load_mul
       (.Q(load_i),
        .\c_r_reg[0]_0 (u_load_mul_n_16),
        .\c_r_reg[10]_0 (u_load_mul_n_17),
        .\c_r_reg[2]_0 (u_load_mul_n_12),
        .\c_r_reg[3]_0 (u_load_mul_n_13),
        .\c_r_reg[5]_0 (u_load_mul_n_15),
        .\c_r_reg[9]_0 (u_load_mul_n_14),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .load_val(load_val));
  coeff_mem u_mem
       (.ADDRARDADDR({u_inv_fsm_n_29,u_inv_fsm_n_30,u_inv_fsm_n_31,u_inv_fsm_n_32,u_fwd_fsm_n_32,u_inv_fsm_n_33,u_inv_fsm_n_34,u_fwd_fsm_n_33}),
        .ADDRBWRADDR({u_inv_fsm_n_27,u_fwd_fsm_n_26,u_fwd_fsm_n_27,u_fwd_fsm_n_28,u_fwd_fsm_n_29,u_fwd_fsm_n_30,u_fwd_fsm_n_31,u_inv_fsm_n_28}),
        .DI({u_mem_n_36,u_mem_n_37,u_mem_n_38,u_mem_n_39,u_mem_n_40}),
        .DINADIN(mem_din_b),
        .DOUTADOUT(mem_dout_b),
        .DOUTBDOUT(mem_dout_a),
        .\FSM_onehot_state_reg[0] (u_mem_n_86),
        .\FSM_onehot_state_reg[1] (u_mem_n_67),
        .\FSM_onehot_state_reg[2] (u_mem_n_65),
        .\FSM_onehot_state_reg[3] (u_mem_n_62),
        .\FSM_onehot_state_reg[3]_0 (u_mem_n_68),
        .\FSM_onehot_state_reg[3]_1 (u_mem_n_72),
        .\FSM_onehot_state_reg[4] (u_mem_n_61),
        .\FSM_onehot_state_reg[4]_0 (u_mem_n_69),
        .\FSM_onehot_state_reg[4]_1 (u_mem_n_87),
        .\FSM_onehot_state_reg[5] (u_mem_n_63),
        .\FSM_onehot_state_reg[5]_0 (u_mem_n_70),
        .O({u_inv_bf_n_0,u_inv_bf_n_1,u_inv_bf_n_2,u_inv_bf_n_3,u_inv_bf_n_4}),
        .Q(cmp_i_d1[7:6]),
        .S({u_mem_n_78,u_mem_n_79,u_mem_n_80,u_mem_n_81,u_mem_n_82,u_mem_n_83,u_mem_n_84,u_mem_n_85}),
        .T_r_reg_i_5(u_inv_bf_n_5),
        .WEA(u_inv_fsm_n_50),
        .WEBWE(u_fwd_fsm_n_43),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .\cmp_i_reg[4] (u_mem_n_64),
        .diff_carry__0(B),
        .diff_carry__0_0(u_mem_n_77),
        .ext_addr_IBUF({ext_addr_IBUF[7:6],ext_addr_IBUF[4:3],ext_addr_IBUF[1:0]}),
        .ext_addr_sel_IBUF(ext_addr_sel_IBUF),
        .ext_dout_OBUF(ext_dout_OBUF),
        .\ext_dout_OBUF[0]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_0),
        .\ext_dout_OBUF[0]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_0),
        .\ext_dout_OBUF[0]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_0),
        .\ext_dout_OBUF[0]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_0),
        .\ext_dout_OBUF[10]_inst_i_1_0 (orig_mem_reg_r1_192_255_7_11_n_3),
        .\ext_dout_OBUF[10]_inst_i_1_1 (orig_mem_reg_r1_128_191_7_11_n_3),
        .\ext_dout_OBUF[10]_inst_i_1_2 (orig_mem_reg_r1_64_127_7_11_n_3),
        .\ext_dout_OBUF[10]_inst_i_1_3 (orig_mem_reg_r1_0_63_7_11_n_3),
        .\ext_dout_OBUF[11]_inst_i_1_0 (orig_mem_reg_r1_192_255_7_11_n_4),
        .\ext_dout_OBUF[11]_inst_i_1_1 (orig_mem_reg_r1_128_191_7_11_n_4),
        .\ext_dout_OBUF[11]_inst_i_1_2 (orig_mem_reg_r1_64_127_7_11_n_4),
        .\ext_dout_OBUF[11]_inst_i_1_3 (orig_mem_reg_r1_0_63_7_11_n_4),
        .\ext_dout_OBUF[1]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_1),
        .\ext_dout_OBUF[1]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_1),
        .\ext_dout_OBUF[1]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_1),
        .\ext_dout_OBUF[1]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_1),
        .\ext_dout_OBUF[2]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_2),
        .\ext_dout_OBUF[2]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_2),
        .\ext_dout_OBUF[2]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_2),
        .\ext_dout_OBUF[2]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_2),
        .\ext_dout_OBUF[3]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_3),
        .\ext_dout_OBUF[3]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_3),
        .\ext_dout_OBUF[3]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_3),
        .\ext_dout_OBUF[3]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_3),
        .\ext_dout_OBUF[4]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_4),
        .\ext_dout_OBUF[4]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_4),
        .\ext_dout_OBUF[4]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_4),
        .\ext_dout_OBUF[4]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_4),
        .\ext_dout_OBUF[5]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_5),
        .\ext_dout_OBUF[5]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_5),
        .\ext_dout_OBUF[5]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_5),
        .\ext_dout_OBUF[5]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_5),
        .\ext_dout_OBUF[6]_inst_i_1_0 (orig_mem_reg_r1_192_255_0_6_n_6),
        .\ext_dout_OBUF[6]_inst_i_1_1 (orig_mem_reg_r1_128_191_0_6_n_6),
        .\ext_dout_OBUF[6]_inst_i_1_2 (orig_mem_reg_r1_64_127_0_6_n_6),
        .\ext_dout_OBUF[6]_inst_i_1_3 (orig_mem_reg_r1_0_63_0_6_n_6),
        .\ext_dout_OBUF[7]_inst_i_1_0 (orig_mem_reg_r1_192_255_7_11_n_0),
        .\ext_dout_OBUF[7]_inst_i_1_1 (orig_mem_reg_r1_128_191_7_11_n_0),
        .\ext_dout_OBUF[7]_inst_i_1_2 (orig_mem_reg_r1_64_127_7_11_n_0),
        .\ext_dout_OBUF[7]_inst_i_1_3 (orig_mem_reg_r1_0_63_7_11_n_0),
        .\ext_dout_OBUF[8]_inst_i_1_0 (orig_mem_reg_r1_192_255_7_11_n_1),
        .\ext_dout_OBUF[8]_inst_i_1_1 (orig_mem_reg_r1_128_191_7_11_n_1),
        .\ext_dout_OBUF[8]_inst_i_1_2 (orig_mem_reg_r1_64_127_7_11_n_1),
        .\ext_dout_OBUF[8]_inst_i_1_3 (orig_mem_reg_r1_0_63_7_11_n_1),
        .\ext_dout_OBUF[9]_inst_i_1_0 (orig_mem_reg_r1_192_255_7_11_n_2),
        .\ext_dout_OBUF[9]_inst_i_1_1 (orig_mem_reg_r1_128_191_7_11_n_2),
        .\ext_dout_OBUF[9]_inst_i_1_2 (orig_mem_reg_r1_64_127_7_11_n_2),
        .\ext_dout_OBUF[9]_inst_i_1_3 (orig_mem_reg_r1_0_63_7_11_n_2),
        .\load_i_reg[3] (u_mem_n_66),
        .\load_i_reg[6] (u_mem_n_71),
        .\load_i_reg[7] (u_mem_n_60),
        .load_val({load_val[10],load_val[8:6],load_val[4],load_val[0]}),
        .mem_reg_bram_0_0({u_mem_n_41,u_mem_n_42,u_mem_n_43,u_mem_n_44}),
        .mem_reg_bram_0_1({u_mem_n_45,u_mem_n_46,u_mem_n_47,u_mem_n_48,u_mem_n_49,u_mem_n_50}),
        .mem_reg_bram_0_10(u_load_mul_n_17),
        .mem_reg_bram_0_11(u_inv_fsm_n_35),
        .mem_reg_bram_0_12({u_scale_n_0,u_scale_n_1,u_scale_n_2,u_scale_n_3,u_scale_n_4,u_scale_n_5,u_scale_n_6,u_scale_n_7,u_scale_n_8,u_scale_n_9,u_scale_n_10,u_scale_n_11}),
        .mem_reg_bram_0_13(state__0),
        .mem_reg_bram_0_14(u_load_mul_n_16),
        .mem_reg_bram_0_15(u_load_mul_n_12),
        .mem_reg_bram_0_16(u_load_mul_n_13),
        .mem_reg_bram_0_17({u_fwd_bf_n_23,u_fwd_bf_n_24,u_fwd_bf_n_25,u_fwd_bf_n_26,u_fwd_bf_n_27,u_fwd_bf_n_28,u_fwd_bf_n_29}),
        .mem_reg_bram_0_2({u_mem_n_51,u_mem_n_52,u_mem_n_53,u_mem_n_54}),
        .mem_reg_bram_0_3({u_mem_n_55,u_mem_n_56,u_mem_n_57,u_mem_n_58,u_mem_n_59}),
        .mem_reg_bram_0_4(u_mem_n_88),
        .mem_reg_bram_0_5({done_OBUF,cmp_i_d1__0,\FSM_onehot_state_reg_n_0_[3] ,\FSM_onehot_state_reg_n_0_[2] ,orig_mem,\FSM_onehot_state_reg_n_0_[0] }),
        .mem_reg_bram_0_6({load_i[7:6],load_i[4:3],load_i[1:0]}),
        .mem_reg_bram_0_7(\cmp_i_reg_n_0_[4] ),
        .mem_reg_bram_0_8(u_load_mul_n_15),
        .mem_reg_bram_0_9(u_load_mul_n_14),
        .mem_reg_bram_0_i_146_0({b[11:10],b[8],b[6:0]}),
        .mem_reg_bram_0_i_153_0(u_fwd_bf_n_22),
        .mem_reg_bram_0_i_154_0(u_inv_bf_n_25),
        .mem_reg_bram_0_i_178_0({u_inv_bf_n_18,u_inv_bf_n_19,u_inv_bf_n_20,u_inv_bf_n_21,u_inv_bf_n_22,u_inv_bf_n_23,u_inv_bf_n_24}),
        .mismatch_i_3_0(orig_mem_reg_r2_192_255_0_6_n_3),
        .mismatch_i_3_1(orig_mem_reg_r2_128_191_0_6_n_3),
        .mismatch_i_3_10(orig_mem_reg_r2_64_127_0_6_n_5),
        .mismatch_i_3_11(orig_mem_reg_r2_0_63_0_6_n_5),
        .mismatch_i_3_2(orig_mem_reg_r2_64_127_0_6_n_3),
        .mismatch_i_3_3(orig_mem_reg_r2_0_63_0_6_n_3),
        .mismatch_i_3_4(orig_mem_reg_r2_192_255_0_6_n_4),
        .mismatch_i_3_5(orig_mem_reg_r2_128_191_0_6_n_4),
        .mismatch_i_3_6(orig_mem_reg_r2_64_127_0_6_n_4),
        .mismatch_i_3_7(orig_mem_reg_r2_0_63_0_6_n_4),
        .mismatch_i_3_8(orig_mem_reg_r2_192_255_0_6_n_5),
        .mismatch_i_3_9(orig_mem_reg_r2_128_191_0_6_n_5),
        .mismatch_i_4_0(orig_mem_reg_r2_192_255_0_6_n_0),
        .mismatch_i_4_1(orig_mem_reg_r2_128_191_0_6_n_0),
        .mismatch_i_4_10(orig_mem_reg_r2_64_127_0_6_n_2),
        .mismatch_i_4_11(orig_mem_reg_r2_0_63_0_6_n_2),
        .mismatch_i_4_2(orig_mem_reg_r2_64_127_0_6_n_0),
        .mismatch_i_4_3(orig_mem_reg_r2_0_63_0_6_n_0),
        .mismatch_i_4_4(orig_mem_reg_r2_192_255_0_6_n_1),
        .mismatch_i_4_5(orig_mem_reg_r2_128_191_0_6_n_1),
        .mismatch_i_4_6(orig_mem_reg_r2_64_127_0_6_n_1),
        .mismatch_i_4_7(orig_mem_reg_r2_0_63_0_6_n_1),
        .mismatch_i_4_8(orig_mem_reg_r2_192_255_0_6_n_2),
        .mismatch_i_4_9(orig_mem_reg_r2_128_191_0_6_n_2),
        .mismatch_i_5_0(orig_mem_reg_r2_192_255_7_11_n_2),
        .mismatch_i_5_1(orig_mem_reg_r2_128_191_7_11_n_2),
        .mismatch_i_5_10(orig_mem_reg_r2_64_127_7_11_n_4),
        .mismatch_i_5_11(orig_mem_reg_r2_0_63_7_11_n_4),
        .mismatch_i_5_2(orig_mem_reg_r2_64_127_7_11_n_2),
        .mismatch_i_5_3(orig_mem_reg_r2_0_63_7_11_n_2),
        .mismatch_i_5_4(orig_mem_reg_r2_192_255_7_11_n_3),
        .mismatch_i_5_5(orig_mem_reg_r2_128_191_7_11_n_3),
        .mismatch_i_5_6(orig_mem_reg_r2_64_127_7_11_n_3),
        .mismatch_i_5_7(orig_mem_reg_r2_0_63_7_11_n_3),
        .mismatch_i_5_8(orig_mem_reg_r2_192_255_7_11_n_4),
        .mismatch_i_5_9(orig_mem_reg_r2_128_191_7_11_n_4),
        .mismatch_i_6_0(orig_mem_reg_r2_192_255_0_6_n_6),
        .mismatch_i_6_1(orig_mem_reg_r2_128_191_0_6_n_6),
        .mismatch_i_6_10(orig_mem_reg_r2_64_127_7_11_n_1),
        .mismatch_i_6_11(orig_mem_reg_r2_0_63_7_11_n_1),
        .mismatch_i_6_2(orig_mem_reg_r2_64_127_0_6_n_6),
        .mismatch_i_6_3(orig_mem_reg_r2_0_63_0_6_n_6),
        .mismatch_i_6_4(orig_mem_reg_r2_192_255_7_11_n_0),
        .mismatch_i_6_5(orig_mem_reg_r2_128_191_7_11_n_0),
        .mismatch_i_6_6(orig_mem_reg_r2_64_127_7_11_n_0),
        .mismatch_i_6_7(orig_mem_reg_r2_0_63_7_11_n_0),
        .mismatch_i_6_8(orig_mem_reg_r2_192_255_7_11_n_1),
        .mismatch_i_6_9(orig_mem_reg_r2_128_191_7_11_n_1),
        .mismatch_reg(cmp_valid_d1_reg_n_0),
        .mismatch_reg_0(mismatch_reg_n_0),
        .start_i_IBUF(start_i_IBUF));
  mod_mult_1 u_scale
       (.DOUTBDOUT(mem_dout_a),
        .Q({u_scale_n_0,u_scale_n_1,u_scale_n_2,u_scale_n_3,u_scale_n_4,u_scale_n_5,u_scale_n_6,u_scale_n_7,u_scale_n_8,u_scale_n_9,u_scale_n_10,u_scale_n_11}),
        .clk_IBUF_BUFG(clk_IBUF_BUFG));
endmodule

module intt_butterfly
   (O,
    mem_reg_bram_0,
    Q,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    clk_IBUF_BUFG,
    DSP_ALU_INST,
    A,
    DI,
    S,
    T_r_reg_i_27,
    T_r_reg_i_27_0,
    DSP_A_B_DATA_INST,
    DOUTBDOUT,
    DOUTADOUT);
  output [4:0]O;
  output mem_reg_bram_0;
  output [11:0]Q;
  output [6:0]mem_reg_bram_0_0;
  output [0:0]mem_reg_bram_0_1;
  input clk_IBUF_BUFG;
  input [3:0]DSP_ALU_INST;
  input [11:0]A;
  input [7:0]DI;
  input [7:0]S;
  input [3:0]T_r_reg_i_27;
  input [4:0]T_r_reg_i_27_0;
  input DSP_A_B_DATA_INST;
  input [7:0]DOUTBDOUT;
  input [6:0]DOUTADOUT;

  wire [11:0]A;
  wire [7:1]B;
  wire [7:0]DI;
  wire [6:0]DOUTADOUT;
  wire [7:0]DOUTBDOUT;
  wire [3:0]DSP_ALU_INST;
  wire DSP_A_B_DATA_INST;
  wire [4:0]O;
  wire [11:0]Q;
  wire [7:0]S;
  wire [3:0]T_r_reg_i_27;
  wire [4:0]T_r_reg_i_27_0;
  wire clk_IBUF_BUFG;
  wire mem_reg_bram_0;
  wire [6:0]mem_reg_bram_0_0;
  wire [0:0]mem_reg_bram_0_1;
  wire u_sub_n_12;

  mod_add u_add
       (.DI(DI[0]),
        .DOUTADOUT(DOUTADOUT),
        .DOUTBDOUT(DOUTBDOUT),
        .mem_reg_bram_0(mem_reg_bram_0_0),
        .mem_reg_bram_0_0(mem_reg_bram_0_1));
  mod_mult_2 u_mult
       (.A(A),
        .B({DSP_ALU_INST,B,u_sub_n_12}),
        .Q(Q),
        .clk_IBUF_BUFG(clk_IBUF_BUFG));
  mod_sub u_sub
       (.B({B,u_sub_n_12}),
        .DI(DI),
        .DSP_A_B_DATA_INST(DSP_A_B_DATA_INST),
        .O(O),
        .S(S),
        .T_r_reg_i_27(T_r_reg_i_27),
        .T_r_reg_i_27_0(T_r_reg_i_27_0),
        .mem_reg_bram_0(mem_reg_bram_0));
endmodule

module intt_control_fsm
   (\k_r_reg_rep[0]_0 ,
    \k_r_reg_rep[0]_1 ,
    \k_r_reg_rep[0]_2 ,
    \k_r_reg_rep[0]_3 ,
    \k_r_reg_rep[0]_4 ,
    \k_r_reg_rep[0]_5 ,
    \k_r_reg_rep[0]_6 ,
    \k_r_reg_rep[0]_7 ,
    \k_r_reg_rep[0]_8 ,
    \k_r_reg_rep[0]_9 ,
    \k_r_reg_rep[0]_10 ,
    \k_r_reg_rep[0]_11 ,
    \k_r_reg_rep[0]_12 ,
    \k_r_reg_rep[0]_13 ,
    \k_r_reg_rep[0]_14 ,
    \k_r_reg_rep[0]_15 ,
    \k_r_reg_rep[0]_16 ,
    \k_r_reg_rep[0]_17 ,
    \k_r_reg_rep[0]_18 ,
    \k_r_reg_rep[0]_19 ,
    \k_r_reg_rep[0]_20 ,
    \k_r_reg_rep[0]_21 ,
    \k_r_reg_rep[0]_22 ,
    \k_r_reg_rep[0]_23 ,
    \load_phase_cnt_reg[0] ,
    E,
    \load_i_reg[6] ,
    ADDRBWRADDR,
    ADDRARDADDR,
    \FSM_sequential_state_reg[1]_0 ,
    \j_off_reg[0]_0 ,
    \FSM_sequential_state_reg[1]_1 ,
    \FSM_onehot_state_reg[3] ,
    \cmp_i_reg[4] ,
    \scale_i_reg[6]_0 ,
    \scale_i_reg[5]_0 ,
    \j_off_reg[1]_0 ,
    \scale_i_reg[2]_0 ,
    \scale_i_reg[3]_0 ,
    \scale_i_reg[4]_0 ,
    \len_r_reg[1]_0 ,
    \FSM_onehot_state_reg[4] ,
    \load_i_reg[3] ,
    WEA,
    \k_r_reg_rep[6]_0 ,
    Q,
    mem_reg_bram_0,
    \FSM_onehot_state_reg[5] ,
    \FSM_onehot_state_reg[5]_0 ,
    cmp_last_d1,
    cmp_valid_d1_reg,
    start_i_IBUF,
    \FSM_onehot_state[5]_i_2_0 ,
    \FSM_onehot_state[5]_i_2_1 ,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    mem_reg_bram_0_2,
    ext_addr_IBUF,
    mem_reg_bram_0_3,
    mem_reg_bram_0_4,
    mem_reg_bram_0_5,
    mem_reg_bram_0_6,
    mem_reg_bram_0_7,
    mem_reg_bram_0_8,
    mem_reg_bram_0_9,
    mem_reg_bram_0_10,
    mem_reg_bram_0_11,
    mem_reg_bram_0_12,
    mem_reg_bram_0_13,
    \phase_cnt_reg[0]_0 ,
    mem_reg_bram_0_14,
    rst_IBUF,
    mem_reg_bram_0_15,
    mem_reg_bram_0_16,
    \FSM_onehot_state[5]_i_2_2 ,
    clk_IBUF_BUFG);
  output \k_r_reg_rep[0]_0 ;
  output \k_r_reg_rep[0]_1 ;
  output \k_r_reg_rep[0]_2 ;
  output \k_r_reg_rep[0]_3 ;
  output \k_r_reg_rep[0]_4 ;
  output \k_r_reg_rep[0]_5 ;
  output \k_r_reg_rep[0]_6 ;
  output \k_r_reg_rep[0]_7 ;
  output \k_r_reg_rep[0]_8 ;
  output \k_r_reg_rep[0]_9 ;
  output \k_r_reg_rep[0]_10 ;
  output \k_r_reg_rep[0]_11 ;
  output \k_r_reg_rep[0]_12 ;
  output \k_r_reg_rep[0]_13 ;
  output \k_r_reg_rep[0]_14 ;
  output \k_r_reg_rep[0]_15 ;
  output \k_r_reg_rep[0]_16 ;
  output \k_r_reg_rep[0]_17 ;
  output \k_r_reg_rep[0]_18 ;
  output \k_r_reg_rep[0]_19 ;
  output \k_r_reg_rep[0]_20 ;
  output \k_r_reg_rep[0]_21 ;
  output \k_r_reg_rep[0]_22 ;
  output \k_r_reg_rep[0]_23 ;
  output \load_phase_cnt_reg[0] ;
  output [0:0]E;
  output \load_i_reg[6] ;
  output [1:0]ADDRBWRADDR;
  output [5:0]ADDRARDADDR;
  output \FSM_sequential_state_reg[1]_0 ;
  output [0:0]\j_off_reg[0]_0 ;
  output [1:0]\FSM_sequential_state_reg[1]_1 ;
  output [0:0]\FSM_onehot_state_reg[3] ;
  output \cmp_i_reg[4] ;
  output \scale_i_reg[6]_0 ;
  output \scale_i_reg[5]_0 ;
  output \j_off_reg[1]_0 ;
  output \scale_i_reg[2]_0 ;
  output \scale_i_reg[3]_0 ;
  output \scale_i_reg[4]_0 ;
  output \len_r_reg[1]_0 ;
  output \FSM_onehot_state_reg[4] ;
  output \load_i_reg[3] ;
  output [0:0]WEA;
  output [0:0]\k_r_reg_rep[6]_0 ;
  input [2:0]Q;
  input [3:0]mem_reg_bram_0;
  input \FSM_onehot_state_reg[5] ;
  input \FSM_onehot_state_reg[5]_0 ;
  input cmp_last_d1;
  input cmp_valid_d1_reg;
  input start_i_IBUF;
  input \FSM_onehot_state[5]_i_2_0 ;
  input [7:0]\FSM_onehot_state[5]_i_2_1 ;
  input [7:0]mem_reg_bram_0_0;
  input mem_reg_bram_0_1;
  input mem_reg_bram_0_2;
  input [1:0]ext_addr_IBUF;
  input mem_reg_bram_0_3;
  input mem_reg_bram_0_4;
  input mem_reg_bram_0_5;
  input mem_reg_bram_0_6;
  input mem_reg_bram_0_7;
  input mem_reg_bram_0_8;
  input mem_reg_bram_0_9;
  input mem_reg_bram_0_10;
  input mem_reg_bram_0_11;
  input mem_reg_bram_0_12;
  input [0:0]mem_reg_bram_0_13;
  input \phase_cnt_reg[0]_0 ;
  input mem_reg_bram_0_14;
  input rst_IBUF;
  input mem_reg_bram_0_15;
  input mem_reg_bram_0_16;
  input [0:0]\FSM_onehot_state[5]_i_2_2 ;
  input clk_IBUF_BUFG;

  wire [5:0]ADDRARDADDR;
  wire [1:0]ADDRBWRADDR;
  wire [0:0]E;
  wire \FSM_onehot_state[5]_i_2_0 ;
  wire [7:0]\FSM_onehot_state[5]_i_2_1 ;
  wire [0:0]\FSM_onehot_state[5]_i_2_2 ;
  wire \FSM_onehot_state[5]_i_2_n_0 ;
  wire \FSM_onehot_state[5]_i_3_n_0 ;
  wire \FSM_onehot_state[5]_i_4_n_0 ;
  wire [0:0]\FSM_onehot_state_reg[3] ;
  wire \FSM_onehot_state_reg[4] ;
  wire \FSM_onehot_state_reg[5] ;
  wire \FSM_onehot_state_reg[5]_0 ;
  wire \FSM_sequential_state[1]_i_1_n_0 ;
  wire \FSM_sequential_state[1]_i_2_n_0 ;
  wire \FSM_sequential_state[1]_i_3_n_0 ;
  wire \FSM_sequential_state[1]_i_4_n_0 ;
  wire \FSM_sequential_state_reg[1]_0 ;
  wire [1:0]\FSM_sequential_state_reg[1]_1 ;
  wire [2:0]Q;
  wire [0:0]WEA;
  wire clk_IBUF_BUFG;
  wire \cmp_i[7]_i_3_n_0 ;
  wire \cmp_i_reg[4] ;
  wire cmp_last_d1;
  wire cmp_valid_d1_reg;
  wire [1:0]ext_addr_IBUF;
  wire [7:2]in9;
  wire [7:0]j_off;
  wire \j_off[4]_i_2_n_0 ;
  wire \j_off[5]_i_2__0_n_0 ;
  wire \j_off[7]_i_1__0_n_0 ;
  wire \j_off[7]_i_3__0_n_0 ;
  wire \j_off[7]_i_4__0_n_0 ;
  wire \j_off[7]_i_5_n_0 ;
  wire \j_off[7]_i_6_n_0 ;
  wire \j_off[7]_i_7_n_0 ;
  wire \j_off[7]_i_8_n_0 ;
  wire \j_off[7]_i_9_n_0 ;
  wire [0:0]\j_off_reg[0]_0 ;
  wire \j_off_reg[1]_0 ;
  wire \j_off_reg_n_0_[1] ;
  wire \j_off_reg_n_0_[2] ;
  wire \j_off_reg_n_0_[3] ;
  wire \j_off_reg_n_0_[4] ;
  wire \j_off_reg_n_0_[5] ;
  wire \j_off_reg_n_0_[6] ;
  wire \j_off_reg_n_0_[7] ;
  wire [6:0]k_r;
  wire \k_r[4]_i_2_n_0 ;
  wire \k_r[6]_i_2_n_0 ;
  wire \k_r_reg_n_0_[0] ;
  wire \k_r_reg_n_0_[1] ;
  wire \k_r_reg_n_0_[2] ;
  wire \k_r_reg_n_0_[3] ;
  wire \k_r_reg_n_0_[4] ;
  wire \k_r_reg_n_0_[5] ;
  wire \k_r_reg_n_0_[6] ;
  wire \k_r_reg_rep[0]_0 ;
  wire \k_r_reg_rep[0]_1 ;
  wire \k_r_reg_rep[0]_10 ;
  wire \k_r_reg_rep[0]_11 ;
  wire \k_r_reg_rep[0]_12 ;
  wire \k_r_reg_rep[0]_13 ;
  wire \k_r_reg_rep[0]_14 ;
  wire \k_r_reg_rep[0]_15 ;
  wire \k_r_reg_rep[0]_16 ;
  wire \k_r_reg_rep[0]_17 ;
  wire \k_r_reg_rep[0]_18 ;
  wire \k_r_reg_rep[0]_19 ;
  wire \k_r_reg_rep[0]_2 ;
  wire \k_r_reg_rep[0]_20 ;
  wire \k_r_reg_rep[0]_21 ;
  wire \k_r_reg_rep[0]_22 ;
  wire \k_r_reg_rep[0]_23 ;
  wire \k_r_reg_rep[0]_3 ;
  wire \k_r_reg_rep[0]_4 ;
  wire \k_r_reg_rep[0]_5 ;
  wire \k_r_reg_rep[0]_6 ;
  wire \k_r_reg_rep[0]_7 ;
  wire \k_r_reg_rep[0]_8 ;
  wire \k_r_reg_rep[0]_9 ;
  wire [0:0]\k_r_reg_rep[6]_0 ;
  wire \k_r_reg_rep_n_0_[0] ;
  wire \k_r_reg_rep_n_0_[1] ;
  wire \k_r_reg_rep_n_0_[2] ;
  wire \k_r_reg_rep_n_0_[3] ;
  wire \k_r_reg_rep_n_0_[4] ;
  wire \k_r_reg_rep_n_0_[5] ;
  wire [2:0]layer;
  wire \layer[1]_i_1__0_n_0 ;
  wire \layer[2]_i_1__0_n_0 ;
  wire \layer[2]_i_3__0_n_0 ;
  wire \layer[2]_i_4__0_n_0 ;
  wire \layer[2]_i_5_n_0 ;
  wire \layer_reg_n_0_[0] ;
  wire \layer_reg_n_0_[1] ;
  wire \layer_reg_n_0_[2] ;
  wire [7:2]len_r;
  wire \len_r_reg[1]_0 ;
  wire \len_r_reg_n_0_[7] ;
  wire \load_i_reg[3] ;
  wire \load_i_reg[6] ;
  wire \load_phase_cnt_reg[0] ;
  wire [3:0]mem_reg_bram_0;
  wire [7:0]mem_reg_bram_0_0;
  wire mem_reg_bram_0_1;
  wire mem_reg_bram_0_10;
  wire mem_reg_bram_0_11;
  wire mem_reg_bram_0_12;
  wire [0:0]mem_reg_bram_0_13;
  wire mem_reg_bram_0_14;
  wire mem_reg_bram_0_15;
  wire mem_reg_bram_0_16;
  wire mem_reg_bram_0_2;
  wire mem_reg_bram_0_3;
  wire mem_reg_bram_0_4;
  wire mem_reg_bram_0_5;
  wire mem_reg_bram_0_6;
  wire mem_reg_bram_0_7;
  wire mem_reg_bram_0_8;
  wire mem_reg_bram_0_9;
  wire mem_reg_bram_0_i_118_n_0;
  wire mem_reg_bram_0_i_120_n_0;
  wire mem_reg_bram_0_i_124_n_0;
  wire mem_reg_bram_0_i_126_n_0;
  wire mem_reg_bram_0_i_128_n_0;
  wire mem_reg_bram_0_i_180_n_0;
  wire mem_reg_bram_0_i_181_n_0;
  wire mem_reg_bram_0_i_182_n_0;
  wire mem_reg_bram_0_i_44_n_0;
  wire mem_reg_bram_0_i_48_n_0;
  wire mem_reg_bram_0_i_49_n_0;
  wire mem_reg_bram_0_i_50_n_0;
  wire mem_reg_bram_0_i_52_n_0;
  wire mem_reg_bram_0_i_53_n_0;
  wire mem_reg_bram_0_i_56_n_0;
  wire mem_reg_bram_0_i_57_n_0;
  wire mem_reg_bram_0_i_58_n_0;
  wire mem_reg_bram_0_i_64_n_0;
  wire mem_reg_bram_0_i_70_n_0;
  wire mem_reg_bram_0_i_82_n_0;
  wire [2:1]phase_cnt;
  wire \phase_cnt[0]_i_1__0_n_0 ;
  wire \phase_cnt[2]_i_1__0_n_0 ;
  wire \phase_cnt_reg[0]_0 ;
  wire \phase_cnt_reg_n_0_[0] ;
  wire \phase_cnt_reg_n_0_[1] ;
  wire \phase_cnt_reg_n_0_[2] ;
  wire rst_IBUF;
  wire [3:0]scale_i;
  wire \scale_i[2]_i_1_n_0 ;
  wire \scale_i[4]_i_1_n_0 ;
  wire \scale_i[5]_i_1_n_0 ;
  wire \scale_i[5]_i_2_n_0 ;
  wire \scale_i[6]_i_1_n_0 ;
  wire \scale_i[7]_i_1_n_0 ;
  wire \scale_i[7]_i_2_n_0 ;
  wire \scale_i[7]_i_3_n_0 ;
  wire \scale_i_reg[2]_0 ;
  wire \scale_i_reg[3]_0 ;
  wire \scale_i_reg[4]_0 ;
  wire \scale_i_reg[5]_0 ;
  wire \scale_i_reg[6]_0 ;
  wire \scale_i_reg_n_0_[0] ;
  wire \scale_i_reg_n_0_[1] ;
  wire \scale_i_reg_n_0_[2] ;
  wire \scale_i_reg_n_0_[3] ;
  wire \scale_i_reg_n_0_[4] ;
  wire \scale_i_reg_n_0_[5] ;
  wire \scale_i_reg_n_0_[6] ;
  wire \scale_i_reg_n_0_[7] ;
  wire start_i_IBUF;
  wire [7:2]start_r;
  wire \start_r[4]_i_2__0_n_0 ;
  wire \start_r[5]_i_2__0_n_0 ;
  wire \start_r[6]_i_2__0_n_0 ;
  wire \start_r[7]_i_1__0_n_0 ;
  wire \start_r[7]_i_3__0_n_0 ;
  wire \start_r[7]_i_4_n_0 ;
  wire \start_r[7]_i_5_n_0 ;
  wire \start_r_reg_n_0_[2] ;
  wire \start_r_reg_n_0_[3] ;
  wire \start_r_reg_n_0_[4] ;
  wire \start_r_reg_n_0_[5] ;
  wire \start_r_reg_n_0_[6] ;
  wire \start_r_reg_n_0_[7] ;
  wire [0:0]state__1;

  LUT6 #(
    .INIT(64'h00000000FFEFEFEF)) 
    \FSM_onehot_state[5]_i_1 
       (.I0(\FSM_onehot_state_reg[5] ),
        .I1(mem_reg_bram_0[0]),
        .I2(\FSM_onehot_state_reg[5]_0 ),
        .I3(cmp_last_d1),
        .I4(cmp_valid_d1_reg),
        .I5(\FSM_onehot_state[5]_i_2_n_0 ),
        .O(E));
  LUT6 #(
    .INIT(64'h00000000DF000000)) 
    \FSM_onehot_state[5]_i_2 
       (.I0(\FSM_onehot_state_reg[5]_0 ),
        .I1(mem_reg_bram_0[0]),
        .I2(start_i_IBUF),
        .I3(\FSM_onehot_state_reg[5] ),
        .I4(\FSM_onehot_state[5]_i_3_n_0 ),
        .I5(\FSM_onehot_state[5]_i_4_n_0 ),
        .O(\FSM_onehot_state[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h1111FFF1FFFFFFF1)) 
    \FSM_onehot_state[5]_i_3 
       (.I0(mem_reg_bram_0[1]),
        .I1(mem_reg_bram_0[0]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(\FSM_onehot_state[5]_i_2_2 ),
        .O(\FSM_onehot_state[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \FSM_onehot_state[5]_i_4 
       (.I0(\load_i_reg[6] ),
        .I1(\FSM_onehot_state[5]_i_2_0 ),
        .I2(\FSM_onehot_state[5]_i_2_1 [7]),
        .I3(Q[0]),
        .I4(Q[2]),
        .I5(Q[1]),
        .O(\FSM_onehot_state[5]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .O(state__1));
  LUT6 #(
    .INIT(64'hAFEFAAEFAAEFAAEF)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(\FSM_sequential_state[1]_i_2_n_0 ),
        .I1(\phase_cnt_reg[0]_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .I4(\FSM_sequential_state[1]_i_3_n_0 ),
        .I5(\FSM_sequential_state[1]_i_4_n_0 ),
        .O(\FSM_sequential_state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h00000080)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(\layer[2]_i_5_n_0 ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\layer_reg_n_0_[2] ),
        .I3(\layer_reg_n_0_[0] ),
        .I4(\start_r[7]_i_3__0_n_0 ),
        .O(\FSM_sequential_state[1]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \FSM_sequential_state[1]_i_3 
       (.I0(\scale_i_reg_n_0_[6] ),
        .I1(\scale_i[7]_i_3_n_0 ),
        .I2(\scale_i_reg_n_0_[7] ),
        .O(\FSM_sequential_state[1]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \FSM_sequential_state[1]_i_4 
       (.I0(\phase_cnt_reg_n_0_[1] ),
        .I1(\phase_cnt_reg_n_0_[2] ),
        .I2(\phase_cnt_reg_n_0_[0] ),
        .O(\FSM_sequential_state[1]_i_4_n_0 ));
  (* FSM_ENCODED_STATES = "S_IDLE:01,S_BFLY:11,S_SCALE:10,S_DONE:00" *) 
  FDSE \FSM_sequential_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_sequential_state[1]_i_1_n_0 ),
        .D(state__1),
        .Q(\FSM_sequential_state_reg[1]_1 [0]),
        .S(rst_IBUF));
  (* FSM_ENCODED_STATES = "S_IDLE:01,S_BFLY:11,S_SCALE:10,S_DONE:00" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_sequential_state[1]_i_1_n_0 ),
        .D(\FSM_sequential_state_reg[1]_1 [0]),
        .Q(\FSM_sequential_state_reg[1]_1 [1]),
        .R(rst_IBUF));
  LUT6 #(
    .INIT(64'h8FFFFFFF88888888)) 
    \cmp_i[7]_i_1 
       (.I0(\cmp_i[7]_i_3_n_0 ),
        .I1(mem_reg_bram_0[1]),
        .I2(mem_reg_bram_0_0[6]),
        .I3(\cmp_i_reg[4] ),
        .I4(mem_reg_bram_0_0[7]),
        .I5(mem_reg_bram_0[2]),
        .O(\FSM_onehot_state_reg[3] ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cmp_i[7]_i_3 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\FSM_sequential_state_reg[1]_1 [0]),
        .O(\cmp_i[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \cmp_i[7]_i_4 
       (.I0(mem_reg_bram_0_0[4]),
        .I1(mem_reg_bram_0_0[2]),
        .I2(mem_reg_bram_0_0[1]),
        .I3(mem_reg_bram_0_0[0]),
        .I4(mem_reg_bram_0_0[3]),
        .I5(mem_reg_bram_0_0[5]),
        .O(\cmp_i_reg[4] ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT5 #(
    .INIT(32'hFEFFAAAA)) 
    cmp_valid_d1_i_1
       (.I0(mem_reg_bram_0[2]),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(mem_reg_bram_0[1]),
        .I4(cmp_valid_d1_reg),
        .O(\FSM_onehot_state_reg[4] ));
  LUT6 #(
    .INIT(64'h4707B6D7B4864E4A)) 
    g0_b0__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_0 ));
  LUT6 #(
    .INIT(64'h6452C21C418CA34A)) 
    g0_b10__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_10 ));
  LUT6 #(
    .INIT(64'h33A114E43A52301C)) 
    g0_b11__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_11 ));
  LUT6 #(
    .INIT(64'hF1D781826F169330)) 
    g0_b1__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_1 ));
  LUT6 #(
    .INIT(64'hA17D00DCE69A2B24)) 
    g0_b2__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_2 ));
  LUT6 #(
    .INIT(64'hDE53CB1A32276A48)) 
    g0_b3__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_3 ));
  LUT6 #(
    .INIT(64'h03729E0CF5A4EABC)) 
    g0_b4__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_4 ));
  LUT6 #(
    .INIT(64'h32E4FA55E2B57360)) 
    g0_b5__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_5 ));
  LUT6 #(
    .INIT(64'h45C88C4A185896FA)) 
    g0_b6__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_6 ));
  LUT6 #(
    .INIT(64'hDC5A075C415AB40A)) 
    g0_b7__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_7 ));
  LUT6 #(
    .INIT(64'h94FFD623F99F0AC0)) 
    g0_b8__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_8 ));
  LUT6 #(
    .INIT(64'h8B249B08EC10DAF6)) 
    g0_b9__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_9 ));
  LUT6 #(
    .INIT(64'h68543FB4B5DF4D3F)) 
    g1_b0__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_12 ));
  LUT6 #(
    .INIT(64'h0F1A018D005B0590)) 
    g1_b10__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_22 ));
  LUT6 #(
    .INIT(64'hB061D46A2E84E64A)) 
    g1_b11__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_23 ));
  LUT6 #(
    .INIT(64'hB5FCD3520193C224)) 
    g1_b1__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_13 ));
  LUT6 #(
    .INIT(64'h7AF30FBC5EDD7294)) 
    g1_b2__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_14 ));
  LUT6 #(
    .INIT(64'h930002C251A8A88A)) 
    g1_b3__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_15 ));
  LUT6 #(
    .INIT(64'h77D53E3F18FA1469)) 
    g1_b4__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_16 ));
  LUT6 #(
    .INIT(64'hF3B1FBF721FFBA50)) 
    g1_b5__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_17 ));
  LUT6 #(
    .INIT(64'hE4F30CB6188EFEFE)) 
    g1_b6__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_18 ));
  LUT6 #(
    .INIT(64'h03454C2E956DDD62)) 
    g1_b7__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_19 ));
  LUT6 #(
    .INIT(64'h648442346F70C100)) 
    g1_b8__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_20 ));
  LUT6 #(
    .INIT(64'h65C1AC8591BFD23E)) 
    g1_b9__0
       (.I0(\k_r_reg_rep_n_0_[0] ),
        .I1(\k_r_reg_rep_n_0_[1] ),
        .I2(\k_r_reg_rep_n_0_[2] ),
        .I3(\k_r_reg_rep_n_0_[3] ),
        .I4(\k_r_reg_rep_n_0_[4] ),
        .I5(\k_r_reg_rep_n_0_[5] ),
        .O(\k_r_reg_rep[0]_21 ));
  LUT2 #(
    .INIT(4'h2)) 
    \j_off[0]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\j_off_reg[0]_0 ),
        .O(j_off[0]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \j_off[1]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\j_off_reg[0]_0 ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .O(j_off[1]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h08808080)) 
    \j_off[2]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\j_off_reg_n_0_[2] ),
        .I3(\j_off_reg_n_0_[1] ),
        .I4(\j_off_reg[0]_0 ),
        .O(j_off[2]));
  LUT6 #(
    .INIT(64'h0880808080808080)) 
    \j_off[3]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\j_off_reg_n_0_[3] ),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\j_off_reg[0]_0 ),
        .I5(\j_off_reg_n_0_[1] ),
        .O(j_off[3]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT4 #(
    .INIT(16'h0880)) 
    \j_off[4]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\j_off_reg_n_0_[4] ),
        .I3(\j_off[4]_i_2_n_0 ),
        .O(j_off[4]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \j_off[4]_i_2 
       (.I0(\j_off_reg_n_0_[2] ),
        .I1(\j_off_reg[0]_0 ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\j_off_reg_n_0_[3] ),
        .O(\j_off[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT4 #(
    .INIT(16'h0880)) 
    \j_off[5]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\j_off_reg_n_0_[5] ),
        .I3(\j_off[5]_i_2__0_n_0 ),
        .O(j_off[5]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \j_off[5]_i_2__0 
       (.I0(\j_off_reg_n_0_[3] ),
        .I1(\j_off_reg_n_0_[1] ),
        .I2(\j_off_reg[0]_0 ),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[4] ),
        .O(\j_off[5]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h0880)) 
    \j_off[6]_i_1__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\j_off_reg_n_0_[6] ),
        .I3(\j_off[7]_i_4__0_n_0 ),
        .O(j_off[6]));
  LUT6 #(
    .INIT(64'h0000C00088888888)) 
    \j_off[7]_i_1__0 
       (.I0(\phase_cnt_reg[0]_0 ),
        .I1(\FSM_sequential_state_reg[1]_1 [0]),
        .I2(\phase_cnt_reg_n_0_[1] ),
        .I3(\phase_cnt_reg_n_0_[2] ),
        .I4(\phase_cnt_reg_n_0_[0] ),
        .I5(\FSM_sequential_state_reg[1]_1 [1]),
        .O(\j_off[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h28880000)) 
    \j_off[7]_i_2__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\j_off_reg_n_0_[7] ),
        .I2(\j_off[7]_i_4__0_n_0 ),
        .I3(\j_off_reg_n_0_[6] ),
        .I4(\FSM_sequential_state_reg[1]_1 [1]),
        .O(j_off[7]));
  LUT6 #(
    .INIT(64'hDFFD7FF7F77FDFFD)) 
    \j_off[7]_i_3__0 
       (.I0(\j_off[7]_i_5_n_0 ),
        .I1(\j_off[7]_i_6_n_0 ),
        .I2(\j_off_reg_n_0_[7] ),
        .I3(\len_r_reg_n_0_[7] ),
        .I4(\j_off_reg_n_0_[6] ),
        .I5(in9[7]),
        .O(\j_off[7]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \j_off[7]_i_4__0 
       (.I0(\j_off_reg_n_0_[4] ),
        .I1(\j_off_reg_n_0_[2] ),
        .I2(\j_off_reg[0]_0 ),
        .I3(\j_off_reg_n_0_[1] ),
        .I4(\j_off_reg_n_0_[3] ),
        .I5(\j_off_reg_n_0_[5] ),
        .O(\j_off[7]_i_4__0_n_0 ));
  LUT6 #(
    .INIT(64'h0000800808800000)) 
    \j_off[7]_i_5 
       (.I0(\j_off[7]_i_7_n_0 ),
        .I1(\j_off_reg[0]_0 ),
        .I2(in9[3]),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[1] ),
        .I5(in9[2]),
        .O(\j_off[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \j_off[7]_i_6 
       (.I0(in9[5]),
        .I1(in9[2]),
        .I2(in9[3]),
        .I3(in9[4]),
        .I4(in9[6]),
        .O(\j_off[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0024090009000009)) 
    \j_off[7]_i_7 
       (.I0(\j_off_reg_n_0_[4] ),
        .I1(in9[5]),
        .I2(\j_off[7]_i_8_n_0 ),
        .I3(in9[4]),
        .I4(\j_off[7]_i_9_n_0 ),
        .I5(\j_off_reg_n_0_[3] ),
        .O(\j_off[7]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \j_off[7]_i_8 
       (.I0(\j_off_reg_n_0_[5] ),
        .I1(in9[6]),
        .O(\j_off[7]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \j_off[7]_i_9 
       (.I0(in9[3]),
        .I1(in9[2]),
        .O(\j_off[7]_i_9_n_0 ));
  FDRE \j_off_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[0]),
        .Q(\j_off_reg[0]_0 ),
        .R(rst_IBUF));
  FDRE \j_off_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[1]),
        .Q(\j_off_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[2]),
        .Q(\j_off_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[3]),
        .Q(\j_off_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[4]),
        .Q(\j_off_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[5]),
        .Q(\j_off_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[6]),
        .Q(\j_off_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \j_off_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\j_off[7]_i_1__0_n_0 ),
        .D(j_off[7]),
        .Q(\j_off_reg_n_0_[7] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h3A)) 
    \k_r[0]_i_1__0 
       (.I0(\phase_cnt_reg[0]_0 ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .O(k_r[0]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'hC3AA)) 
    \k_r[1]_i_1 
       (.I0(\phase_cnt_reg[0]_0 ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\k_r_reg_n_0_[1] ),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .O(k_r[1]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'hA9FFA900)) 
    \k_r[2]_i_1__0 
       (.I0(\k_r_reg_n_0_[2] ),
        .I1(\k_r_reg_n_0_[1] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .I4(\phase_cnt_reg[0]_0 ),
        .O(k_r[2]));
  LUT6 #(
    .INIT(64'hAAA9FFFFAAA90000)) 
    \k_r[3]_i_1__0 
       (.I0(\k_r_reg_n_0_[3] ),
        .I1(\k_r_reg_n_0_[2] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\k_r_reg_n_0_[1] ),
        .I4(\FSM_sequential_state_reg[1]_1 [1]),
        .I5(\phase_cnt_reg[0]_0 ),
        .O(k_r[3]));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT4 #(
    .INIT(16'h6F60)) 
    \k_r[4]_i_1__0 
       (.I0(\k_r_reg_n_0_[4] ),
        .I1(\k_r[4]_i_2_n_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .I3(\phase_cnt_reg[0]_0 ),
        .O(k_r[4]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \k_r[4]_i_2 
       (.I0(\k_r_reg_n_0_[2] ),
        .I1(\k_r_reg_n_0_[0] ),
        .I2(\k_r_reg_n_0_[1] ),
        .I3(\k_r_reg_n_0_[3] ),
        .O(\k_r[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'h6F60)) 
    \k_r[5]_i_1 
       (.I0(\k_r_reg_n_0_[5] ),
        .I1(\k_r[6]_i_2_n_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .I3(\phase_cnt_reg[0]_0 ),
        .O(k_r[5]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT5 #(
    .INIT(32'h9AFF9A00)) 
    \k_r[6]_i_1__0 
       (.I0(\k_r_reg_n_0_[6] ),
        .I1(\k_r_reg_n_0_[5] ),
        .I2(\k_r[6]_i_2_n_0 ),
        .I3(\FSM_sequential_state_reg[1]_1 [1]),
        .I4(\phase_cnt_reg[0]_0 ),
        .O(k_r[6]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \k_r[6]_i_2 
       (.I0(\k_r_reg_n_0_[3] ),
        .I1(\k_r_reg_n_0_[1] ),
        .I2(\k_r_reg_n_0_[0] ),
        .I3(\k_r_reg_n_0_[2] ),
        .I4(\k_r_reg_n_0_[4] ),
        .O(\k_r[6]_i_2_n_0 ));
  FDSE \k_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[0]),
        .Q(\k_r_reg_n_0_[0] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[1]),
        .Q(\k_r_reg_n_0_[1] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[2]),
        .Q(\k_r_reg_n_0_[2] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[3]),
        .Q(\k_r_reg_n_0_[3] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[4]),
        .Q(\k_r_reg_n_0_[4] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[5]),
        .Q(\k_r_reg_n_0_[5] ),
        .S(rst_IBUF));
  FDSE \k_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[6]),
        .Q(\k_r_reg_n_0_[6] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[0]),
        .Q(\k_r_reg_rep_n_0_[0] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[1]),
        .Q(\k_r_reg_rep_n_0_[1] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[2]),
        .Q(\k_r_reg_rep_n_0_[2] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[3]),
        .Q(\k_r_reg_rep_n_0_[3] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[4]),
        .Q(\k_r_reg_rep_n_0_[4] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[5]),
        .Q(\k_r_reg_rep_n_0_[5] ),
        .S(rst_IBUF));
  (* equivalent_register_removal = "no" *) 
  FDSE \k_r_reg_rep[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(k_r[6]),
        .Q(\k_r_reg_rep[6]_0 ),
        .S(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \layer[0]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\layer_reg_n_0_[0] ),
        .O(layer[0]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \layer[1]_i_1__0 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .O(\layer[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h080808AA08080808)) 
    \layer[2]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\phase_cnt_reg[0]_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .I3(\layer[2]_i_3__0_n_0 ),
        .I4(\layer[2]_i_4__0_n_0 ),
        .I5(\layer[2]_i_5_n_0 ),
        .O(\layer[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \layer[2]_i_2__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\layer_reg_n_0_[1] ),
        .I2(\layer_reg_n_0_[0] ),
        .I3(\layer_reg_n_0_[2] ),
        .O(layer[2]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hFFBFFFFF)) 
    \layer[2]_i_3__0 
       (.I0(\j_off[7]_i_3__0_n_0 ),
        .I1(\phase_cnt_reg_n_0_[1] ),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[0] ),
        .I4(\FSM_sequential_state_reg[1]_1 [1]),
        .O(\layer[2]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \layer[2]_i_4__0 
       (.I0(\layer_reg_n_0_[1] ),
        .I1(\layer_reg_n_0_[2] ),
        .I2(\layer_reg_n_0_[0] ),
        .O(\layer[2]_i_4__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h65A6)) 
    \layer[2]_i_5 
       (.I0(\len_r_reg_n_0_[7] ),
        .I1(\start_r_reg_n_0_[7] ),
        .I2(\start_r[7]_i_5_n_0 ),
        .I3(in9[7]),
        .O(\layer[2]_i_5_n_0 ));
  FDRE \layer_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(layer[0]),
        .Q(\layer_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \layer_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(\layer[1]_i_1__0_n_0 ),
        .Q(\layer_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \layer_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(layer[2]),
        .Q(\layer_reg_n_0_[2] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[2]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[2]),
        .O(len_r[2]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[3]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[3]),
        .O(len_r[3]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[4]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[4]),
        .O(len_r[4]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[5]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[5]),
        .O(len_r[5]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[6]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[6]),
        .O(len_r[6]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \len_r[7]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[7]),
        .O(len_r[7]));
  FDSE \len_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(state__1),
        .Q(in9[2]),
        .S(rst_IBUF));
  FDRE \len_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[2]),
        .Q(in9[3]),
        .R(rst_IBUF));
  FDRE \len_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[3]),
        .Q(in9[4]),
        .R(rst_IBUF));
  FDRE \len_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[4]),
        .Q(in9[5]),
        .R(rst_IBUF));
  FDRE \len_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[5]),
        .Q(in9[6]),
        .R(rst_IBUF));
  FDRE \len_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[6]),
        .Q(in9[7]),
        .R(rst_IBUF));
  FDRE \len_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\layer[2]_i_1__0_n_0 ),
        .D(len_r[7]),
        .Q(\len_r_reg_n_0_[7] ),
        .R(rst_IBUF));
  LUT2 #(
    .INIT(4'h8)) 
    \load_i[7]_i_4 
       (.I0(\load_i_reg[3] ),
        .I1(\FSM_onehot_state[5]_i_2_1 [6]),
        .O(\load_i_reg[6] ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \load_i[7]_i_5 
       (.I0(\FSM_onehot_state[5]_i_2_1 [3]),
        .I1(\FSM_onehot_state[5]_i_2_1 [2]),
        .I2(\FSM_onehot_state[5]_i_2_1 [0]),
        .I3(\FSM_onehot_state[5]_i_2_1 [1]),
        .I4(\FSM_onehot_state[5]_i_2_1 [4]),
        .I5(\FSM_onehot_state[5]_i_2_1 [5]),
        .O(\load_i_reg[3] ));
  LUT6 #(
    .INIT(64'h0000000101010001)) 
    mem_reg_bram_0_i_1
       (.I0(mem_reg_bram_0_5),
        .I1(mem_reg_bram_0[2]),
        .I2(mem_reg_bram_0[3]),
        .I3(mem_reg_bram_0_i_44_n_0),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(mem_reg_bram_0_12),
        .O(ADDRARDADDR[5]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'hDFFF)) 
    mem_reg_bram_0_i_118
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\phase_cnt_reg_n_0_[0] ),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .O(mem_reg_bram_0_i_118_n_0));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAFF3F)) 
    mem_reg_bram_0_i_119
       (.I0(mem_reg_bram_0_i_118_n_0),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[1]),
        .I4(mem_reg_bram_0[0]),
        .I5(mem_reg_bram_0[1]),
        .O(\load_phase_cnt_reg[0] ));
  LUT6 #(
    .INIT(64'hE81717E817E8E817)) 
    mem_reg_bram_0_i_120
       (.I0(in9[7]),
        .I1(\j_off_reg_n_0_[6] ),
        .I2(\start_r_reg_n_0_[6] ),
        .I3(\start_r_reg_n_0_[7] ),
        .I4(\j_off_reg_n_0_[7] ),
        .I5(\len_r_reg_n_0_[7] ),
        .O(mem_reg_bram_0_i_120_n_0));
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_124
       (.I0(\j_off_reg_n_0_[4] ),
        .I1(in9[5]),
        .I2(\start_r_reg_n_0_[4] ),
        .O(mem_reg_bram_0_i_124_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_126
       (.I0(\start_r_reg_n_0_[3] ),
        .I1(in9[4]),
        .I2(\j_off_reg_n_0_[3] ),
        .O(mem_reg_bram_0_i_126_n_0));
  LUT5 #(
    .INIT(32'h69996669)) 
    mem_reg_bram_0_i_128
       (.I0(\j_off_reg_n_0_[7] ),
        .I1(\start_r_reg_n_0_[7] ),
        .I2(\start_r_reg_n_0_[6] ),
        .I3(\j_off_reg_n_0_[6] ),
        .I4(mem_reg_bram_0_i_180_n_0),
        .O(mem_reg_bram_0_i_128_n_0));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT2 #(
    .INIT(4'h2)) 
    mem_reg_bram_0_i_129
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\FSM_sequential_state_reg[1]_1 [0]),
        .O(\FSM_sequential_state_reg[1]_0 ));
  LUT6 #(
    .INIT(64'hF70404F704F7F704)) 
    mem_reg_bram_0_i_131
       (.I0(\scale_i_reg_n_0_[6] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(mem_reg_bram_0_i_180_n_0),
        .I4(\j_off_reg_n_0_[6] ),
        .I5(\start_r_reg_n_0_[6] ),
        .O(\scale_i_reg[6]_0 ));
  LUT6 #(
    .INIT(64'hF70404F704F7F704)) 
    mem_reg_bram_0_i_134
       (.I0(\scale_i_reg_n_0_[5] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(mem_reg_bram_0_i_181_n_0),
        .I4(\j_off_reg_n_0_[5] ),
        .I5(\start_r_reg_n_0_[5] ),
        .O(\scale_i_reg[5]_0 ));
  LUT6 #(
    .INIT(64'hFB0808FB08FBFB08)) 
    mem_reg_bram_0_i_136
       (.I0(\scale_i_reg_n_0_[4] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(mem_reg_bram_0_i_182_n_0),
        .I4(\j_off_reg_n_0_[4] ),
        .I5(\start_r_reg_n_0_[4] ),
        .O(\scale_i_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hB8888BBB8BBBB888)) 
    mem_reg_bram_0_i_138
       (.I0(\scale_i_reg_n_0_[3] ),
        .I1(\FSM_sequential_state_reg[1]_0 ),
        .I2(\j_off_reg_n_0_[2] ),
        .I3(\start_r_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[3] ),
        .I5(\start_r_reg_n_0_[3] ),
        .O(\scale_i_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT4 #(
    .INIT(16'h5535)) 
    mem_reg_bram_0_i_141
       (.I0(\j_off_reg_n_0_[1] ),
        .I1(\scale_i_reg_n_0_[1] ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .I3(\FSM_sequential_state_reg[1]_1 [0]),
        .O(\j_off_reg[1]_0 ));
  LUT6 #(
    .INIT(64'hA0A0C0C0AFAFCFC0)) 
    mem_reg_bram_0_i_16
       (.I0(mem_reg_bram_0_0[0]),
        .I1(ext_addr_IBUF[0]),
        .I2(mem_reg_bram_0_1),
        .I3(mem_reg_bram_0_i_82_n_0),
        .I4(mem_reg_bram_0_3),
        .I5(mem_reg_bram_0_4),
        .O(ADDRBWRADDR[0]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'h2B)) 
    mem_reg_bram_0_i_180
       (.I0(mem_reg_bram_0_i_181_n_0),
        .I1(\start_r_reg_n_0_[5] ),
        .I2(\j_off_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_180_n_0));
  LUT6 #(
    .INIT(64'h1117177717771777)) 
    mem_reg_bram_0_i_181
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(\j_off_reg_n_0_[4] ),
        .I2(\start_r_reg_n_0_[3] ),
        .I3(\j_off_reg_n_0_[3] ),
        .I4(\start_r_reg_n_0_[2] ),
        .I5(\j_off_reg_n_0_[2] ),
        .O(mem_reg_bram_0_i_181_n_0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT4 #(
    .INIT(16'hE888)) 
    mem_reg_bram_0_i_182
       (.I0(\start_r_reg_n_0_[3] ),
        .I1(\j_off_reg_n_0_[3] ),
        .I2(\start_r_reg_n_0_[2] ),
        .I3(\j_off_reg_n_0_[2] ),
        .O(mem_reg_bram_0_i_182_n_0));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT5 #(
    .INIT(32'h08FBFB08)) 
    mem_reg_bram_0_i_183
       (.I0(\scale_i_reg_n_0_[2] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .I3(\start_r_reg_n_0_[2] ),
        .I4(\j_off_reg_n_0_[2] ),
        .O(\scale_i_reg[2]_0 ));
  LUT6 #(
    .INIT(64'h00002882AAAA2882)) 
    mem_reg_bram_0_i_2
       (.I0(mem_reg_bram_0_7),
        .I1(mem_reg_bram_0_i_48_n_0),
        .I2(mem_reg_bram_0_i_49_n_0),
        .I3(mem_reg_bram_0_i_50_n_0),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(mem_reg_bram_0_11),
        .O(ADDRARDADDR[4]));
  LUT6 #(
    .INIT(64'hAA8200820082AA82)) 
    mem_reg_bram_0_i_3
       (.I0(mem_reg_bram_0_7),
        .I1(mem_reg_bram_0_i_52_n_0),
        .I2(mem_reg_bram_0_i_53_n_0),
        .I3(\FSM_onehot_state_reg[5]_0 ),
        .I4(mem_reg_bram_0_9),
        .I5(mem_reg_bram_0_10),
        .O(ADDRARDADDR[3]));
  LUT6 #(
    .INIT(64'h00002882AAAA2882)) 
    mem_reg_bram_0_i_4
       (.I0(mem_reg_bram_0_7),
        .I1(mem_reg_bram_0_i_56_n_0),
        .I2(mem_reg_bram_0_i_57_n_0),
        .I3(mem_reg_bram_0_i_58_n_0),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(mem_reg_bram_0_8),
        .O(ADDRARDADDR[2]));
  LUT6 #(
    .INIT(64'h0000000080808A80)) 
    mem_reg_bram_0_i_41
       (.I0(mem_reg_bram_0_7),
        .I1(mem_reg_bram_0_14),
        .I2(\FSM_onehot_state_reg[5]_0 ),
        .I3(\FSM_sequential_state_reg[1]_1 [0]),
        .I4(mem_reg_bram_0_i_118_n_0),
        .I5(rst_IBUF),
        .O(WEA));
  LUT6 #(
    .INIT(64'h65A6A665A66565A6)) 
    mem_reg_bram_0_i_44
       (.I0(mem_reg_bram_0_i_120_n_0),
        .I1(mem_reg_bram_0_i_48_n_0),
        .I2(mem_reg_bram_0_i_50_n_0),
        .I3(\start_r_reg_n_0_[6] ),
        .I4(in9[7]),
        .I5(\j_off_reg_n_0_[6] ),
        .O(mem_reg_bram_0_i_44_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_48
       (.I0(\j_off_reg_n_0_[5] ),
        .I1(in9[6]),
        .I2(\start_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_48_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_49
       (.I0(\start_r_reg_n_0_[6] ),
        .I1(in9[7]),
        .I2(\j_off_reg_n_0_[6] ),
        .O(mem_reg_bram_0_i_49_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'h69FF0069)) 
    mem_reg_bram_0_i_50
       (.I0(\start_r_reg_n_0_[5] ),
        .I1(in9[6]),
        .I2(\j_off_reg_n_0_[5] ),
        .I3(mem_reg_bram_0_i_124_n_0),
        .I4(mem_reg_bram_0_i_53_n_0),
        .O(mem_reg_bram_0_i_50_n_0));
  LUT6 #(
    .INIT(64'h17E8E817E81717E8)) 
    mem_reg_bram_0_i_52
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(in9[5]),
        .I2(\j_off_reg_n_0_[4] ),
        .I3(\j_off_reg_n_0_[5] ),
        .I4(in9[6]),
        .I5(\start_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_52_n_0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT5 #(
    .INIT(32'h2BB2B22B)) 
    mem_reg_bram_0_i_53
       (.I0(mem_reg_bram_0_i_58_n_0),
        .I1(mem_reg_bram_0_i_56_n_0),
        .I2(\start_r_reg_n_0_[4] ),
        .I3(in9[5]),
        .I4(\j_off_reg_n_0_[4] ),
        .O(mem_reg_bram_0_i_53_n_0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    mem_reg_bram_0_i_56
       (.I0(\j_off_reg_n_0_[3] ),
        .I1(in9[4]),
        .I2(\start_r_reg_n_0_[3] ),
        .O(mem_reg_bram_0_i_56_n_0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_57
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(in9[5]),
        .I2(\j_off_reg_n_0_[4] ),
        .O(mem_reg_bram_0_i_57_n_0));
  LUT6 #(
    .INIT(64'h0007077F7FFFFFFF)) 
    mem_reg_bram_0_i_58
       (.I0(\j_off_reg_n_0_[1] ),
        .I1(in9[2]),
        .I2(\j_off_reg_n_0_[2] ),
        .I3(in9[3]),
        .I4(\start_r_reg_n_0_[2] ),
        .I5(mem_reg_bram_0_i_126_n_0),
        .O(mem_reg_bram_0_i_58_n_0));
  LUT6 #(
    .INIT(64'hFF6A006A00000000)) 
    mem_reg_bram_0_i_6
       (.I0(mem_reg_bram_0_i_64_n_0),
        .I1(in9[2]),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(\FSM_onehot_state_reg[5]_0 ),
        .I4(mem_reg_bram_0_15),
        .I5(mem_reg_bram_0_7),
        .O(ADDRARDADDR[1]));
  LUT6 #(
    .INIT(64'h78F0F087F087870F)) 
    mem_reg_bram_0_i_60
       (.I0(in9[2]),
        .I1(\j_off_reg_n_0_[1] ),
        .I2(mem_reg_bram_0_i_126_n_0),
        .I3(\j_off_reg_n_0_[2] ),
        .I4(in9[3]),
        .I5(\start_r_reg_n_0_[2] ),
        .O(\len_r_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h96)) 
    mem_reg_bram_0_i_64
       (.I0(\start_r_reg_n_0_[2] ),
        .I1(in9[3]),
        .I2(\j_off_reg_n_0_[2] ),
        .O(mem_reg_bram_0_i_64_n_0));
  LUT6 #(
    .INIT(64'h0000044044440440)) 
    mem_reg_bram_0_i_7
       (.I0(mem_reg_bram_0_5),
        .I1(\FSM_onehot_state_reg[5] ),
        .I2(\j_off_reg_n_0_[1] ),
        .I3(in9[2]),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(mem_reg_bram_0_6),
        .O(ADDRARDADDR[0]));
  LUT6 #(
    .INIT(64'h0000510155555101)) 
    mem_reg_bram_0_i_70
       (.I0(mem_reg_bram_0_5),
        .I1(mem_reg_bram_0_i_128_n_0),
        .I2(\FSM_sequential_state_reg[1]_0 ),
        .I3(\scale_i_reg_n_0_[7] ),
        .I4(\FSM_onehot_state_reg[5]_0 ),
        .I5(mem_reg_bram_0_16),
        .O(mem_reg_bram_0_i_70_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFB800B8)) 
    mem_reg_bram_0_i_82
       (.I0(\scale_i_reg_n_0_[0] ),
        .I1(\FSM_sequential_state_reg[1]_0 ),
        .I2(\j_off_reg[0]_0 ),
        .I3(\FSM_onehot_state_reg[5]_0 ),
        .I4(mem_reg_bram_0_13),
        .I5(mem_reg_bram_0_5),
        .O(mem_reg_bram_0_i_82_n_0));
  LUT6 #(
    .INIT(64'hBBB88888FFFC3330)) 
    mem_reg_bram_0_i_9
       (.I0(mem_reg_bram_0_0[7]),
        .I1(mem_reg_bram_0_1),
        .I2(mem_reg_bram_0_2),
        .I3(mem_reg_bram_0_i_70_n_0),
        .I4(ext_addr_IBUF[1]),
        .I5(mem_reg_bram_0_3),
        .O(ADDRBWRADDR[1]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT4 #(
    .INIT(16'h0444)) 
    \phase_cnt[0]_i_1__0 
       (.I0(\phase_cnt_reg_n_0_[0] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .O(\phase_cnt[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT4 #(
    .INIT(16'h04C0)) 
    \phase_cnt[1]_i_1__0 
       (.I0(\phase_cnt_reg_n_0_[2] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\phase_cnt_reg_n_0_[0] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .O(phase_cnt[1]));
  LUT3 #(
    .INIT(8'hF8)) 
    \phase_cnt[2]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\phase_cnt_reg[0]_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .O(\phase_cnt[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h08C0)) 
    \phase_cnt[2]_i_2__0 
       (.I0(\phase_cnt_reg_n_0_[0] ),
        .I1(\FSM_sequential_state_reg[1]_1 [1]),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .O(phase_cnt[2]));
  FDRE \phase_cnt_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1__0_n_0 ),
        .D(\phase_cnt[0]_i_1__0_n_0 ),
        .Q(\phase_cnt_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \phase_cnt_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1__0_n_0 ),
        .D(phase_cnt[1]),
        .Q(\phase_cnt_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \phase_cnt_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\phase_cnt[2]_i_1__0_n_0 ),
        .D(phase_cnt[2]),
        .Q(\phase_cnt_reg_n_0_[2] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \scale_i[0]_i_1 
       (.I0(\scale_i_reg_n_0_[0] ),
        .I1(\FSM_sequential_state_reg[1]_1 [0]),
        .O(scale_i[0]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \scale_i[1]_i_1 
       (.I0(\scale_i_reg_n_0_[1] ),
        .I1(\scale_i_reg_n_0_[0] ),
        .I2(\FSM_sequential_state_reg[1]_1 [0]),
        .O(scale_i[1]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h1540)) 
    \scale_i[2]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\scale_i_reg_n_0_[0] ),
        .I2(\scale_i_reg_n_0_[1] ),
        .I3(\scale_i_reg_n_0_[2] ),
        .O(\scale_i[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h00007F80)) 
    \scale_i[3]_i_1 
       (.I0(\scale_i_reg_n_0_[1] ),
        .I1(\scale_i_reg_n_0_[0] ),
        .I2(\scale_i_reg_n_0_[2] ),
        .I3(\scale_i_reg_n_0_[3] ),
        .I4(\FSM_sequential_state_reg[1]_1 [0]),
        .O(scale_i[3]));
  LUT6 #(
    .INIT(64'h1555555540000000)) 
    \scale_i[4]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\scale_i_reg_n_0_[3] ),
        .I2(\scale_i_reg_n_0_[2] ),
        .I3(\scale_i_reg_n_0_[0] ),
        .I4(\scale_i_reg_n_0_[1] ),
        .I5(\scale_i_reg_n_0_[4] ),
        .O(\scale_i[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'h14)) 
    \scale_i[5]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\scale_i[5]_i_2_n_0 ),
        .I2(\scale_i_reg_n_0_[5] ),
        .O(\scale_i[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \scale_i[5]_i_2 
       (.I0(\scale_i_reg_n_0_[4] ),
        .I1(\scale_i_reg_n_0_[1] ),
        .I2(\scale_i_reg_n_0_[0] ),
        .I3(\scale_i_reg_n_0_[2] ),
        .I4(\scale_i_reg_n_0_[3] ),
        .O(\scale_i[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'h14)) 
    \scale_i[6]_i_1 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\scale_i[7]_i_3_n_0 ),
        .I2(\scale_i_reg_n_0_[6] ),
        .O(\scale_i[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAABFFF)) 
    \scale_i[7]_i_1 
       (.I0(\FSM_sequential_state[1]_i_2_n_0 ),
        .I1(\scale_i_reg_n_0_[6] ),
        .I2(\scale_i[7]_i_3_n_0 ),
        .I3(\scale_i_reg_n_0_[7] ),
        .I4(\FSM_sequential_state_reg[1]_1 [0]),
        .I5(mem_reg_bram_0_i_118_n_0),
        .O(\scale_i[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'h1540)) 
    \scale_i[7]_i_2 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\scale_i[7]_i_3_n_0 ),
        .I2(\scale_i_reg_n_0_[6] ),
        .I3(\scale_i_reg_n_0_[7] ),
        .O(\scale_i[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \scale_i[7]_i_3 
       (.I0(\scale_i_reg_n_0_[3] ),
        .I1(\scale_i_reg_n_0_[2] ),
        .I2(\scale_i_reg_n_0_[0] ),
        .I3(\scale_i_reg_n_0_[1] ),
        .I4(\scale_i_reg_n_0_[4] ),
        .I5(\scale_i_reg_n_0_[5] ),
        .O(\scale_i[7]_i_3_n_0 ));
  FDRE \scale_i_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(scale_i[0]),
        .Q(\scale_i_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(scale_i[1]),
        .Q(\scale_i_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(\scale_i[2]_i_1_n_0 ),
        .Q(\scale_i_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(scale_i[3]),
        .Q(\scale_i_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(\scale_i[4]_i_1_n_0 ),
        .Q(\scale_i_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(\scale_i[5]_i_1_n_0 ),
        .Q(\scale_i_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(\scale_i[6]_i_1_n_0 ),
        .Q(\scale_i_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \scale_i_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\scale_i[7]_i_1_n_0 ),
        .D(\scale_i[7]_i_2_n_0 ),
        .Q(\scale_i_reg_n_0_[7] ),
        .R(rst_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT4 #(
    .INIT(16'h0028)) 
    \start_r[2]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\start_r_reg_n_0_[2] ),
        .I2(in9[2]),
        .I3(\layer[2]_i_5_n_0 ),
        .O(start_r[2]));
  LUT6 #(
    .INIT(64'h00000000802A2A80)) 
    \start_r[3]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[2]),
        .I2(\start_r_reg_n_0_[2] ),
        .I3(in9[3]),
        .I4(\start_r_reg_n_0_[3] ),
        .I5(\layer[2]_i_5_n_0 ),
        .O(start_r[3]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[4]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\start_r[4]_i_2__0_n_0 ),
        .I2(in9[4]),
        .I3(\start_r_reg_n_0_[4] ),
        .I4(\layer[2]_i_5_n_0 ),
        .O(start_r[4]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT4 #(
    .INIT(16'hE888)) 
    \start_r[4]_i_2__0 
       (.I0(in9[3]),
        .I1(\start_r_reg_n_0_[3] ),
        .I2(in9[2]),
        .I3(\start_r_reg_n_0_[2] ),
        .O(\start_r[4]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h00002882)) 
    \start_r[5]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\start_r[5]_i_2__0_n_0 ),
        .I2(in9[5]),
        .I3(\start_r_reg_n_0_[5] ),
        .I4(\layer[2]_i_5_n_0 ),
        .O(start_r[5]));
  LUT6 #(
    .INIT(64'h00151555557F7FFF)) 
    \start_r[5]_i_2__0 
       (.I0(\start_r_reg_n_0_[4] ),
        .I1(\start_r_reg_n_0_[2] ),
        .I2(in9[2]),
        .I3(\start_r_reg_n_0_[3] ),
        .I4(in9[3]),
        .I5(in9[4]),
        .O(\start_r[5]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'h00008228)) 
    \start_r[6]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\start_r[6]_i_2__0_n_0 ),
        .I2(in9[6]),
        .I3(\start_r_reg_n_0_[6] ),
        .I4(\layer[2]_i_5_n_0 ),
        .O(start_r[6]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'hB2)) 
    \start_r[6]_i_2__0 
       (.I0(in9[5]),
        .I1(\start_r[5]_i_2__0_n_0 ),
        .I2(\start_r_reg_n_0_[5] ),
        .O(\start_r[6]_i_2__0_n_0 ));
  LUT5 #(
    .INIT(32'h08FF0808)) 
    \start_r[7]_i_1__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [0]),
        .I1(\phase_cnt_reg[0]_0 ),
        .I2(\FSM_sequential_state_reg[1]_1 [1]),
        .I3(\start_r[7]_i_3__0_n_0 ),
        .I4(\start_r[7]_i_4_n_0 ),
        .O(\start_r[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h08002082)) 
    \start_r[7]_i_2__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(in9[7]),
        .I2(\start_r[7]_i_5_n_0 ),
        .I3(\start_r_reg_n_0_[7] ),
        .I4(\len_r_reg_n_0_[7] ),
        .O(start_r[7]));
  LUT6 #(
    .INIT(64'hFFFFDFFFFFFFFFFF)) 
    \start_r[7]_i_3__0 
       (.I0(\FSM_sequential_state_reg[1]_1 [1]),
        .I1(\phase_cnt_reg_n_0_[0] ),
        .I2(\phase_cnt_reg_n_0_[2] ),
        .I3(\phase_cnt_reg_n_0_[1] ),
        .I4(\j_off[7]_i_3__0_n_0 ),
        .I5(\FSM_sequential_state_reg[1]_1 [0]),
        .O(\start_r[7]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'hBFFF)) 
    \start_r[7]_i_4 
       (.I0(\layer_reg_n_0_[0] ),
        .I1(\layer_reg_n_0_[2] ),
        .I2(\layer_reg_n_0_[1] ),
        .I3(\layer[2]_i_5_n_0 ),
        .O(\start_r[7]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h105175F7)) 
    \start_r[7]_i_5 
       (.I0(\start_r_reg_n_0_[6] ),
        .I1(\start_r_reg_n_0_[5] ),
        .I2(\start_r[5]_i_2__0_n_0 ),
        .I3(in9[5]),
        .I4(in9[6]),
        .O(\start_r[7]_i_5_n_0 ));
  FDRE \start_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[2]),
        .Q(\start_r_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[3]),
        .Q(\start_r_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[4]),
        .Q(\start_r_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[5]),
        .Q(\start_r_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[6]),
        .Q(\start_r_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE \start_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\start_r[7]_i_1__0_n_0 ),
        .D(start_r[7]),
        .Q(\start_r_reg_n_0_[7] ),
        .R(rst_IBUF));
endmodule

module mod_add
   (mem_reg_bram_0,
    mem_reg_bram_0_0,
    DOUTBDOUT,
    DI,
    DOUTADOUT);
  output [6:0]mem_reg_bram_0;
  output [0:0]mem_reg_bram_0_0;
  input [7:0]DOUTBDOUT;
  input [0:0]DI;
  input [6:0]DOUTADOUT;

  wire [0:0]DI;
  wire [6:0]DOUTADOUT;
  wire [7:0]DOUTBDOUT;
  wire [6:0]mem_reg_bram_0;
  wire [0:0]mem_reg_bram_0_0;

  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_186
       (.I0(DOUTBDOUT[7]),
        .I1(DOUTADOUT[6]),
        .O(mem_reg_bram_0_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_194
       (.I0(DOUTBDOUT[6]),
        .I1(DOUTADOUT[5]),
        .O(mem_reg_bram_0[6]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_195
       (.I0(DOUTBDOUT[5]),
        .I1(DOUTADOUT[4]),
        .O(mem_reg_bram_0[5]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_196
       (.I0(DOUTBDOUT[4]),
        .I1(DOUTADOUT[3]),
        .O(mem_reg_bram_0[4]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_197
       (.I0(DOUTBDOUT[3]),
        .I1(DOUTADOUT[2]),
        .O(mem_reg_bram_0[3]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_198
       (.I0(DOUTBDOUT[2]),
        .I1(DOUTADOUT[1]),
        .O(mem_reg_bram_0[2]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_199
       (.I0(DOUTBDOUT[1]),
        .I1(DOUTADOUT[0]),
        .O(mem_reg_bram_0[1]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_201
       (.I0(DOUTBDOUT[0]),
        .I1(DI),
        .O(mem_reg_bram_0[0]));
endmodule

module mod_mult
   (load_val,
    \c_r_reg[2]_0 ,
    \c_r_reg[3]_0 ,
    \c_r_reg[9]_0 ,
    \c_r_reg[5]_0 ,
    \c_r_reg[0]_0 ,
    \c_r_reg[10]_0 ,
    clk_IBUF_BUFG,
    Q);
  output [11:0]load_val;
  output \c_r_reg[2]_0 ;
  output \c_r_reg[3]_0 ;
  output \c_r_reg[9]_0 ;
  output \c_r_reg[5]_0 ;
  output \c_r_reg[0]_0 ;
  output \c_r_reg[10]_0 ;
  input clk_IBUF_BUFG;
  input [7:0]Q;

  wire [7:0]Q;
  wire T_mu_r_reg_n_100;
  wire T_mu_r_reg_n_101;
  wire T_mu_r_reg_n_102;
  wire T_mu_r_reg_n_103;
  wire T_mu_r_reg_n_104;
  wire T_mu_r_reg_n_105;
  wire T_mu_r_reg_n_73;
  wire T_mu_r_reg_n_74;
  wire T_mu_r_reg_n_75;
  wire T_mu_r_reg_n_76;
  wire T_mu_r_reg_n_77;
  wire T_mu_r_reg_n_78;
  wire T_mu_r_reg_n_79;
  wire T_mu_r_reg_n_80;
  wire T_mu_r_reg_n_81;
  wire T_mu_r_reg_n_82;
  wire T_mu_r_reg_n_83;
  wire T_mu_r_reg_n_84;
  wire T_mu_r_reg_n_85;
  wire T_mu_r_reg_n_86;
  wire T_mu_r_reg_n_87;
  wire T_mu_r_reg_n_88;
  wire T_mu_r_reg_n_89;
  wire T_mu_r_reg_n_90;
  wire T_mu_r_reg_n_91;
  wire T_mu_r_reg_n_92;
  wire T_mu_r_reg_n_93;
  wire T_mu_r_reg_n_94;
  wire T_mu_r_reg_n_95;
  wire T_mu_r_reg_n_96;
  wire T_mu_r_reg_n_97;
  wire T_mu_r_reg_n_98;
  wire T_mu_r_reg_n_99;
  wire T_r_reg_n_100;
  wire T_r_reg_n_101;
  wire T_r_reg_n_102;
  wire T_r_reg_n_103;
  wire T_r_reg_n_104;
  wire T_r_reg_n_105;
  wire T_r_reg_n_86;
  wire T_r_reg_n_87;
  wire T_r_reg_n_88;
  wire T_r_reg_n_89;
  wire T_r_reg_n_90;
  wire T_r_reg_n_91;
  wire T_r_reg_n_92;
  wire T_r_reg_n_93;
  wire T_r_reg_n_94;
  wire T_r_reg_n_95;
  wire T_r_reg_n_96;
  wire T_r_reg_n_97;
  wire T_r_reg_n_98;
  wire T_r_reg_n_99;
  wire \c_r[0]_i_1_n_0 ;
  wire \c_r[10]_i_1_n_0 ;
  wire \c_r[11]_i_1_n_0 ;
  wire \c_r[11]_i_2_n_0 ;
  wire \c_r[11]_i_3_n_0 ;
  wire \c_r[11]_i_4_n_0 ;
  wire \c_r[11]_i_5_n_0 ;
  wire \c_r[1]_i_1_n_0 ;
  wire \c_r[2]_i_1_n_0 ;
  wire \c_r[3]_i_1_n_0 ;
  wire \c_r[4]_i_1_n_0 ;
  wire \c_r[5]_i_1_n_0 ;
  wire \c_r[6]_i_1_n_0 ;
  wire \c_r[7]_i_1_n_0 ;
  wire \c_r[7]_i_2_n_0 ;
  wire \c_r[8]_i_1_n_0 ;
  wire \c_r[8]_i_2_n_0 ;
  wire \c_r[9]_i_1_n_0 ;
  wire \c_r_reg[0]_0 ;
  wire \c_r_reg[10]_0 ;
  wire \c_r_reg[2]_0 ;
  wire \c_r_reg[3]_0 ;
  wire \c_r_reg[5]_0 ;
  wire \c_r_reg[9]_0 ;
  wire \c_r_reg_n_0_[0] ;
  wire \c_r_reg_n_0_[10] ;
  wire \c_r_reg_n_0_[11] ;
  wire \c_r_reg_n_0_[1] ;
  wire \c_r_reg_n_0_[2] ;
  wire \c_r_reg_n_0_[3] ;
  wire \c_r_reg_n_0_[4] ;
  wire \c_r_reg_n_0_[5] ;
  wire \c_r_reg_n_0_[6] ;
  wire \c_r_reg_n_0_[7] ;
  wire \c_r_reg_n_0_[8] ;
  wire \c_r_reg_n_0_[9] ;
  wire clk_IBUF_BUFG;
  wire [11:0]load_val;
  wire mem_reg_bram_0_i_151_n_0;
  wire mem_reg_bram_0_i_152_n_0;
  wire orig_mem_reg_r1_0_63_0_6_i_10_n_0;
  wire orig_mem_reg_r1_0_63_0_6_i_11_n_0;
  wire orig_mem_reg_r1_0_63_0_6_i_12_n_0;
  wire orig_mem_reg_r1_0_63_0_6_i_9_n_0;
  wire orig_mem_reg_r1_0_63_7_11_i_6_n_0;
  wire orig_mem_reg_r1_0_63_7_11_i_7_n_0;
  wire orig_mem_reg_r1_0_63_7_11_i_8_n_0;
  wire r_r_reg_n_100;
  wire r_r_reg_n_101;
  wire r_r_reg_n_102;
  wire r_r_reg_n_103;
  wire r_r_reg_n_104;
  wire r_r_reg_n_105;
  wire r_r_reg_n_93;
  wire r_r_reg_n_94;
  wire r_r_reg_n_95;
  wire r_r_reg_n_96;
  wire r_r_reg_n_97;
  wire r_r_reg_n_98;
  wire r_r_reg_n_99;
  wire NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_mu_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_mu_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:33]NLW_T_mu_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_mu_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_mu_r_reg_XOROUT_UNCONNECTED;
  wire NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:20]NLW_T_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_r_reg_XOROUT_UNCONNECTED;
  wire NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_r_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_r_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_r_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_r_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_r_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:13]NLW_r_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_r_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_r_r_reg_XOROUT_UNCONNECTED;

  (* KEEP_HIERARCHY = "yes" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-12 {cell *THIS*}}" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_mu_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_mu_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_mu_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_mu_r_reg_P_UNCONNECTED[47:33],T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81,T_mu_r_reg_n_82,T_mu_r_reg_n_83,T_mu_r_reg_n_84,T_mu_r_reg_n_85,T_mu_r_reg_n_86,T_mu_r_reg_n_87,T_mu_r_reg_n_88,T_mu_r_reg_n_89,T_mu_r_reg_n_90,T_mu_r_reg_n_91,T_mu_r_reg_n_92,T_mu_r_reg_n_93,T_mu_r_reg_n_94,T_mu_r_reg_n_95,T_mu_r_reg_n_96,T_mu_r_reg_n_97,T_mu_r_reg_n_98,T_mu_r_reg_n_99,T_mu_r_reg_n_100,T_mu_r_reg_n_101,T_mu_r_reg_n_102,T_mu_r_reg_n_103,T_mu_r_reg_n_104,T_mu_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_mu_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_mu_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,Q}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b1),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_r_reg_P_UNCONNECTED[47:20],T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \c_r[0]_i_1 
       (.I0(\c_r[11]_i_2_n_0 ),
        .I1(r_r_reg_n_105),
        .O(\c_r[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT4 #(
    .INIT(16'h5DA2)) 
    \c_r[10]_i_1 
       (.I0(\c_r[11]_i_2_n_0 ),
        .I1(\c_r[11]_i_3_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .O(\c_r[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT5 #(
    .INIT(32'h5DFFA200)) 
    \c_r[11]_i_1 
       (.I0(\c_r[11]_i_2_n_0 ),
        .I1(\c_r[11]_i_3_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .I4(r_r_reg_n_94),
        .O(\c_r[11]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFE000)) 
    \c_r[11]_i_2 
       (.I0(\c_r[11]_i_4_n_0 ),
        .I1(r_r_reg_n_96),
        .I2(r_r_reg_n_95),
        .I3(r_r_reg_n_94),
        .I4(r_r_reg_n_93),
        .O(\c_r[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h55555557)) 
    \c_r[11]_i_3 
       (.I0(r_r_reg_n_97),
        .I1(r_r_reg_n_99),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .I4(\c_r[8]_i_2_n_0 ),
        .O(\c_r[11]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000000)) 
    \c_r[11]_i_4 
       (.I0(\c_r[11]_i_5_n_0 ),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_98),
        .I3(r_r_reg_n_99),
        .I4(r_r_reg_n_100),
        .I5(r_r_reg_n_97),
        .O(\c_r[11]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \c_r[11]_i_5 
       (.I0(r_r_reg_n_101),
        .I1(r_r_reg_n_102),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_104),
        .O(\c_r[11]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \c_r[1]_i_1 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2_n_0 ),
        .O(\c_r[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT4 #(
    .INIT(16'hEF10)) 
    \c_r[2]_i_1 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2_n_0 ),
        .I3(r_r_reg_n_103),
        .O(\c_r[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    \c_r[3]_i_1 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2_n_0 ),
        .O(\c_r[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFF00010000)) 
    \c_r[4]_i_1 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2_n_0 ),
        .I5(r_r_reg_n_101),
        .O(\c_r[4]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \c_r[5]_i_1 
       (.I0(r_r_reg_n_100),
        .I1(\c_r[7]_i_2_n_0 ),
        .O(\c_r[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \c_r[6]_i_1 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2_n_0 ),
        .I2(r_r_reg_n_100),
        .O(\c_r[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT4 #(
    .INIT(16'hFE01)) 
    \c_r[7]_i_1 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2_n_0 ),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .O(\c_r[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \c_r[7]_i_2 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_101),
        .I4(r_r_reg_n_102),
        .I5(\c_r[11]_i_2_n_0 ),
        .O(\c_r[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0001FFFFFFFE0000)) 
    \c_r[8]_i_1 
       (.I0(\c_r[8]_i_2_n_0 ),
        .I1(r_r_reg_n_98),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_99),
        .I4(\c_r[11]_i_2_n_0 ),
        .I5(r_r_reg_n_97),
        .O(\c_r[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \c_r[8]_i_2 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_101),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_105),
        .I4(r_r_reg_n_104),
        .O(\c_r[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \c_r[9]_i_1 
       (.I0(\c_r[11]_i_2_n_0 ),
        .I1(\c_r[11]_i_3_n_0 ),
        .I2(r_r_reg_n_96),
        .O(\c_r[9]_i_1_n_0 ));
  FDRE \c_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[0]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \c_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[10]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[10] ),
        .R(1'b0));
  FDRE \c_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[11]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[11] ),
        .R(1'b0));
  FDRE \c_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[1]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[1] ),
        .R(1'b0));
  FDRE \c_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[2]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[2] ),
        .R(1'b0));
  FDRE \c_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[3]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[3] ),
        .R(1'b0));
  FDRE \c_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[4]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[4] ),
        .R(1'b0));
  FDRE \c_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[5]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[5] ),
        .R(1'b0));
  FDRE \c_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[6]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[6] ),
        .R(1'b0));
  FDRE \c_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[7]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \c_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[8]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[8] ),
        .R(1'b0));
  FDRE \c_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[9]_i_1_n_0 ),
        .Q(\c_r_reg_n_0_[9] ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h9595955595559555)) 
    mem_reg_bram_0_i_106
       (.I0(\c_r_reg_n_0_[5] ),
        .I1(\c_r_reg_n_0_[4] ),
        .I2(\c_r_reg_n_0_[3] ),
        .I3(\c_r_reg_n_0_[2] ),
        .I4(orig_mem_reg_r1_0_63_0_6_i_10_n_0),
        .I5(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .O(\c_r_reg[5]_0 ));
  LUT6 #(
    .INIT(64'h777FFFFFFFFFFFFF)) 
    mem_reg_bram_0_i_151
       (.I0(\c_r_reg_n_0_[6] ),
        .I1(\c_r_reg_n_0_[4] ),
        .I2(\c_r_reg_n_0_[2] ),
        .I3(orig_mem_reg_r1_0_63_0_6_i_10_n_0),
        .I4(\c_r_reg_n_0_[3] ),
        .I5(\c_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_151_n_0));
  LUT6 #(
    .INIT(64'hFF7FFFFFFFFFFFFF)) 
    mem_reg_bram_0_i_152
       (.I0(\c_r_reg_n_0_[6] ),
        .I1(\c_r_reg_n_0_[4] ),
        .I2(\c_r_reg_n_0_[3] ),
        .I3(\c_r_reg_n_0_[2] ),
        .I4(orig_mem_reg_r1_0_63_0_6_i_10_n_0),
        .I5(\c_r_reg_n_0_[5] ),
        .O(mem_reg_bram_0_i_152_n_0));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT5 #(
    .INIT(32'hAAAA9555)) 
    mem_reg_bram_0_i_165
       (.I0(\c_r_reg_n_0_[3] ),
        .I1(\c_r_reg_n_0_[1] ),
        .I2(\c_r_reg_n_0_[0] ),
        .I3(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I4(\c_r_reg_n_0_[2] ),
        .O(\c_r_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    mem_reg_bram_0_i_174
       (.I0(\c_r_reg_n_0_[2] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[0] ),
        .I3(\c_r_reg_n_0_[1] ),
        .O(\c_r_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'h87)) 
    mem_reg_bram_0_i_176
       (.I0(\c_r_reg_n_0_[0] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[1] ),
        .O(\c_r_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT4 #(
    .INIT(16'h2DFF)) 
    mem_reg_bram_0_i_92
       (.I0(\c_r_reg_n_0_[10] ),
        .I1(orig_mem_reg_r1_0_63_7_11_i_8_n_0),
        .I2(\c_r_reg_n_0_[11] ),
        .I3(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .O(\c_r_reg[10]_0 ));
  LUT6 #(
    .INIT(64'h6565555555599AAA)) 
    mem_reg_bram_0_i_98
       (.I0(\c_r_reg_n_0_[9] ),
        .I1(mem_reg_bram_0_i_151_n_0),
        .I2(\c_r_reg_n_0_[7] ),
        .I3(mem_reg_bram_0_i_152_n_0),
        .I4(\c_r_reg_n_0_[8] ),
        .I5(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .O(\c_r_reg[9]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'h6)) 
    orig_mem_reg_r1_0_63_0_6_i_1
       (.I0(\c_r_reg_n_0_[0] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .O(load_val[0]));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'h8)) 
    orig_mem_reg_r1_0_63_0_6_i_10
       (.I0(\c_r_reg_n_0_[0] ),
        .I1(\c_r_reg_n_0_[1] ),
        .O(orig_mem_reg_r1_0_63_0_6_i_10_n_0));
  LUT6 #(
    .INIT(64'h8888800000000000)) 
    orig_mem_reg_r1_0_63_0_6_i_11
       (.I0(\c_r_reg_n_0_[5] ),
        .I1(\c_r_reg_n_0_[3] ),
        .I2(\c_r_reg_n_0_[0] ),
        .I3(\c_r_reg_n_0_[1] ),
        .I4(\c_r_reg_n_0_[2] ),
        .I5(\c_r_reg_n_0_[4] ),
        .O(orig_mem_reg_r1_0_63_0_6_i_11_n_0));
  LUT6 #(
    .INIT(64'hFF7FFFFFFFFFFFFF)) 
    orig_mem_reg_r1_0_63_0_6_i_12
       (.I0(\c_r_reg_n_0_[5] ),
        .I1(\c_r_reg_n_0_[1] ),
        .I2(\c_r_reg_n_0_[0] ),
        .I3(\c_r_reg_n_0_[2] ),
        .I4(\c_r_reg_n_0_[3] ),
        .I5(\c_r_reg_n_0_[4] ),
        .O(orig_mem_reg_r1_0_63_0_6_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    orig_mem_reg_r1_0_63_0_6_i_2
       (.I0(\c_r_reg_n_0_[1] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[0] ),
        .O(load_val[1]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT4 #(
    .INIT(16'h807F)) 
    orig_mem_reg_r1_0_63_0_6_i_3
       (.I0(\c_r_reg_n_0_[1] ),
        .I1(\c_r_reg_n_0_[0] ),
        .I2(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I3(\c_r_reg_n_0_[2] ),
        .O(load_val[2]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT5 #(
    .INIT(32'h1555EAAA)) 
    orig_mem_reg_r1_0_63_0_6_i_4
       (.I0(\c_r_reg_n_0_[2] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[0] ),
        .I3(\c_r_reg_n_0_[1] ),
        .I4(\c_r_reg_n_0_[3] ),
        .O(load_val[3]));
  LUT6 #(
    .INIT(64'h55556AAAAAAAAAAA)) 
    orig_mem_reg_r1_0_63_0_6_i_5
       (.I0(\c_r_reg_n_0_[4] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[1] ),
        .I3(\c_r_reg_n_0_[0] ),
        .I4(\c_r_reg_n_0_[2] ),
        .I5(\c_r_reg_n_0_[3] ),
        .O(load_val[4]));
  LUT6 #(
    .INIT(64'h07FFFFFFF8000000)) 
    orig_mem_reg_r1_0_63_0_6_i_6
       (.I0(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I1(orig_mem_reg_r1_0_63_0_6_i_10_n_0),
        .I2(\c_r_reg_n_0_[2] ),
        .I3(\c_r_reg_n_0_[3] ),
        .I4(\c_r_reg_n_0_[4] ),
        .I5(\c_r_reg_n_0_[5] ),
        .O(load_val[5]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT4 #(
    .INIT(16'h6669)) 
    orig_mem_reg_r1_0_63_0_6_i_7
       (.I0(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .I1(\c_r_reg_n_0_[6] ),
        .I2(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I3(orig_mem_reg_r1_0_63_0_6_i_12_n_0),
        .O(load_val[6]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT5 #(
    .INIT(32'h1337FFFF)) 
    orig_mem_reg_r1_0_63_0_6_i_9
       (.I0(orig_mem_reg_r1_0_63_7_11_i_6_n_0),
        .I1(\c_r_reg_n_0_[10] ),
        .I2(orig_mem_reg_r1_0_63_7_11_i_7_n_0),
        .I3(\c_r_reg_n_0_[9] ),
        .I4(\c_r_reg_n_0_[11] ),
        .O(orig_mem_reg_r1_0_63_0_6_i_9_n_0));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT5 #(
    .INIT(32'h5AAA6AA9)) 
    orig_mem_reg_r1_0_63_7_11_i_1
       (.I0(\c_r_reg_n_0_[7] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .I3(\c_r_reg_n_0_[6] ),
        .I4(orig_mem_reg_r1_0_63_0_6_i_12_n_0),
        .O(load_val[7]));
  LUT6 #(
    .INIT(64'h695999999999999A)) 
    orig_mem_reg_r1_0_63_7_11_i_2
       (.I0(\c_r_reg_n_0_[8] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I2(\c_r_reg_n_0_[7] ),
        .I3(orig_mem_reg_r1_0_63_0_6_i_12_n_0),
        .I4(\c_r_reg_n_0_[6] ),
        .I5(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .O(load_val[8]));
  LUT1 #(
    .INIT(2'h1)) 
    orig_mem_reg_r1_0_63_7_11_i_3
       (.I0(\c_r_reg[9]_0 ),
        .O(load_val[9]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT5 #(
    .INIT(32'h05577000)) 
    orig_mem_reg_r1_0_63_7_11_i_4
       (.I0(\c_r_reg_n_0_[11] ),
        .I1(orig_mem_reg_r1_0_63_7_11_i_6_n_0),
        .I2(\c_r_reg_n_0_[9] ),
        .I3(orig_mem_reg_r1_0_63_7_11_i_7_n_0),
        .I4(\c_r_reg_n_0_[10] ),
        .O(load_val[10]));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT4 #(
    .INIT(16'h8288)) 
    orig_mem_reg_r1_0_63_7_11_i_5
       (.I0(orig_mem_reg_r1_0_63_0_6_i_9_n_0),
        .I1(\c_r_reg_n_0_[11] ),
        .I2(orig_mem_reg_r1_0_63_7_11_i_8_n_0),
        .I3(\c_r_reg_n_0_[10] ),
        .O(load_val[11]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT5 #(
    .INIT(32'h6A2AAAA8)) 
    orig_mem_reg_r1_0_63_7_11_i_6
       (.I0(\c_r_reg_n_0_[8] ),
        .I1(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .I2(\c_r_reg_n_0_[6] ),
        .I3(orig_mem_reg_r1_0_63_0_6_i_12_n_0),
        .I4(\c_r_reg_n_0_[7] ),
        .O(orig_mem_reg_r1_0_63_7_11_i_6_n_0));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    orig_mem_reg_r1_0_63_7_11_i_7
       (.I0(\c_r_reg_n_0_[8] ),
        .I1(\c_r_reg_n_0_[6] ),
        .I2(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .I3(\c_r_reg_n_0_[7] ),
        .O(orig_mem_reg_r1_0_63_7_11_i_7_n_0));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    orig_mem_reg_r1_0_63_7_11_i_8
       (.I0(\c_r_reg_n_0_[9] ),
        .I1(\c_r_reg_n_0_[7] ),
        .I2(orig_mem_reg_r1_0_63_0_6_i_11_n_0),
        .I3(\c_r_reg_n_0_[6] ),
        .I4(\c_r_reg_n_0_[8] ),
        .O(orig_mem_reg_r1_0_63_7_11_i_8_n_0));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    r_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_r_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b1,1'b1}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_r_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_r_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b1),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_r_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_r_r_reg_P_UNCONNECTED[47:13],r_r_reg_n_93,r_r_reg_n_94,r_r_reg_n_95,r_r_reg_n_96,r_r_reg_n_97,r_r_reg_n_98,r_r_reg_n_99,r_r_reg_n_100,r_r_reg_n_101,r_r_reg_n_102,r_r_reg_n_103,r_r_reg_n_104,r_r_reg_n_105}),
        .PATTERNBDETECT(NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_r_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_r_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_r_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_r_r_reg_XOROUT_UNCONNECTED[7:0]));
endmodule

(* ORIG_REF_NAME = "mod_mult" *) 
module mod_mult_1
   (Q,
    clk_IBUF_BUFG,
    DOUTBDOUT);
  output [11:0]Q;
  input clk_IBUF_BUFG;
  input [11:0]DOUTBDOUT;

  wire [11:0]DOUTBDOUT;
  wire [11:0]Q;
  wire T_mu_r_reg_n_100;
  wire T_mu_r_reg_n_101;
  wire T_mu_r_reg_n_102;
  wire T_mu_r_reg_n_103;
  wire T_mu_r_reg_n_104;
  wire T_mu_r_reg_n_105;
  wire T_mu_r_reg_n_69;
  wire T_mu_r_reg_n_70;
  wire T_mu_r_reg_n_71;
  wire T_mu_r_reg_n_72;
  wire T_mu_r_reg_n_73;
  wire T_mu_r_reg_n_74;
  wire T_mu_r_reg_n_75;
  wire T_mu_r_reg_n_76;
  wire T_mu_r_reg_n_77;
  wire T_mu_r_reg_n_78;
  wire T_mu_r_reg_n_79;
  wire T_mu_r_reg_n_80;
  wire T_mu_r_reg_n_81;
  wire T_mu_r_reg_n_82;
  wire T_mu_r_reg_n_83;
  wire T_mu_r_reg_n_84;
  wire T_mu_r_reg_n_85;
  wire T_mu_r_reg_n_86;
  wire T_mu_r_reg_n_87;
  wire T_mu_r_reg_n_88;
  wire T_mu_r_reg_n_89;
  wire T_mu_r_reg_n_90;
  wire T_mu_r_reg_n_91;
  wire T_mu_r_reg_n_92;
  wire T_mu_r_reg_n_93;
  wire T_mu_r_reg_n_94;
  wire T_mu_r_reg_n_95;
  wire T_mu_r_reg_n_96;
  wire T_mu_r_reg_n_97;
  wire T_mu_r_reg_n_98;
  wire T_mu_r_reg_n_99;
  wire T_r_reg_n_100;
  wire T_r_reg_n_101;
  wire T_r_reg_n_102;
  wire T_r_reg_n_103;
  wire T_r_reg_n_104;
  wire T_r_reg_n_105;
  wire T_r_reg_n_82;
  wire T_r_reg_n_83;
  wire T_r_reg_n_84;
  wire T_r_reg_n_85;
  wire T_r_reg_n_86;
  wire T_r_reg_n_87;
  wire T_r_reg_n_88;
  wire T_r_reg_n_89;
  wire T_r_reg_n_90;
  wire T_r_reg_n_91;
  wire T_r_reg_n_92;
  wire T_r_reg_n_93;
  wire T_r_reg_n_94;
  wire T_r_reg_n_95;
  wire T_r_reg_n_96;
  wire T_r_reg_n_97;
  wire T_r_reg_n_98;
  wire T_r_reg_n_99;
  wire \c_r[0]_i_1__2_n_0 ;
  wire \c_r[10]_i_1__2_n_0 ;
  wire \c_r[11]_i_1__2_n_0 ;
  wire \c_r[11]_i_2__2_n_0 ;
  wire \c_r[11]_i_3__2_n_0 ;
  wire \c_r[11]_i_4__2_n_0 ;
  wire \c_r[11]_i_5__2_n_0 ;
  wire \c_r[1]_i_1__2_n_0 ;
  wire \c_r[2]_i_1__2_n_0 ;
  wire \c_r[3]_i_1__2_n_0 ;
  wire \c_r[4]_i_1__2_n_0 ;
  wire \c_r[5]_i_1__2_n_0 ;
  wire \c_r[6]_i_1__2_n_0 ;
  wire \c_r[7]_i_1__2_n_0 ;
  wire \c_r[7]_i_2__2_n_0 ;
  wire \c_r[8]_i_1__2_n_0 ;
  wire \c_r[8]_i_2__2_n_0 ;
  wire \c_r[9]_i_1__2_n_0 ;
  wire clk_IBUF_BUFG;
  wire r_r_reg_n_100;
  wire r_r_reg_n_101;
  wire r_r_reg_n_102;
  wire r_r_reg_n_103;
  wire r_r_reg_n_104;
  wire r_r_reg_n_105;
  wire r_r_reg_n_93;
  wire r_r_reg_n_94;
  wire r_r_reg_n_95;
  wire r_r_reg_n_96;
  wire r_r_reg_n_97;
  wire r_r_reg_n_98;
  wire r_r_reg_n_99;
  wire NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_mu_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_mu_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:37]NLW_T_mu_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_mu_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_mu_r_reg_XOROUT_UNCONNECTED;
  wire NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:24]NLW_T_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_r_reg_XOROUT_UNCONNECTED;
  wire NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_r_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_r_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_r_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_r_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_r_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:13]NLW_r_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_r_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_r_r_reg_XOROUT_UNCONNECTED;

  (* KEEP_HIERARCHY = "yes" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-12 {cell *THIS*}}" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_mu_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_mu_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_mu_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_mu_r_reg_P_UNCONNECTED[47:37],T_mu_r_reg_n_69,T_mu_r_reg_n_70,T_mu_r_reg_n_71,T_mu_r_reg_n_72,T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81,T_mu_r_reg_n_82,T_mu_r_reg_n_83,T_mu_r_reg_n_84,T_mu_r_reg_n_85,T_mu_r_reg_n_86,T_mu_r_reg_n_87,T_mu_r_reg_n_88,T_mu_r_reg_n_89,T_mu_r_reg_n_90,T_mu_r_reg_n_91,T_mu_r_reg_n_92,T_mu_r_reg_n_93,T_mu_r_reg_n_94,T_mu_r_reg_n_95,T_mu_r_reg_n_96,T_mu_r_reg_n_97,T_mu_r_reg_n_98,T_mu_r_reg_n_99,T_mu_r_reg_n_100,T_mu_r_reg_n_101,T_mu_r_reg_n_102,T_mu_r_reg_n_103,T_mu_r_reg_n_104,T_mu_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_mu_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_mu_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,DOUTBDOUT}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b1),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_r_reg_P_UNCONNECTED[47:24],T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \c_r[0]_i_1__2 
       (.I0(\c_r[11]_i_2__2_n_0 ),
        .I1(r_r_reg_n_105),
        .O(\c_r[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT4 #(
    .INIT(16'h5DA2)) 
    \c_r[10]_i_1__2 
       (.I0(\c_r[11]_i_2__2_n_0 ),
        .I1(\c_r[11]_i_3__2_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .O(\c_r[10]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT5 #(
    .INIT(32'h5DFFA200)) 
    \c_r[11]_i_1__2 
       (.I0(\c_r[11]_i_2__2_n_0 ),
        .I1(\c_r[11]_i_3__2_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .I4(r_r_reg_n_94),
        .O(\c_r[11]_i_1__2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFE000)) 
    \c_r[11]_i_2__2 
       (.I0(\c_r[11]_i_4__2_n_0 ),
        .I1(r_r_reg_n_96),
        .I2(r_r_reg_n_95),
        .I3(r_r_reg_n_94),
        .I4(r_r_reg_n_93),
        .O(\c_r[11]_i_2__2_n_0 ));
  LUT5 #(
    .INIT(32'h55555557)) 
    \c_r[11]_i_3__2 
       (.I0(r_r_reg_n_97),
        .I1(r_r_reg_n_99),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .I4(\c_r[8]_i_2__2_n_0 ),
        .O(\c_r[11]_i_3__2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000000)) 
    \c_r[11]_i_4__2 
       (.I0(\c_r[11]_i_5__2_n_0 ),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_98),
        .I3(r_r_reg_n_99),
        .I4(r_r_reg_n_100),
        .I5(r_r_reg_n_97),
        .O(\c_r[11]_i_4__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \c_r[11]_i_5__2 
       (.I0(r_r_reg_n_101),
        .I1(r_r_reg_n_102),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_104),
        .O(\c_r[11]_i_5__2_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \c_r[1]_i_1__2 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2__2_n_0 ),
        .O(\c_r[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT4 #(
    .INIT(16'hEF10)) 
    \c_r[2]_i_1__2 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2__2_n_0 ),
        .I3(r_r_reg_n_103),
        .O(\c_r[2]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    \c_r[3]_i_1__2 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2__2_n_0 ),
        .O(\c_r[3]_i_1__2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFF00010000)) 
    \c_r[4]_i_1__2 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2__2_n_0 ),
        .I5(r_r_reg_n_101),
        .O(\c_r[4]_i_1__2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \c_r[5]_i_1__2 
       (.I0(r_r_reg_n_100),
        .I1(\c_r[7]_i_2__2_n_0 ),
        .O(\c_r[5]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \c_r[6]_i_1__2 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__2_n_0 ),
        .I2(r_r_reg_n_100),
        .O(\c_r[6]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT4 #(
    .INIT(16'hFE01)) 
    \c_r[7]_i_1__2 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__2_n_0 ),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .O(\c_r[7]_i_1__2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \c_r[7]_i_2__2 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_101),
        .I4(r_r_reg_n_102),
        .I5(\c_r[11]_i_2__2_n_0 ),
        .O(\c_r[7]_i_2__2_n_0 ));
  LUT6 #(
    .INIT(64'h0001FFFFFFFE0000)) 
    \c_r[8]_i_1__2 
       (.I0(\c_r[8]_i_2__2_n_0 ),
        .I1(r_r_reg_n_98),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_99),
        .I4(\c_r[11]_i_2__2_n_0 ),
        .I5(r_r_reg_n_97),
        .O(\c_r[8]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \c_r[8]_i_2__2 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_101),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_105),
        .I4(r_r_reg_n_104),
        .O(\c_r[8]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \c_r[9]_i_1__2 
       (.I0(\c_r[11]_i_2__2_n_0 ),
        .I1(\c_r[11]_i_3__2_n_0 ),
        .I2(r_r_reg_n_96),
        .O(\c_r[9]_i_1__2_n_0 ));
  FDRE \c_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[0]_i_1__2_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE \c_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[10]_i_1__2_n_0 ),
        .Q(Q[10]),
        .R(1'b0));
  FDRE \c_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[11]_i_1__2_n_0 ),
        .Q(Q[11]),
        .R(1'b0));
  FDRE \c_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[1]_i_1__2_n_0 ),
        .Q(Q[1]),
        .R(1'b0));
  FDRE \c_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[2]_i_1__2_n_0 ),
        .Q(Q[2]),
        .R(1'b0));
  FDRE \c_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[3]_i_1__2_n_0 ),
        .Q(Q[3]),
        .R(1'b0));
  FDRE \c_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[4]_i_1__2_n_0 ),
        .Q(Q[4]),
        .R(1'b0));
  FDRE \c_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[5]_i_1__2_n_0 ),
        .Q(Q[5]),
        .R(1'b0));
  FDRE \c_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[6]_i_1__2_n_0 ),
        .Q(Q[6]),
        .R(1'b0));
  FDRE \c_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[7]_i_1__2_n_0 ),
        .Q(Q[7]),
        .R(1'b0));
  FDRE \c_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[8]_i_1__2_n_0 ),
        .Q(Q[8]),
        .R(1'b0));
  FDRE \c_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[9]_i_1__2_n_0 ),
        .Q(Q[9]),
        .R(1'b0));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    r_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_mu_r_reg_n_69,T_mu_r_reg_n_70,T_mu_r_reg_n_71,T_mu_r_reg_n_72,T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_r_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b1,1'b1}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_r_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_r_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b1),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_r_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_r_r_reg_P_UNCONNECTED[47:13],r_r_reg_n_93,r_r_reg_n_94,r_r_reg_n_95,r_r_reg_n_96,r_r_reg_n_97,r_r_reg_n_98,r_r_reg_n_99,r_r_reg_n_100,r_r_reg_n_101,r_r_reg_n_102,r_r_reg_n_103,r_r_reg_n_104,r_r_reg_n_105}),
        .PATTERNBDETECT(NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_r_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_r_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_r_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_r_r_reg_XOROUT_UNCONNECTED[7:0]));
endmodule

(* ORIG_REF_NAME = "mod_mult" *) 
module mod_mult_2
   (Q,
    clk_IBUF_BUFG,
    B,
    A);
  output [11:0]Q;
  input clk_IBUF_BUFG;
  input [11:0]B;
  input [11:0]A;

  wire [11:0]A;
  wire [11:0]B;
  wire [11:0]Q;
  wire T_mu_r_reg_n_100;
  wire T_mu_r_reg_n_101;
  wire T_mu_r_reg_n_102;
  wire T_mu_r_reg_n_103;
  wire T_mu_r_reg_n_104;
  wire T_mu_r_reg_n_105;
  wire T_mu_r_reg_n_69;
  wire T_mu_r_reg_n_70;
  wire T_mu_r_reg_n_71;
  wire T_mu_r_reg_n_72;
  wire T_mu_r_reg_n_73;
  wire T_mu_r_reg_n_74;
  wire T_mu_r_reg_n_75;
  wire T_mu_r_reg_n_76;
  wire T_mu_r_reg_n_77;
  wire T_mu_r_reg_n_78;
  wire T_mu_r_reg_n_79;
  wire T_mu_r_reg_n_80;
  wire T_mu_r_reg_n_81;
  wire T_mu_r_reg_n_82;
  wire T_mu_r_reg_n_83;
  wire T_mu_r_reg_n_84;
  wire T_mu_r_reg_n_85;
  wire T_mu_r_reg_n_86;
  wire T_mu_r_reg_n_87;
  wire T_mu_r_reg_n_88;
  wire T_mu_r_reg_n_89;
  wire T_mu_r_reg_n_90;
  wire T_mu_r_reg_n_91;
  wire T_mu_r_reg_n_92;
  wire T_mu_r_reg_n_93;
  wire T_mu_r_reg_n_94;
  wire T_mu_r_reg_n_95;
  wire T_mu_r_reg_n_96;
  wire T_mu_r_reg_n_97;
  wire T_mu_r_reg_n_98;
  wire T_mu_r_reg_n_99;
  wire T_r_reg_n_100;
  wire T_r_reg_n_101;
  wire T_r_reg_n_102;
  wire T_r_reg_n_103;
  wire T_r_reg_n_104;
  wire T_r_reg_n_105;
  wire T_r_reg_n_82;
  wire T_r_reg_n_83;
  wire T_r_reg_n_84;
  wire T_r_reg_n_85;
  wire T_r_reg_n_86;
  wire T_r_reg_n_87;
  wire T_r_reg_n_88;
  wire T_r_reg_n_89;
  wire T_r_reg_n_90;
  wire T_r_reg_n_91;
  wire T_r_reg_n_92;
  wire T_r_reg_n_93;
  wire T_r_reg_n_94;
  wire T_r_reg_n_95;
  wire T_r_reg_n_96;
  wire T_r_reg_n_97;
  wire T_r_reg_n_98;
  wire T_r_reg_n_99;
  wire \c_r[0]_i_1__1_n_0 ;
  wire \c_r[10]_i_1__1_n_0 ;
  wire \c_r[11]_i_1__1_n_0 ;
  wire \c_r[11]_i_2__1_n_0 ;
  wire \c_r[11]_i_3__1_n_0 ;
  wire \c_r[11]_i_4__1_n_0 ;
  wire \c_r[11]_i_5__1_n_0 ;
  wire \c_r[1]_i_1__1_n_0 ;
  wire \c_r[2]_i_1__1_n_0 ;
  wire \c_r[3]_i_1__1_n_0 ;
  wire \c_r[4]_i_1__1_n_0 ;
  wire \c_r[5]_i_1__1_n_0 ;
  wire \c_r[6]_i_1__1_n_0 ;
  wire \c_r[7]_i_1__1_n_0 ;
  wire \c_r[7]_i_2__1_n_0 ;
  wire \c_r[8]_i_1__1_n_0 ;
  wire \c_r[8]_i_2__1_n_0 ;
  wire \c_r[9]_i_1__1_n_0 ;
  wire clk_IBUF_BUFG;
  wire r_r_reg_n_100;
  wire r_r_reg_n_101;
  wire r_r_reg_n_102;
  wire r_r_reg_n_103;
  wire r_r_reg_n_104;
  wire r_r_reg_n_105;
  wire r_r_reg_n_93;
  wire r_r_reg_n_94;
  wire r_r_reg_n_95;
  wire r_r_reg_n_96;
  wire r_r_reg_n_97;
  wire r_r_reg_n_98;
  wire r_r_reg_n_99;
  wire NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_mu_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_mu_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:37]NLW_T_mu_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_mu_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_mu_r_reg_XOROUT_UNCONNECTED;
  wire NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:24]NLW_T_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_r_reg_XOROUT_UNCONNECTED;
  wire NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_r_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_r_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_r_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_r_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_r_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:13]NLW_r_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_r_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_r_r_reg_XOROUT_UNCONNECTED;

  (* KEEP_HIERARCHY = "yes" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-12 {cell *THIS*}}" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_mu_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_mu_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_mu_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_mu_r_reg_P_UNCONNECTED[47:37],T_mu_r_reg_n_69,T_mu_r_reg_n_70,T_mu_r_reg_n_71,T_mu_r_reg_n_72,T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81,T_mu_r_reg_n_82,T_mu_r_reg_n_83,T_mu_r_reg_n_84,T_mu_r_reg_n_85,T_mu_r_reg_n_86,T_mu_r_reg_n_87,T_mu_r_reg_n_88,T_mu_r_reg_n_89,T_mu_r_reg_n_90,T_mu_r_reg_n_91,T_mu_r_reg_n_92,T_mu_r_reg_n_93,T_mu_r_reg_n_94,T_mu_r_reg_n_95,T_mu_r_reg_n_96,T_mu_r_reg_n_97,T_mu_r_reg_n_98,T_mu_r_reg_n_99,T_mu_r_reg_n_100,T_mu_r_reg_n_101,T_mu_r_reg_n_102,T_mu_r_reg_n_103,T_mu_r_reg_n_104,T_mu_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_mu_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_mu_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BMULTSEL("B"),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,A}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,B}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b1),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b1),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_r_reg_P_UNCONNECTED[47:24],T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \c_r[0]_i_1__1 
       (.I0(\c_r[11]_i_2__1_n_0 ),
        .I1(r_r_reg_n_105),
        .O(\c_r[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h5DA2)) 
    \c_r[10]_i_1__1 
       (.I0(\c_r[11]_i_2__1_n_0 ),
        .I1(\c_r[11]_i_3__1_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .O(\c_r[10]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h5DFFA200)) 
    \c_r[11]_i_1__1 
       (.I0(\c_r[11]_i_2__1_n_0 ),
        .I1(\c_r[11]_i_3__1_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .I4(r_r_reg_n_94),
        .O(\c_r[11]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFE000)) 
    \c_r[11]_i_2__1 
       (.I0(\c_r[11]_i_4__1_n_0 ),
        .I1(r_r_reg_n_96),
        .I2(r_r_reg_n_95),
        .I3(r_r_reg_n_94),
        .I4(r_r_reg_n_93),
        .O(\c_r[11]_i_2__1_n_0 ));
  LUT5 #(
    .INIT(32'h55555557)) 
    \c_r[11]_i_3__1 
       (.I0(r_r_reg_n_97),
        .I1(r_r_reg_n_99),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .I4(\c_r[8]_i_2__1_n_0 ),
        .O(\c_r[11]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000000)) 
    \c_r[11]_i_4__1 
       (.I0(\c_r[11]_i_5__1_n_0 ),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_98),
        .I3(r_r_reg_n_99),
        .I4(r_r_reg_n_100),
        .I5(r_r_reg_n_97),
        .O(\c_r[11]_i_4__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \c_r[11]_i_5__1 
       (.I0(r_r_reg_n_101),
        .I1(r_r_reg_n_102),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_104),
        .O(\c_r[11]_i_5__1_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \c_r[1]_i_1__1 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2__1_n_0 ),
        .O(\c_r[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'hEF10)) 
    \c_r[2]_i_1__1 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(\c_r[11]_i_2__1_n_0 ),
        .I3(r_r_reg_n_103),
        .O(\c_r[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    \c_r[3]_i_1__1 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2__1_n_0 ),
        .O(\c_r[3]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFF00010000)) 
    \c_r[4]_i_1__1 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(\c_r[11]_i_2__1_n_0 ),
        .I5(r_r_reg_n_101),
        .O(\c_r[4]_i_1__1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \c_r[5]_i_1__1 
       (.I0(r_r_reg_n_100),
        .I1(\c_r[7]_i_2__1_n_0 ),
        .O(\c_r[5]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \c_r[6]_i_1__1 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__1_n_0 ),
        .I2(r_r_reg_n_100),
        .O(\c_r[6]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'hFE01)) 
    \c_r[7]_i_1__1 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__1_n_0 ),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .O(\c_r[7]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \c_r[7]_i_2__1 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_101),
        .I4(r_r_reg_n_102),
        .I5(\c_r[11]_i_2__1_n_0 ),
        .O(\c_r[7]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'h0001FFFFFFFE0000)) 
    \c_r[8]_i_1__1 
       (.I0(\c_r[8]_i_2__1_n_0 ),
        .I1(r_r_reg_n_98),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_99),
        .I4(\c_r[11]_i_2__1_n_0 ),
        .I5(r_r_reg_n_97),
        .O(\c_r[8]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \c_r[8]_i_2__1 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_101),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_105),
        .I4(r_r_reg_n_104),
        .O(\c_r[8]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \c_r[9]_i_1__1 
       (.I0(\c_r[11]_i_2__1_n_0 ),
        .I1(\c_r[11]_i_3__1_n_0 ),
        .I2(r_r_reg_n_96),
        .O(\c_r[9]_i_1__1_n_0 ));
  FDRE \c_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[0]_i_1__1_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE \c_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[10]_i_1__1_n_0 ),
        .Q(Q[10]),
        .R(1'b0));
  FDRE \c_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[11]_i_1__1_n_0 ),
        .Q(Q[11]),
        .R(1'b0));
  FDRE \c_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[1]_i_1__1_n_0 ),
        .Q(Q[1]),
        .R(1'b0));
  FDRE \c_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[2]_i_1__1_n_0 ),
        .Q(Q[2]),
        .R(1'b0));
  FDRE \c_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[3]_i_1__1_n_0 ),
        .Q(Q[3]),
        .R(1'b0));
  FDRE \c_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[4]_i_1__1_n_0 ),
        .Q(Q[4]),
        .R(1'b0));
  FDRE \c_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[5]_i_1__1_n_0 ),
        .Q(Q[5]),
        .R(1'b0));
  FDRE \c_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[6]_i_1__1_n_0 ),
        .Q(Q[6]),
        .R(1'b0));
  FDRE \c_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[7]_i_1__1_n_0 ),
        .Q(Q[7]),
        .R(1'b0));
  FDRE \c_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[8]_i_1__1_n_0 ),
        .Q(Q[8]),
        .R(1'b0));
  FDRE \c_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[9]_i_1__1_n_0 ),
        .Q(Q[9]),
        .R(1'b0));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    r_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_mu_r_reg_n_69,T_mu_r_reg_n_70,T_mu_r_reg_n_71,T_mu_r_reg_n_72,T_mu_r_reg_n_73,T_mu_r_reg_n_74,T_mu_r_reg_n_75,T_mu_r_reg_n_76,T_mu_r_reg_n_77,T_mu_r_reg_n_78,T_mu_r_reg_n_79,T_mu_r_reg_n_80,T_mu_r_reg_n_81}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_r_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b1,1'b1}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_r_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_r_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b1),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_r_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_r_r_reg_P_UNCONNECTED[47:13],r_r_reg_n_93,r_r_reg_n_94,r_r_reg_n_95,r_r_reg_n_96,r_r_reg_n_97,r_r_reg_n_98,r_r_reg_n_99,r_r_reg_n_100,r_r_reg_n_101,r_r_reg_n_102,r_r_reg_n_103,r_r_reg_n_104,r_r_reg_n_105}),
        .PATTERNBDETECT(NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_r_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_r_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_r_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_r_r_reg_XOROUT_UNCONNECTED[7:0]));
endmodule

(* ORIG_REF_NAME = "mod_mult" *) 
module mod_mult_3
   (S,
    Q,
    DI,
    DINADIN,
    diff_carry__0,
    \c_r_reg[6]_0 ,
    \c_r_reg[9]_0 ,
    \c_r_reg[7]_0 ,
    clk_IBUF_BUFG,
    DOUTADOUT,
    DSP_ALU_INST,
    DOUTBDOUT,
    O,
    mem_reg_bram_0,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    mem_reg_bram_0_i_110);
  output [4:0]S;
  output [9:0]Q;
  output [0:0]DI;
  output [3:0]DINADIN;
  output diff_carry__0;
  output [6:0]\c_r_reg[6]_0 ;
  output [0:0]\c_r_reg[9]_0 ;
  output [6:0]\c_r_reg[7]_0 ;
  input clk_IBUF_BUFG;
  input [11:0]DOUTADOUT;
  input [11:0]DSP_ALU_INST;
  input [10:0]DOUTBDOUT;
  input [4:0]O;
  input [0:0]mem_reg_bram_0;
  input [3:0]mem_reg_bram_0_0;
  input mem_reg_bram_0_1;
  input [0:0]mem_reg_bram_0_i_110;

  wire [12:0]A;
  wire [0:0]DI;
  wire [3:0]DINADIN;
  wire [11:0]DOUTADOUT;
  wire [10:0]DOUTBDOUT;
  wire [11:0]DSP_ALU_INST;
  wire [4:0]O;
  wire [9:0]Q;
  wire [4:0]S;
  wire T_mu_r_reg_n_100;
  wire T_mu_r_reg_n_101;
  wire T_mu_r_reg_n_102;
  wire T_mu_r_reg_n_103;
  wire T_mu_r_reg_n_104;
  wire T_mu_r_reg_n_105;
  wire T_mu_r_reg_n_82;
  wire T_mu_r_reg_n_83;
  wire T_mu_r_reg_n_84;
  wire T_mu_r_reg_n_85;
  wire T_mu_r_reg_n_86;
  wire T_mu_r_reg_n_87;
  wire T_mu_r_reg_n_88;
  wire T_mu_r_reg_n_89;
  wire T_mu_r_reg_n_90;
  wire T_mu_r_reg_n_91;
  wire T_mu_r_reg_n_92;
  wire T_mu_r_reg_n_93;
  wire T_mu_r_reg_n_94;
  wire T_mu_r_reg_n_95;
  wire T_mu_r_reg_n_96;
  wire T_mu_r_reg_n_97;
  wire T_mu_r_reg_n_98;
  wire T_mu_r_reg_n_99;
  wire T_r_reg_n_100;
  wire T_r_reg_n_101;
  wire T_r_reg_n_102;
  wire T_r_reg_n_103;
  wire T_r_reg_n_104;
  wire T_r_reg_n_105;
  wire T_r_reg_n_82;
  wire T_r_reg_n_83;
  wire T_r_reg_n_84;
  wire T_r_reg_n_85;
  wire T_r_reg_n_86;
  wire T_r_reg_n_87;
  wire T_r_reg_n_88;
  wire T_r_reg_n_89;
  wire T_r_reg_n_90;
  wire T_r_reg_n_91;
  wire T_r_reg_n_92;
  wire T_r_reg_n_93;
  wire T_r_reg_n_94;
  wire T_r_reg_n_95;
  wire T_r_reg_n_96;
  wire T_r_reg_n_97;
  wire T_r_reg_n_98;
  wire T_r_reg_n_99;
  wire [9:7]b;
  wire c_r2;
  wire \c_r[0]_i_1__0_n_0 ;
  wire \c_r[10]_i_1__0_n_0 ;
  wire \c_r[11]_i_1__0_n_0 ;
  wire \c_r[11]_i_3__0_n_0 ;
  wire \c_r[11]_i_4__0_n_0 ;
  wire \c_r[11]_i_5__0_n_0 ;
  wire \c_r[1]_i_1__0_n_0 ;
  wire \c_r[2]_i_1__0_n_0 ;
  wire \c_r[3]_i_1__0_n_0 ;
  wire \c_r[4]_i_1__0_n_0 ;
  wire \c_r[5]_i_1__0_n_0 ;
  wire \c_r[6]_i_1__0_n_0 ;
  wire \c_r[7]_i_1__0_n_0 ;
  wire \c_r[7]_i_2__0_n_0 ;
  wire \c_r[8]_i_1__0_n_0 ;
  wire \c_r[8]_i_2__0_n_0 ;
  wire \c_r[9]_i_1__0_n_0 ;
  wire [6:0]\c_r_reg[6]_0 ;
  wire [6:0]\c_r_reg[7]_0 ;
  wire [0:0]\c_r_reg[9]_0 ;
  wire clk_IBUF_BUFG;
  wire diff_carry__0;
  wire [0:0]mem_reg_bram_0;
  wire [3:0]mem_reg_bram_0_0;
  wire mem_reg_bram_0_1;
  wire [0:0]mem_reg_bram_0_i_110;
  wire mem_reg_bram_0_i_84_n_0;
  wire mem_reg_bram_0_i_85_n_0;
  wire r_r_reg_n_100;
  wire r_r_reg_n_101;
  wire r_r_reg_n_102;
  wire r_r_reg_n_103;
  wire r_r_reg_n_104;
  wire r_r_reg_n_105;
  wire r_r_reg_n_93;
  wire r_r_reg_n_94;
  wire r_r_reg_n_95;
  wire r_r_reg_n_96;
  wire r_r_reg_n_97;
  wire r_r_reg_n_98;
  wire r_r_reg_n_99;
  wire NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_mu_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_mu_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:37]NLW_T_mu_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_mu_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_mu_r_reg_XOROUT_UNCONNECTED;
  wire NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_T_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_T_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_T_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_T_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_T_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_T_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:24]NLW_T_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_T_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_T_r_reg_XOROUT_UNCONNECTED;
  wire NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED;
  wire NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED;
  wire NLW_r_r_reg_OVERFLOW_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED;
  wire NLW_r_r_reg_PATTERNDETECT_UNCONNECTED;
  wire NLW_r_r_reg_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_r_r_reg_ACOUT_UNCONNECTED;
  wire [17:0]NLW_r_r_reg_BCOUT_UNCONNECTED;
  wire [3:0]NLW_r_r_reg_CARRYOUT_UNCONNECTED;
  wire [47:13]NLW_r_r_reg_P_UNCONNECTED;
  wire [47:0]NLW_r_r_reg_PCOUT_UNCONNECTED;
  wire [7:0]NLW_r_r_reg_XOROUT_UNCONNECTED;

  (* KEEP_HIERARCHY = "yes" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-12 {cell *THIS*}}" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_mu_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_mu_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b1,1'b1,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_mu_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_mu_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_mu_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_mu_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_mu_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_mu_r_reg_P_UNCONNECTED[47:37],A,T_mu_r_reg_n_82,T_mu_r_reg_n_83,T_mu_r_reg_n_84,T_mu_r_reg_n_85,T_mu_r_reg_n_86,T_mu_r_reg_n_87,T_mu_r_reg_n_88,T_mu_r_reg_n_89,T_mu_r_reg_n_90,T_mu_r_reg_n_91,T_mu_r_reg_n_92,T_mu_r_reg_n_93,T_mu_r_reg_n_94,T_mu_r_reg_n_95,T_mu_r_reg_n_96,T_mu_r_reg_n_97,T_mu_r_reg_n_98,T_mu_r_reg_n_99,T_mu_r_reg_n_100,T_mu_r_reg_n_101,T_mu_r_reg_n_102,T_mu_r_reg_n_103,T_mu_r_reg_n_104,T_mu_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_mu_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_mu_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_mu_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_mu_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_mu_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(1),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(1),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(1),
    .BMULTSEL("B"),
    .BREG(1),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    T_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,DSP_ALU_INST}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_T_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,DOUTADOUT}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_T_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_T_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_T_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b1),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b1),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_T_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_T_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_T_r_reg_P_UNCONNECTED[47:24],T_r_reg_n_82,T_r_reg_n_83,T_r_reg_n_84,T_r_reg_n_85,T_r_reg_n_86,T_r_reg_n_87,T_r_reg_n_88,T_r_reg_n_89,T_r_reg_n_90,T_r_reg_n_91,T_r_reg_n_92,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .PATTERNBDETECT(NLW_T_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_T_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_T_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_T_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_T_r_reg_XOROUT_UNCONNECTED[7:0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \c_r[0]_i_1__0 
       (.I0(c_r2),
        .I1(r_r_reg_n_105),
        .O(\c_r[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h5DA2)) 
    \c_r[10]_i_1__0 
       (.I0(c_r2),
        .I1(\c_r[11]_i_3__0_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .O(\c_r[10]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h5DFFA200)) 
    \c_r[11]_i_1__0 
       (.I0(c_r2),
        .I1(\c_r[11]_i_3__0_n_0 ),
        .I2(r_r_reg_n_96),
        .I3(r_r_reg_n_95),
        .I4(r_r_reg_n_94),
        .O(\c_r[11]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFE000)) 
    \c_r[11]_i_2__0 
       (.I0(\c_r[11]_i_4__0_n_0 ),
        .I1(r_r_reg_n_96),
        .I2(r_r_reg_n_95),
        .I3(r_r_reg_n_94),
        .I4(r_r_reg_n_93),
        .O(c_r2));
  LUT5 #(
    .INIT(32'h55555557)) 
    \c_r[11]_i_3__0 
       (.I0(r_r_reg_n_97),
        .I1(r_r_reg_n_99),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .I4(\c_r[8]_i_2__0_n_0 ),
        .O(\c_r[11]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000000)) 
    \c_r[11]_i_4__0 
       (.I0(\c_r[11]_i_5__0_n_0 ),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_98),
        .I3(r_r_reg_n_99),
        .I4(r_r_reg_n_100),
        .I5(r_r_reg_n_97),
        .O(\c_r[11]_i_4__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \c_r[11]_i_5__0 
       (.I0(r_r_reg_n_101),
        .I1(r_r_reg_n_102),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_104),
        .O(\c_r[11]_i_5__0_n_0 ));
  LUT3 #(
    .INIT(8'h9A)) 
    \c_r[1]_i_1__0 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(c_r2),
        .O(\c_r[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hEF10)) 
    \c_r[2]_i_1__0 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(c_r2),
        .I3(r_r_reg_n_103),
        .O(\c_r[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hAAA9AAAA)) 
    \c_r[3]_i_1__0 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(c_r2),
        .O(\c_r[3]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFF00010000)) 
    \c_r[4]_i_1__0 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_103),
        .I2(r_r_reg_n_105),
        .I3(r_r_reg_n_104),
        .I4(c_r2),
        .I5(r_r_reg_n_101),
        .O(\c_r[4]_i_1__0_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \c_r[5]_i_1__0 
       (.I0(r_r_reg_n_100),
        .I1(\c_r[7]_i_2__0_n_0 ),
        .O(\c_r[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \c_r[6]_i_1__0 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__0_n_0 ),
        .I2(r_r_reg_n_100),
        .O(\c_r[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFE01)) 
    \c_r[7]_i_1__0 
       (.I0(r_r_reg_n_99),
        .I1(\c_r[7]_i_2__0_n_0 ),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_98),
        .O(\c_r[7]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \c_r[7]_i_2__0 
       (.I0(r_r_reg_n_104),
        .I1(r_r_reg_n_105),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_101),
        .I4(r_r_reg_n_102),
        .I5(c_r2),
        .O(\c_r[7]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'h0001FFFFFFFE0000)) 
    \c_r[8]_i_1__0 
       (.I0(\c_r[8]_i_2__0_n_0 ),
        .I1(r_r_reg_n_98),
        .I2(r_r_reg_n_100),
        .I3(r_r_reg_n_99),
        .I4(c_r2),
        .I5(r_r_reg_n_97),
        .O(\c_r[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \c_r[8]_i_2__0 
       (.I0(r_r_reg_n_102),
        .I1(r_r_reg_n_101),
        .I2(r_r_reg_n_103),
        .I3(r_r_reg_n_105),
        .I4(r_r_reg_n_104),
        .O(\c_r[8]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \c_r[9]_i_1__0 
       (.I0(c_r2),
        .I1(\c_r[11]_i_3__0_n_0 ),
        .I2(r_r_reg_n_96),
        .O(\c_r[9]_i_1__0_n_0 ));
  FDRE \c_r_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[0]_i_1__0_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE \c_r_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[10]_i_1__0_n_0 ),
        .Q(Q[8]),
        .R(1'b0));
  FDRE \c_r_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[11]_i_1__0_n_0 ),
        .Q(Q[9]),
        .R(1'b0));
  FDRE \c_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[1]_i_1__0_n_0 ),
        .Q(Q[1]),
        .R(1'b0));
  FDRE \c_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[2]_i_1__0_n_0 ),
        .Q(Q[2]),
        .R(1'b0));
  FDRE \c_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[3]_i_1__0_n_0 ),
        .Q(Q[3]),
        .R(1'b0));
  FDRE \c_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[4]_i_1__0_n_0 ),
        .Q(Q[4]),
        .R(1'b0));
  FDRE \c_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[5]_i_1__0_n_0 ),
        .Q(Q[5]),
        .R(1'b0));
  FDRE \c_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[6]_i_1__0_n_0 ),
        .Q(Q[6]),
        .R(1'b0));
  FDRE \c_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[7]_i_1__0_n_0 ),
        .Q(b[7]),
        .R(1'b0));
  FDRE \c_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[8]_i_1__0_n_0 ),
        .Q(Q[7]),
        .R(1'b0));
  FDRE \c_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\c_r[9]_i_1__0_n_0 ),
        .Q(b[9]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    diff_carry__0_i_5
       (.I0(Q[9]),
        .I1(DOUTBDOUT[10]),
        .O(S[4]));
  LUT4 #(
    .INIT(16'hD22D)) 
    diff_carry__0_i_6
       (.I0(Q[8]),
        .I1(DOUTBDOUT[9]),
        .I2(Q[9]),
        .I3(DOUTBDOUT[10]),
        .O(S[3]));
  LUT4 #(
    .INIT(16'h6966)) 
    diff_carry__0_i_7
       (.I0(Q[8]),
        .I1(DOUTBDOUT[9]),
        .I2(b[9]),
        .I3(DOUTBDOUT[8]),
        .O(S[2]));
  LUT4 #(
    .INIT(16'h2DD2)) 
    diff_carry__0_i_8
       (.I0(Q[7]),
        .I1(DOUTBDOUT[7]),
        .I2(b[9]),
        .I3(DOUTBDOUT[8]),
        .O(S[1]));
  LUT4 #(
    .INIT(16'h6966)) 
    diff_carry__0_i_9
       (.I0(Q[7]),
        .I1(DOUTBDOUT[7]),
        .I2(b[7]),
        .I3(DOUTBDOUT[6]),
        .O(S[0]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_10
       (.I0(Q[3]),
        .I1(DOUTBDOUT[2]),
        .I2(Q[4]),
        .I3(DOUTBDOUT[3]),
        .O(\c_r_reg[6]_0 [3]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_11
       (.I0(Q[2]),
        .I1(DOUTBDOUT[1]),
        .I2(Q[3]),
        .I3(DOUTBDOUT[2]),
        .O(\c_r_reg[6]_0 [2]));
  LUT3 #(
    .INIT(8'h96)) 
    diff_carry_i_12__0
       (.I0(Q[1]),
        .I1(Q[2]),
        .I2(DOUTBDOUT[1]),
        .O(\c_r_reg[6]_0 [1]));
  LUT2 #(
    .INIT(4'h6)) 
    diff_carry_i_13
       (.I0(Q[1]),
        .I1(DOUTBDOUT[0]),
        .O(\c_r_reg[6]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    diff_carry_i_6
       (.I0(Q[1]),
        .O(DI));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_7
       (.I0(Q[6]),
        .I1(DOUTBDOUT[5]),
        .I2(b[7]),
        .I3(DOUTBDOUT[6]),
        .O(\c_r_reg[6]_0 [6]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_8
       (.I0(Q[5]),
        .I1(DOUTBDOUT[4]),
        .I2(Q[6]),
        .I3(DOUTBDOUT[5]),
        .O(\c_r_reg[6]_0 [5]));
  LUT4 #(
    .INIT(16'hB44B)) 
    diff_carry_i_9
       (.I0(Q[4]),
        .I1(DOUTBDOUT[3]),
        .I2(Q[5]),
        .I3(DOUTBDOUT[4]),
        .O(\c_r_reg[6]_0 [4]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_166
       (.I0(b[7]),
        .I1(DOUTBDOUT[6]),
        .O(\c_r_reg[7]_0 [6]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_167
       (.I0(Q[6]),
        .I1(DOUTBDOUT[5]),
        .O(\c_r_reg[7]_0 [5]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_168
       (.I0(Q[5]),
        .I1(DOUTBDOUT[4]),
        .O(\c_r_reg[7]_0 [4]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_169
       (.I0(Q[4]),
        .I1(DOUTBDOUT[3]),
        .O(\c_r_reg[7]_0 [3]));
  LUT6 #(
    .INIT(64'hCC2CFFFFCC2C0000)) 
    mem_reg_bram_0_i_17
       (.I0(O[4]),
        .I1(O[3]),
        .I2(O[2]),
        .I3(mem_reg_bram_0_i_84_n_0),
        .I4(mem_reg_bram_0),
        .I5(mem_reg_bram_0_0[3]),
        .O(DINADIN[3]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_170
       (.I0(Q[3]),
        .I1(DOUTBDOUT[2]),
        .O(\c_r_reg[7]_0 [2]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_171
       (.I0(Q[2]),
        .I1(DOUTBDOUT[1]),
        .O(\c_r_reg[7]_0 [1]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_173
       (.I0(Q[0]),
        .I1(mem_reg_bram_0_i_110),
        .O(\c_r_reg[7]_0 [0]));
  LUT4 #(
    .INIT(16'h6F60)) 
    mem_reg_bram_0_i_18
       (.I0(O[2]),
        .I1(mem_reg_bram_0_i_85_n_0),
        .I2(mem_reg_bram_0),
        .I3(mem_reg_bram_0_0[2]),
        .O(DINADIN[2]));
  LUT6 #(
    .INIT(64'h99A9FFFF99A90000)) 
    mem_reg_bram_0_i_19
       (.I0(O[1]),
        .I1(diff_carry__0),
        .I2(O[0]),
        .I3(mem_reg_bram_0_1),
        .I4(mem_reg_bram_0),
        .I5(mem_reg_bram_0_0[1]),
        .O(DINADIN[1]));
  LUT2 #(
    .INIT(4'h6)) 
    mem_reg_bram_0_i_190
       (.I0(b[9]),
        .I1(DOUTBDOUT[8]),
        .O(\c_r_reg[9]_0 ));
  LUT5 #(
    .INIT(32'hA9FFA900)) 
    mem_reg_bram_0_i_20
       (.I0(O[0]),
        .I1(diff_carry__0),
        .I2(mem_reg_bram_0_1),
        .I3(mem_reg_bram_0),
        .I4(mem_reg_bram_0_0[0]),
        .O(DINADIN[0]));
  LUT3 #(
    .INIT(8'h45)) 
    mem_reg_bram_0_i_84
       (.I0(O[1]),
        .I1(mem_reg_bram_0_1),
        .I2(O[0]),
        .O(mem_reg_bram_0_i_84_n_0));
  LUT6 #(
    .INIT(64'hF2F2F2F2F2000000)) 
    mem_reg_bram_0_i_85
       (.I0(O[0]),
        .I1(mem_reg_bram_0_1),
        .I2(O[1]),
        .I3(O[2]),
        .I4(O[3]),
        .I5(O[4]),
        .O(mem_reg_bram_0_i_85_n_0));
  LUT6 #(
    .INIT(64'h1555151515551555)) 
    mem_reg_bram_0_i_86
       (.I0(O[4]),
        .I1(O[3]),
        .I2(O[2]),
        .I3(O[1]),
        .I4(mem_reg_bram_0_1),
        .I5(O[0]),
        .O(diff_carry__0));
  (* KEEP_HIERARCHY = "yes" *) 
  DSP48E2 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AMULTSEL("A"),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .AUTORESET_PRIORITY("RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BMULTSEL("B"),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREADDINSEL("A"),
    .PREG(1),
    .RND(48'h000000000000),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48"),
    .USE_WIDEXOR("FALSE"),
    .XORSIMD("XOR24_48_96")) 
    r_r_reg
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,A}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_r_r_reg_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b1,1'b1}),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_r_r_reg_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,T_r_reg_n_93,T_r_reg_n_94,T_r_reg_n_95,T_r_reg_n_96,T_r_reg_n_97,T_r_reg_n_98,T_r_reg_n_99,T_r_reg_n_100,T_r_reg_n_101,T_r_reg_n_102,T_r_reg_n_103,T_r_reg_n_104,T_r_reg_n_105}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_r_r_reg_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_r_r_reg_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b1),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b1),
        .CLK(clk_IBUF_BUFG),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_r_r_reg_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_r_r_reg_OVERFLOW_UNCONNECTED),
        .P({NLW_r_r_reg_P_UNCONNECTED[47:13],r_r_reg_n_93,r_r_reg_n_94,r_r_reg_n_95,r_r_reg_n_96,r_r_reg_n_97,r_r_reg_n_98,r_r_reg_n_99,r_r_reg_n_100,r_r_reg_n_101,r_r_reg_n_102,r_r_reg_n_103,r_r_reg_n_104,r_r_reg_n_105}),
        .PATTERNBDETECT(NLW_r_r_reg_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_r_r_reg_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_r_r_reg_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_r_r_reg_UNDERFLOW_UNCONNECTED),
        .XOROUT(NLW_r_r_reg_XOROUT_UNCONNECTED[7:0]));
endmodule

module mod_sub
   (O,
    B,
    mem_reg_bram_0,
    DI,
    S,
    T_r_reg_i_27,
    T_r_reg_i_27_0,
    DSP_A_B_DATA_INST);
  output [4:0]O;
  output [7:0]B;
  output mem_reg_bram_0;
  input [7:0]DI;
  input [7:0]S;
  input [3:0]T_r_reg_i_27;
  input [4:0]T_r_reg_i_27_0;
  input DSP_A_B_DATA_INST;

  wire [7:0]B;
  wire [7:0]DI;
  wire DSP_A_B_DATA_INST;
  wire [4:0]O;
  wire [7:0]S;
  wire T_r_reg_i_26_n_0;
  wire [3:0]T_r_reg_i_27;
  wire [4:0]T_r_reg_i_27_0;
  wire T_r_reg_i_28_n_0;
  wire diff_carry__0_n_4;
  wire diff_carry__0_n_5;
  wire diff_carry__0_n_6;
  wire diff_carry__0_n_7;
  wire diff_carry_n_0;
  wire diff_carry_n_1;
  wire diff_carry_n_10;
  wire diff_carry_n_11;
  wire diff_carry_n_12;
  wire diff_carry_n_13;
  wire diff_carry_n_14;
  wire diff_carry_n_15;
  wire diff_carry_n_2;
  wire diff_carry_n_3;
  wire diff_carry_n_4;
  wire diff_carry_n_5;
  wire diff_carry_n_6;
  wire diff_carry_n_7;
  wire diff_carry_n_8;
  wire diff_carry_n_9;
  wire mem_reg_bram_0;
  wire [7:4]NLW_diff_carry__0_CO_UNCONNECTED;
  wire [7:5]NLW_diff_carry__0_O_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hAAA9)) 
    T_r_reg_i_10
       (.I0(diff_carry_n_13),
        .I1(diff_carry_n_14),
        .I2(diff_carry_n_15),
        .I3(DSP_A_B_DATA_INST),
        .O(B[2]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    T_r_reg_i_11
       (.I0(diff_carry_n_14),
        .I1(DSP_A_B_DATA_INST),
        .I2(diff_carry_n_15),
        .O(B[1]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT2 #(
    .INIT(4'h9)) 
    T_r_reg_i_12
       (.I0(diff_carry_n_15),
        .I1(DSP_A_B_DATA_INST),
        .O(B[0]));
  LUT5 #(
    .INIT(32'h00000001)) 
    T_r_reg_i_25
       (.I0(diff_carry_n_15),
        .I1(diff_carry_n_8),
        .I2(diff_carry_n_9),
        .I3(diff_carry_n_10),
        .I4(T_r_reg_i_28_n_0),
        .O(mem_reg_bram_0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    T_r_reg_i_26
       (.I0(diff_carry_n_13),
        .I1(DSP_A_B_DATA_INST),
        .I2(diff_carry_n_15),
        .I3(diff_carry_n_14),
        .I4(diff_carry_n_12),
        .I5(diff_carry_n_11),
        .O(T_r_reg_i_26_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    T_r_reg_i_28
       (.I0(diff_carry_n_12),
        .I1(diff_carry_n_11),
        .I2(diff_carry_n_14),
        .I3(diff_carry_n_13),
        .O(T_r_reg_i_28_n_0));
  LUT6 #(
    .INIT(64'hEF00FFFFEF00EF00)) 
    T_r_reg_i_5
       (.I0(diff_carry_n_10),
        .I1(diff_carry_n_9),
        .I2(T_r_reg_i_26_n_0),
        .I3(diff_carry_n_8),
        .I4(DSP_A_B_DATA_INST),
        .I5(mem_reg_bram_0),
        .O(B[7]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h9A)) 
    T_r_reg_i_6
       (.I0(diff_carry_n_9),
        .I1(diff_carry_n_10),
        .I2(T_r_reg_i_26_n_0),
        .O(B[6]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h6)) 
    T_r_reg_i_7
       (.I0(diff_carry_n_10),
        .I1(T_r_reg_i_26_n_0),
        .O(B[5]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAAAA9)) 
    T_r_reg_i_8
       (.I0(diff_carry_n_11),
        .I1(diff_carry_n_12),
        .I2(diff_carry_n_14),
        .I3(diff_carry_n_15),
        .I4(DSP_A_B_DATA_INST),
        .I5(diff_carry_n_13),
        .O(B[4]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'hAAAAAAA9)) 
    T_r_reg_i_9
       (.I0(diff_carry_n_12),
        .I1(diff_carry_n_13),
        .I2(DSP_A_B_DATA_INST),
        .I3(diff_carry_n_15),
        .I4(diff_carry_n_14),
        .O(B[3]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 diff_carry
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({diff_carry_n_0,diff_carry_n_1,diff_carry_n_2,diff_carry_n_3,diff_carry_n_4,diff_carry_n_5,diff_carry_n_6,diff_carry_n_7}),
        .DI(DI),
        .O({diff_carry_n_8,diff_carry_n_9,diff_carry_n_10,diff_carry_n_11,diff_carry_n_12,diff_carry_n_13,diff_carry_n_14,diff_carry_n_15}),
        .S(S));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 diff_carry__0
       (.CI(diff_carry_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_diff_carry__0_CO_UNCONNECTED[7:4],diff_carry__0_n_4,diff_carry__0_n_5,diff_carry__0_n_6,diff_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,T_r_reg_i_27}),
        .O({NLW_diff_carry__0_O_UNCONNECTED[7:5],O}),
        .S({1'b0,1'b0,1'b0,T_r_reg_i_27_0}));
endmodule

(* ORIG_REF_NAME = "mod_sub" *) 
module mod_sub_4
   (O,
    DINADIN,
    \c_r_reg[1] ,
    DI,
    S,
    mem_reg_bram_0,
    mem_reg_bram_0_0,
    mem_reg_bram_0_1,
    mem_reg_bram_0_2,
    mem_reg_bram_0_3);
  output [4:0]O;
  output [7:0]DINADIN;
  output \c_r_reg[1] ;
  input [7:0]DI;
  input [7:0]S;
  input [3:0]mem_reg_bram_0;
  input [4:0]mem_reg_bram_0_0;
  input mem_reg_bram_0_1;
  input [0:0]mem_reg_bram_0_2;
  input [7:0]mem_reg_bram_0_3;

  wire [7:0]DI;
  wire [7:0]DINADIN;
  wire [4:0]O;
  wire [7:0]S;
  wire \c_r_reg[1] ;
  wire diff_carry__0_n_4;
  wire diff_carry__0_n_5;
  wire diff_carry__0_n_6;
  wire diff_carry__0_n_7;
  wire diff_carry_n_0;
  wire diff_carry_n_1;
  wire diff_carry_n_10;
  wire diff_carry_n_11;
  wire diff_carry_n_12;
  wire diff_carry_n_13;
  wire diff_carry_n_14;
  wire diff_carry_n_15;
  wire diff_carry_n_2;
  wire diff_carry_n_3;
  wire diff_carry_n_4;
  wire diff_carry_n_5;
  wire diff_carry_n_6;
  wire diff_carry_n_7;
  wire diff_carry_n_8;
  wire diff_carry_n_9;
  wire [3:0]mem_reg_bram_0;
  wire [4:0]mem_reg_bram_0_0;
  wire mem_reg_bram_0_1;
  wire [0:0]mem_reg_bram_0_2;
  wire [7:0]mem_reg_bram_0_3;
  wire mem_reg_bram_0_i_143_n_0;
  wire mem_reg_bram_0_i_88_n_0;
  wire mem_reg_bram_0_i_89_n_0;
  wire mem_reg_bram_0_i_90_n_0;
  wire [7:4]NLW_diff_carry__0_CO_UNCONNECTED;
  wire [7:5]NLW_diff_carry__0_O_UNCONNECTED;

  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 diff_carry
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({diff_carry_n_0,diff_carry_n_1,diff_carry_n_2,diff_carry_n_3,diff_carry_n_4,diff_carry_n_5,diff_carry_n_6,diff_carry_n_7}),
        .DI(DI),
        .O({diff_carry_n_8,diff_carry_n_9,diff_carry_n_10,diff_carry_n_11,diff_carry_n_12,diff_carry_n_13,diff_carry_n_14,diff_carry_n_15}),
        .S(S));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 diff_carry__0
       (.CI(diff_carry_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_diff_carry__0_CO_UNCONNECTED[7:4],diff_carry__0_n_4,diff_carry__0_n_5,diff_carry__0_n_6,diff_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,mem_reg_bram_0}),
        .O({NLW_diff_carry__0_O_UNCONNECTED[7:5],O}),
        .S({1'b0,1'b0,1'b0,mem_reg_bram_0_0}));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'hE)) 
    mem_reg_bram_0_i_143
       (.I0(diff_carry_n_11),
        .I1(diff_carry_n_12),
        .O(mem_reg_bram_0_i_143_n_0));
  LUT6 #(
    .INIT(64'h9CCCFFFF9CCC0000)) 
    mem_reg_bram_0_i_21
       (.I0(mem_reg_bram_0_1),
        .I1(diff_carry_n_8),
        .I2(mem_reg_bram_0_i_88_n_0),
        .I3(mem_reg_bram_0_i_89_n_0),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_3[7]),
        .O(DINADIN[7]));
  LUT6 #(
    .INIT(64'hC9CCFFFFC9CC0000)) 
    mem_reg_bram_0_i_22
       (.I0(mem_reg_bram_0_1),
        .I1(diff_carry_n_9),
        .I2(diff_carry_n_10),
        .I3(mem_reg_bram_0_i_88_n_0),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_3[6]),
        .O(DINADIN[6]));
  LUT6 #(
    .INIT(64'hA9AAFFFFA9AA0000)) 
    mem_reg_bram_0_i_23
       (.I0(diff_carry_n_10),
        .I1(diff_carry_n_11),
        .I2(diff_carry_n_12),
        .I3(mem_reg_bram_0_i_90_n_0),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_3[5]),
        .O(DINADIN[5]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h9AFF9A00)) 
    mem_reg_bram_0_i_24
       (.I0(diff_carry_n_11),
        .I1(diff_carry_n_12),
        .I2(mem_reg_bram_0_i_90_n_0),
        .I3(mem_reg_bram_0_2),
        .I4(mem_reg_bram_0_3[4]),
        .O(DINADIN[4]));
  LUT4 #(
    .INIT(16'h6F60)) 
    mem_reg_bram_0_i_25
       (.I0(diff_carry_n_12),
        .I1(mem_reg_bram_0_i_90_n_0),
        .I2(mem_reg_bram_0_2),
        .I3(mem_reg_bram_0_3[3]),
        .O(DINADIN[3]));
  LUT6 #(
    .INIT(64'hAAA9FFFFAAA90000)) 
    mem_reg_bram_0_i_26
       (.I0(diff_carry_n_13),
        .I1(diff_carry_n_14),
        .I2(diff_carry_n_15),
        .I3(mem_reg_bram_0_1),
        .I4(mem_reg_bram_0_2),
        .I5(mem_reg_bram_0_3[2]),
        .O(DINADIN[2]));
  LUT5 #(
    .INIT(32'hA9FFA900)) 
    mem_reg_bram_0_i_27
       (.I0(diff_carry_n_14),
        .I1(mem_reg_bram_0_1),
        .I2(diff_carry_n_15),
        .I3(mem_reg_bram_0_2),
        .I4(mem_reg_bram_0_3[1]),
        .O(DINADIN[1]));
  LUT4 #(
    .INIT(16'h9F90)) 
    mem_reg_bram_0_i_28
       (.I0(diff_carry_n_15),
        .I1(mem_reg_bram_0_1),
        .I2(mem_reg_bram_0_2),
        .I3(mem_reg_bram_0_3[0]),
        .O(DINADIN[0]));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    mem_reg_bram_0_i_87
       (.I0(diff_carry_n_15),
        .I1(diff_carry_n_8),
        .I2(mem_reg_bram_0_i_89_n_0),
        .I3(mem_reg_bram_0_i_143_n_0),
        .I4(diff_carry_n_13),
        .I5(diff_carry_n_14),
        .O(\c_r_reg[1] ));
  LUT5 #(
    .INIT(32'h00000001)) 
    mem_reg_bram_0_i_88
       (.I0(diff_carry_n_12),
        .I1(diff_carry_n_11),
        .I2(diff_carry_n_15),
        .I3(diff_carry_n_14),
        .I4(diff_carry_n_13),
        .O(mem_reg_bram_0_i_88_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    mem_reg_bram_0_i_89
       (.I0(diff_carry_n_9),
        .I1(diff_carry_n_10),
        .O(mem_reg_bram_0_i_89_n_0));
  LUT4 #(
    .INIT(16'h0001)) 
    mem_reg_bram_0_i_90
       (.I0(diff_carry_n_14),
        .I1(diff_carry_n_15),
        .I2(mem_reg_bram_0_1),
        .I3(diff_carry_n_13),
        .O(mem_reg_bram_0_i_90_n_0));
endmodule

module twiddle_rom
   (\k_r_reg_rep[6] ,
    DSP_A_B_DATA_INST,
    DSP_A_B_DATA_INST_0,
    DSP_A_B_DATA_INST_1,
    DSP_A_B_DATA_INST_2,
    DSP_A_B_DATA_INST_3,
    DSP_A_B_DATA_INST_4,
    DSP_A_B_DATA_INST_5,
    DSP_A_B_DATA_INST_6,
    DSP_A_B_DATA_INST_7,
    DSP_A_B_DATA_INST_8,
    DSP_A_B_DATA_INST_9,
    DSP_A_B_DATA_INST_10,
    DSP_A_B_DATA_INST_11,
    DSP_A_B_DATA_INST_12,
    DSP_A_B_DATA_INST_13,
    DSP_A_B_DATA_INST_14,
    DSP_A_B_DATA_INST_15,
    DSP_A_B_DATA_INST_16,
    DSP_A_B_DATA_INST_17,
    DSP_A_B_DATA_INST_18,
    DSP_A_B_DATA_INST_19,
    DSP_A_B_DATA_INST_20,
    DSP_A_B_DATA_INST_21,
    DSP_A_B_DATA_INST_22,
    DSP_A_B_DATA_INST_23);
  output [11:0]\k_r_reg_rep[6] ;
  input [0:0]DSP_A_B_DATA_INST;
  input DSP_A_B_DATA_INST_0;
  input DSP_A_B_DATA_INST_1;
  input DSP_A_B_DATA_INST_2;
  input DSP_A_B_DATA_INST_3;
  input DSP_A_B_DATA_INST_4;
  input DSP_A_B_DATA_INST_5;
  input DSP_A_B_DATA_INST_6;
  input DSP_A_B_DATA_INST_7;
  input DSP_A_B_DATA_INST_8;
  input DSP_A_B_DATA_INST_9;
  input DSP_A_B_DATA_INST_10;
  input DSP_A_B_DATA_INST_11;
  input DSP_A_B_DATA_INST_12;
  input DSP_A_B_DATA_INST_13;
  input DSP_A_B_DATA_INST_14;
  input DSP_A_B_DATA_INST_15;
  input DSP_A_B_DATA_INST_16;
  input DSP_A_B_DATA_INST_17;
  input DSP_A_B_DATA_INST_18;
  input DSP_A_B_DATA_INST_19;
  input DSP_A_B_DATA_INST_20;
  input DSP_A_B_DATA_INST_21;
  input DSP_A_B_DATA_INST_22;
  input DSP_A_B_DATA_INST_23;

  wire [0:0]DSP_A_B_DATA_INST;
  wire DSP_A_B_DATA_INST_0;
  wire DSP_A_B_DATA_INST_1;
  wire DSP_A_B_DATA_INST_10;
  wire DSP_A_B_DATA_INST_11;
  wire DSP_A_B_DATA_INST_12;
  wire DSP_A_B_DATA_INST_13;
  wire DSP_A_B_DATA_INST_14;
  wire DSP_A_B_DATA_INST_15;
  wire DSP_A_B_DATA_INST_16;
  wire DSP_A_B_DATA_INST_17;
  wire DSP_A_B_DATA_INST_18;
  wire DSP_A_B_DATA_INST_19;
  wire DSP_A_B_DATA_INST_2;
  wire DSP_A_B_DATA_INST_20;
  wire DSP_A_B_DATA_INST_21;
  wire DSP_A_B_DATA_INST_22;
  wire DSP_A_B_DATA_INST_23;
  wire DSP_A_B_DATA_INST_3;
  wire DSP_A_B_DATA_INST_4;
  wire DSP_A_B_DATA_INST_5;
  wire DSP_A_B_DATA_INST_6;
  wire DSP_A_B_DATA_INST_7;
  wire DSP_A_B_DATA_INST_8;
  wire DSP_A_B_DATA_INST_9;
  wire [11:0]\k_r_reg_rep[6] ;

  MUXF7 T_r_reg_i_1
       (.I0(DSP_A_B_DATA_INST_22),
        .I1(DSP_A_B_DATA_INST_23),
        .O(\k_r_reg_rep[6] [11]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_10
       (.I0(DSP_A_B_DATA_INST_4),
        .I1(DSP_A_B_DATA_INST_5),
        .O(\k_r_reg_rep[6] [2]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_11
       (.I0(DSP_A_B_DATA_INST_2),
        .I1(DSP_A_B_DATA_INST_3),
        .O(\k_r_reg_rep[6] [1]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_12
       (.I0(DSP_A_B_DATA_INST_0),
        .I1(DSP_A_B_DATA_INST_1),
        .O(\k_r_reg_rep[6] [0]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_2
       (.I0(DSP_A_B_DATA_INST_20),
        .I1(DSP_A_B_DATA_INST_21),
        .O(\k_r_reg_rep[6] [10]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_3
       (.I0(DSP_A_B_DATA_INST_18),
        .I1(DSP_A_B_DATA_INST_19),
        .O(\k_r_reg_rep[6] [9]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_4
       (.I0(DSP_A_B_DATA_INST_16),
        .I1(DSP_A_B_DATA_INST_17),
        .O(\k_r_reg_rep[6] [8]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_5
       (.I0(DSP_A_B_DATA_INST_14),
        .I1(DSP_A_B_DATA_INST_15),
        .O(\k_r_reg_rep[6] [7]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_6
       (.I0(DSP_A_B_DATA_INST_12),
        .I1(DSP_A_B_DATA_INST_13),
        .O(\k_r_reg_rep[6] [6]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_7
       (.I0(DSP_A_B_DATA_INST_10),
        .I1(DSP_A_B_DATA_INST_11),
        .O(\k_r_reg_rep[6] [5]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_8
       (.I0(DSP_A_B_DATA_INST_8),
        .I1(DSP_A_B_DATA_INST_9),
        .O(\k_r_reg_rep[6] [4]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_9
       (.I0(DSP_A_B_DATA_INST_6),
        .I1(DSP_A_B_DATA_INST_7),
        .O(\k_r_reg_rep[6] [3]),
        .S(DSP_A_B_DATA_INST));
endmodule

(* ORIG_REF_NAME = "twiddle_rom" *) 
module twiddle_rom_0
   (A,
    DSP_A_B_DATA_INST,
    DSP_A_B_DATA_INST_0,
    DSP_A_B_DATA_INST_1,
    DSP_A_B_DATA_INST_2,
    DSP_A_B_DATA_INST_3,
    DSP_A_B_DATA_INST_4,
    DSP_A_B_DATA_INST_5,
    DSP_A_B_DATA_INST_6,
    DSP_A_B_DATA_INST_7,
    DSP_A_B_DATA_INST_8,
    DSP_A_B_DATA_INST_9,
    DSP_A_B_DATA_INST_10,
    DSP_A_B_DATA_INST_11,
    DSP_A_B_DATA_INST_12,
    DSP_A_B_DATA_INST_13,
    DSP_A_B_DATA_INST_14,
    DSP_A_B_DATA_INST_15,
    DSP_A_B_DATA_INST_16,
    DSP_A_B_DATA_INST_17,
    DSP_A_B_DATA_INST_18,
    DSP_A_B_DATA_INST_19,
    DSP_A_B_DATA_INST_20,
    DSP_A_B_DATA_INST_21,
    DSP_A_B_DATA_INST_22,
    DSP_A_B_DATA_INST_23);
  output [11:0]A;
  input [0:0]DSP_A_B_DATA_INST;
  input DSP_A_B_DATA_INST_0;
  input DSP_A_B_DATA_INST_1;
  input DSP_A_B_DATA_INST_2;
  input DSP_A_B_DATA_INST_3;
  input DSP_A_B_DATA_INST_4;
  input DSP_A_B_DATA_INST_5;
  input DSP_A_B_DATA_INST_6;
  input DSP_A_B_DATA_INST_7;
  input DSP_A_B_DATA_INST_8;
  input DSP_A_B_DATA_INST_9;
  input DSP_A_B_DATA_INST_10;
  input DSP_A_B_DATA_INST_11;
  input DSP_A_B_DATA_INST_12;
  input DSP_A_B_DATA_INST_13;
  input DSP_A_B_DATA_INST_14;
  input DSP_A_B_DATA_INST_15;
  input DSP_A_B_DATA_INST_16;
  input DSP_A_B_DATA_INST_17;
  input DSP_A_B_DATA_INST_18;
  input DSP_A_B_DATA_INST_19;
  input DSP_A_B_DATA_INST_20;
  input DSP_A_B_DATA_INST_21;
  input DSP_A_B_DATA_INST_22;
  input DSP_A_B_DATA_INST_23;

  wire [11:0]A;
  wire [0:0]DSP_A_B_DATA_INST;
  wire DSP_A_B_DATA_INST_0;
  wire DSP_A_B_DATA_INST_1;
  wire DSP_A_B_DATA_INST_10;
  wire DSP_A_B_DATA_INST_11;
  wire DSP_A_B_DATA_INST_12;
  wire DSP_A_B_DATA_INST_13;
  wire DSP_A_B_DATA_INST_14;
  wire DSP_A_B_DATA_INST_15;
  wire DSP_A_B_DATA_INST_16;
  wire DSP_A_B_DATA_INST_17;
  wire DSP_A_B_DATA_INST_18;
  wire DSP_A_B_DATA_INST_19;
  wire DSP_A_B_DATA_INST_2;
  wire DSP_A_B_DATA_INST_20;
  wire DSP_A_B_DATA_INST_21;
  wire DSP_A_B_DATA_INST_22;
  wire DSP_A_B_DATA_INST_23;
  wire DSP_A_B_DATA_INST_3;
  wire DSP_A_B_DATA_INST_4;
  wire DSP_A_B_DATA_INST_5;
  wire DSP_A_B_DATA_INST_6;
  wire DSP_A_B_DATA_INST_7;
  wire DSP_A_B_DATA_INST_8;
  wire DSP_A_B_DATA_INST_9;

  MUXF7 T_r_reg_i_13
       (.I0(DSP_A_B_DATA_INST_22),
        .I1(DSP_A_B_DATA_INST_23),
        .O(A[11]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_14
       (.I0(DSP_A_B_DATA_INST_20),
        .I1(DSP_A_B_DATA_INST_21),
        .O(A[10]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_15
       (.I0(DSP_A_B_DATA_INST_18),
        .I1(DSP_A_B_DATA_INST_19),
        .O(A[9]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_16
       (.I0(DSP_A_B_DATA_INST_16),
        .I1(DSP_A_B_DATA_INST_17),
        .O(A[8]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_17
       (.I0(DSP_A_B_DATA_INST_14),
        .I1(DSP_A_B_DATA_INST_15),
        .O(A[7]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_18
       (.I0(DSP_A_B_DATA_INST_12),
        .I1(DSP_A_B_DATA_INST_13),
        .O(A[6]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_19
       (.I0(DSP_A_B_DATA_INST_10),
        .I1(DSP_A_B_DATA_INST_11),
        .O(A[5]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_20
       (.I0(DSP_A_B_DATA_INST_8),
        .I1(DSP_A_B_DATA_INST_9),
        .O(A[4]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_21
       (.I0(DSP_A_B_DATA_INST_6),
        .I1(DSP_A_B_DATA_INST_7),
        .O(A[3]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_22
       (.I0(DSP_A_B_DATA_INST_4),
        .I1(DSP_A_B_DATA_INST_5),
        .O(A[2]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_23
       (.I0(DSP_A_B_DATA_INST_2),
        .I1(DSP_A_B_DATA_INST_3),
        .O(A[1]),
        .S(DSP_A_B_DATA_INST));
  MUXF7 T_r_reg_i_24
       (.I0(DSP_A_B_DATA_INST_0),
        .I1(DSP_A_B_DATA_INST_1),
        .O(A[0]),
        .S(DSP_A_B_DATA_INST));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
