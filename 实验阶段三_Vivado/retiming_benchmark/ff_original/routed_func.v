// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Tue Nov 10 09:55:11 2026
// Host        : nitro running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/retiming_benchmark/ff_original/routed_func.v
// Design      : small25
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "36872c" *) 
(* NotValidForBitStream *)
module small25
   (clk_in,
    reset,
    data_in,
    result,
    valid_out);
  input clk_in;
  input reset;
  input [15:0]data_in;
  output [15:0]result;
  output valid_out;

  wire clk;
  wire clk_in;
  wire clk_in_IBUF;
  wire [15:0]data_in;
  wire [15:0]data_in_IBUF;
  (* RTL_KEEP = "true" *) wire [15:0]op1;
  (* RTL_KEEP = "true" *) wire [15:0]op10;
  wire op10_inferred_i_10_n_0;
  wire op10_inferred_i_11_n_0;
  wire op10_inferred_i_12_n_0;
  wire op10_inferred_i_13_n_0;
  wire op10_inferred_i_14_n_0;
  wire op10_inferred_i_15_n_0;
  wire op10_inferred_i_2_n_0;
  wire op10_inferred_i_3_n_0;
  wire op10_inferred_i_4_n_0;
  wire op10_inferred_i_6_n_0;
  wire op10_inferred_i_7_n_0;
  wire op10_inferred_i_8_n_0;
  wire op10_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op11;
  wire op11_inferred_i_10_n_0;
  wire op11_inferred_i_11_n_0;
  wire op11_inferred_i_13_n_0;
  wire op11_inferred_i_14_n_0;
  wire op11_inferred_i_2_n_0;
  wire op11_inferred_i_3_n_0;
  wire op11_inferred_i_4_n_0;
  wire op11_inferred_i_5_n_0;
  wire op11_inferred_i_6_n_0;
  wire op11_inferred_i_7_n_0;
  wire op11_inferred_i_8_n_0;
  wire op11_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op12;
  wire op12_inferred_i_10_n_0;
  wire op12_inferred_i_11_n_0;
  wire op12_inferred_i_2_n_0;
  wire op12_inferred_i_3_n_0;
  wire op12_inferred_i_4_n_0;
  wire op12_inferred_i_6_n_0;
  wire op12_inferred_i_7_n_0;
  wire op12_inferred_i_8_n_0;
  wire op12_inferred_i_9_n_0;
  wire op1_inferred_i_10_n_0;
  wire op1_inferred_i_11_n_0;
  wire op1_inferred_i_12_n_0;
  wire op1_inferred_i_13_n_0;
  wire op1_inferred_i_2_n_0;
  wire op1_inferred_i_3_n_0;
  wire op1_inferred_i_4_n_0;
  wire op1_inferred_i_5_n_0;
  wire op1_inferred_i_6_n_0;
  wire op1_inferred_i_7_n_0;
  wire op1_inferred_i_8_n_0;
  wire op1_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op2;
  wire op2_inferred_i_10_n_0;
  wire op2_inferred_i_11_n_0;
  wire op2_inferred_i_12_n_0;
  wire op2_inferred_i_2_n_0;
  wire op2_inferred_i_3_n_0;
  wire op2_inferred_i_4_n_0;
  wire op2_inferred_i_6_n_0;
  wire op2_inferred_i_7_n_0;
  wire op2_inferred_i_8_n_0;
  wire op2_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op3;
  wire op3_inferred_i_10_n_0;
  wire op3_inferred_i_11_n_0;
  wire op3_inferred_i_12_n_0;
  wire op3_inferred_i_13_n_0;
  wire op3_inferred_i_2_n_0;
  wire op3_inferred_i_3_n_0;
  wire op3_inferred_i_4_n_0;
  wire op3_inferred_i_5_n_0;
  wire op3_inferred_i_6_n_0;
  wire op3_inferred_i_7_n_0;
  wire op3_inferred_i_8_n_0;
  wire op3_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op4;
  wire op4_inferred_i_10_n_0;
  wire op4_inferred_i_11_n_0;
  wire op4_inferred_i_12_n_0;
  wire op4_inferred_i_13_n_0;
  wire op4_inferred_i_14_n_0;
  wire op4_inferred_i_15_n_0;
  wire op4_inferred_i_2_n_0;
  wire op4_inferred_i_3_n_0;
  wire op4_inferred_i_4_n_0;
  wire op4_inferred_i_6_n_0;
  wire op4_inferred_i_7_n_0;
  wire op4_inferred_i_8_n_0;
  wire op4_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op5;
  wire op5_inferred_i_2_n_0;
  wire op5_inferred_i_3_n_0;
  wire op5_inferred_i_4_n_0;
  wire op5_inferred_i_5_n_0;
  wire op5_inferred_i_6_n_0;
  wire op5_inferred_i_7_n_0;
  wire op5_inferred_i_8_n_0;
  wire op5_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op6;
  wire op6_inferred_i_10_n_0;
  wire op6_inferred_i_11_n_0;
  wire op6_inferred_i_12_n_0;
  wire op6_inferred_i_13_n_0;
  wire op6_inferred_i_2_n_0;
  wire op6_inferred_i_3_n_0;
  wire op6_inferred_i_4_n_0;
  wire op6_inferred_i_6_n_0;
  wire op6_inferred_i_7_n_0;
  wire op6_inferred_i_8_n_0;
  wire op6_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op7;
  wire op7_inferred_i_10_n_0;
  wire op7_inferred_i_11_n_0;
  wire op7_inferred_i_12_n_0;
  wire op7_inferred_i_2_n_0;
  wire op7_inferred_i_3_n_0;
  wire op7_inferred_i_4_n_0;
  wire op7_inferred_i_5_n_0;
  wire op7_inferred_i_6_n_0;
  wire op7_inferred_i_7_n_0;
  wire op7_inferred_i_8_n_0;
  wire op7_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op8;
  wire op8_inferred_i_10_n_0;
  wire op8_inferred_i_11_n_0;
  wire op8_inferred_i_12_n_0;
  wire op8_inferred_i_13_n_0;
  wire op8_inferred_i_14_n_0;
  wire op8_inferred_i_2_n_0;
  wire op8_inferred_i_3_n_0;
  wire op8_inferred_i_4_n_0;
  wire op8_inferred_i_6_n_0;
  wire op8_inferred_i_7_n_0;
  wire op8_inferred_i_8_n_0;
  wire op8_inferred_i_9_n_0;
  (* RTL_KEEP = "true" *) wire [15:0]op9;
  wire op9_inferred_i_10_n_0;
  wire op9_inferred_i_11_n_0;
  wire op9_inferred_i_2_n_0;
  wire op9_inferred_i_3_n_0;
  wire op9_inferred_i_4_n_0;
  wire op9_inferred_i_5_n_0;
  wire op9_inferred_i_6_n_0;
  wire op9_inferred_i_7_n_0;
  wire op9_inferred_i_8_n_0;
  wire op9_inferred_i_9_n_0;
  wire [15:0]q0;
  wire [15:0]q1;
  wire [15:0]q11;
  wire [15:0]q12;
  wire [15:0]q2;
  wire reset;
  wire reset_IBUF;
  wire [15:0]result;
  wire [15:0]result_OBUF;
  wire valid_out;
  wire valid_out_OBUF;
  wire [4:1]vd;
  wire [3:0]NLW_op10_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_4_CO_UNCONNECTED;
  wire [0:0]NLW_op10_inferred_i_4_O_UNCONNECTED;
  wire [3:0]NLW_op11_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op11_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op11_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op11_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op12_inferred_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_op12_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op12_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op12_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op12_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op1_inferred_i_1_CO_UNCONNECTED;
  wire [3:2]NLW_op1_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op1_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op1_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op1_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op2_inferred_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_op2_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op2_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op2_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op2_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op3_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op3_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op3_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op3_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op4_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op4_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op4_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op4_inferred_i_4_CO_UNCONNECTED;
  wire [0:0]NLW_op4_inferred_i_4_O_UNCONNECTED;
  wire [3:0]NLW_op5_inferred_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_op5_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op5_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op5_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op5_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op6_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op6_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op6_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op6_inferred_i_4_CO_UNCONNECTED;
  wire [0:0]NLW_op6_inferred_i_4_O_UNCONNECTED;
  wire [3:0]NLW_op7_inferred_i_1_CO_UNCONNECTED;
  wire [2:0]NLW_op7_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op7_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op7_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op8_inferred_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_op8_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op8_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op8_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op8_inferred_i_4_CO_UNCONNECTED;
  wire [3:0]NLW_op9_inferred_i_1_CO_UNCONNECTED;
  wire [3:1]NLW_op9_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op9_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op9_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op9_inferred_i_4_CO_UNCONNECTED;

  IBUF clk_in_IBUF_inst
       (.I(clk_in),
        .O(clk_in_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clock_buffer
       (.I(clk_in_IBUF),
        .O(clk));
  IBUF \data_in_IBUF[0]_inst 
       (.I(data_in[0]),
        .O(data_in_IBUF[0]));
  IBUF \data_in_IBUF[10]_inst 
       (.I(data_in[10]),
        .O(data_in_IBUF[10]));
  IBUF \data_in_IBUF[11]_inst 
       (.I(data_in[11]),
        .O(data_in_IBUF[11]));
  IBUF \data_in_IBUF[12]_inst 
       (.I(data_in[12]),
        .O(data_in_IBUF[12]));
  IBUF \data_in_IBUF[13]_inst 
       (.I(data_in[13]),
        .O(data_in_IBUF[13]));
  IBUF \data_in_IBUF[14]_inst 
       (.I(data_in[14]),
        .O(data_in_IBUF[14]));
  IBUF \data_in_IBUF[15]_inst 
       (.I(data_in[15]),
        .O(data_in_IBUF[15]));
  IBUF \data_in_IBUF[1]_inst 
       (.I(data_in[1]),
        .O(data_in_IBUF[1]));
  IBUF \data_in_IBUF[2]_inst 
       (.I(data_in[2]),
        .O(data_in_IBUF[2]));
  IBUF \data_in_IBUF[3]_inst 
       (.I(data_in[3]),
        .O(data_in_IBUF[3]));
  IBUF \data_in_IBUF[4]_inst 
       (.I(data_in[4]),
        .O(data_in_IBUF[4]));
  IBUF \data_in_IBUF[5]_inst 
       (.I(data_in[5]),
        .O(data_in_IBUF[5]));
  IBUF \data_in_IBUF[6]_inst 
       (.I(data_in[6]),
        .O(data_in_IBUF[6]));
  IBUF \data_in_IBUF[7]_inst 
       (.I(data_in[7]),
        .O(data_in_IBUF[7]));
  IBUF \data_in_IBUF[8]_inst 
       (.I(data_in[8]),
        .O(data_in_IBUF[8]));
  IBUF \data_in_IBUF[9]_inst 
       (.I(data_in[9]),
        .O(data_in_IBUF[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[0]),
        .Q(q11[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[1]),
        .Q(q11[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[2]),
        .Q(q11[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[3]),
        .Q(q11[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[4]),
        .Q(q11[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[5]),
        .Q(q11[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[6]),
        .Q(q11[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[7]),
        .Q(q11[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[8]),
        .Q(q11[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[9]),
        .Q(q11[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[10]),
        .Q(q11[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[11]),
        .Q(q11[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[12]),
        .Q(q11[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[13]),
        .Q(q11[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[14]),
        .Q(q11[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut11_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op11[15]),
        .Q(q11[15]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[0]),
        .Q(q12[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[1]),
        .Q(q12[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[2]),
        .Q(q12[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[3]),
        .Q(q12[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[4]),
        .Q(q12[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[5]),
        .Q(q12[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[6]),
        .Q(q12[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[7]),
        .Q(q12[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[8]),
        .Q(q12[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[9]),
        .Q(q12[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[10]),
        .Q(q12[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[11]),
        .Q(q12[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[12]),
        .Q(q12[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[13]),
        .Q(q12[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[14]),
        .Q(q12[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut12_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op12[15]),
        .Q(q12[15]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[0]),
        .Q(q1[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[1]),
        .Q(q1[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[2]),
        .Q(q1[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[3]),
        .Q(q1[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[4]),
        .Q(q1[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[5]),
        .Q(q1[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[6]),
        .Q(q1[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[7]),
        .Q(q1[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[8]),
        .Q(q1[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[9]),
        .Q(q1[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[10]),
        .Q(q1[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[11]),
        .Q(q1[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[12]),
        .Q(q1[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[13]),
        .Q(q1[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[14]),
        .Q(q1[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut1_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op1[15]),
        .Q(q1[15]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[0]),
        .Q(q2[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[1]),
        .Q(q2[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[2]),
        .Q(q2[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[3]),
        .Q(q2[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[4]),
        .Q(q2[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[5]),
        .Q(q2[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[6]),
        .Q(q2[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[7]),
        .Q(q2[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[8]),
        .Q(q2[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[9]),
        .Q(q2[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[10]),
        .Q(q2[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[11]),
        .Q(q2[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[12]),
        .Q(q2[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[13]),
        .Q(q2[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[14]),
        .Q(q2[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut2_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op2[15]),
        .Q(q2[15]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[0]),
        .Q(q0[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[1]),
        .Q(q0[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[2]),
        .Q(q0[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[3]),
        .Q(q0[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[4]),
        .Q(q0[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[5]),
        .Q(q0[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[6]),
        .Q(q0[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[7]),
        .Q(q0[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[8]),
        .Q(q0[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[9]),
        .Q(q0[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[10]),
        .Q(q0[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[11]),
        .Q(q0[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[12]),
        .Q(q0[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[13]),
        .Q(op1[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[14]),
        .Q(op1[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    input_ff_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[15]),
        .Q(q0[15]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op10_inferred_i_1
       (.CI(op10_inferred_i_2_n_0),
        .CO(NLW_op10_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,op9[11:10],1'b0}),
        .O(op10[15:12]),
        .S({op10_inferred_i_6_n_0,op10_inferred_i_7_n_0,op10_inferred_i_8_n_0,op9[9]}));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_10
       (.I0(op9[5]),
        .O(op10_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_11
       (.I0(op9[4]),
        .O(op10_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_12
       (.I0(op9[3]),
        .O(op10_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_13
       (.I0(op9[15]),
        .O(op10_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_14
       (.I0(op9[14]),
        .O(op10_inferred_i_14_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_15
       (.I0(op9[13]),
        .O(op10_inferred_i_15_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op10_inferred_i_2
       (.CI(op10_inferred_i_3_n_0),
        .CO({op10_inferred_i_2_n_0,NLW_op10_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op9[7],1'b0,op9[5]}),
        .O(op10[11:8]),
        .S({op9[8],op10_inferred_i_9_n_0,op9[6],op10_inferred_i_10_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET" *) 
  CARRY4 op10_inferred_i_3
       (.CI(op10_inferred_i_4_n_0),
        .CO({op10_inferred_i_3_n_0,NLW_op10_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op9[4:3],1'b0,1'b0}),
        .O(op10[7:4]),
        .S({op10_inferred_i_11_n_0,op10_inferred_i_12_n_0,op8[15:14]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET" *) 
  CARRY4 op10_inferred_i_4
       (.CI(1'b0),
        .CO({op10_inferred_i_4_n_0,NLW_op10_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op9[15:13]}),
        .O({op10[3:1],NLW_op10_inferred_i_4_O_UNCONNECTED[0]}),
        .S({op8[13],op10_inferred_i_13_n_0,op10_inferred_i_14_n_0,op10_inferred_i_15_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_5
       (.I0(op9[13]),
        .O(op10[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_6
       (.I0(op9[12]),
        .O(op10_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_7
       (.I0(op9[11]),
        .O(op10_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_8
       (.I0(op9[10]),
        .O(op10_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op10_inferred_i_9
       (.I0(op9[7]),
        .O(op10_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op11_inferred_i_1
       (.CI(op11_inferred_i_2_n_0),
        .CO(NLW_op11_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,op10[11:9]}),
        .O(op11[15:12]),
        .S({op11_inferred_i_5_n_0,op11_inferred_i_6_n_0,op11_inferred_i_7_n_0,op11_inferred_i_8_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_10
       (.I0(op10[5]),
        .O(op11_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_11
       (.I0(op10[1]),
        .O(op11_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_13
       (.I0(op10[15]),
        .O(op11_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_14
       (.I0(op10[14]),
        .O(op11_inferred_i_14_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op11_inferred_i_2
       (.CI(op11_inferred_i_3_n_0),
        .CO({op11_inferred_i_2_n_0,NLW_op11_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op10[8],1'b0,1'b0,op10[5]}),
        .O(op11[11:8]),
        .S({op11_inferred_i_9_n_0,op10[7:6],op11_inferred_i_10_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op11_inferred_i_3
       (.CI(op11_inferred_i_4_n_0),
        .CO({op11_inferred_i_3_n_0,NLW_op11_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,op10[1]}),
        .O(op11[7:4]),
        .S({op10[4:2],op11_inferred_i_11_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET PROPCONST" *) 
  CARRY4 op11_inferred_i_4
       (.CI(1'b0),
        .CO({op11_inferred_i_4_n_0,NLW_op11_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op10[0],op10[15:14],1'b0}),
        .O(op11[3:0]),
        .S({op9[13],op11_inferred_i_13_n_0,op11_inferred_i_14_n_0,op10[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_5
       (.I0(op10[12]),
        .O(op11_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_6
       (.I0(op10[11]),
        .O(op11_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_7
       (.I0(op10[10]),
        .O(op11_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_8
       (.I0(op10[9]),
        .O(op11_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_9
       (.I0(op10[8]),
        .O(op11_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_1
       (.CI(op12_inferred_i_2_n_0),
        .CO(NLW_op12_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_op12_inferred_i_1_O_UNCONNECTED[3],op12[15:13]}),
        .S({1'b0,q11[12:10]}));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_10
       (.I0(q11[1]),
        .O(op12_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_11
       (.I0(q11[15]),
        .O(op12_inferred_i_11_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_2
       (.CI(op12_inferred_i_3_n_0),
        .CO({op12_inferred_i_2_n_0,NLW_op12_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,q11[8:7],1'b0}),
        .O(op12[12:9]),
        .S({q11[9],op12_inferred_i_6_n_0,op12_inferred_i_7_n_0,q11[6]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_3
       (.CI(op12_inferred_i_4_n_0),
        .CO({op12_inferred_i_3_n_0,NLW_op12_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,q11[3:2]}),
        .O(op12[8:5]),
        .S({q11[5:4],op12_inferred_i_8_n_0,op12_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_4
       (.CI(1'b0),
        .CO({op12_inferred_i_4_n_0,NLW_op12_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(q11[13]),
        .DI({q11[1],1'b0,q11[15],1'b0}),
        .O(op12[4:1]),
        .S({op12_inferred_i_10_n_0,q11[0],op12_inferred_i_11_n_0,q11[14]}));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_5
       (.I0(q11[13]),
        .O(op12[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_6
       (.I0(q11[8]),
        .O(op12_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_7
       (.I0(q11[7]),
        .O(op12_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_8
       (.I0(q11[3]),
        .O(op12_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_9
       (.I0(q11[2]),
        .O(op12_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op1_inferred_i_1
       (.CI(op1_inferred_i_2_n_0),
        .CO(NLW_op1_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_op1_inferred_i_1_O_UNCONNECTED[3:2],op1[15:14]}),
        .S({1'b0,1'b0,q0[12:11]}));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_10
       (.I0(q0[4]),
        .O(op1_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_11
       (.I0(q0[2]),
        .O(op1_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_12
       (.I0(q0[1]),
        .O(op1_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_13
       (.I0(q0[0]),
        .O(op1_inferred_i_13_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op1_inferred_i_2
       (.CI(op1_inferred_i_3_n_0),
        .CO({op1_inferred_i_2_n_0,NLW_op1_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q0[10:9],1'b0,q0[7]}),
        .O(op1[13:10]),
        .S({op1_inferred_i_5_n_0,op1_inferred_i_6_n_0,q0[8],op1_inferred_i_7_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op1_inferred_i_3
       (.CI(op1_inferred_i_4_n_0),
        .CO({op1_inferred_i_3_n_0,NLW_op1_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q0[6:4],1'b0}),
        .O(op1[9:6]),
        .S({op1_inferred_i_8_n_0,op1_inferred_i_9_n_0,op1_inferred_i_10_n_0,q0[3]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op1_inferred_i_4
       (.CI(1'b0),
        .CO({op1_inferred_i_4_n_0,NLW_op1_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q0[2:0],1'b0}),
        .O(op1[5:2]),
        .S({op1_inferred_i_11_n_0,op1_inferred_i_12_n_0,op1_inferred_i_13_n_0,q0[15]}));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_5
       (.I0(q0[10]),
        .O(op1_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_6
       (.I0(q0[9]),
        .O(op1_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_7
       (.I0(q0[7]),
        .O(op1_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_8
       (.I0(q0[6]),
        .O(op1_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op1_inferred_i_9
       (.I0(q0[5]),
        .O(op1_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_1
       (.CI(op2_inferred_i_2_n_0),
        .CO(NLW_op2_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,q1[11],1'b0}),
        .O({NLW_op2_inferred_i_1_O_UNCONNECTED[3],op2[15:13]}),
        .S({1'b0,q1[12],op2_inferred_i_6_n_0,q1[10]}));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_10
       (.I0(q1[0]),
        .O(op2_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_11
       (.I0(q1[15]),
        .O(op2_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_12
       (.I0(q1[14]),
        .O(op2_inferred_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_2
       (.CI(op2_inferred_i_3_n_0),
        .CO({op2_inferred_i_2_n_0,NLW_op2_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,q1[8],1'b0,q1[6]}),
        .O(op2[12:9]),
        .S({q1[9],op2_inferred_i_7_n_0,q1[7],op2_inferred_i_8_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_3
       (.CI(op2_inferred_i_4_n_0),
        .CO({op2_inferred_i_3_n_0,NLW_op2_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q1[5],1'b0,1'b0,1'b0}),
        .O(op2[8:5]),
        .S({op2_inferred_i_9_n_0,q1[4:2]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_4
       (.CI(1'b0),
        .CO({op2_inferred_i_4_n_0,NLW_op2_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(q1[13]),
        .DI({1'b0,q1[0],q1[15:14]}),
        .O(op2[4:1]),
        .S({q1[1],op2_inferred_i_10_n_0,op2_inferred_i_11_n_0,op2_inferred_i_12_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_5
       (.I0(q1[13]),
        .O(op2[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_6
       (.I0(q1[11]),
        .O(op2_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_7
       (.I0(q1[8]),
        .O(op2_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_8
       (.I0(q1[6]),
        .O(op2_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_9
       (.I0(q1[5]),
        .O(op2_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_1
       (.CI(op3_inferred_i_2_n_0),
        .CO(NLW_op3_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,q2[11],1'b0,q2[9]}),
        .O(op3[15:12]),
        .S({q2[12],op3_inferred_i_5_n_0,q2[10],op3_inferred_i_6_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_10
       (.I0(q2[3]),
        .O(op3_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_11
       (.I0(q2[2]),
        .O(op3_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_12
       (.I0(q2[15]),
        .O(op3_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_13
       (.I0(q2[14]),
        .O(op3_inferred_i_13_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_2
       (.CI(op3_inferred_i_3_n_0),
        .CO({op3_inferred_i_2_n_0,NLW_op3_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q2[8:6],1'b0}),
        .O(op3[11:8]),
        .S({op3_inferred_i_7_n_0,op3_inferred_i_8_n_0,op3_inferred_i_9_n_0,q2[5]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_3
       (.CI(op3_inferred_i_4_n_0),
        .CO({op3_inferred_i_3_n_0,NLW_op3_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,q2[3:2],1'b0}),
        .O(op3[7:4]),
        .S({q2[4],op3_inferred_i_10_n_0,op3_inferred_i_11_n_0,q2[1]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op3_inferred_i_4
       (.CI(1'b0),
        .CO({op3_inferred_i_4_n_0,NLW_op3_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,q2[15:14],1'b0}),
        .O(op3[3:0]),
        .S({q2[0],op3_inferred_i_12_n_0,op3_inferred_i_13_n_0,q2[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_5
       (.I0(q2[11]),
        .O(op3_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_6
       (.I0(q2[9]),
        .O(op3_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_7
       (.I0(q2[8]),
        .O(op3_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_8
       (.I0(q2[7]),
        .O(op3_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_9
       (.I0(q2[6]),
        .O(op3_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op4_inferred_i_1
       (.CI(op4_inferred_i_2_n_0),
        .CO(NLW_op4_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,op3[11:9]}),
        .O(op4[15:12]),
        .S({op3[12],op4_inferred_i_6_n_0,op4_inferred_i_7_n_0,op4_inferred_i_8_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_10
       (.I0(op3[4]),
        .O(op4_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_11
       (.I0(op3[2]),
        .O(op4_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_12
       (.I0(op3[1]),
        .O(op4_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_13
       (.I0(op3[0]),
        .O(op4_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_14
       (.I0(op3[15]),
        .O(op4_inferred_i_14_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_15
       (.I0(op3[13]),
        .O(op4_inferred_i_15_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op4_inferred_i_2
       (.CI(op4_inferred_i_3_n_0),
        .CO({op4_inferred_i_2_n_0,NLW_op4_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,op3[5]}),
        .O(op4[11:8]),
        .S({op3[8:6],op4_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op4_inferred_i_3
       (.CI(op4_inferred_i_4_n_0),
        .CO({op4_inferred_i_3_n_0,NLW_op4_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op3[4],1'b0,op3[2:1]}),
        .O(op4[7:4]),
        .S({op4_inferred_i_10_n_0,op3[3],op4_inferred_i_11_n_0,op4_inferred_i_12_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op4_inferred_i_4
       (.CI(1'b0),
        .CO({op4_inferred_i_4_n_0,NLW_op4_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op3[0],op3[15],1'b0,op3[13]}),
        .O({op4[3:1],NLW_op4_inferred_i_4_O_UNCONNECTED[0]}),
        .S({op4_inferred_i_13_n_0,op4_inferred_i_14_n_0,op3[14],op4_inferred_i_15_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_5
       (.I0(op3[13]),
        .O(op4[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_6
       (.I0(op3[11]),
        .O(op4_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_7
       (.I0(op3[10]),
        .O(op4_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_8
       (.I0(op3[9]),
        .O(op4_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_9
       (.I0(op3[5]),
        .O(op4_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op5_inferred_i_1
       (.CI(op5_inferred_i_2_n_0),
        .CO(NLW_op5_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_op5_inferred_i_1_O_UNCONNECTED[3],op5[15:13]}),
        .S({1'b0,op5_inferred_i_5_n_0,op4[11:10]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op5_inferred_i_2
       (.CI(op5_inferred_i_3_n_0),
        .CO({op5_inferred_i_2_n_0,NLW_op5_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op4[7],1'b0}),
        .O(op5[12:9]),
        .S({op4[9:8],op5_inferred_i_6_n_0,op4[6]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op5_inferred_i_3
       (.CI(op5_inferred_i_4_n_0),
        .CO({op5_inferred_i_3_n_0,NLW_op5_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op4[5],1'b0,1'b0,1'b0}),
        .O(op5[8:5]),
        .S({op5_inferred_i_7_n_0,op4[4:2]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op5_inferred_i_4
       (.CI(1'b0),
        .CO({op5_inferred_i_4_n_0,NLW_op5_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op4[1],1'b0,op4[15],1'b0}),
        .O(op5[4:1]),
        .S({op5_inferred_i_8_n_0,op4[0],op5_inferred_i_9_n_0,op4[14]}));
  LUT1 #(
    .INIT(2'h1)) 
    op5_inferred_i_5
       (.I0(op4[12]),
        .O(op5_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op5_inferred_i_6
       (.I0(op4[7]),
        .O(op5_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op5_inferred_i_7
       (.I0(op4[5]),
        .O(op5_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op5_inferred_i_8
       (.I0(op4[1]),
        .O(op5_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op5_inferred_i_9
       (.I0(op4[15]),
        .O(op5_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op6_inferred_i_1
       (.CI(op6_inferred_i_2_n_0),
        .CO(NLW_op6_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,op5[9]}),
        .O(op6[15:12]),
        .S({op6_inferred_i_6_n_0,op5[11:10],op6_inferred_i_7_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_10
       (.I0(op5[2]),
        .O(op6_inferred_i_10_n_0));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_11
       (.I0(op4[13]),
        .O(op6_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_12
       (.I0(op5[14]),
        .O(op6_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_13
       (.I0(op5[13]),
        .O(op6_inferred_i_13_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op6_inferred_i_2
       (.CI(op6_inferred_i_3_n_0),
        .CO({op6_inferred_i_2_n_0,NLW_op6_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op5[8],1'b0,1'b0,1'b0}),
        .O(op6[11:8]),
        .S({op6_inferred_i_8_n_0,op5[7:5]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op6_inferred_i_3
       (.CI(op6_inferred_i_4_n_0),
        .CO({op6_inferred_i_3_n_0,NLW_op6_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op5[3:2],1'b0}),
        .O(op6[7:4]),
        .S({op5[4],op6_inferred_i_9_n_0,op6_inferred_i_10_n_0,op5[1]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET" *) 
  CARRY4 op6_inferred_i_4
       (.CI(1'b0),
        .CO({op6_inferred_i_4_n_0,NLW_op6_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op4[13],1'b0,op5[14:13]}),
        .O({op6[3:1],NLW_op6_inferred_i_4_O_UNCONNECTED[0]}),
        .S({op6_inferred_i_11_n_0,op5[15],op6_inferred_i_12_n_0,op6_inferred_i_13_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_5
       (.I0(op5[13]),
        .O(op6[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_6
       (.I0(op5[12]),
        .O(op6_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_7
       (.I0(op5[9]),
        .O(op6_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_8
       (.I0(op5[8]),
        .O(op6_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op6_inferred_i_9
       (.I0(op5[3]),
        .O(op6_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op7_inferred_i_1
       (.CI(op7_inferred_i_2_n_0),
        .CO(NLW_op7_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op6[10],1'b0}),
        .O(op7[15:12]),
        .S({op7_inferred_i_5_n_0,op6[11],op7_inferred_i_6_n_0,op6[9]}));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_10
       (.I0(op6[4]),
        .O(op7_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_11
       (.I0(op6[3]),
        .O(op7_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_12
       (.I0(op6[14]),
        .O(op7_inferred_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op7_inferred_i_2
       (.CI(op7_inferred_i_3_n_0),
        .CO({op7_inferred_i_2_n_0,NLW_op7_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op6[8],1'b0,op6[6:5]}),
        .O(op7[11:8]),
        .S({op7_inferred_i_7_n_0,op6[7],op7_inferred_i_8_n_0,op7_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op7_inferred_i_3
       (.CI(op7_inferred_i_4_n_0),
        .CO({op7_inferred_i_3_n_0,NLW_op7_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op6[4:3],1'b0,1'b0}),
        .O(op7[7:4]),
        .S({op7_inferred_i_10_n_0,op7_inferred_i_11_n_0,op6[2:1]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op7_inferred_i_4
       (.CI(1'b0),
        .CO({op7_inferred_i_4_n_0,NLW_op7_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op6[14],1'b0}),
        .O(op7[3:0]),
        .S({op6[0],op6[15],op7_inferred_i_12_n_0,op6[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_5
       (.I0(op6[12]),
        .O(op7_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_6
       (.I0(op6[10]),
        .O(op7_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_7
       (.I0(op6[8]),
        .O(op7_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_8
       (.I0(op6[6]),
        .O(op7_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_9
       (.I0(op6[5]),
        .O(op7_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op8_inferred_i_1
       (.CI(op8_inferred_i_2_n_0),
        .CO(NLW_op8_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,op7[10]}),
        .O({NLW_op8_inferred_i_1_O_UNCONNECTED[3],op8[15:13]}),
        .S({1'b0,op8_inferred_i_6_n_0,op7[11],op8_inferred_i_7_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_10
       (.I0(op7[7]),
        .O(op8_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_11
       (.I0(op7[6]),
        .O(op8_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_12
       (.I0(op7[5]),
        .O(op8_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_13
       (.I0(op7[1]),
        .O(op8_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_14
       (.I0(op7[0]),
        .O(op8_inferred_i_14_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op8_inferred_i_2
       (.CI(op8_inferred_i_3_n_0),
        .CO({op8_inferred_i_2_n_0,NLW_op8_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI(op7[9:6]),
        .O(op8[12:9]),
        .S({op8_inferred_i_8_n_0,op8_inferred_i_9_n_0,op8_inferred_i_10_n_0,op8_inferred_i_11_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op8_inferred_i_3
       (.CI(op8_inferred_i_4_n_0),
        .CO({op8_inferred_i_3_n_0,NLW_op8_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op7[5],1'b0,1'b0,1'b0}),
        .O(op8[8:5]),
        .S({op8_inferred_i_12_n_0,op7[4:2]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op8_inferred_i_4
       (.CI(1'b0),
        .CO({op8_inferred_i_4_n_0,NLW_op8_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(op7[13]),
        .DI({op7[1:0],1'b0,1'b0}),
        .O(op8[4:1]),
        .S({op8_inferred_i_13_n_0,op8_inferred_i_14_n_0,op7[15:14]}));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_5
       (.I0(op7[13]),
        .O(op8[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_6
       (.I0(op7[12]),
        .O(op8_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_7
       (.I0(op7[10]),
        .O(op8_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_8
       (.I0(op7[9]),
        .O(op8_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op8_inferred_i_9
       (.I0(op7[8]),
        .O(op8_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op9_inferred_i_1
       (.CI(op9_inferred_i_2_n_0),
        .CO(NLW_op9_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_op9_inferred_i_1_O_UNCONNECTED[3:1],op9[15]}),
        .S({1'b0,1'b0,1'b0,op9_inferred_i_5_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_10
       (.I0(op8[2]),
        .O(op9_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_11
       (.I0(op8[1]),
        .O(op9_inferred_i_11_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op9_inferred_i_2
       (.CI(op9_inferred_i_3_n_0),
        .CO({op9_inferred_i_2_n_0,NLW_op9_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op8[11],1'b0,op8[9],1'b0}),
        .O(op9[14:11]),
        .S({op9_inferred_i_6_n_0,op8[10],op9_inferred_i_7_n_0,op8[8]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op9_inferred_i_3
       (.CI(op9_inferred_i_4_n_0),
        .CO({op9_inferred_i_3_n_0,NLW_op9_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op8[6],1'b0,1'b0}),
        .O(op9[10:7]),
        .S({op8[7],op9_inferred_i_8_n_0,op8[5:4]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op9_inferred_i_4
       (.CI(1'b0),
        .CO({op9_inferred_i_4_n_0,NLW_op9_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op8[3:1],1'b0}),
        .O(op9[6:3]),
        .S({op9_inferred_i_9_n_0,op9_inferred_i_10_n_0,op9_inferred_i_11_n_0,op8[0]}));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_5
       (.I0(op8[12]),
        .O(op9_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_6
       (.I0(op8[11]),
        .O(op9_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_7
       (.I0(op8[9]),
        .O(op9_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_8
       (.I0(op8[6]),
        .O(op9_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op9_inferred_i_9
       (.I0(op8[3]),
        .O(op9_inferred_i_9_n_0));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF \result_OBUF[0]_inst 
       (.I(result_OBUF[0]),
        .O(result[0]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[0]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[0]),
        .O(result_OBUF[0]));
  OBUF \result_OBUF[10]_inst 
       (.I(result_OBUF[10]),
        .O(result[10]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[10]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[10]),
        .O(result_OBUF[10]));
  OBUF \result_OBUF[11]_inst 
       (.I(result_OBUF[11]),
        .O(result[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[11]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[11]),
        .O(result_OBUF[11]));
  OBUF \result_OBUF[12]_inst 
       (.I(result_OBUF[12]),
        .O(result[12]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[12]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[12]),
        .O(result_OBUF[12]));
  OBUF \result_OBUF[13]_inst 
       (.I(result_OBUF[13]),
        .O(result[13]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[13]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[13]),
        .O(result_OBUF[13]));
  OBUF \result_OBUF[14]_inst 
       (.I(result_OBUF[14]),
        .O(result[14]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[14]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[14]),
        .O(result_OBUF[14]));
  OBUF \result_OBUF[15]_inst 
       (.I(result_OBUF[15]),
        .O(result[15]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[15]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[15]),
        .O(result_OBUF[15]));
  OBUF \result_OBUF[1]_inst 
       (.I(result_OBUF[1]),
        .O(result[1]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[1]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[1]),
        .O(result_OBUF[1]));
  OBUF \result_OBUF[2]_inst 
       (.I(result_OBUF[2]),
        .O(result[2]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[2]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[2]),
        .O(result_OBUF[2]));
  OBUF \result_OBUF[3]_inst 
       (.I(result_OBUF[3]),
        .O(result[3]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[3]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[3]),
        .O(result_OBUF[3]));
  OBUF \result_OBUF[4]_inst 
       (.I(result_OBUF[4]),
        .O(result[4]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[4]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[4]),
        .O(result_OBUF[4]));
  OBUF \result_OBUF[5]_inst 
       (.I(result_OBUF[5]),
        .O(result[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[5]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[5]),
        .O(result_OBUF[5]));
  OBUF \result_OBUF[6]_inst 
       (.I(result_OBUF[6]),
        .O(result[6]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[6]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[6]),
        .O(result_OBUF[6]));
  OBUF \result_OBUF[7]_inst 
       (.I(result_OBUF[7]),
        .O(result[7]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[7]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[7]),
        .O(result_OBUF[7]));
  OBUF \result_OBUF[8]_inst 
       (.I(result_OBUF[8]),
        .O(result[8]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[8]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[8]),
        .O(result_OBUF[8]));
  OBUF \result_OBUF[9]_inst 
       (.I(result_OBUF[9]),
        .O(result[9]));
  LUT2 #(
    .INIT(4'h8)) 
    \result_OBUF[9]_inst_i_1 
       (.I0(valid_out_OBUF),
        .I1(q12[9]),
        .O(result_OBUF[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    valid_ff_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(1'b1),
        .Q(vd[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    valid_ff_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(vd[1]),
        .Q(vd[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    valid_ff_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(vd[2]),
        .Q(vd[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    valid_ff_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(vd[3]),
        .Q(vd[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    valid_ff_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(vd[4]),
        .Q(valid_out_OBUF));
  OBUF valid_out_OBUF_inst
       (.I(valid_out_OBUF),
        .O(valid_out));
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
