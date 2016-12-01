`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2016 09:28:49 PM
// Design Name: 
// Module Name: topmodule
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


module topmodule(
    input clk,
    input [15:0] sw,
    input btnC,
    input btnU,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] led
    );
    wire [15:0] in;
    wire [3:0] lock;
    wire slow_clk;
    slowclock(clk,btnU,slow_clk);
    
    wire trigger; assign trigger = btnC & slow_clk;
    create_input(trigger,sw,in);
    diagram(in,btnU,trigger,lock,led);
    SevsegDisplay(lock,an,seg);
endmodule
