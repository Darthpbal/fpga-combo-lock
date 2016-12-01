`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2016 09:44:30 PM
// Design Name: 
// Module Name: slowclock
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


module slowclock(
    input clk,
    input reset,
    output reg slow_clk

    );
    reg [30:0] counter;
    always @(posedge clk or posedge reset)
     begin
         if (reset)
            begin
             counter = 30'd0;  //initialize Counter
             slow_clk = 1'b0;
            end
         else begin
             if(counter != 30'd50000000) 
                 counter = counter + 1'b1;
             else begin
                 counter = 30'd0;
                 slow_clk = ~ slow_clk;   
                  end
              end   
     end
endmodule
