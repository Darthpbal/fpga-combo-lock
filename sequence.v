`timescale 1ns / 1ps

module sequence(
        input trigger,
        input reset,
        input [3:0] in,
        output reg [3:0] state
    );

    parameter
      state = 0, state2 = 1;      //


    reg [15:0] defaultCode = 16'h0000, usrCode = 16'h0000;
    reg [31:0] overrideCode = 32'b0;
    reg [1:0] passErrCount = 2'b00;


    reg [3:0] state=4'b0000;
    reg [3:0] next=4'b0000;

    always@(posedge clk or posedge reset)begin
        if (reset)begin
          state <= lock;
        end
        else begin
          state <= next;
        end
    end


    always@(trigger or state)begin
        case(state)

            lock:begin
            end

        endcase
    end
endmodule
