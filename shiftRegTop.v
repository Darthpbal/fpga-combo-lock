/*
Top module is modeled as the basys board itself to
be more intuitive.
*/
`timescale 1ns / 1ps

module fourIn16OutShiftRegTop (
        input [3:0] swt,   //basys board switches
        input clk,          //basys board clock
        // input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        // input btnL,         //up button on basys board
        // input btnR,         //up button on basys board
        input btnC,         //up button on basys board
        output [3:0] segEn, //basys seven segment enable bus
        // output segDec,         //seven segment decimal point
        output [6:0] seg   //seven segment signals
        // output [15:0] led   //basys board LED array
    );
    //down reset
    //center trigger

    wire btnD_deb, btnC_deb;
    debounce down(.Clk(clk), .PB(btnD), .pulse(btnD_deb));
    debounce center(.Clk(clk), .PB(btnC), .pulse(btnC_deb));

    wire [15:0] regVal;
    fourIn16OutShiftReg shiftReg(.in(swt), .trig(btnC_deb), .rst(btnD_deb), .out(regVal));

    SevSegDriver display(
                        .clk(clk),
                        .rst(btnD_deb),
                        .disp3(regVal[15:12]),
                        .disp2(regVal[11:8]),
                        .disp1(regVal[7:4]),
                        .disp0(regVal[3:0]),
                        .segEn(segEn),
                        .seg(seg)
                    );

endmodule
