`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 03:59:23 PM
// Design Name: 
// Module Name: GCD_Code
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

module GCD_datapath(lt,gt,eq,lda,ldb,sel1,sel2,data_in,selin,clk);
input lda,ldb,sel1,sel2,selin,clk;
input[15:0] data_in;
output lt,gt,eq;
wire[15:0] Aout,Bout,X,Y,bus,subout;

PIPO A(Aout,lda,bus,clk);
PIPO B(Bout,ldb,bus,clk);
mux mux1(X,Aout,Bout,sel1);
mux mux2(Y,Aout,Bout,sel2);
mux mux3(bus,subout,data_in,selin);
SUB S(subout,X,Y);
COMP C(lt,gt,eq,Aout,Bout);
endmodule

module PIPO(dout,ld,din,clk);
input[15:0] din;
output reg[15:0] dout;
input ld,clk;
always@(posedge clk)
if(ld)
dout<=din;
endmodule

module mux(out,in0,in1,sel);
input sel;
input[15:0] in0,in1;
output[15:0] out;
assign out=sel? in1:in0;
endmodule

module SUB(out,in1,in2);
input[15:0] in1,in2;
output reg[15:0] out;
always@(*)
out<=in1-in2;
endmodule

module COMP(lt,gt,eq,Aout,Bout);
input[15:0] Aout,Bout;
output lt,gt,eq;
assign lt=Aout<Bout;
assign gt=Aout>Bout;
assign eq=Aout==Bout;
endmodule
                                                 
                                               

module GCD_controller(lda,ldb,sel1,sel2,selin,done,clk,lt,gt,eq,start);
input clk,lt,gt,eq,start;
output reg lda,ldb,sel1,sel2,selin,done;
reg[15:0] state;
parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
always@(posedge clk)
begin
case(state)
S0: if(start) state<=S1;
S1: state <=S2;
S2: #2 if(eq) state<=S5;
    else if(lt) state<=S3;
    else if(gt) state<=S4;
S3: #2 if(eq) state<=S5;
    else if(lt) state<=S3;
    else if(gt) state<=S4;
S4: #2 if(eq) state<=S5;
    else if(lt) state<=S3;
    else if(gt) state<=S4;
S5: state <=S5;
default: state<=S0;
endcase
end
always@(state)
begin
case(state)
S0: begin selin=1; lda=1;ldb=0;done=0;end
S1: begin selin=1;lda=0;ldb=1;end
S2: if(eq) done=1;
    else if(lt)
    begin
    sel1=1;sel2=0;selin = 0;
    #1 lda=0;ldb=1;
    end
    else if(gt) 
    begin
    sel1=0;sel2=1;selin=0;
    #1 lda=1;ldb=0;
    end
S3: if(eq) done=1;
    else if(lt)
    begin
    sel1=1;sel2=0;selin=0;
    #1 lda=0;ldb=1;
    end
    else if(gt)
    begin
    sel1=0;sel2=1;selin=0;
    #1 lda=1;ldb=0;
    end
S4: if(eq) done=1;
    else if(lt)
    begin
    sel1=1;sel2=0;selin=0;
    #1 lda=0;ldb=1;
    end
    else if(gt)
    begin
    sel1=0;sel2=1;selin=0;
    #1 lda=1;ldb=0;
    end
S5: begin
    done=1;sel1=0;sel2=0;lda=0;
    ldb=0;
    end
default: begin lda=0;ldb=0;end
endcase
end
endmodule
                                                 
                                                 
                                               