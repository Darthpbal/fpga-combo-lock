module basys (
        input btnc, btnu, btnl, btnr;

    );

endmodule



/*
Top module for the processor. This is modeled as the basys board itself to
be more intuitive.
*/

module basys (
  input [15:0] swt,   //basys board switches
  input clk,          //basys board clock
  input btnU,         //up button on basys board
  output [3:0] segEn, //basys seven segment enable bus
  output dec,         //seven segment decimal point
  output [6:0] sevSeg,//seven segment signals
  output [15:0] led   //basys board LED array
  );

  //enable rightmost
  assign segEn = 4'b1110;

  //ALU output to be connected to the bcd to seven segment decoder as well as the basys LED array.
  wire [3:0] result;

  wire decPlaceholder;

  //processor instantiation
  processor top(
      .A(swt[3:0]),
      .load_A(swt[4]),
      .B(swt[8:5]),
      .load_B(swt[9]),
      .opcode(swt[13:10]),
      .sel(swt[14]),
      .Cin(swt[15]),
      .clock(clk),
      .reset(btnU),
      .A_out(led[3:0]),
      .B_out(led[7:4]),
      .ALU_out(result),
      .cf(led[12]),
      .Cout(decPlaceholder),
      .OVF(led[13]),
      .nf(led[14]),
      .zf(led[15])
      );

  //seven segment display instantiation
  Seven_Seg mySeg(
      .segSel(result),
      .seg(sevSeg)
      );

  //assign the alu output to the leds on the basys board.
  assign led[11:8] = result;

  //invert the decimal point signal since the seven segment display is active low
  assign dec = ~decPlaceholder;
endmodule
