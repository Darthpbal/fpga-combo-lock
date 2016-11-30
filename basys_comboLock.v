/*
Top module is modeled as the basys board itself to
be more intuitive.
*/


module basys (
        input [15:0] swt,   //basys board switches
        input clk,          //basys board clock
        input btnU,         //up button on basys board
        input btnD,         //up button on basys board
        input btnL,         //up button on basys board
        input btnR,         //up button on basys board
        input btnC,         //up button on basys board
        output [3:0] segEn, //basys seven segment enable bus
        output segDec,         //seven segment decimal point
        output [6:0] sevSeg,//seven segment signals
        output [15:0] led   //basys board LED array
    );

    wire [3:0] numSelect;
    upDownCount hexValSelector(
        .up(btnR),
        .down(btnL),
        .rst(swt[0]),
        .numOut(numSelect)
    );

    wire [15:0] pinCode;
    fourIn16OutShiftReg shiftInPin(
        .in(numSelect),
        .trig(btnC),
        .rst(swt[0]),
        .out(pinCode)
    );

    SevSegDriver comboLockDisplay(
        .clk(clk),
        .rst(swt[0]),
        .disp3(pinCode[15:12]),
        .disp2(pinCode[11:8]),
        .disp1(pinCode[7:4]),
        .disp0(numSelect),
        .segEn(segEn),
        .seg(sevSeg)
    );

    wire [2:0] numCount;
    countTo4 triggerMachineOn4(
        .trig(btnC),
        .rst(swt[0]),
        .count(numCount)
    );

    comboLockStateMachine(
        .pinCode(pinCode),
        .trig(numCount[2]),
        .lock(swt[15]),
        .rst(swt[0]),
        .clk(clk),
        .state(led[1:0])
    );


endmodule
