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
    reg [1:0] nextState;//, errCount;

    always @ ( posedge clk, posedge rst ) begin
        if(rst) state <= locked;
        else begin
            state <= nextState;
            // if(trig) state <= nextState;
            // else state <= state;
        end
    end

    always @ (  posedge lock, posedge trig, posedge rst ) begin
        nextState <= 2'bx;
        if(rst) begin
            usrPinSet <= 0;
            passWord <= defaultPass;
            nextState <= locked;
            errCount <= 0;
        end
        else if(trig | lock) begin
            case (state)
                locked:begin
                    if( pinCode == passWord ) begin
                        if(usrPinSet) begin
                            errCount <= 0;
                            nextState <= unlocked;
                        end
                        else begin
                            errCount <= 0;
                            nextState <= definePin;
                        end
                        // nextState <= (usrPinSet)? unlocked: definePin;
                        // errCount <= 0;
                    end
                    else begin
                        errCount <= errCount + 1;
                        // if(errCount == (errMax - 1)) nextState <= lockout;
                        // else
                        nextState <= locked;
                    end
                end
                definePin:begin
                    passWord <= pinCode;
                    usrPinSet <= 1;
                    nextState <= locked;
                    errCount <= 0;
                end
                unlocked: begin
                    if(lock) nextState <= locked;
                    else nextState <= unlocked;
                end
                lockout: begin
                    if(pinCode == override) begin
                        nextState <= definePin;
                        errCount <= 0;
                    end
                    else nextState <= lockout;
                end
                default: nextState <= locked;
            endcase
        end
        else nextState <= 2'bx;
    end
endmodule
