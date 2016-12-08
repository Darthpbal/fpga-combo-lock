`timescale 1ns / 1ps
module basys_tb ();
    // reg [1:0] swt;
    reg clk, btnU, btnD, btnL, btnR, btnC;
    wire [3:0] segEn;
    // wire segDec;
    wire [6:0] seg;
    wire [15:0] led;
    // wire [2:0] numCount;


    basys dut(
        // .swt(swt),
        .clk(clk),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnC(btnC),
        .segEn(segEn),
        // .segDec(segDec),
        .seg(seg),
        // .numCount(numCount),
        .led(led)
    );

    parameter clk_period = 2;
    always #clk_period clk = ~clk;

    initial begin
        clk = 0;
        btnU = 0;
        btnD = 1;
        btnL = 0;
        btnR = 0;
        btnC = 0;
        #(clk_period * 3);

        btnD = 0;
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



        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);
        #clk_period btnL = 1; #clk_period btnL = 0;
        #(clk_period * 3);

        #clk_period btnC = 1; #clk_period btnC = 0;//C
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
        #(clk_period * 8);
        $finish;
    end
endmodule
