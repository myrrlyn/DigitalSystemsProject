//  Alexander Payne, Adam Suter
//  Light Routine 0
//  Linear Oscillating LEDs, mod-16 Counters

module Routine3(Clock, Reset, OutputBus);
  input        Clock;
  input        Reset;
  output [46:0]OutputBus;

  reg     [4:0]LedState;
  reg    [17:0]LedList;
  reg     [4:0]SsdState;
  reg    [27:0]SsdDisp;
  reg     [4:0]RtnState;
  reg          SIGOUT;

  always @ (posedge Clock)
   begin
    //  HARD RESET
    if (Reset == 1'b1)
     begin
      LedState = 5'b00000;
      SsdState = 5'b00000;
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
    //  Cycle the four 7SD displays
    //  Note: For ease of reading, 0 denotes off and 1 on; these will be
    //  inverted in the ouput assignment to fit the LCD conventions.
    //  GFEDCBA GFEDCBA GFEDCBA GFEDCBA
    //  2222222 2111111 1111000 0000000 <<
    //  7654321 0987654 3210987 6543210 <<
    case (SsdState)
      5'b00000 : SsdDisp = SsdDisp + (1 << 1);
      5'b00001 : SsdDisp = SsdDisp + (1 << 2);
      5'b00010 : SsdDisp = SsdDisp + (1 << 3);
      5'b00011 : SsdDisp = SsdDisp + (1 << 4);
      5'b00100 : SsdDisp = SsdDisp + (1 << 5)  - (1 << 1);
      5'b00101 : SsdDisp = SsdDisp + (1 << 7)  - (1 << 2);
      5'b00110 : SsdDisp = SsdDisp + (1 << 12) - (1 << 3);
      5'b00111 : SsdDisp = SsdDisp + (1 << 11) - (1 << 4);
      5'b01000 : SsdDisp = SsdDisp + (1 << 17) - (1 << 5);
      5'b01001 : SsdDisp = SsdDisp + (1 << 18) - (1 << 7);
      5'b01010 : SsdDisp = SsdDisp + (1 << 19) - (1 << 12);
      5'b01011 : SsdDisp = SsdDisp + (1 << 21) - (1 << 11);
      5'b01100 : SsdDisp = SsdDisp + (1 << 26) - (1 << 17);
      5'b01101 : SsdDisp = SsdDisp + (1 << 25) - (1 << 18);
      5'b01110 : SsdDisp = SsdDisp + (1 << 24) - (1 << 19);
      5'b01111 : SsdDisp = SsdDisp + (1 << 23) - (1 << 21);
      5'b10000 : SsdDisp = SsdDisp + (1 << 22) - (1 << 26);
      5'b10001 : SsdDisp = SsdDisp + (1 << 14) - (1 << 25);
      5'b10010 : SsdDisp = SsdDisp + (1 << 15) - (1 << 24);
      5'b10011 : SsdDisp = SsdDisp + (1 << 16) - (1 << 23);
      5'b10100 : SsdDisp = SsdDisp + (1 << 10) - (1 << 22);
      5'b10101 : SsdDisp = SsdDisp + (1 << 9)  - (1 << 14);
      5'b10110 : SsdDisp = SsdDisp + (1 << 8)  - (1 << 15);
      5'b10111 : SsdDisp = SsdDisp + (1 << 0)  - (1 << 16);
      5'b11000 : SsdDisp = SsdDisp + (1 << 1)  - (1 << 10);
      5'b11001 : SsdDisp = SsdDisp + (1 << 2)  - (1 << 9);
      5'b11010 : SsdDisp = SsdDisp             - (1 << 8);
      5'b11011 : SsdDisp = SsdDisp             - (1 << 0);
      5'b11100 : SsdDisp = SsdDisp             - (1 << 1);
      5'b11101 : SsdDisp = SsdDisp             - (1 << 2);
      5'b11110 : SsdState = 5'b11111;
    endcase
    if (SsdState == 5'b11110)
     begin
      SIGOUT = 1'b1;
     end

    LedState = LedState + 1;
    SsdState = SsdState + 1;
    RtnState = RtnState + 1;
   end

  //  Assign individual output components to the bus
  assign OutputBus[46]    = SIGOUT;
  assign OutputBus[45:28] = LedList;
  assign OutputBus[27:21] = ~SsdDisp[27:21];
  assign OutputBus[20:14] = ~SsdDisp[20:14];
  assign OutputBus[13:7]  = ~SsdDisp[13:7];
  assign OutputBus[6:0]   = ~SsdDisp[6:0];
endmodule
