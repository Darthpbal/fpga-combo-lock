module debounce ( Clk, PB, pulse);

input   Clk;
input   PB;
output   pulse;

reg     pulse;
reg     [1:0] cnt;
wire    clk_n;

assign clk_n = ~Clk;

always @(clk_n or PB or cnt)
   begin : process_1
   if (cnt == 2'b 01 & PB == 1'b 0)
      begin
      pulse <= 1'b 1;
      end
   else
      begin
      pulse <= 1'b 0;
      end
   end


always @(posedge clk_n or posedge PB)
   begin : process_1_1
   if (PB == 1'b 1)
      begin
      cnt <= 2'b 00;
      end
   else if (cnt != 2'b 11 )
      begin
      cnt <= cnt + 1;
      end
   end


endmodule // module debounce
