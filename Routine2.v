//  Alexander Payne, Adam Suter
//  Light Routine 0
//  Linear Oscillating LEDs, mod-16 Counters

module Routine2(Clock, Reset, OutputBus);
  input         Clock;
  input         Reset;
  output  [45:0]OutputBus;

     reg  [2:0]GrnState;
     reg  [7:0]LedGrn;
     reg  [3:0]RedState;
     reg  [9:0]LedRed;
     reg  [3:0]SsdState;
     reg [27:0]SsdDisp;

  always @ (posedge Clock)
  begin
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
    //  Cycle the four 7SD displays
    //  Note: For ease of reading, 0 denotes off and 1 on; these will be
    //  inverted in the ouput assignment to fit the LCD conventions.
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

    GrnState = Reset ? GrnState + 1 : 3'b000;
    RedState = Reset ? RedState + 1 : 4'b0000;
    SsdState = Reset ? SsdState + 1 : 4'b0000;
    SsdDisp  = Reset ? SsdDisp      : 28'b0000000_0000000_0000000_0000000;
  end

  //  Assign individual output components to the bus
  assign OutputBus[45:36] = LedRed;
  assign OutputBus[35:28] = LedGrn;
  assign OutputBus[27:21] = ~SsdDisp[27:21];
  assign OutputBus[20:14] = ~SsdDisp[20:14];
  assign OutputBus[13:7]  = ~SsdDisp[13:7];
  assign OutputBus[6:0]   = ~SsdDisp[6:0];
endmodule
