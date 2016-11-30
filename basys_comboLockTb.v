`timescale 1ns / 1ps
module basys_tb ();
    reg [15:0] swt;
    reg clk, btnU, btnD, btnL, btnR, btnC;
    wire [3:0] segEn;
    wire segDec;
    wire [6:0] sevSeg;
    wire [15:0] led;

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

    parameter clk_period = 2;
    always #clk_period clk = ~clk;


    initial begin
        swt = 0;
        clk = 0;
        btnU = 0;
        btnD = 0;
        btnL = 0;
        btnR = 0;
        btnC = 0;
        #(clk_period * 3);

        swt[0] = 1'b0;
        #(clk_period * 3);




        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);

        #clk_period btnC = 1; #clk_period btnC = 0;//F
        #(clk_period * 3);

        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);
        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);
        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);
        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);
        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);

        #clk_period btnC = 1; #clk_period btnC = 0;//A
        #(clk_period * 3);

        #clk_period btnR = 1; #clk_period btnR = 0;
        #(clk_period * 3);
        #clk_period btnR = 1; #clk_period btnR = 0;
        #(clk_period * 3);

        #clk_period btnC = 1; #clk_period btnC = 0;//C
        #(clk_period * 3);

        #clk_period btnR = 1; #clk_period btnR = 0;
        #(clk_period * 3);
        #clk_period btnR = 1; #clk_period btnR = 0;
        #(clk_period * 3);

        #clk_period btnC = 1; #clk_period btnC = 0;//E
        #(clk_period * 8);
    end
endmodule
