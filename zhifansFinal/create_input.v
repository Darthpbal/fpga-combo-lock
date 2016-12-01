`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2016 08:20:35 PM
// Design Name: 
// Module Name: create_input
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


module create_input(
    input press,
    input [15:0] switch,
    output reg [15:0] out
    );
    always@(posedge press)begin
        out = switch;
    end
endmodule
