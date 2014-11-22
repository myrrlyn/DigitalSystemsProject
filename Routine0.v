//  Alexander Payne, Adam Suter
//  Light Routine 0
//  Linear Oscillating LEDs, mod-16 Counters

module Routine0(Clock, LedRed, LedGrn, Hex0, Hex1, Hex2, Hex3);
  input        Clock;
  output  [9:0]LedRed;
     reg  [9:0]LedRed;
  output  [7:0]LedGrn;
     reg  [7:0]LedGrn;
  output  [6:0]Hex0;
  output  [6:0]Hex1;
  output  [6:0]Hex2;
  output  [6:0]Hex3;
  
  reg     [2:0]GrnState;
  reg     [3:0]RedState;
  reg     [3:0]HexState;
  
  always @ (posedge Clock)
  begin
    //  Oscillate the green LEDs
    if (GrnState == 3'b000)
    begin
      LedGrn = 8'b00001111;
    end
    else if (GrnState < 3'b101)
    begin
      LedGrn = LedGrn << 1;
    end
    else if (GrnState > 3'b100)
    begin
      LedGrn = LedGrn >> 1;
    end
    //  Oscillate the red LEDs
    if (RedState == 4'b0000)
    begin
      LedRed = 10'b1111000000;
    end
    else if (RedState < 4'b0111)
    begin
      LedRed = LedRed >> 1;
    end
    else if (RedState < 4'b1101)
    begin
      LedRed = LedRed << 1;
    end
    else if (RedState == 4'b1101)
    begin
      LedRed = LedRed >> 1;
      RedState = 4'b0001;
    end
    GrnState = GrnState + 1;
    RedState = RedState + 1;
    HexState = HexState + 1;
  end

  //  Convert 4-bit BCD numbers to Seven-Segment Display output instructions.
  myrrBcd7sdDecoder14 Hex0Display(HexState, Hex0);
  myrrBcd7sdDecoder14 Hex1Display(HexState, Hex1);
  myrrBcd7sdDecoder14 Hex2Display(HexState, Hex2);
  myrrBcd7sdDecoder14 Hex3Display(HexState, Hex3);
endmodule