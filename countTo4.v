`timescale 1ns / 1ps

module countTo4 (
        input trig, rst,
        output reg [2:0] count,
        output reg flag
    );

    always @ ( negedge trig, posedge rst ) begin
        if(rst) begin
            count <= 0;
            flag <= 0;
        end
        else begin
            if(count == 2'b11) begin
                count <= 0;
                flag <= 1;
            end
            else begin
                flag <= 0;
                count <= count + 1;
            end
        end
    end
endmodule
