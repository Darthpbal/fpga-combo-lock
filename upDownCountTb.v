`timescale 1ns / 1ps
module upDownCount_tb ();
    reg up, down, rst;
    wire [3:0] number;


    upDownCount dut(
        .up(up)
        .down(down)
        .rst(rst)
        .numOut(numOut)
    );

    parameter clk_period = 4;
    always #clk_period clk = ~clk;


    initial begin
        clk = 0;
        rst = 1;
        up = 0;
        down = 0;
        #(clk_period * 4);
        rst = 0;
        #(clk_period * 4);
        //1
        up = 1;
        #(clk_period * 4);
        up = 0;
        #(clk_period * 4);
        //2
        up = 1;
        #(clk_period * 4);
        up = 0;
        #(clk_period * 4);
        //3
        up = 1;
        #(clk_period * 4);
        up = 0;
        #(clk_period * 4);
        //4
        up = 1;
        #(clk_period * 4);
        up = 0;
        #(clk_period * 4);




        $finish
    end
endmodule
