/*
Top module is modeled as the basys board itself to
be more intuitive.
*/
`timescale 1ns / 1ps

module basys (
        // input [1:0] swt,   //basys board switches
        input clk,          //basys board clock
        input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        input btnL,         //up button on basys board
        input btnR,         //up button on basys board
        input btnC,         //up button on basys board
        output [3:0] segEn, //basys seven segment enable bus
        // output segDec,         //seven segment decimal point
        output [6:0] seg,//seven segment signals
        // output [2:0] numCount,
        output [15:0] led   //basys board LED array
    );

    assign led[3:2] = {btnR, btnR_debounce};
    assign led[15:4] = 0;


    wire btnL_debounce, btnR_debounce, btnU_debounce, btnC_debounce, btnD_debounce;
    debounce left( .Clk(clk), .PB(btnL), .pulse(btnL_debounce) );
    debounce right( .Clk(clk), .PB(btnR), .pulse(btnR_debounce) );
    debounce up( .Clk(clk), .PB(btnU), .pulse(btnU_debounce) );
    debounce center( .Clk(clk), .PB(btnC), .pulse(btnC_debounce) );
    debounce down( .Clk(clk), .PB(btnD), .pulse(btnD_debounce) );

    wire [3:0] numSelect;
    upDownCount hexValSelector(
        .up(btnR_debounce),
        .down(btnL_debounce),
        .rst(btnD_debounce),
        .clk(clk),
        .numOut(numSelect)
    );

    wire [15:0] pinCode;
    fourIn16OutShiftReg shiftInPin(
        .in(numSelect),
        .trig(btnC_debounce),
        .rst(btnD_debounce),
        .out(pinCode)
    );

    SevSegDriver comboLockDisplay(
        .clk(clk),
        .rst(btnD_debounce),
        .disp3(pinCode[15:12]),
        .disp2(pinCode[11:8]),
        .disp1(pinCode[7:4]),
        .disp0(numSelect),
        .segEn(segEn),
        .seg(seg)
    );

    wire [1:0] numCount;
    wire flag;
    countTo4 triggerMachineOn4(
        .trig(btnC_debounce),
        .rst(btnD_debounce),
        .count(numCount),
        .flag(flag)
    );

    comboLockStateMachine stateMachine(
        .pinCode({pinCode[15:4], numSelect}),
        .trig(flag),
        .lock(btnU_debounce),
        .rst(btnD_debounce),
        .clk(clk),
        .state(led[1:0])
    );


endmodule
