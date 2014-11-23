//  Alexander Payne, Adam Suter
//  Light Routine 1
//  Linear Oscillating LEDs, mod-16 Counters

module Routine1(Clock, Reset, OutputBus);
  input        Clock;
  input        Reset;
  output [46:0]OutputBus;
  wire    [6:0]Hex0;
  wire    [6:0]Hex1;
  wire    [6:0]Hex2;
  wire    [6:0]Hex3;

  reg     [4:0]LedState;
  reg    [17:0]LedList;
  reg     [3:0]HexState;
  reg     [4:0]RtnState;
  reg          SIGOUT;

  always @ (posedge Clock)
   begin
    //  HARD RESET
    if (Reset == 1'b1)
     begin
      LedState = 5'b00000;
      HexState = 4'b0000;
      RtnState = 5'b00000;
     end
    //  Oscillate the LEDs
    if (LedState == 5'b00000)
     begin
      LedList = 18'b00000_00000_0000_1111;
     end
    else if (LedState < 5'b01111)
     begin
      LedList = LedList << 1;
     end
    else if (LedState < 5'b11100)
     begin
      LedList = LedList >> 1;
     end
    else if (LedState == 5'b11100)
     begin
      LedList = LedList >> 1;
      LedState = 5'b00000;
     end
    LedState = LedState + 1;
    HexState = HexState + 1;
    RtnState = RtnState + 1;
    if (RtnState == 4'b11100)
     begin
      SIGOUT = 1'b1;
     end
    else
     begin
      SIGOUT = 1'b0;
     end
   end

  //  Convert 4-bit BCD numbers to Seven-Segment Display output instructions.
  myrrBcd7sdDecoder Hex0Display(HexState, Hex0);
  myrrBcd7sdDecoder Hex1Display(HexState, Hex1);
  myrrBcd7sdDecoder Hex2Display(HexState, Hex2);
  myrrBcd7sdDecoder Hex3Display(HexState, Hex3);

  //  Assign individual output components to the bus
  assign OutputBus[46]    = SIGOUT;
  assign OutputBus[45:36] = LedList[17:8];
  assign OutputBus[35:28] = LedList[7:0];
  assign OutputBus[27:21] = Hex3;
  assign OutputBus[20:14] = Hex2;
  assign OutputBus[13:7] = Hex1;
  assign OutputBus[6:0] = Hex0;
endmodule
