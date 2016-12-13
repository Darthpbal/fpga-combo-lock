/*
Top module is modeled as the basys board itself to
be more intuitive.
*/
`timescale 1ns / 1ps

module comboLockStateMachineTop (
        input [15:0] swt,   //basys board switches
        input clk,          //basys board clock
        input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        // input btnL,         //up button on basys board
        // input btnR,         //up button on basys board
        input btnC,         //up button on basys board
        output [3:0] segEn, //basys seven segment enable bus
        // output segDec,         //seven segment decimal point
        output [6:0] seg,   //seven segment signals
        output [1:0] led,   //basys board LED array
        output [1:0] errCount   //basys board LED array
    );
    //down reset
    //up lock
    //center trig
    wire btnD_deb, btnU_deb, btnC_deb;
    debounce reset(.Clk(clk), .PB(btnD), .pulse(btnD_deb));
    debounce lock(.Clk(clk), .PB(btnU), .pulse(btnU_deb));
    debounce trigger(.Clk(clk), .PB(btnC), .pulse(btnC_deb));

    comboLockStateMachine stateMachine(
            .pinCode(swt),
            .trig(btnC_deb),
            .lock(btnU_deb),
            .rst(btnD_deb),
            .clk(clk),
            .state(led),
            .errCount(errCount)
        );

    SevSegDriver display(
            .clk(clk),
            .rst(btnD_deb),
            .disp3(swt[15:12]),
            .disp2(swt[11:8]),
            .disp1(swt[7:4]),
            .disp0(swt[3:0]),
            .segEn(segEn),
            .seg(seg)
        );

endmodule
