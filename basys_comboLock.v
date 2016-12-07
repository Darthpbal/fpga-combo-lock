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
        output [1:0] led   //basys board LED array
    );

    wire slow_clk;
    slowclock forInput(
        .clk(clk),
        .reset(btnD),
        .slow_clk(slow_clk)
    );

    reg leftTrig, rightTrig;

    wire centerTrig; assign centerTrig = btnC & clk;

    always @ ( clk ) begin
        if(btnL) leftTrig <= 1;
        else leftTrig <= 0;
        if(btnR) rightTrig <= 1;
        else rightTrig <= 0;
        // leftTrig <= (btnL)? 1: 0;
        // rightTrig <= (btnR)? 1: 0;
        // centerTrig <= (btnC)? btnC & clk: 0;
    end

    wire [3:0] numSelect;
    upDownCount hexValSelector(
        .up(rightTrig),
        .down(leftTrig),
        .rst(btnD),
        .numOut(numSelect)
    );

    wire [15:0] pinCode;
    fourIn16OutShiftReg shiftInPin(
        .in(numSelect),
        .trig(centerTrig),
        .rst(btnD),
        .out(pinCode)
    );

    SevSegDriver comboLockDisplay(
        .clk(clk),
        .rst(btnD),
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
        .trig(centerTrig),
        .rst(btnD),
        .count(numCount),
        .flag(flag)
    );

    comboLockStateMachine stateMachine(
        .pinCode({pinCode[15:4], numSelect}),
        .trig(flag),
        .lock(btnU),
        .rst(btnD),
        .clk(clk),
        .state(led[1:0])
    );


endmodule
