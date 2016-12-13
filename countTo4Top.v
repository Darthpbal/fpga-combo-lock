/*
Top module is modeled as the basys board itself to
be more intuitive.
*/
`timescale 1ns / 1ps

module countTo4Top (
        // input [15:0] swt,   //basys board switches
        input clk,          //basys board clock
        // input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        // input btnL,         //up button on basys board
        // input btnR,         //up button on basys board
        input btnC,         //up button on basys board
        // output [3:0] segEn, //basys seven segment enable bus
        // output segDec,         //seven segment decimal point
        // output [6:0] seg,   //seven segment signals
        output [2:0] led   //basys board LED array
    );
    //center trigger
    //down reset

    wire btnD_deb, btnC_deb;
    debounce center(.Clk(clk), .PB(btnC), .pulse(btnC_deb));
    debounce down(.Clk(clk), .PB(btnD), .pulse(btnD_deb));

    countTo4 counter(
                    .trig(btnC_deb),
                    .rst(btnD_deb),
                    .count(led[1:0]),
                    .flag(led[2])
                );
endmodule
