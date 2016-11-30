`timescale 1ns / 1ps

module countTo4 (
        input trig, rst,
        output reg [2:0] count
    );

    always @ ( negedge trig, posedge rst ) begin
        if(rst) count <= 0;
        else begin
            if(count == 3'b100) count <= 0;
            else count <= count + 1;
        end
    end
endmodule
