/*
Performance glitches exist in this file.
*/


`timescale 1ns / 1ps

module comboLockStateMachine (
        input [15:0] pinCode,
        input trig, lock, rst, clk,
        output reg [1:0] state, errCount
    );

    parameter defaultPass = 16'hFACE, override = 16'hDADA;
    parameter errMax = 3;
    parameter [1:0]
                locked = 3,
                unlocked = 1,
                lockout = 0,
                definePin = 2;

    reg [15:0] passWord = defaultPass;
    reg usrPinSet = 1'b0;
    reg [1:0] nextState;

    always @ ( posedge clk, posedge rst ) begin
        if(rst) state <= locked;
        else begin
            state <= nextState;
        end
    end

    reg errFlag, passSetFlag, rstCountFlag;
    wire trigSig;
    assign trigSig = lock | trig;
    always @ ( posedge trigSig, posedge rst ) begin
        nextState <= 2'bx;
        errFlag <= 0;
        passSetFlag <= 0;
        rstCountFlag <= 0;
        if(rst) begin
            nextState <= locked;
            errFlag <= 0;
            passSetFlag <= 0;
            rstCountFlag <= 0;
        end
        else begin
            case (state)
                locked:begin
                    if( pinCode == passWord ) begin
                        if(usrPinSet) nextState <= unlocked;
                        else nextState <= definePin;
                    end
                    else if (errCount == 2'b11) nextState <= lockout;
                    else begin
                        nextState <= locked;
                        errFlag <= 1;
                    end
                end
                definePin:begin
                    nextState <= locked;
                    passSetFlag <= 1;
                    rstCountFlag <= 1;
                end
                unlocked: begin
                    if(lock) nextState <= locked;
                    else nextState <= unlocked;
                    rstCountFlag <= 1;
                end
                lockout: begin
                    if(pinCode == override) nextState <= definePin;
                    else nextState <= lockout;
                end
                default: nextState <= locked;
            endcase
        end
    end

    wire rstErrCount;
    assign rstErrCount = rst | rstCountFlag;
    always @(posedge errFlag, posedge rstErrCount) begin
        if(rstErrCount) errCount <= 0;
        else errCount <= errCount + 1;
    end

    always @ ( posedge passSetFlag, posedge rst ) begin
        if(rst) begin
            usrPinSet <= 0;
            passWord <= defaultPass;
        end
        else begin
            usrPinSet <= 1;
            passWord <= pinCode;
        end
    end
endmodule
