`timescale 1ns/1fs
module tb;
wire [4:0] ff_result; wire ff_locked;
integer checked=0, err0=0,err1=0,err5=0,ff_err5=0;

reg clk_in=0,reset=1,grs_n=0,observe=0;
reg [4:0] data_in=0;wire [4:0] result;wire locked;
integer i,j,errors=0,checks=0;reg [4:0] words[0:2063];reg [4:0] expected;
GTP_GRS GRS_INST(.GRS_N(grs_n));
ff_reference control(clk_in,reset,data_in,ff_result,ff_locked);
small25 dut(clk_in,reset,data_in,result,locked);
always #10 clk_in=~clk_in;
integer nr0=0,nf0=0;
always @(posedge dut.clocks[0]) if(observe && nr0<32) begin $display("EDGE 0 R %.9f",$realtime);nr0=nr0+1;end
always @(negedge dut.clocks[0]) if(observe && nf0<32) begin $display("EDGE 0 F %.9f",$realtime);nf0=nf0+1;end
function [4:0] reference;input [4:0] v;reg [4:0] x;
begin x=v+5'd3;x={x[2:0],x[4:3]}^5'd5;x=x+5'd11;reference={x[2:0],x[4:3]}^5'd7;end
endfunction
initial begin
 for(i=0;i<2064;i=i+1) words[i]=0;
 for(i=0;i<1024;i=i+1) begin words[8+2*i]=i/32;words[9+2*i]=i%32;end
 #100 grs_n=1;wait(locked===1'b1 && ff_locked===1'b1);$display("ALL_LOCKED %.9f",$realtime);
 repeat(20) @(posedge dut.clocks[0]);#0.1;reset=0;observe=1;
 for(i=0;i<2064;i=i+1) begin
  @(posedge dut.clocks[0]);#0.2;data_in=words[i];#(11.871212121212);
  if(i>=13 && i<2061) begin
     checked=checked+1;
     if(result!==reference(words[i])) err0=err0+1;
     if(result!==reference(words[i-1])) err1=err1+1;
     if(result!==reference(words[i-5])) err5=err5+1;
     if(ff_result!==reference(words[i-5])) ff_err5=ff_err5+1;
   end
   j=i-1;if(j>=8 && j<2056) begin
   expected=reference(words[j]);checks=checks+1;
   if(result!==expected) begin errors=errors+1;if(errors<5) $display("MISMATCH %0d %0d %0d",i,result,expected);end
  end
 end
 $display("ALIGNMENT checks=%0d latch0=%0d latch1=%0d latch5=%0d ff5=%0d",checked,err0,err1,err5,ff_err5);
 $display("FUNCTION_RESULT checks=%0d errors=%0d",checks,errors);$finish;
end
initial begin #100000;$display("PLL_TIMEOUT");$finish;end
endmodule


