`timescale 1ns / 1ps
module comboLockStateMachine_tb ();
    reg [15:0] pinCode;
    reg trig, lock, rst, clk;
    wire [1:0] state;


    comboLockStateMachine dut(
        .pinCode(pinCode),
        .trig(trig),
        .lock(lock),
        .rst(rst),
        .clk(clk),
        .state(state)
    );

    parameter clk_period = 2;
    always #clk_period clk = ~clk;


    initial begin
        pinCode = 0;
        trig = 0;
        lock = 0;
        rst = 1;
        clk = 0;
        #4;
        rst = 0;
        #4;


        // trig = 1; #2 trig = 0; #4;

        pinCode = 16'hABCD;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        pinCode = 16'hBABA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        pinCode = 16'hFACE;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        pinCode = 16'hCACA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        pinCode = 16'hCACA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        lock = 1;
        #(clk_period * 3);
        lock = 0;
        #(clk_period * 3);

        pinCode = 16'hDADA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);

        pinCode = 16'hDADA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);

        pinCode = 16'hDADA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);

        pinCode = 16'hDADA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);

        pinCode = 16'hABBA;
        #(clk_period * 3);
        trig = 1;
        #(clk_period * 3);
        trig = 0;
        #(clk_period * 3);


        $finish;
    end
endmodule
