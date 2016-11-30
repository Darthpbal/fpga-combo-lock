`timescale 1ns / 1ps
module basys_tb ();
    //signals

    basys dut(
        .swt(swt),
        .clk(clk),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnC(btnC),
        .segEn(segEn),
        .segDec(segDec),
        .sevSeg(sevSeg),
        .led(led)
    );

    initial begin

    end
endmodule
