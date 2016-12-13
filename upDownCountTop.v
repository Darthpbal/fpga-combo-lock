/*
Top module is modeled as the basys board itself to
be more intuitive.
*/
`timescale 1ns / 1ps

module upDownCountTop (
        // input [15:0] swt,   //basys board switches
        input clk,          //basys board clock
        // input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        input btnL,         //up button on basys board
        input btnR,         //up button on basys board
        // input btnC,         //up button on basys board
        output [3:0] segEn, //basys seven segment enable bus
        output segDec,         //seven segment decimal point
        output [6:0] sevSeg//seven segment signals
        // output [15:0] led   //basys board LED array
    );

    //left, scroll left
    //right, scroll right
    //down, reset

    wire btnD_deb, btnL_deb, btnR_deb;
    debounce debouncer(.Clk(clk), .PB(btnD), .pulse(btnD_deb));
    debounce debouncer(.Clk(clk), .PB(btnL), .pulse(btnL_deb));
    debounce debouncer(.Clk(clk), .PB(btnR), .pulse(btnR_deb));

    wire numberSelection;
    upDownCount numSelector(.up(btnR_deb), .down(btnL_deb), .rst(btnD_deb), .numOut(numberSelection));

    SevSegDriver disp(.clk(clk),
                    .rst(btnD_deb),
                    .disp3(4'h0),
                    .disp2(4'h0),
                    .disp1(4'h0),
                    .disp0(numberSelection),
                    .segEn(segEn),
                    .seg(sevSeg)
                );

endmodule
