`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/20 20:16:11
// Design Name: 
// Module Name: sequence_tb
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


module sequence_tb;
reg clk,reset;
reg [3:0] x;
wire [3:0] y;
wire [3:0] nowst;
wire [15:0] codeout;
sequence uut(clk,reset,x,y,nowst,codeout);
task tog;
 begin
  #1 clk=~clk;
  #1 clk=~clk;
end
endtask

initial begin
clk=0;
    x=4'h1; tog;
  x=4'h0; tog;
  x=4'h1; tog;
  x=4'h2; tog;
  x=4'h3; tog;
  
  x=4'h0;tog;//1234
  
  x=4'h1; tog;
  x=4'h2; tog;
  x=4'h3; tog;
  x=4'h4; tog;
  
  x=4'h0; tog;//2345
  
 x=4'ha; tog;
  x=4'hb; tog;
  x=4'hc; tog;
  x=4'hd; tog
  ;
  x=4'hb; tog;
  x=4'hc;tog; 
 x=4'h0; tog;
 
 x=4'h1; tog;
 x=4'h1; tog;//lockout
 
 
  x=4'hb; tog;
  x=4'hc; tog;
  x=4'hd; tog;
 x=4'he; tog;
 x=4'h0; tog;
  $finish;
end
endmodule
