`timescale 1ns / 1ps

module diagram_tb;
    reg press;
    reg reset;
    reg [15:0] in;
    wire [3:0] lock;
    wire [3:0] state_out;

    diagram uut(in,reset,press,lock,state_out);

    task toggle;
        begin
            #1 press=~press;
            #1 press=~press;
        end
        endtask

    initial   begin
            press=0;
            reset=0;

           in=16'haaaa;
           toggle;

          in=16'h1000;
          toggle;

            in=16'h0000; toggle;

             in=16'h1000;    toggle;

         reset=1; toggle;
         reset=0;toggle;
         #10;

          in=16'haaaa;//bank example
                   toggle;

                  in=16'hbbcd;
                  toggle;

                    in=16'hffff; toggle;
                     in=16'h9876; toggle;
                      in=16'habce; toggle;
                     in=4'b0111;    toggle;
                     in=16'hffff;toggle;//override
                     in=16'b1111;toggle;//user set code the same as override code
                     in=16'b1111;toggle;//user try to unlock
         $finish;
        end

endmodule
