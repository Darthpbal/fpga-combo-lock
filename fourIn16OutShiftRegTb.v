`timescale 1ns / 1ps
module fourIn16OutShiftReg_tb ();
    reg [3:0] in;
    reg trig, rst;
    wire [15:0] out;
    wire [3:0] seg3, seg2, seg1, seg0;


    fourIn16OutShiftReg dut(
        .in(in),
        .trig(trig),
        .rst(rst),
        .out(out)
    );

    assign seg3 = out[15:12];
    assign seg2 = out[11:8];
    assign seg1 = out[7:4];
    assign seg0 = out[3:0];

    initial begin
        in = 0;
        trig = 0;
        rst = 1;
        #4;
        rst = 0;
        #4;



        in = 0;
        trig = 1; #2 trig = 0;
        #4

        in = 4;
        trig = 1; #2 trig = 0;
        #4
        in = 3;
        trig = 1; #2 trig = 0;
        #4
        in = 2;
        trig = 1; #2 trig = 0;
        #4
        in = 1;
        trig = 1; #2 trig = 0;
        #4;

        in = 4'hF;
        trig = 1; #2 trig = 0;
        #4
        in = 4'hF;
        trig = 1; #2 trig = 0;
        #4
        in = 4'hF;
        trig = 1; #2 trig = 0;
        #4
        in = 4'hF;
        trig = 1; #2 trig = 0;
        #4;
        rst = 1; #2 rst = 0;
        $finish;
    end
endmodule
