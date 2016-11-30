`timescale 1ns / 1ps
module SevSegDriver_tb ();
    reg clk, rst;
    reg [3:0] disp3, disp2, disp1, disp0;
    // reg [15:0] counter;

    wire [3:0] segEn;
    wire [6:0] seg;

    SevSegDriver dut(.clk(clk),
                    .rst(rst),
                    .disp3(disp3),
                    .disp2(disp2),
                    .disp1(disp1),
                    .disp0(disp0),
                    .segEn(segEn),
                    .seg(seg)
                );

    parameter clk_period = 10;

    always #clk_period clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #(clk_period * 6);
        rst = 0;
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h0;
        #(clk_period * 6);
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h1;
        #(clk_period * 6);
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h2;
        #(clk_period * 6);
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h3;
        #(clk_period * 6);
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'hF;
        #(clk_period * 6);
        $finish;
        rst = 0;
        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h0;
        #(clk_period * 6);

        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h1;
        #(clk_period * 6);

        disp3 = 4'h0; disp2 = 4'h0; disp1 = 4'h1; disp0 = 4'h0;
        #(clk_period * 6);

        disp3 = 4'h0; disp2 = 4'h1; disp1 = 4'h0; disp0 = 4'h0;
        #(clk_period * 6);

        disp3 = 4'h1; disp2 = 4'h0; disp1 = 4'h0; disp0 = 4'h0;
        #(clk_period * 6);



        disp3 = 4'h3; disp2 = 4'h2; disp1 = 4'h1; disp0 = 4'h0;
        #(clk_period * 6);
        $finish;

    end
endmodule
