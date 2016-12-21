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


/*

Clock problem with Spartan 6

up vote
6
down vote
favorite
1
I have a clock divider implemented as follows:

module sync_out(
  input clk,            // This is the FPGA system clock
  output reg sync       // This is the generated sync signal to be tested
);
  localparam
    SYNC_OUT_CLOCK_RATIO = 20;

  reg [10:0] counter;   // Clock counter reset when reaching CLOCK_RATIO

  initial begin
    counter <= 0;
    sync <= 0;
  end

  always @(posedge clk) begin
    counter <= counter + 1;

    if(counter == SYNC_OUT_CLOCK_RATIO) begin
      counter <= 0;
      sync <= ~sync;
    end
  end
endmodule
Here clk is the main clock, and sync is the divided clock outputted directed out of the board. Now ISE gives me the following error:

Place:1136 - This design contains a global buffer instance,
   <clock_deskew_0/BUFG_inst>, driving the net, <clk>, that is driving the
   following (first 30) non-clock load pins.
   < PIN: sync_apbinterface_0/pclk_test_select[15]_AND_253_o4.A4; >
   This is not a recommended design practice in Spartan-6 due to limitations in
   the global routing that may cause excessive delay, skew or unroutable
   situations.  It is recommended to only use a BUFG resource to drive clock
   loads. If you wish to override this recommendation, you may use the
   CLOCK_DEDICATED_ROUTE constraint (given below) in the .ucf file to demote
   this message to a WARNING and allow your design to continue.
   < PIN "clock_deskew_0/BUFG_inst.O" CLOCK_DEDICATED_ROUTE = FALSE; >
What exactly is the problem here, and how can I fix it?

verilog
shareimprove this question
asked Jun 25 '12 at 9:29

Randomblue
3,9521558126

In addition to the error you've asked about, be aware that if SYNC_OUT_CLOCK_RATIO is 20, you'll actually have a divide-by-21 function. Even if you already noticed this, it will be potentially confusing for anyone who has to read your code. – The Photon Jun 25 '12 at 16:25
add a comment
3 Answers
active oldest votes
up vote
5
down vote
accepted
Your clk pin is driving some non-clock pins (LUT inputs by the look of it). This is almost always a bad idea.

Open your design in the technology viewer and look at the "non-clock load pins" listed in the logfile (< PIN: sync_apbinterface_0/pclk_test_select[15]_AND_253_o4.A4; > is the first one) and see if you can figure out why a LUT is using the CLK input.

If it turns out that all is OK and you really want to do this, for whatever reason, and you are going to be happy justifying that to a baying pack of engineers if it all goes wrong, you can turn the error off as described at the end of the error message.

shareimprove this answer
answered Jun 25 '12 at 14:24

Martin Thompson
6,85811337
add a comment
up vote
7
down vote
Generally speaking you should not be writing dividers like this. You are creating a clock signal out of logic, which as ISE is telling you, is not a recommended design practise. Not only are you consuming (often scarce) clock routing nets, but you can also end up with jittery, glitchy clocks as the logic blocks ripple through to their next state.

examples (in VHDL, I prefer it to Verilog, but it's a simple enough example)

e.g. 1: how NOT to do it (create a clock from logic outputs):

signal counter: integer range 0 to 999;
signal slowclk: std_logic;

gen_slowclk: process(clk, rst)
begin
    if rising_edge(clk) then
        if counter = 0 then
            slow_clk <= not slow_clk;
            counter <= counter'high
        else
            counter <= counter - 1;
        end if;
    end if;

    if rst = '1' then
        slow_clk <= '0';
        counter = counter'high;
    end if;
end process;

use_slow_clk: process(slow_clk, rst)
begin
    if rising_edge(slow_clk) then
        -- ...
    end if;

    if reset = '1' then
        -- ...
    end if;
end process;
This creates a slow_clk which is 1000 times slower than the main clock, and then uses that slow_clk signal as the clock input in another process. It's an example of how not to do things. If you examine your RTL you'll see the output of logic going into the clock inputs of the FFs in the use_slow_clk process, which is bad.

What you should be doing instead is creating clock enables. You drive all your logic with the original (fast) clock, and then create a clock enable signal. Most FPGAs have flip-flop primitives that have clock enable inputs, which is exactly why you would design this way.

e.g. 2: Use clock enables (the recommended way):

signal counter: integer range 0 to 999;
signal slow_ce: std_logic;

gen_slow_ce: process(clk, rst)
begin
    if rising_edge(clk) then
        if counter = 0 then
            slow_ce <= '1';
            counter <= counter'high
        else
            slow_ce <= '0';
            counter <= counter - 1;
        end if;
    end if;

    if rst = '1' then
        slow_ce <= '0';
        counter = counter'high;
    end if;
end process;

use_slow_ce: process(clk, rst)
begin
    if rising_edge(clk) then
        if slow_ce = '1' then
            -- ...
        end if;
    end if;

    if reset = '1' then
        -- ...
    end if;
end process;
If you examine the RTL of this type of construction, you will see that all FFs use the same clock signal, and that is provided on a clock net. The added @if slow_ce = '1'@ is recognized by the synthesizer and instantiates an FF with a clock enable; this is a signal which is designed to be controlled with logic and to cleanly gate the FF.

In both of these examples, the logic in @use_slow_*@ is executed at the same frequency (1/1000 the main clock) but in the second case you have only one clock network and are making use of the clock enables present in your FPGA, which leads to better synthesis, better clocks and easier timing closure. This leads to saner FPGA designs which leads to happy FPGA designers. :-)

shareimprove this answer
edited Jan 6 at 18:31
answered Jun 25 '12 at 19:17

akohlsmith
7,76612143

Why should using a high frequency clock with "low frequency" clock enables result in easier timing closure? Do you imply that a multicycle_path for all FFs using the "low frequency" clock enables is defined? Otherwise you knowingly extend the harsher timing requirement of the high frequency clock to the logic which should run at the low frequency, which will do the oposite of easing timing closure... Of course I agree on the need of using the global clocking network for all clock signals. – damage Mar 7 at 8:38
add a comment
up vote
3
down vote
Perhaps there's a problem with the two simultaneous assignments to counter. See if changing your always block to this helps:

  always @(posedge clk) begin
    if(counter == SYNC_OUT_CLOCK_RATIO) begin
      counter <= 0;
      sync <= ~sync;
    end else begin
      counter <= counter + 1;
    end
  end



  */
