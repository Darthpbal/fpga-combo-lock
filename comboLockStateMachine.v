`timescale 1ns / 1ps

module comboLockStateMachine (
        input [15:0] pinCode,
        input trig, lock, rst, clk,
        output reg [1:0] state
    );

    parameter defaultPass = 16'hFACE, override = 16'hDADA;
    parameter errMax = 3;
    parameter  locked = 0,
                unlocked = 1,
                lockout = 2,
                definePin = 3;

    reg [15:0] passWord = defaultPass;
    reg usrPinSet = 0;
    reg [1:0] nextState, errCount;

    always @ ( /*posedge trig,*/ posedge rst, posedge clk ) begin
        if(rst) begin
            // usrPinSet <= 0;
            // passWord <= defaultPass;
            state <= locked;
            // nextState <= locked;
            // errCount <= 0;
        end
        else state <= nextState;
    end

    always @ ( /*posedge trig or*/ posedge lock ) begin
        case (state)
            locked:begin
                if( pinCode == passWord ) begin
                    nextState <= (usrPinSet)? unlocked: definePin;
                    errCount <= 0;
                end
                else begin
                    errCount <= errCount + 1;
                    if(errCount == (errMax - 1)) nextState <= lockout;
                end
            end
            definePin:begin
                passWord <= pinCode;
                usrPinSet <= 1;
                nextState <= locked;
                errCount <= 0;
            end
            unlocked: if(lock) nextState <= locked;
            lockout: begin
                if(pinCode == override) begin
                    nextState <= definePin;
                    errCount <= 0;
                end
            end
            default: nextState <= locked;
        endcase
    end
endmodule
