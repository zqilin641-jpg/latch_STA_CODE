`timescale 1ns/1ps
module tb;
reg ci=1,cy=0;reg[3:0]di=1,s=3;wire[3:0]co,q;
CARRY4 dut(.CI(ci),.CYINIT(cy),.DI(di),.S(s),.CO(co),.O(q));
initial begin
#10; s=1;
#0.161; s=3;
#0.336; ci=0;
#0.321; s=2;
#0.058; s=6;
#0.179; ci=1;
#10;
$display("REPLAY co=%b expected=0111 q=%b expected=1001",co,q);$finish;
end
endmodule
