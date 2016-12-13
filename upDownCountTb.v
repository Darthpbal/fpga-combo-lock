`timescale 1ns / 1ps
module upDownCount_tb ();
    reg up, down, rst, clk;
    wire [3:0] number;
    wire up_deb, down_deb;

    debounce updb(.Clk(clk), .PB(up), .pulse(up_deb));
    debounce dndb(.Clk(clk), .PB(down), .pulse(down_deb));

    upDownCount dut(
        .up(up_deb),
        .down(down_deb),
        .rst(rst),
        .clk(clk),
        .numOut(number)
    );

    always begin
        #2 clk = ~clk;
    end

    initial begin
        rst = 1;
        up = 0;
        down = 0;
        clk = 0;
        #8;
        rst = 0;
        #8;
        //1
        up = 1;
        #8;
        up = 0;
        #8;
        //2
        up = 1;
        #8;
        up = 0;
        #8;
        //3
        up = 1;
        #8;
        up = 0;
        #8;
        //4
        up = 1;
        #8;
        up = 0;
        #8
        //4
        down = 1;
        #8;
        down = 0;
        #8
        //4
        down = 1;
        #8;
        down = 0;
        #8
        //4
        down = 1;
        #8;
        down = 0;
        #8
        //4
        down = 1;
        #8;
        down = 0;
        #8
        //4
        down = 1;
        #8;
        down = 0;
        #8

        rst = 1;
        #30;

        $finish;
    end
endmodule
