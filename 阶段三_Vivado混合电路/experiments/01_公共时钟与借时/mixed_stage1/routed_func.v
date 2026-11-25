// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
// Date        : Mon Nov  9 15:40:31 2026
// Host        : nitro running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               E:/pds/lacth/latch_validation/howard_bridge/vivado_single_clock/mixed_stage1/routed_func.v
// Design      : small25
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "182fbdda" *) 
(* NotValidForBitStream *)
module small25
   (clk_in,
    reset,
    data_in,
    result);
  input clk_in;
  input reset;
  input [4:0]data_in;
  output [4:0]result;

  wire clk;
  wire clk_in;
  wire clk_in_IBUF;
  wire [4:0]d1;
  wire [2:0]d2;
  wire [4:0]d3;
  wire [2:0]d4;
  wire [4:0]data_in;
  wire [4:0]data_in_IBUF;
  wire ff_16_i_1_n_0;
  wire ff_18_i_1_n_0;
  wire latch_06_i_1_n_0;
  wire [4:0]q0;
  wire [4:0]q1;
  wire [4:0]q2;
  wire [4:0]q3;
  wire reset;
  wire reset_IBUF;
  wire [4:0]result;
  wire [4:0]result_OBUF;

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
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_00
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
    ff_01
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
    ff_02
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(data_in_IBUF[2]),
        .Q(q0[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  (* \PinAttr:D:HOLD_DETOUR  = "2271" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_03
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
    ff_04
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
    ff_10
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d2[0]),
        .Q(q2[0]));
  LUT1 #(
    .INIT(2'h1)) 
    ff_10_i_1
       (.I0(q1[3]),
        .O(d2[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_11
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(q1[4]),
        .Q(q2[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_12
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d2[2]),
        .Q(q2[2]));
  LUT1 #(
    .INIT(2'h1)) 
    ff_12_i_1
       (.I0(q1[0]),
        .O(d2[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_13
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(q1[1]),
        .Q(q2[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_14
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(q1[2]),
        .Q(q2[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_15
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d3[0]),
        .Q(q3[0]));
  LUT1 #(
    .INIT(2'h1)) 
    ff_15_i_1
       (.I0(q2[0]),
        .O(d3[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_16
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(ff_16_i_1_n_0),
        .Q(q3[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h9)) 
    ff_16_i_1
       (.I0(q2[0]),
        .I1(q2[1]),
        .O(ff_16_i_1_n_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_17
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d3[2]),
        .Q(q3[2]));
  (* \PinAttr:I2:HOLD_DETOUR  = "190" *) 
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h1E)) 
    ff_17_i_1
       (.I0(q2[1]),
        .I1(q2[0]),
        .I2(q2[2]),
        .O(d3[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_18
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(ff_18_i_1_n_0),
        .Q(q3[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hE01F)) 
    ff_18_i_1
       (.I0(q2[0]),
        .I1(q2[1]),
        .I2(q2[2]),
        .I3(q2[3]),
        .O(ff_18_i_1_n_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_19
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d3[4]),
        .Q(q3[4]));
  (* \PinAttr:I4:HOLD_DETOUR  = "148" *) 
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h1115EEEA)) 
    ff_19_i_1
       (.I0(q2[3]),
        .I1(q2[2]),
        .I2(q2[1]),
        .I3(q2[0]),
        .I4(q2[4]),
        .O(d3[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_20
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d4[0]),
        .Q(result_OBUF[0]));
  LUT1 #(
    .INIT(2'h1)) 
    ff_20_i_1
       (.I0(q3[3]),
        .O(d4[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_21
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d4[1]),
        .Q(result_OBUF[1]));
  LUT1 #(
    .INIT(2'h1)) 
    ff_21_i_1
       (.I0(q3[4]),
        .O(d4[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_22
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(d4[2]),
        .Q(result_OBUF[2]));
  (* \PinAttr:I0:HOLD_DETOUR  = "171" *) 
  LUT1 #(
    .INIT(2'h1)) 
    ff_22_i_1
       (.I0(q3[0]),
        .O(d4[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_23
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(q3[1]),
        .Q(result_OBUF[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  FDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0)) 
    ff_24
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(q3[2]),
        .Q(result_OBUF[4]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_05
       (.CLR(reset_IBUF),
        .D(d1[0]),
        .G(clk),
        .GE(1'b1),
        .Q(q1[0]));
  LUT1 #(
    .INIT(2'h1)) 
    latch_05_i_1
       (.I0(q0[0]),
        .O(d1[0]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_06
       (.CLR(reset_IBUF),
        .D(latch_06_i_1_n_0),
        .G(clk),
        .GE(1'b1),
        .Q(q1[1]));
  LUT2 #(
    .INIT(4'h9)) 
    latch_06_i_1
       (.I0(q0[0]),
        .I1(q0[1]),
        .O(latch_06_i_1_n_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_07
       (.CLR(reset_IBUF),
        .D(d1[2]),
        .G(clk),
        .GE(1'b1),
        .Q(q1[2]));
  LUT3 #(
    .INIT(8'h1E)) 
    latch_07_i_1
       (.I0(q0[1]),
        .I1(q0[0]),
        .I2(q0[2]),
        .O(d1[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_08
       (.CLR(reset_IBUF),
        .D(d1[3]),
        .G(clk),
        .GE(1'b1),
        .Q(q1[3]));
  LUT4 #(
    .INIT(16'h1FE0)) 
    latch_08_i_1
       (.I0(q0[0]),
        .I1(q0[1]),
        .I2(q0[2]),
        .I3(q0[3]),
        .O(d1[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* DONT_TOUCH *) 
  LDCE #(
    .INIT(1'b0),
    .IS_CLR_INVERTED(1'b0),
    .IS_G_INVERTED(1'b0)) 
    latch_09
       (.CLR(reset_IBUF),
        .D(d1[4]),
        .G(clk),
        .GE(1'b1),
        .Q(q1[4]));
  LUT5 #(
    .INIT(32'h57FFA800)) 
    latch_09_i_1
       (.I0(q0[2]),
        .I1(q0[1]),
        .I2(q0[0]),
        .I3(q0[3]),
        .I4(q0[4]),
        .O(d1[4]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF \result_OBUF[0]_inst 
       (.I(result_OBUF[0]),
        .O(result[0]));
  OBUF \result_OBUF[1]_inst 
       (.I(result_OBUF[1]),
        .O(result[1]));
  OBUF \result_OBUF[2]_inst 
       (.I(result_OBUF[2]),
        .O(result[2]));
  OBUF \result_OBUF[3]_inst 
       (.I(result_OBUF[3]),
        .O(result[3]));
  OBUF \result_OBUF[4]_inst 
       (.I(result_OBUF[4]),
        .O(result[4]));
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
