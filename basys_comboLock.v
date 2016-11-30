/*
Top module for the processor. This is modeled as the basys board itself to
be more intuitive.
*/

module basys (
  input [15:0] swt,   //basys board switches
  input clk,          //basys board clock
  input btnU,         //up button on basys board
  input btnD,         //up button on basys board
  input btnL,         //up button on basys board
  input btnR,         //up button on basys board
  input btnC,         //up button on basys board
  output [3:0] segEn, //basys seven segment enable bus
  output segDec,         //seven segment decimal point
  output [6:0] sevSeg,//seven segment signals
  output [15:0] led   //basys board LED array
  );

endmodule
