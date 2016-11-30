`timescale 1ns / 1ps

module upDownCount (
        input up, down, rst,
        output reg [3:0] numOut
    );

    always @ ( posedge up, posedge down, posedge rst ) begin
        if(rst) numOut <= 0;
        else begin
            if(up) numOut <= numOut + 1;
            else if(down) numOut <= numOut - 1;
            else numOut <= numOut;
        end
    end

endmodule
