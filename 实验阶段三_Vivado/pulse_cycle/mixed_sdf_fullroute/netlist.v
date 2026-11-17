// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Tue Nov 17 10:42:43 2026
// Host        : nitro running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode timesim
//               E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/pulse_cycle/mixed_sdf_fullroute/netlist.v
// Design      : small25
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* ECO_CHECKSUM = "6f38018c" *) 
(* NotValidForBitStream *)
(* \DesignAttr:ENABLE_NOC_NETLIST_VIEW  *) 
(* \DesignAttr:ENABLE_AIE_NETLIST_VIEW  *) 
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
  wire fb;
  wire fb_raw;
  wire mm_out;
  (* RTL_KEEP = "true" *) wire [15:0]op1;
  (* RTL_KEEP = "true" *) wire [15:0]op10;
  wire op10_inferred_i_10_n_0;
  wire op10_inferred_i_11_n_0;
  wire op10_inferred_i_12_n_0;
  wire op10_inferred_i_13_n_0;
  wire op10_inferred_i_14_n_0;
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
  wire op11_inferred_i_12_n_0;
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
  wire [15:0]output_d;
  wire [15:0]q0;
  wire [15:0]q10;
  wire [15:0]q3;
  wire [15:0]q6;
  wire reset;
  wire reset_IBUF;
  wire [15:0]result;
  wire [15:0]result_OBUF;
  wire valid_out;
  wire valid_out_OBUF;
  wire [4:1]vd;
  wire NLW_common_mmcm_CLKFBOUTB_UNCONNECTED;
  wire NLW_common_mmcm_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_common_mmcm_CLKINSTOPPED_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT0B_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT1_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT1B_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT2_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT2B_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT3_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT3B_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT4_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT5_UNCONNECTED;
  wire NLW_common_mmcm_CLKOUT6_UNCONNECTED;
  wire NLW_common_mmcm_DRDY_UNCONNECTED;
  wire NLW_common_mmcm_LOCKED_UNCONNECTED;
  wire NLW_common_mmcm_PSDONE_UNCONNECTED;
  wire [15:0]NLW_common_mmcm_DO_UNCONNECTED;
  wire [3:0]NLW_op10_inferred_i_1_CO_UNCONNECTED;
  wire [3:3]NLW_op10_inferred_i_1_O_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_2_CO_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_3_CO_UNCONNECTED;
  wire [2:0]NLW_op10_inferred_i_4_CO_UNCONNECTED;
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
       (.I(mm_out),
        .O(clk));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "MMCME2_BASE" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CLKINSEL GND:PSINCDEC,PSEN,PSCLK,DWE,DEN,DCLK,DI[15],DI[14],DI[13],DI[12],DI[11],DI[10],DI[9],DI[8],DI[7],DI[6],DI[5],DI[4],DI[3],DI[2],DI[1],DI[0],DADDR[6],DADDR[5],DADDR[4],DADDR[3],DADDR[2],DADDR[1],DADDR[0],CLKIN2" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(8.000000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(10.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(8.000000),
    .CLKOUT0_DUTY_CYCLE(0.125000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    common_mmcm
       (.CLKFBIN(fb),
        .CLKFBOUT(fb_raw),
        .CLKFBOUTB(NLW_common_mmcm_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_common_mmcm_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in_IBUF),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_common_mmcm_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(mm_out),
        .CLKOUT0B(NLW_common_mmcm_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(NLW_common_mmcm_CLKOUT1_UNCONNECTED),
        .CLKOUT1B(NLW_common_mmcm_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(NLW_common_mmcm_CLKOUT2_UNCONNECTED),
        .CLKOUT2B(NLW_common_mmcm_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_common_mmcm_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_common_mmcm_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_common_mmcm_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_common_mmcm_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_common_mmcm_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_common_mmcm_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_common_mmcm_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(NLW_common_mmcm_LOCKED_UNCONNECTED),
        .PSCLK(1'b0),
        .PSDONE(NLW_common_mmcm_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(1'b0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG feedback_buffer
       (.I(fb_raw),
        .O(fb));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[0]),
        .Q(q10[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[1]),
        .Q(q10[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[2]),
        .Q(q10[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[3]),
        .Q(q10[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[4]),
        .Q(q10[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[5]),
        .Q(q10[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[6]),
        .Q(q10[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[7]),
        .Q(q10[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[8]),
        .Q(q10[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[9]),
        .Q(q10[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[10]),
        .Q(q10[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[11]),
        .Q(q10[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[12]),
        .Q(q10[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[13]),
        .Q(q10[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[14]),
        .Q(q10[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut10_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op10[15]),
        .Q(q10[15]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[0]),
        .Q(q3[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[1]),
        .Q(q3[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[2]),
        .Q(q3[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[3]),
        .Q(q3[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[4]),
        .Q(q3[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[5]),
        .Q(q3[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[6]),
        .Q(q3[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[7]),
        .Q(q3[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[8]),
        .Q(q3[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[9]),
        .Q(q3[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[10]),
        .Q(q3[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[11]),
        .Q(q3[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[12]),
        .Q(q3[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[13]),
        .Q(q3[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[14]),
        .Q(q3[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_cut3_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(op3[15]),
        .Q(q3[15]));
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
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_00
       (.CLR(reset_IBUF),
        .D(op6[0]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_01
       (.CLR(reset_IBUF),
        .D(op6[1]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_02
       (.CLR(reset_IBUF),
        .D(op6[2]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_03
       (.CLR(reset_IBUF),
        .D(op6[3]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_04
       (.CLR(reset_IBUF),
        .D(op6[4]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_05
       (.CLR(reset_IBUF),
        .D(op6[5]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_06
       (.CLR(reset_IBUF),
        .D(op6[6]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_07
       (.CLR(reset_IBUF),
        .D(op6[7]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_08
       (.CLR(reset_IBUF),
        .D(op6[8]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_09
       (.CLR(reset_IBUF),
        .D(op6[9]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_10
       (.CLR(reset_IBUF),
        .D(op6[10]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_11
       (.CLR(reset_IBUF),
        .D(op6[11]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_12
       (.CLR(reset_IBUF),
        .D(op6[12]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_13
       (.CLR(reset_IBUF),
        .D(op6[13]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_14
       (.CLR(reset_IBUF),
        .D(op6[14]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_cut6_15
       (.CLR(reset_IBUF),
        .D(op6[15]),
        .G(clk),
        .GE(1'b1),
        .Q(q6[15]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op10_inferred_i_1
       (.CI(op10_inferred_i_2_n_0),
        .CO(NLW_op10_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op9[11:10]}),
        .O({NLW_op10_inferred_i_1_O_UNCONNECTED[3],op10[15:13]}),
        .S({1'b0,op10_inferred_i_6_n_0,op10_inferred_i_7_n_0,op10_inferred_i_8_n_0}));
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
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op10_inferred_i_2
       (.CI(op10_inferred_i_3_n_0),
        .CO({op10_inferred_i_2_n_0,NLW_op10_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op9[7],1'b0}),
        .O(op10[12:9]),
        .S({op9[9:8],op10_inferred_i_9_n_0,op9[6]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET" *) 
  CARRY4 op10_inferred_i_3
       (.CI(op10_inferred_i_4_n_0),
        .CO({op10_inferred_i_3_n_0,NLW_op10_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op9[5:3],1'b0}),
        .O(op10[8:5]),
        .S({op10_inferred_i_10_n_0,op10_inferred_i_11_n_0,op10_inferred_i_12_n_0,op8[15]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "RETARGET" *) 
  CARRY4 op10_inferred_i_4
       (.CI(1'b0),
        .CO({op10_inferred_i_4_n_0,NLW_op10_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(op9[13]),
        .DI({1'b0,1'b0,op9[15:14]}),
        .O(op10[4:1]),
        .S({op8[14:13],op10_inferred_i_13_n_0,op10_inferred_i_14_n_0}));
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
        .DI({1'b0,q10[11:9]}),
        .O(op11[15:12]),
        .S({op11_inferred_i_5_n_0,op11_inferred_i_6_n_0,op11_inferred_i_7_n_0,op11_inferred_i_8_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_10
       (.I0(q10[5]),
        .O(op11_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_11
       (.I0(q10[1]),
        .O(op11_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_12
       (.I0(q10[0]),
        .O(op11_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_13
       (.I0(q10[15]),
        .O(op11_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_14
       (.I0(q10[14]),
        .O(op11_inferred_i_14_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op11_inferred_i_2
       (.CI(op11_inferred_i_3_n_0),
        .CO({op11_inferred_i_2_n_0,NLW_op11_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q10[8],1'b0,1'b0,q10[5]}),
        .O(op11[11:8]),
        .S({op11_inferred_i_9_n_0,q10[7:6],op11_inferred_i_10_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op11_inferred_i_3
       (.CI(op11_inferred_i_4_n_0),
        .CO({op11_inferred_i_3_n_0,NLW_op11_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,q10[1]}),
        .O(op11[7:4]),
        .S({q10[4:2],op11_inferred_i_11_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op11_inferred_i_4
       (.CI(1'b0),
        .CO({op11_inferred_i_4_n_0,NLW_op11_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q10[0],q10[15:14],1'b0}),
        .O(op11[3:0]),
        .S({op11_inferred_i_12_n_0,op11_inferred_i_13_n_0,op11_inferred_i_14_n_0,q10[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_5
       (.I0(q10[12]),
        .O(op11_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_6
       (.I0(q10[11]),
        .O(op11_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_7
       (.I0(q10[10]),
        .O(op11_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_8
       (.I0(q10[9]),
        .O(op11_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op11_inferred_i_9
       (.I0(q10[8]),
        .O(op11_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_1
       (.CI(op12_inferred_i_2_n_0),
        .CO(NLW_op12_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_op12_inferred_i_1_O_UNCONNECTED[3],op12[15:13]}),
        .S({1'b0,op11[12:10]}));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_10
       (.I0(op11[1]),
        .O(op12_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_11
       (.I0(op11[15]),
        .O(op12_inferred_i_11_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_2
       (.CI(op12_inferred_i_3_n_0),
        .CO({op12_inferred_i_2_n_0,NLW_op12_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op11[8:7],1'b0}),
        .O(op12[12:9]),
        .S({op11[9],op12_inferred_i_6_n_0,op12_inferred_i_7_n_0,op11[6]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_3
       (.CI(op12_inferred_i_4_n_0),
        .CO({op12_inferred_i_3_n_0,NLW_op12_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,op11[3:2]}),
        .O(op12[8:5]),
        .S({op11[5:4],op12_inferred_i_8_n_0,op12_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op12_inferred_i_4
       (.CI(1'b0),
        .CO({op12_inferred_i_4_n_0,NLW_op12_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(op11[13]),
        .DI({op11[1],1'b0,op11[15],1'b0}),
        .O(op12[4:1]),
        .S({op12_inferred_i_10_n_0,op11[0],op12_inferred_i_11_n_0,op11[14]}));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_6
       (.I0(op11[8]),
        .O(op12_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_7
       (.I0(op11[7]),
        .O(op12_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_8
       (.I0(op11[3]),
        .O(op12_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op12_inferred_i_9
       (.I0(op11[2]),
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
        .DI({1'b0,1'b0,op1[11],1'b0}),
        .O({NLW_op2_inferred_i_1_O_UNCONNECTED[3],op2[15:13]}),
        .S({1'b0,op1[12],op2_inferred_i_6_n_0,op1[10]}));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_10
       (.I0(op1[0]),
        .O(op2_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_11
       (.I0(op1[15]),
        .O(op2_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_12
       (.I0(op1[14]),
        .O(op2_inferred_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_2
       (.CI(op2_inferred_i_3_n_0),
        .CO({op2_inferred_i_2_n_0,NLW_op2_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op1[8],1'b0,op1[6]}),
        .O(op2[12:9]),
        .S({op1[9],op2_inferred_i_7_n_0,op1[7],op2_inferred_i_8_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_3
       (.CI(op2_inferred_i_4_n_0),
        .CO({op2_inferred_i_3_n_0,NLW_op2_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op1[5],1'b0,1'b0,1'b0}),
        .O(op2[8:5]),
        .S({op2_inferred_i_9_n_0,op1[4:2]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op2_inferred_i_4
       (.CI(1'b0),
        .CO({op2_inferred_i_4_n_0,NLW_op2_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(op1[13]),
        .DI({1'b0,op1[0],op1[15:14]}),
        .O(op2[4:1]),
        .S({op1[1],op2_inferred_i_10_n_0,op2_inferred_i_11_n_0,op2_inferred_i_12_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_5
       (.I0(op1[13]),
        .O(op2[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_6
       (.I0(op1[11]),
        .O(op2_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_7
       (.I0(op1[8]),
        .O(op2_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_8
       (.I0(op1[6]),
        .O(op2_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op2_inferred_i_9
       (.I0(op1[5]),
        .O(op2_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_1
       (.CI(op3_inferred_i_2_n_0),
        .CO(NLW_op3_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,op2[11],1'b0,op2[9]}),
        .O(op3[15:12]),
        .S({op2[12],op3_inferred_i_5_n_0,op2[10],op3_inferred_i_6_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_10
       (.I0(op2[3]),
        .O(op3_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_11
       (.I0(op2[2]),
        .O(op3_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_12
       (.I0(op2[15]),
        .O(op3_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_13
       (.I0(op2[14]),
        .O(op3_inferred_i_13_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_2
       (.CI(op3_inferred_i_3_n_0),
        .CO({op3_inferred_i_2_n_0,NLW_op3_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op2[8:6],1'b0}),
        .O(op3[11:8]),
        .S({op3_inferred_i_7_n_0,op3_inferred_i_8_n_0,op3_inferred_i_9_n_0,op2[5]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op3_inferred_i_3
       (.CI(op3_inferred_i_4_n_0),
        .CO({op3_inferred_i_3_n_0,NLW_op3_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op2[3:2],1'b0}),
        .O(op3[7:4]),
        .S({op2[4],op3_inferred_i_10_n_0,op3_inferred_i_11_n_0,op2[1]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op3_inferred_i_4
       (.CI(1'b0),
        .CO({op3_inferred_i_4_n_0,NLW_op3_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,op2[15:14],1'b0}),
        .O(op3[3:0]),
        .S({op2[0],op3_inferred_i_12_n_0,op3_inferred_i_13_n_0,op2[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_5
       (.I0(op2[11]),
        .O(op3_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_6
       (.I0(op2[9]),
        .O(op3_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_7
       (.I0(op2[8]),
        .O(op3_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_8
       (.I0(op2[7]),
        .O(op3_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op3_inferred_i_9
       (.I0(op2[6]),
        .O(op3_inferred_i_9_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op4_inferred_i_1
       (.CI(op4_inferred_i_2_n_0),
        .CO(NLW_op4_inferred_i_1_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,q3[11:9]}),
        .O(op4[15:12]),
        .S({q3[12],op4_inferred_i_6_n_0,op4_inferred_i_7_n_0,op4_inferred_i_8_n_0}));
  (* \PinAttr:I0:HOLD_DETOUR  = "524" *) 
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_10
       (.I0(q3[4]),
        .O(op4_inferred_i_10_n_0));
  (* \PinAttr:I0:HOLD_DETOUR  = "476" *) 
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_11
       (.I0(q3[2]),
        .O(op4_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_12
       (.I0(q3[1]),
        .O(op4_inferred_i_12_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_13
       (.I0(q3[0]),
        .O(op4_inferred_i_13_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_14
       (.I0(q3[15]),
        .O(op4_inferred_i_14_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_15
       (.I0(q3[13]),
        .O(op4_inferred_i_15_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  (* \PinAttr:DI[0]:HOLD_DETOUR  = "514" *) 
  (* \PinAttr:S[1]:HOLD_DETOUR  = "488" *) 
  (* \PinAttr:S[3]:HOLD_DETOUR  = "544" *) 
  CARRY4 op4_inferred_i_2
       (.CI(op4_inferred_i_3_n_0),
        .CO({op4_inferred_i_2_n_0,NLW_op4_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,q3[5]}),
        .O(op4[11:8]),
        .S({q3[8:6],op4_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* \PinAttr:DI[0]:HOLD_DETOUR  = "494" *) 
  (* \PinAttr:DI[1]:HOLD_DETOUR  = "537" *) 
  (* \PinAttr:DI[3]:HOLD_DETOUR  = "554" *) 
  CARRY4 op4_inferred_i_3
       (.CI(op4_inferred_i_4_n_0),
        .CO({op4_inferred_i_3_n_0,NLW_op4_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q3[4],1'b0,q3[2:1]}),
        .O(op4[7:4]),
        .S({op4_inferred_i_10_n_0,q3[3],op4_inferred_i_11_n_0,op4_inferred_i_12_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* \PinAttr:DI[2]:HOLD_DETOUR  = "550" *) 
  (* \PinAttr:S[1]:HOLD_DETOUR  = "552" *) 
  CARRY4 op4_inferred_i_4
       (.CI(1'b0),
        .CO({op4_inferred_i_4_n_0,NLW_op4_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q3[0],q3[15],1'b0,q3[13]}),
        .O({op4[3:1],NLW_op4_inferred_i_4_O_UNCONNECTED[0]}),
        .S({op4_inferred_i_13_n_0,op4_inferred_i_14_n_0,q3[14],op4_inferred_i_15_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_5
       (.I0(q3[13]),
        .O(op4[0]));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_6
       (.I0(q3[11]),
        .O(op4_inferred_i_6_n_0));
  (* \PinAttr:I0:HOLD_DETOUR  = "579" *) 
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_7
       (.I0(q3[10]),
        .O(op4_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_8
       (.I0(q3[9]),
        .O(op4_inferred_i_8_n_0));
  (* \PinAttr:I0:HOLD_DETOUR  = "515" *) 
  LUT1 #(
    .INIT(2'h1)) 
    op4_inferred_i_9
       (.I0(q3[5]),
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
  (* \PinAttr:DI[1]:HOLD_DETOUR  = "353" *) 
  (* \PinAttr:S[3]:HOLD_DETOUR  = "360" *) 
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
  (* \PinAttr:DI[1]:HOLD_DETOUR  = "396" *) 
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
  (* \PinAttr:I0:HOLD_DETOUR  = "391" *) 
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
  (* \PinAttr:I0:HOLD_DETOUR  = "328" *) 
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
  (* \PinAttr:DI[0]:HOLD_DETOUR  = "543" *) 
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
  (* \PinAttr:S[0]:HOLD_DETOUR  = "592" *) 
  CARRY4 op6_inferred_i_2
       (.CI(op6_inferred_i_3_n_0),
        .CO({op6_inferred_i_2_n_0,NLW_op6_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({op5[8],1'b0,1'b0,1'b0}),
        .O(op6[11:8]),
        .S({op6_inferred_i_8_n_0,op5[7:5]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* \PinAttr:S[3]:HOLD_DETOUR  = "629" *) 
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
        .DI({1'b0,1'b0,q6[10],1'b0}),
        .O(op7[15:12]),
        .S({op7_inferred_i_5_n_0,q6[11],op7_inferred_i_6_n_0,q6[9]}));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_10
       (.I0(q6[4]),
        .O(op7_inferred_i_10_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_11
       (.I0(q6[3]),
        .O(op7_inferred_i_11_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_12
       (.I0(q6[14]),
        .O(op7_inferred_i_12_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op7_inferred_i_2
       (.CI(op7_inferred_i_3_n_0),
        .CO({op7_inferred_i_2_n_0,NLW_op7_inferred_i_2_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q6[8],1'b0,q6[6:5]}),
        .O(op7[11:8]),
        .S({op7_inferred_i_7_n_0,q6[7],op7_inferred_i_8_n_0,op7_inferred_i_9_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 op7_inferred_i_3
       (.CI(op7_inferred_i_4_n_0),
        .CO({op7_inferred_i_3_n_0,NLW_op7_inferred_i_3_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({q6[4:3],1'b0,1'b0}),
        .O(op7[7:4]),
        .S({op7_inferred_i_10_n_0,op7_inferred_i_11_n_0,q6[2:1]}));
  (* ADDER_THRESHOLD = "35" *) 
  (* OPT_MODIFIED = "PROPCONST" *) 
  CARRY4 op7_inferred_i_4
       (.CI(1'b0),
        .CO({op7_inferred_i_4_n_0,NLW_op7_inferred_i_4_CO_UNCONNECTED[2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,q6[14],1'b0}),
        .O(op7[3:0]),
        .S({q6[0],q6[15],op7_inferred_i_12_n_0,q6[13]}));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_5
       (.I0(q6[12]),
        .O(op7_inferred_i_5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_6
       (.I0(q6[10]),
        .O(op7_inferred_i_6_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_7
       (.I0(q6[8]),
        .O(op7_inferred_i_7_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_8
       (.I0(q6[6]),
        .O(op7_inferred_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    op7_inferred_i_9
       (.I0(q6[5]),
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
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_00
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[0]),
        .Q(result_OBUF[0]));
  (* OPT_MODIFIED = "RETARGET" *) 
  LUT2 #(
    .INIT(4'h2)) 
    output_ff_00_i_1
       (.I0(vd[4]),
        .I1(op11[13]),
        .O(output_d[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_01
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[1]),
        .Q(result_OBUF[1]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_01_i_1
       (.I0(vd[4]),
        .I1(op12[1]),
        .O(output_d[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[2]),
        .Q(result_OBUF[2]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_02_i_1
       (.I0(vd[4]),
        .I1(op12[2]),
        .O(output_d[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_03
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[3]),
        .Q(result_OBUF[3]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_03_i_1
       (.I0(vd[4]),
        .I1(op12[3]),
        .O(output_d[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_04
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[4]),
        .Q(result_OBUF[4]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_04_i_1
       (.I0(vd[4]),
        .I1(op12[4]),
        .O(output_d[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_05
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[5]),
        .Q(result_OBUF[5]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_05_i_1
       (.I0(vd[4]),
        .I1(op12[5]),
        .O(output_d[5]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_06
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[6]),
        .Q(result_OBUF[6]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_06_i_1
       (.I0(vd[4]),
        .I1(op12[6]),
        .O(output_d[6]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_07
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[7]),
        .Q(result_OBUF[7]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_07_i_1
       (.I0(vd[4]),
        .I1(op12[7]),
        .O(output_d[7]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_08
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[8]),
        .Q(result_OBUF[8]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_08_i_1
       (.I0(vd[4]),
        .I1(op12[8]),
        .O(output_d[8]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_09
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[9]),
        .Q(result_OBUF[9]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_09_i_1
       (.I0(vd[4]),
        .I1(op12[9]),
        .O(output_d[9]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[10]),
        .Q(result_OBUF[10]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_10_i_1
       (.I0(vd[4]),
        .I1(op12[10]),
        .O(output_d[10]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[11]),
        .Q(result_OBUF[11]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_11_i_1
       (.I0(vd[4]),
        .I1(op12[11]),
        .O(output_d[11]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[12]),
        .Q(result_OBUF[12]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_12_i_1
       (.I0(vd[4]),
        .I1(op12[12]),
        .O(output_d[12]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[13]),
        .Q(result_OBUF[13]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_13_i_1
       (.I0(vd[4]),
        .I1(op12[13]),
        .O(output_d[13]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[14]),
        .Q(result_OBUF[14]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_14_i_1
       (.I0(vd[4]),
        .I1(op12[14]),
        .O(output_d[14]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    output_ff_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(output_d[15]),
        .Q(result_OBUF[15]));
  LUT2 #(
    .INIT(4'h8)) 
    output_ff_15_i_1
       (.I0(vd[4]),
        .I1(op12[15]),
        .O(output_d[15]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF sim_cell_0
       (.I(data_in[0]),
        .O(data_in_IBUF[0]));
  IBUF sim_cell_1
       (.I(data_in[10]),
        .O(data_in_IBUF[10]));
  IBUF sim_cell_10
       (.I(data_in[4]),
        .O(data_in_IBUF[4]));
  IBUF sim_cell_11
       (.I(data_in[5]),
        .O(data_in_IBUF[5]));
  IBUF sim_cell_12
       (.I(data_in[6]),
        .O(data_in_IBUF[6]));
  IBUF sim_cell_13
       (.I(data_in[7]),
        .O(data_in_IBUF[7]));
  IBUF sim_cell_14
       (.I(data_in[8]),
        .O(data_in_IBUF[8]));
  IBUF sim_cell_15
       (.I(data_in[9]),
        .O(data_in_IBUF[9]));
  OBUF sim_cell_16
       (.I(result_OBUF[0]),
        .O(result[0]));
  OBUF sim_cell_17
       (.I(result_OBUF[10]),
        .O(result[10]));
  OBUF sim_cell_18
       (.I(result_OBUF[11]),
        .O(result[11]));
  OBUF sim_cell_19
       (.I(result_OBUF[12]),
        .O(result[12]));
  IBUF sim_cell_2
       (.I(data_in[11]),
        .O(data_in_IBUF[11]));
  OBUF sim_cell_20
       (.I(result_OBUF[13]),
        .O(result[13]));
  OBUF sim_cell_21
       (.I(result_OBUF[14]),
        .O(result[14]));
  OBUF sim_cell_22
       (.I(result_OBUF[15]),
        .O(result[15]));
  OBUF sim_cell_23
       (.I(result_OBUF[1]),
        .O(result[1]));
  OBUF sim_cell_24
       (.I(result_OBUF[2]),
        .O(result[2]));
  OBUF sim_cell_25
       (.I(result_OBUF[3]),
        .O(result[3]));
  OBUF sim_cell_26
       (.I(result_OBUF[4]),
        .O(result[4]));
  OBUF sim_cell_27
       (.I(result_OBUF[5]),
        .O(result[5]));
  OBUF sim_cell_28
       (.I(result_OBUF[6]),
        .O(result[6]));
  OBUF sim_cell_29
       (.I(result_OBUF[7]),
        .O(result[7]));
  IBUF sim_cell_3
       (.I(data_in[12]),
        .O(data_in_IBUF[12]));
  OBUF sim_cell_30
       (.I(result_OBUF[8]),
        .O(result[8]));
  OBUF sim_cell_31
       (.I(result_OBUF[9]),
        .O(result[9]));
  IBUF sim_cell_4
       (.I(data_in[13]),
        .O(data_in_IBUF[13]));
  IBUF sim_cell_5
       (.I(data_in[14]),
        .O(data_in_IBUF[14]));
  IBUF sim_cell_6
       (.I(data_in[15]),
        .O(data_in_IBUF[15]));
  IBUF sim_cell_7
       (.I(data_in[1]),
        .O(data_in_IBUF[1]));
  IBUF sim_cell_8
       (.I(data_in[2]),
        .O(data_in_IBUF[2]));
  IBUF sim_cell_9
       (.I(data_in[3]),
        .O(data_in_IBUF[3]));
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
