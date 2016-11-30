`timescale 1ns / 1ps

module fourIn16OutShiftReg (
        input [3:0] in,
        input trig, rst,
        output reg [15:0] out
    );

    always @ ( negedge trig, posedge rst ) begin
        if(rst) out <= 0;
        else begin
            out <= {out[11:0], in};
        end
    end
endmodule
