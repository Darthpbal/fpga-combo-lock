`timescale 1ns / 1ps


module diagram(
    input [15:0] in,//input of code
    input reset,
    input clk,
    output reg [3:0] lock,
    output [3:0] state_out
    );
    reg [3:0] present=4'b0000;
    reg [3:0] next =4'b0000;
    reg [1:0] count_incorrect=2'b00;
    reg [15:0] user_code;

    parameter [3:0]
        S0=4'b0000,//wait for bank code    aaaa
        S1=4'b0001,//user define
        S2=4'b0010,//wait for user define code
        S3=4'b0011,//lockout   wait for override          ffff
        S4=4'b0100,//unlock state
        S5=4'b0101,
        S6=4'b0110;

    parameter [1:0]
        L=2'b00,
        U=2'b01,
        H=2'b10;

    assign state_out=present;

   // wire [3:0] in;
    //create_input(press,In,in);
    always@(posedge clk or posedge reset)
        begin
            if(reset)
            present <= S0;
            else
            present <= next;
        end

    always@(present or in)
    begin
        next = 4'bxxxx;
        lock=L;
            case(present)
                S0:begin
                        if(in==16'haaaa) //aaaa is bankexample
                         next <=S1;
                        else
                         next <=S0;

                        lock <= L;//moore machine output
                   end
                S1:begin
                        user_code <= in;
                        next <=S2;
                        count_incorrect=2'b00;
                        lock <=L;//moore machine output
                   end
                S2:begin
                        if(in==user_code)
                            next <=S4;
                        else
                        if(count_incorrect==2'b10) next <=S3;
                        else begin
                            count_incorrect <= count_incorrect+2'b01;
                            next <= S2;
                        end
                        lock <= L;
                   end
                S3:begin
                        if(in==16'hffff) next <=S1;
                        else next <=S3;
                        lock <= H;
                   end
                S4:begin
                        if(in !=user_code)
                            next <=S2;
                        else
                            next <=S4;
                        lock <= U;
                   end
               default:
                    next <=S0;
               endcase
    end

endmodule
