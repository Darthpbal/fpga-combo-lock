`timescale 1ns / 1ps

module create_input(
    input press,
    input [15:0] switch,
    output reg [15:0] out
    );
    always@(posedge press)begin
        out = switch;
    end
endmodule
