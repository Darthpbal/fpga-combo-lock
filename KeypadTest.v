`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*

todo:
create single flag for whether or not a user pass has been stored
make the new user pass get stored where the default code used to be
have seperate set of reg for the override code

*/
//////////////////////////////////////////////////////////////////////////////////


module KeypadTest(
    input clk,					// 100Mhz onboard clock
    inout [7:0] JA,			// Port JA on Artix7, JA[3:0] is Columns, JA[10:7] is rows
    input reset,
    input btnC,
    output [3:0] an,			// Anodes on seven segment display
    output [6:0] seg,
    output keyFlag
    );


	reg [30:0] counter;
	reg [1:0] count;  // declaring a 31 bits counter
    reg slow_clk;


	// Output wires
	wire [3:0] an;
	wire [6:0] seg;





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
			.DecodeOut(Decode),
            .ping(keyFlag)
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
