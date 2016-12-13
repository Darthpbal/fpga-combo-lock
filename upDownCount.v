`timescale 1ns / 1ps

module upDownCount (
        input up, down, rst, clk,
        output reg [3:0] numOut
    );

    always @ ( posedge clk ) begin
        if(rst) numOut <= 1'b0;
        else begin
            if(up) numOut <= numOut + 1'b1;
            else if(down) numOut <= numOut - 1'b1;
            else numOut <= numOut;
        end
    end

endmodule
