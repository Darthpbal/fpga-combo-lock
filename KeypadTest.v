`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/17/2016 09:57:45 AM
// Design Name:
// Module Name: KeypadTest
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module KeypadTest(
    clk,
    JA,
    an,
    seg,
    reset,
    btnC//line 41
    );


// ==============================================================================================
// 											Port Declarations
// ==============================================================================================
	input clk;					// 100Mhz onboard clock
	inout [7:0] JA;			// Port JA on Artix7, JA[3:0] is Columns, JA[10:7] is rows
	output [3:0] an;			// Anodes on seven segment display
	output [6:0] seg;
	input  reset;
	input btnC;
	reg [30:0] counter;
	reg [1:0] count;  // declaring a 31 bits counter
     reg slow_clk;

// ==============================================================================================
// 							  		Parameters, Regsiters, and Wires
// ==============================================================================================

	// Output wires
	wire [3:0] an;
	wire [6:0] seg;


   // wire press;
    //wire press_notdeb;
// ==============================================================================================
// 												Implementation
// ==============================================================================================
always @(posedge clk or posedge reset)
 begin
     if (reset)
        begin
         counter = 30'd0;  //initialize Counter
         slow_clk = 1'b0;
        end
     else begin
         if(counter != 30'd50000000)
             counter = counter + 1'b1;
         else begin
             counter = 30'd0;
             slow_clk = ~ slow_clk;
              end
          end
 end

	//------------------------------------------------
	//  						Decoder
	//-----------------------------------------------
	wire [3:0] Decode;
	Decoder C0(
			.clk(clk),
			.Row(JA[7:4]),
			.Col(JA[3:0]),
			.DecodeOut(Decode)
	);


    wire [3:0] seqout;
    wire trigger;
    assign trigger = btnC & slow_clk;  //could this use an always @negedge btnc trigger = slow_clk? Could this be a nice clean trigger?

	sequence G1(trigger,reset,Decode,seqout);

	//-----------------------------------------------
	//  		Seven Segment Display Controller
	//-----------------------------------------------
	SevsegDisplay C1(
			.DispVal(seqout),
			.anode(an),
			.segOut(seg)
	);

endmodule
