`timescale 1ns/1ps
module tb;
initial $sdf_annotate("routed.sdf",dut,,,"MAXIMUM");
integer ext_edges=0, int_edges=0;
reg clk=0,reset=1; reg [15:0] data_in=0;
wire [15:0] result; wire valid_out;
small25 dut(.clk_in(clk),.reset(reset),.data_in(data_in),.result(result),.valid_out(valid_out));
always @(posedge clk) ext_edges=ext_edges+1;
always @(posedge dut.clk) int_edges=int_edges+1;
always #5 clk=~clk;
reg [15:0] queue[0:4]; reg [31:0] rng=32'h12345678;
integer i,j,k,count=0,checks=0,errors=0;
function [15:0] reference;
input [15:0] x; reg [15:0] y; integer n;
begin y=x; for(n=1;n<=12;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff); reference=y; end
endfunction
always @(posedge dut.clk) begin
 if(reset) begin count=0; for(k=0;k<5;k=k+1) queue[k]=0; end
 else begin
  count=count+1;
  for(k=4;k>0;k=k-1) queue[k]=queue[k-1]; queue[0]=reference(data_in);
 end
 #4;
 checks=checks+1;
 if(valid_out !== (count>=5) || result !== ((count>=5)?queue[4]:16'b0)) begin
  errors=errors+1; if(errors<6) $display("MISMATCH count=%0d got=%h expected=%h valid=%b",count,result,queue[4],valid_out);
 end
end
initial begin
 wait(dut.common_mmcm.LOCKED === 1'b1); repeat(10) @(negedge clk);
 for(i=0;i<4096;i=i+1) begin
  @(negedge clk); #1;
  reset=(i%1024<6);
  rng=rng^(rng<<13); rng=rng^(rng>>17); rng=rng^(rng<<5);
  case(i%8)
   0:data_in=0; 1:data_in=16'hffff; 2:data_in=16'h8000; 3:data_in=16'h7fff;
   default:data_in=rng[15:0];
  endcase
 end
 repeat(8) @(negedge clk);
 $display("CLOCK_DIAG external=%0d internal=%0d locked=%b clk=%b",ext_edges,int_edges,dut.common_mmcm.LOCKED,dut.clk);
 $display("ALIGNED_RESULT checks=%0d errors=%0d",checks,errors); $finish;
end
endmodule

