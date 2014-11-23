//  Alexander Payne, Adam Suter
//  Light Routine 0
//  Linear Oscillating LEDs, mod-16 Counters

module Routine2(Clock, Reset, OutputBus);
  input        Clock;
  input        Reset;
  output [46:0]OutputBus;

  reg     [4:0]LedState;
  reg    [17:0]LedList;
  reg     [3:0]SsdState;
  reg    [27:0]SsdDisp;
  reg     [5:0]RtnState;
  reg          SIGOUT;

  always @ (posedge Clock)
   begin
    //  HARD RESET
    if (Reset == 1'b1)
     begin
      LedState = 5'b00000;
      SsdState = 4'b0000;
      RtnState = 6'b000000;
     end
    //  Rotate the LEDS
    if (LedState == 3'b000)
     begin
      LedList = 18'b00000_00000_0000_1111;
     end
    else
     begin
      LedList = LedList << 1;
     end
    //  Cycle the four 7SD displays
    //  Note: to make the mathematical logic work properly, the number strings
    //  here assume 0 means off and 1 means on, and the strings will be inverted
    //  at the output bus to fit LCD conventions.
    //  GFEDCBA GFEDCBA GFEDCBA GFEDCBA
    //  2222222 2111111 1111000 0000000 <<
    //  7654321 0987654 3210987 6543210 <<
    case (SsdState)
      4'b0000 : SsdDisp = SsdDisp + (1 << 3)  - (SsdDisp[14] ? 1 << 14 : 0);
      4'b0001 : SsdDisp = SsdDisp + (1 << 10) - (SsdDisp[21] ? 1 << 21 : 0);
      4'b0010 : SsdDisp = SsdDisp + (1 << 17);
      4'b0011 : SsdDisp = SsdDisp + (1 << 24);
      4'b0100 : SsdDisp = SsdDisp + (1 << 25) - (1 << 3);
      4'b0101 : SsdDisp = SsdDisp + (1 << 27) - (1 << 10);
      4'b0110 : SsdDisp = SsdDisp + (1 << 20) - (1 << 17);
      4'b0111 : SsdDisp = SsdDisp + (1 << 13) - (1 << 24);
      4'b1000 : SsdDisp = SsdDisp + (1 << 6)  - (1 << 25);
      4'b1001 : SsdDisp = SsdDisp + (1 << 1)  - (1 << 27);
      4'b1010 : SsdDisp = SsdDisp + (1 << 0)  - (1 << 20);
      4'b1011 : SsdDisp = SsdDisp + (1 << 7)  - (1 << 13);
      4'b1100 : SsdDisp = SsdDisp + (1 << 14) - (1 << 6);
      4'b1101 : SsdDisp = SsdDisp + (1 << 21) - (1 << 1);
      4'b1110 : SsdDisp = SsdDisp             - (1 << 0);
      4'b1111 : SsdDisp = SsdDisp             - (1 << 7);
    endcase

    LedState = LedState + 1;
    SsdState = SsdState + 1;
    RtnState = RtnState + 1;
    if (RtnState == 4'b0001 && SsdDisp[21])
     begin
      SIGOUT = 1'b1;
     end
    else
     begin
      SIGOUT = 1'b0;
     end
   end

  //  Assign individual output components to the bus
  assign OutputBus[45:28] = LedList;
  assign OutputBus[27:21] = ~SsdDisp[27:21];
  assign OutputBus[20:14] = ~SsdDisp[20:14];
  assign OutputBus[13:7]  = ~SsdDisp[13:7];
  assign OutputBus[6:0]   = ~SsdDisp[6:0];
endmodule
