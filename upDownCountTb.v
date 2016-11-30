`timescale 1ns / 1ps
module upDownCount_tb ();
    reg up, down, rst;
    wire [3:0] number;


    upDownCount dut(
        .up(up),
        .down(down),
        .rst(rst),
        .numOut(number)
    );



    initial begin
        rst = 1;
        up = 0;
        down = 0;
        #4;
        rst = 0;
        #4;
        //1
        up = 1;
        #4;
        up = 0;
        #4;
        //2
        up = 1;
        #4;
        up = 0;
        #4;
        //3
        up = 1;
        #4;
        up = 0;
        #4;
        //4
        up = 1;
        #4;
        up = 0;
        #4
        //4
        down = 1;
        #4;
        down = 0;
        #4
        //4
        down = 1;
        #4;
        down = 0;
        #4
        //4
        down = 1;
        #4;
        down = 0;
        #4
        //4
        down = 1;
        #4;
        down = 0;
        #4
        //4
        down = 1;
        #4;
        down = 0;
        #4

        rst = 1;
        #30;

        $finish;
    end
endmodule
