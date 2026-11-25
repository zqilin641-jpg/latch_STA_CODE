`timescale 1ns/1ps
module tb;
reg ci=0,cy=0; reg[3:0] di=0,s=0; wire[3:0] co,q;
CARRY4 dut(.CI(ci),.CYINIT(cy),.DI(di),.S(s),.CO(co),.O(q));
reg[3:0] eco,eq;reg c;integer i,j,errors=0;reg[31:0] rng=32'h12345678;
initial begin
for(i=0;i<4096;i=i+1) begin
rng=rng^(rng<<13);rng=rng^(rng>>17);rng=rng^(rng<<5);
{ci,cy,di,s}=rng[9:0]; c=ci|cy;
for(j=0;j<4;j=j+1)begin eq[j]=s[j]^c;c=s[j]?c:di[j];eco[j]=c;end
#10;
if(co!==eco || q!==eq)begin errors=errors+1;if(errors<8)$display("FAIL i=%0d ci=%b cy=%b di=%b s=%b co=%b/%b q=%b/%b",i,ci,cy,di,s,co,eco,q,eq);end
end
$display("CARRY_RESULT checks=4096 errors=%0d",errors);$finish;
end
endmodule
