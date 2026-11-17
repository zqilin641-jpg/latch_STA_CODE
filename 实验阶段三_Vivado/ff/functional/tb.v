`timescale 1ns/1fs
module tb;
reg clk_in=0,reset=1,grs_n=0;
reg [24:0] clocks;
reg [4:0] data_in=0;
wire [4:0] result;wire locked;
integer i,j,n,errors=0,checks=0;
reg [4:0] words[0:2063];reg [4:0] expected;

small25 dut(.clk_in(clocks[0]),.reset(reset),.data_in(data_in),.result(result));
initial begin clocks[0]=0; #(0.000000000000); forever begin clocks[0]=1; #(6.060606060606); clocks[0]=0; #(6.060606060606); end end
initial begin clocks[1]=0; #(0.000000000000); forever begin clocks[1]=1; #(6.060606060606); clocks[1]=0; #(6.060606060606); end end
initial begin clocks[2]=0; #(0.000000000000); forever begin clocks[2]=1; #(6.060606060606); clocks[2]=0; #(6.060606060606); end end
initial begin clocks[3]=0; #(0.000000000000); forever begin clocks[3]=1; #(6.060606060606); clocks[3]=0; #(6.060606060606); end end
initial begin clocks[4]=0; #(0.000000000000); forever begin clocks[4]=1; #(6.060606060606); clocks[4]=0; #(6.060606060606); end end
initial begin clocks[5]=0; #(0.000000000000); forever begin clocks[5]=1; #(6.060606060606); clocks[5]=0; #(6.060606060606); end end
initial begin clocks[6]=0; #(0.000000000000); forever begin clocks[6]=1; #(6.060606060606); clocks[6]=0; #(6.060606060606); end end
initial begin clocks[7]=0; #(0.000000000000); forever begin clocks[7]=1; #(6.060606060606); clocks[7]=0; #(6.060606060606); end end
initial begin clocks[8]=0; #(0.000000000000); forever begin clocks[8]=1; #(6.060606060606); clocks[8]=0; #(6.060606060606); end end
initial begin clocks[9]=0; #(0.000000000000); forever begin clocks[9]=1; #(6.060606060606); clocks[9]=0; #(6.060606060606); end end
initial begin clocks[10]=0; #(0.000000000000); forever begin clocks[10]=1; #(6.060606060606); clocks[10]=0; #(6.060606060606); end end
initial begin clocks[11]=0; #(0.000000000000); forever begin clocks[11]=1; #(6.060606060606); clocks[11]=0; #(6.060606060606); end end
initial begin clocks[12]=0; #(0.000000000000); forever begin clocks[12]=1; #(6.060606060606); clocks[12]=0; #(6.060606060606); end end
initial begin clocks[13]=0; #(0.000000000000); forever begin clocks[13]=1; #(6.060606060606); clocks[13]=0; #(6.060606060606); end end
initial begin clocks[14]=0; #(0.000000000000); forever begin clocks[14]=1; #(6.060606060606); clocks[14]=0; #(6.060606060606); end end
initial begin clocks[15]=0; #(0.000000000000); forever begin clocks[15]=1; #(6.060606060606); clocks[15]=0; #(6.060606060606); end end
initial begin clocks[16]=0; #(0.000000000000); forever begin clocks[16]=1; #(6.060606060606); clocks[16]=0; #(6.060606060606); end end
initial begin clocks[17]=0; #(0.000000000000); forever begin clocks[17]=1; #(6.060606060606); clocks[17]=0; #(6.060606060606); end end
initial begin clocks[18]=0; #(0.000000000000); forever begin clocks[18]=1; #(6.060606060606); clocks[18]=0; #(6.060606060606); end end
initial begin clocks[19]=0; #(0.000000000000); forever begin clocks[19]=1; #(6.060606060606); clocks[19]=0; #(6.060606060606); end end
initial begin clocks[20]=0; #(0.000000000000); forever begin clocks[20]=1; #(6.060606060606); clocks[20]=0; #(6.060606060606); end end
initial begin clocks[21]=0; #(0.000000000000); forever begin clocks[21]=1; #(6.060606060606); clocks[21]=0; #(6.060606060606); end end
initial begin clocks[22]=0; #(0.000000000000); forever begin clocks[22]=1; #(6.060606060606); clocks[22]=0; #(6.060606060606); end end
initial begin clocks[23]=0; #(0.000000000000); forever begin clocks[23]=1; #(6.060606060606); clocks[23]=0; #(6.060606060606); end end
initial begin clocks[24]=0; #(0.000000000000); forever begin clocks[24]=1; #(6.060606060606); clocks[24]=0; #(6.060606060606); end end
function [4:0] reference;
input [4:0] v;reg [4:0] x;
begin x=v+5'd3;x={x[2:0],x[4:3]}^5'd5;x=x+5'd11;reference={x[2:0],x[4:3]}^5'd7;end
endfunction
initial begin
 for(i=0;i<2064;i=i+1) words[i]=0;
 for(i=0;i<1024;i=i+1) begin words[8+2*i]=i/32;words[9+2*i]=i%32;end
 #(121.212121212121);grs_n=1; #(1.212121212121);reset=0; #(120.000000000000);
 for(i=0;i<2064;i=i+1) begin
  #0.2;data_in=words[i]; #(11.871212121212);
  j=i-5;
  if(j>=8 && j<2056) begin
   expected=reference(words[j]);checks=checks+1;
   if(result!==expected) begin errors=errors+1;if(errors<5) $display("MISMATCH i=%0d got=%0d expected=%0d",i,result,expected);end
  end
  #0.05;
 end
 $display("FUNCTION_RESULT checks=%0d errors=%0d",checks,errors);$finish;
end
initial begin #(26666.666666666668);$display("FUNCTION_TIMEOUT");$finish;end
endmodule
