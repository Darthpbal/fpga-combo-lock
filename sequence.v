`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/11/20 19:57:09
// Design Name:
// Module Name: sequence
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module sequence(
    input clk,
    input reset,
    input [3:0] x,
    output [3:0] y
    //    output [3:0] nowst,
    //    output [15:0] codeout
    );
    parameter
      lock = 0,         //
      first = 1,        //
      second = 2,       //
      third = 3,        //
      forth = 4,        //

      defPass1 = 5, //wait for first letter
      defPass2 = 6,
      defPass3 = 7,
      defPass4 = 8,
       defPassWait= 9,

      lockout = 10,      //
      lockout2 = 11,     //
      lock2 = 12,        //
      first2 = 13,       //
      second2 = 14,      //
      third2 = 15;      //


      reg [15:0] code=16'h0000;
      reg [15:0] usrCode = 16'h0000;
      reg [3:0] y;
      reg [3:0] state=4'b0000;
      reg [3:0] next=4'b0000;
      reg [1:0] errPass = 2'b00;

    always@(posedge clk or posedge reset)begin
            if (reset)begin
              state <= lock;
            end
            else begin
              state <= next;
            end
    end



//assign nowst=state;
//assign codeout=code;
    always@(x or state)begin
        case(state)
            lock:begin
                if(x==code[15:12])begin
                    next <= first;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock;
                    end
                end
                y=4'b0000;
            end
            first:begin
                if(x==code[11:8])begin
                    next <= second;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock;
                    end
                end
                y=4'b0000;
            end
            second:begin
                if(x==code[7:4])begin
                    next <= third;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock;
                    end
                end
                y=4'b0000;
            end
            third:begin
                if(x==code[3:0])begin
                    next <= forth;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock;
                    end
                end
                y=4'b0000;
            end
            forth:begin
                if(x==4'h0)begin
                    next <= defPass1;
                    errPass = 2'b00;
                    code=code+16'b0000000000000001;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock;
                    end
                end

                y=4'b0001;
            end


            defPass1: begin
                usrCode[15:12] <= x;
                next <= defPass2;
            end
            defPass2: begin
                usrCode[11:8] <= x;
                next <= defPass3;
            end
            defPass3: begin
                usrCode[7:4] <= x;
                next <= defPass4;
            end
            defPass4: begin
                usrCode[3:0] <= x;
                next <= lock;
            end


            lockout:begin
                if(x==4'hb)begin///////////////////////////////////////////////////////////////////////////////////
                    next <= lockout2;
                end
                else begin
                    next <= lockout;
                end
                y=4'b0010;
            end

            lockout2:begin
                if(x==4'hc)begin///////////////////////////////////////////
                    next <= forth;
                    errPass <= 2'b00;
                end
                else begin
                    next <= lockout;
                end
                y=4'b0010;
            end

            lock2:begin
                if(x==usrCode[15:12])begin
                    next <= first2;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock2;
                        // next <= lockout;
                    end
                end
                y=4'b0000;
            end

            first2:begin
                if(x==usrCode[11:8])begin
                    next <= second2;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock2;
                        // next <= lockout;
                    end
                end
                y=4'b0000;
            end

            second2:begin
                if(x==usrCode[7:4])begin
                    next <= third2;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock2;
                        // next <= lockout;
                    end
                end
                y=4'b0000;
            end

            third2:begin
                if(x==usrCode[3:0])begin
                    next <= forth;
                end
                else begin
                    if(errPass == 2'b11) next <= lockout;
                    else begin
                        errPass = errPass + 2'b01;
                        next <= lock2;
                        // next <= lockout;
                    end
                end
                y=4'b0000;
            end

            default:y=4'b0000;
        endcase
    end
endmodule
