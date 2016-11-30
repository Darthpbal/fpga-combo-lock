`timescale 1ns / 1ps
module countTo4_tb ();
    reg trig, rst;
    wire [1:0] count;
    wire flag;


    countTo4 dut(
        .trig(trig),
        .rst(rst),
        .count(count),
        .flag(flag)
    );

    initial begin
        trig = 0;
        rst = 1;
        #4;
        // 1
        rst = 0;
        trig = 1; #2 trig = 0;
        #4
        // 2
        trig = 1; #2 trig = 0;
        #4
        // 3
        trig = 1; #2 trig = 0;
        #4
        // 4
        trig = 1; #2 trig = 0;
        #4
        // 0
        trig = 1; #2 trig = 0;
        #4;
        // 1
        trig = 1; #2 trig = 0;
        #4;
        rst = 1;
        #4;
        $finish;
    end
endmodule
