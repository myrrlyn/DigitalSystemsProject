//  Pseudo-random number generator
module myrrPRNG(Clock, Reset, Output);
  input        Clock;
  input        Reset;
  output [15:0]Output;
  reg    [15:0]Output;
  reg    [15:0]NewState;

  always @ (posedge Clock)
   begin
    //  Reset must be assigned to a KEY, which is 0 when pressed.
    if (Reset == 1'b1)
     begin
      Output = (NewState * 5 + 1) % (2 << 16);
     end
    else
     begin
      Output = 16'b0000_0000_0000;
     end
    NewState = Output;
   end
endmodule
