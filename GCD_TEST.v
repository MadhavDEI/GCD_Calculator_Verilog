`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 04:17:05 PM
// Design Name: 
// Module Name: GCD_TEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GCD_TEST;
reg[15:0] data_in;
reg clk,start;
wire done;
reg[15:0] A,B,state;
GCD_datapath DP(lt,gt,eq,lda,ldb,sel1,sel2,data_in,selin,clk);
GCD_controller CON(lda,ldb,sel1,sel2,selin,done,clk,lt,gt,eq,start);
initial begin 
clk=1'b0;
#3 start=1'b1;
#1000 $finish;
end

always#5 clk=~clk;
initial begin
#12 data_in=90;
#10 data_in=81;
end

initial begin
$monitor ($time,"%d %b",DP.Aout,done);
//$dumpfile ("gcd,vcd");
//$dumpvars(0,GCD_test);
end
endmodule
