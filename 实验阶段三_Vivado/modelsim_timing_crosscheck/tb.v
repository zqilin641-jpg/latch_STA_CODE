`timescale 1ns/1ps
module tb;

integer ext_edges=0, int_edges=0;
reg clk=0,reset=1; reg [15:0] data_in=0;
wire [15:0] result; wire valid_out;
small25 dut(.clk_in(clk),.reset(reset),.data_in(data_in),.result(result),.valid_out(valid_out));
always @(posedge clk) ext_edges=ext_edges+1;
always @(posedge dut.clk) int_edges=int_edges+1;
always #6.0 clk=~clk;
reg [15:0] raw[0:4]; integer stage_errors=0; function [15:0] partial; input [15:0] x; input integer stop; reg [15:0] y; integer n; begin y=x; for(n=1;n<=stop;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff); partial=y; end endfunction
reg [15:0] queue[0:4]; reg [31:0] rng=32'h12345678;
integer i,j,k,count=0,checks=0,errors=0;
function [15:0] reference;
input [15:0] x; reg [15:0] y; integer n;
begin y=x; for(n=1;n<=12;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff); reference=y; end
endfunction
always @(posedge clk) begin
 if(reset) begin count=0; for(k=0;k<5;k=k+1) queue[k]=0; end
 else begin
  count=count+1; for(k=4;k>0;k=k-1) raw[k]=raw[k-1]; raw[0]=data_in;
  for(k=4;k>0;k=k-1) queue[k]=queue[k-1]; queue[0]=reference(data_in);
 end
 #9;
 checks=checks+1; if(count>=5 && stage_errors<5 && ({dut.input_ff_15.Q,dut.input_ff_14.Q,dut.input_ff_13.Q,dut.q0[12:0]}!==raw[0] || dut.q3!==partial(raw[1],3) || dut.q6!==partial(raw[2],6) || dut.q10!==partial(raw[3],10))) begin stage_errors=stage_errors+1; $display("STAGE count=%0d q0=%h/%h q3=%h/%h q6=%h/%h q10=%h/%h",count,{dut.input_ff_15.Q,dut.input_ff_14.Q,dut.input_ff_13.Q,dut.q0[12:0]},raw[0],dut.q3,partial(raw[1],3),dut.q6,partial(raw[2],6),dut.q10,partial(raw[3],10)); end
 if(valid_out !== (count>=5) || result !== ((count>=5)?queue[4]:16'b0)) begin
  errors=errors+1; if(errors<6) $display("MISMATCH count=%0d got=%h expected=%h valid=%b",count,result,queue[4],valid_out);
 end
end
initial begin
 wait(dut.common_mmcm.LOCKED === 1'b1); repeat(10) @(negedge clk);
 for(i=0;i<256;i=i+1) begin
  @(posedge clk); #2;
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

function [15:0] segment; input [15:0] x; input integer start_n,end_n; reg [15:0] y; integer n; begin y=x; for(n=start_n;n<=end_n;n=n+1) y={y[12:0],y[15:13]}+((16'h1357*n+16'h2461)&16'hffff);segment=y;end endfunction
always @(negedge clk) begin
 #4;
 if(count>=5 && count<15) $display("COMB count=%0d q6=%h op7=%h/%h op8=%h/%h op9=%h/%h op10=%h/%h",count,dut.q6,dut.op7,segment(dut.q6,7,7),dut.op8,segment(dut.q6,7,8),dut.op9,segment(dut.q6,7,9),dut.op10,segment(dut.q6,7,10));
end
always @(negedge clk) begin
#4;
if(count==9) $display("PINTRACE ci=%b source=%b s=%b di=%b co=%b q=%b op7=%h",dut.op8_inferred_i_1.CI,dut.op8_inferred_i_2_n_0,dut.op8_inferred_i_1.S,dut.op8_inferred_i_1.DI,dut.op8_inferred_i_1.CO,dut.op8_inferred_i_1.O,dut.op7);
end
always @(dut.op8_inferred_i_1.CI or dut.op8_inferred_i_1.CYINIT or dut.op8_inferred_i_1.S or dut.op8_inferred_i_1.DI or dut.op8_inferred_i_1.O or dut.op8_inferred_i_1.CO) if(count==9) $display("EVENT %0.3f ci=%b cy=%b s=%b di=%b co=%b q=%b",$realtime,dut.op8_inferred_i_1.CI,dut.op8_inferred_i_1.CYINIT,dut.op8_inferred_i_1.S,dut.op8_inferred_i_1.DI,dut.op8_inferred_i_1.CO,dut.op8_inferred_i_1.O);
always @(negedge clk) begin #4; if(count==9) $display("INTERNAL S_in=%b DI_in=%b CI_in=%b CO_fb=%b ideal=%b O=%b",dut.op8_inferred_i_1.S_in,dut.op8_inferred_i_1.DI_in,dut.op8_inferred_i_1.CI_in,dut.op8_inferred_i_1.CO_fb,dut.op8_inferred_i_1.S_in ^ dut.op8_inferred_i_1.CO_fb,dut.op8_inferred_i_1.O);end
endmodule



