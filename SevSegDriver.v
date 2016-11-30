`timescale 1ns / 1ps

module SevSegDriver(
        input clk, rst,
        input [3:0] disp3, disp2, disp1, disp0,
        output reg [3:0] segEn,
        output reg [6:0] seg
    );


    // parameter used for multiplexing the display output
    //change to 2 for simulation and to 20 for hardware (usually 18 < n < 25, lower is too fast, and higher is too slow)
    //2 would make it so that there's no delay where any displays are off, otherwise all displays are off until the 2 MSB are reached
    parameter n = 20;
    reg [n - 1:0] qReg, qNext;//counter registers for delaying the display operation for human eyes.
    reg [1:0] sel;//the 2 most significant bits of qReg, used for selecting the segment to display on.
    reg [3:0] disp;//the 4 bit number to display on the current segment


    //counter handoff and reset
    always @ ( posedge clk, posedge rst ) begin
        if (rst) qReg <= 0;
        else qReg <= qNext;
    end


    //handle assigning msb of counter registers to the display selector
    always @ ( qReg ) begin
        qNext = qReg + 1;       //count up the counters
        sel = qReg[n-1:n-2];    //assign 2 MSB of counter to display selector
    end


    //handles change for which display is on and what it's showing
    always @ ( sel, disp0, disp1, disp2, disp3) begin
        case (sel)
            2'b00: begin
                segEn <= 4'b1110;
                disp <= disp0;
            end
            2'b01: begin
                segEn <= 4'b1101;
                disp <= disp1;
            end
            2'b10: begin
                segEn <= 4'b1011;
                disp <= disp2;
            end
            2'b11: begin
                segEn <= 4'b0111;
                disp <= disp3;
            end
            default: begin
                segEn <= 4'b1111;
                disp <= 4'b0000;
            end
        endcase
    end


    //decode the display variable into the proper visual output for that number
    //this is the ternary version.
    // assign SSEG[6:0] =
    //     (DISP==4'b0000)? 7'b1000000 :  // 0,
    //     (DISP==4'b0001)? 7'b1111001 :  // 1,
    //     (DISP==4'b0010)? 7'b0100100 :  // 2,
    //     (DISP==4'b0011)? 7'b0110000 :  // 3,
    //     (DISP==4'b0100)? 7'b0011001 :  // 4,
    //     (DISP==4'b0101)? 7'b0010010 :  // 5,
    //     (DISP==4'b0110)? 7'b0000010 :  // 6,
    //     (DISP==4'b0111)? 7'b1111000 :  // 7,
    //     (DISP==4'b1000)? 7'b0000000 :  // 8,
    //     (DISP==4'b1001)? 7'b0011000 :  // 9,
    //     (DISP==4'b1010)? 7'b0001000 :  // A,
    //     (DISP==4'b1011)? 7'b0000011 :  // B,
    //     (DISP==4'b1100)? 7'b1000110 :  // C,
    //     (DISP==4'b1101)? 7'b0100001 :  // D,
    //     (DISP==4'b1110)? 7'b0000110 :  // E,
    //                      7'b0001110 ;  // F


    //decode the display variable into proper visual form
    //the case statement verison
    always @ ( disp ) begin
        case (disp)
            //hex display handling
            4'h0: seg <= 7'b1000000;
            4'h1: seg <= 7'b1111001;
            4'h2: seg <= 7'b0100100;
            4'h3: seg <= 7'b0110000;
            4'h4: seg <= 7'b0011001;
            4'h5: seg <= 7'b0010010;
            4'h6: seg <= 7'b0000010;
            4'h7: seg <= 7'b1111000;
            4'h8: seg <= 7'b0000000;
            4'h9: seg <= 7'b0010000;
            4'hA: seg <= 7'b0001000;
            4'hB: seg <= 7'b0000011;
            4'hC: seg <= 7'b1000110;
            4'hD: seg <= 7'b0100001;
            4'hE: seg <= 7'b0000110;
            4'hF: seg <= 7'b0001110;

            //combo lock state output
            // 4'h0: seg <= 7'b1000111; //L
            // 4'h1: seg <= 7'b1000001; //U
            // 4'h2: seg <= 7'b0001001; //H

            default: seg <= 7'b1111111;//all off
        endcase
    end

endmodule
