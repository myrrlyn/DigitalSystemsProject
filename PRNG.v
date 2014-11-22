//  Pseudo-random number generator
module myrrPRNG(Clock, Seed, Enable, Disp0, Disp1, Disp2, Disp3);
  input  Clock;
  input  [9:0]Seed;
  input  Enable;
  output [3:0]Disp0;
  output [3:0]Disp1;
  output [3:0]Disp2;
  output [3:0]Disp3;
  reg    [15:0]OutState;
  reg    [15:0]NewState;

  always @ (posedge Clock)
  begin
    if (Enable == 1'b1)
    begin
      OutState = (NewState * 5 + 1) % (2 << 16);
      NewState = OutState;
    end
    else
    begin
      OutState[15:0] = 16'b0000_0000_0000_0000;
      OutState[12:3] = Seed;
      NewState = OutState;
    end
  end

  assign Disp3 = OutState[15:12];
  assign Disp2 = OutState[11:8];
  assign Disp1 = OutState[7:4];
  assign Disp0 = OutState[3:0];
endmodule
