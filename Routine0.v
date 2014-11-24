//  Alexander Payne, Adam Suter
//  Light Routine 0
//  Linear Oscillating LEDs, mod-16 Counters

module Routine0(Clock, Reset, OutputBus);
  input        Clock;
  input        Reset;
  output [46:0]OutputBus;
  wire    [6:0]Disp0;
  wire    [6:0]Disp1;
  wire    [6:0]Disp2;
  wire    [6:0]Disp3;

  reg     [2:0]GrnState;
  reg     [7:0]LedGrn;
  reg     [3:0]RedState;
  reg     [9:0]LedRed;
  reg     [3:0]HexState;
  reg     [4:0]RtnState;
  reg          SIGOUT;

  always @ (posedge Clock)
   begin
    //  HARD RESET
    if (Reset == 1'b1)
     begin
      GrnState = 3'b000;
      RedState = 4'b0000;
      HexState = 4'b0000;
      RtnState = 5'b00000;
     end
    //  Oscillate the green LEDs
    if (GrnState == 3'b000)
     begin
      LedGrn = 8'b0000_1111;
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
      LedRed = 10'b11110_00000;
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
    RtnState = RtnState + 1;
    if (RtnState == 5'b11000)
     begin
      SIGOUT = 1'b1;
     end
    else
     begin
      SIGOUT = 1'b0;
     end
   end

  //  Convert 4-bit BCD numbers to Seven-Segment Display output instructions.
  myrrBcd7sdDecoder Hex3Display(HexState, Disp3);
  myrrBcd7sdDecoder Hex2Display(HexState, Disp2);
  myrrBcd7sdDecoder Hex1Display(HexState, Disp1);
  myrrBcd7sdDecoder Hex0Display(HexState, Disp0);

  //  Assign individual output components to the bus
  assign OutputBus[46]    = SIGOUT;
  assign OutputBus[45:36] = LedRed;
  assign OutputBus[35:28] = LedGrn;
  assign OutputBus[27:21] = Disp3;
  assign OutputBus[20:14] = Disp2;
  assign OutputBus[13:7] = Disp1;
  assign OutputBus[6:0] = Disp0;
endmodule
