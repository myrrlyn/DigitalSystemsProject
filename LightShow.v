//  Alexander Payne, Adam Suter
//  Digital Systems Final Project
//  FPGA Board Light Show

module LightShow(
 Clock,
 Disp3,
 Disp2,
 Disp1,
 Disp0,
 LedRed,
 LedGrn
 );
  //  Onboard clock
  input       Clock;
  //  Seven-segment displays. Ordered 3210.
  //  Each bus is ordered GFEDCBA, 1 for off, 0 for on. Segments are labelled
  //  clockwise from top starting with A.
  output [6:0]Disp3;
  output [6:0]Disp2;
  output [6:0]Disp1;
  output [6:0]Disp0;
  //  Red LEDs above switches. Ordered 9876543210. 0 is off, 1 is on.
  output [9:0]LedRed;
  //  Green LEDs above keys. Ordered 76543210. 0 is off, 1 is on.
  output [7:0]LedGrn;

  //  Clock wires
  wire        Pulse;

  //  Timekeeper
  reg   [15:0]Stopwatch;

  //  Output signals

  //  Red LEDs
  reg    [9:0]StateLedRed;
  reg    [3:0]SlideLedRed;
  //  GreenLEDs
  reg    [7:0]StateLedGrn;
  reg    [3:0]SlideLedGrn;
  //  Shorthand for using both LED lines as a single entity
  reg   [17:0]StateLedAll;
  reg    [4:0]SlideLedAll;
  //  All four SSD buses
  reg   [27:0]StateDisplay;
  reg    [7:0]SnakeDisplay;
  //  Hexadecimal counter and display
  reg    [3:0]StateHex;
  wire   [6:0]DispHex;
  //  Text scroller
  reg    [7:0]TextPacer;

  //  Magic numbers are literally Satan's back hair
  reg   [15:0]RTN0START;
  reg   [15:0]RTN1START;
  reg   [15:0]RTN2START;
  reg   [15:0]RTN3START;
  reg   [15:0]RTN4START;
  reg   [15:0]RTN5START;
  reg   [15:0]RTN0CYCLE;

  //  Hexadecimal to SSD driver
  myrrBcd7sdDecoder HexDisplay(StateHex, DispHex);

  //  10Hz master clock
  //  01Hz FOR DEBUGGING
  myrr50M10H MasterClock(Clock, Pulse);

  always @ (posedge Pulse)
   begin
    RTN0START = 16'b0000_0000__0000_0000;
    RTN1START = 16'b0000_0000__0001_1100;
    RTN2START = 16'b0000_0000__0100_1100;
    RTN3START = 16'b0000_0000__0111_0111;
    RTN4START = 16'b0000_0000__1011_0111;
    RTN5START = 16'b0000_0000__1111_0001;
    RTN0CYCLE = 16'b0000_0001__1110_0011;
    //  Initialize SSD cells and lights
    if (Stopwatch == RTN0START)
     begin
      StateDisplay = 28'b1000000_0000000__0000000_0000000;
      StateLedAll  = 18'b10001_00100__1000_0000;
      StateLedRed  = 10'b00000_00001;
      StateLedGrn  =               8'b0000_0000;
     end
    //  "Bootup" Sequence
    if (Stopwatch < RTN1START)
     begin
      //  Walk the SSD cells
      StateDisplay = (StateDisplay >> 1) + (1 << 27);
      //  Walk the light
      if (Stopwatch < 16'b0000_0000__0000_1010)
       begin
        StateLedAll = StateLedAll << 1;
       end
      //  Charge the lights
      else
       begin
        StateLedAll = (StateLedAll >> 1) + (1 << 17);
       end
      //  Map the LED buses to the 18-bit single line
      StateLedRed = StateLedAll[17:8];
      StateLedGrn = StateLedAll[7:0];
     end
    //  Board-default pattern of light oscillation and counting
    else if (Stopwatch < RTN2START)
     begin
      //  Shuttle red and green lights separately
      if (Stopwatch == RTN1START)
       begin
        StateLedRed = 10'b11110_00000;
        SlideLedRed = 4'b0000;
        StateLedGrn =   8'b0000_1111;
        SlideLedGrn = 3'b000;
        StateHex    = 4'b0000;
       end
      else
       begin
        //  Shuttle green lights
        if (SlideLedGrn < 4'b0101)
         begin
          StateLedGrn = StateLedGrn << 1;
         end
        else if (SlideLedGrn < 4'b1001)
         begin
          StateLedGrn = StateLedGrn >> 1;
         end
        else if (SlideLedGrn == 4'b1001)
         begin
          StateLedGrn = StateLedGrn << 1;
          SlideLedGrn = 4'b0001;
         end
        //  Shuttle red lights
        if (SlideLedRed < 4'b0111)
         begin
          StateLedRed = StateLedRed >> 1;
         end
        else if (SlideLedRed < 4'b1101)
         begin
          StateLedRed = StateLedRed << 1;
         end
        else if (SlideLedRed == 4'b1101)
         begin
          StateLedRed = StateLedRed >> 1;
          SlideLedRed = 4'b0001;
         end
       end
      //  Because this project uses direct bitwise manipulation of the SSD
      //  cells as integer literals, the inversion occurs at the output bus. As
      //  the hex/SSD module includes an inversion, it must be inverted also in
      //  order to keep correct output.
      StateDisplay[27:21] = ~DispHex;
      StateDisplay[20:14] = ~DispHex;
      StateDisplay[13:7]  = ~DispHex;
      StateDisplay[6:0]   = ~DispHex;
      SlideLedRed = SlideLedRed + 1;
      SlideLedGrn = SlideLedGrn + 1;
      StateHex    = StateHex    + 1;
     end
    //  Variant light pattern
    else if (Stopwatch < RTN3START)
     begin
      //  Initialize the lights
      if (Stopwatch == RTN2START)
       begin
        StateLedAll = 18'b11110_00000__0000_0000;
        SlideLedAll = 5'b0_0000;
       end
      else if (SlideLedAll < 5'b0_1111)
       begin
        StateLedAll = StateLedAll >> 1;
       end
      else if (SlideLedAll < 5'b1_1101)
       begin
        StateLedAll = StateLedAll << 1;
       end
      else if (SlideLedAll == 5'b1_1101)
       begin
        StateLedAll = StateLedAll >> 1;
        SlideLedAll = 5'b0_0001;
       end
      StateDisplay[27:21] = ~DispHex;
      StateDisplay[20:14] = ~DispHex;
      StateDisplay[13:7]  = ~DispHex;
      StateDisplay[6:0]   = ~DispHex;
      StateHex = StateHex + 1;
      StateLedRed = StateLedAll[17:8];
      StateLedGrn = StateLedAll[7:0];
      SlideLedAll = SlideLedAll + 1;
     end
    //  First snake pattern
    else if (Stopwatch < RTN4START)
     begin
      //  Initialize SSD cells for snaking and lights for chaining
      if (Stopwatch == RTN3START)
       begin
        StateDisplay = 28'b0000000_0000000__0000000_0000000;
        SnakeDisplay = 8'b0000_0000;
        StateLedAll  = 18'b00000_00000__0000_0011;
       end
      //  Case statement to add/remove snake sections
      //  GFEDCBA GFEDCBA GFEDCBA GFEDCBA
      //  2222222 2111111 1111000 0000000 << TENS SHIFT
      //  7654321 0987654 3210987 6543210 << ONES SHIFT
      case (SnakeDisplay)
        //  The ternary operators are required to cancel the subtraction on the
        //  first run, when those cells do not have a snake tail in them.
        8'b0000_0000 : StateDisplay = StateDisplay + (1 << 3)  - (StateDisplay[14] ? (1 << 14) : 0);
        8'b0000_0001 : StateDisplay = StateDisplay + (1 << 10) - (StateDisplay[21] ? (1 << 21) : 0);
        8'b0000_0010 : StateDisplay = StateDisplay + (1 << 17);
        8'b0000_0011 : StateDisplay = StateDisplay + (1 << 24);
        8'b0000_0100 : StateDisplay = StateDisplay + (1 << 25) - (1 << 3);
        8'b0000_0101 : StateDisplay = StateDisplay + (1 << 27) - (1 << 10);
        8'b0000_0110 : StateDisplay = StateDisplay + (1 << 20) - (1 << 17);
        8'b0000_0111 : StateDisplay = StateDisplay + (1 << 13) - (1 << 24);
        8'b0000_1000 : StateDisplay = StateDisplay + (1 << 6)  - (1 << 25);
        8'b0000_1001 : StateDisplay = StateDisplay + (1 << 1)  - (1 << 27);
        8'b0000_1010 : StateDisplay = StateDisplay + (1 << 0)  - (1 << 20);
        8'b0000_1011 : StateDisplay = StateDisplay + (1 << 7)  - (1 << 13);
        8'b0000_1100 : StateDisplay = StateDisplay + (1 << 14) - (1 << 6);
        8'b0000_1101 : StateDisplay = StateDisplay + (1 << 21) - (1 << 1);
        8'b0000_1110 : StateDisplay = StateDisplay             - (1 << 0);
        8'b0000_1111 : StateDisplay = StateDisplay             - (1 << 7);
        8'b0001_0000 : SnakeDisplay = 8'b1111_1111;
      endcase
      StateLedAll = (StateLedAll << 1) + (StateLedAll[3] ? 0 : 1);
      StateLedRed = StateLedAll[17:8];
      StateLedGrn = StateLedAll[7:0];
      SnakeDisplay = SnakeDisplay + 1;
     end
    //  Second snake pattern
    else if (Stopwatch < RTN5START)
     begin
      //  Initialize lights and cells
      if (Stopwatch == RTN4START)
       begin
        StateDisplay = 28'b0000000_0000000__0000000_0000000;
        SnakeDisplay = 8'b0000_0000;
        StateLedAll  = 18'b11000_00000__0000_0000;
       end
      case (SnakeDisplay)
        8'b00000 : StateDisplay = StateDisplay + (1 << 1);
        8'b00001 : StateDisplay = StateDisplay + (1 << 2);
        8'b00010 : StateDisplay = StateDisplay + (1 << 3);
        8'b00011 : StateDisplay = StateDisplay + (1 << 4);
        8'b00100 : StateDisplay = StateDisplay + (1 << 5)  - (1 << 1);
        8'b00101 : StateDisplay = StateDisplay + (1 << 7)  - (1 << 2);
        8'b00110 : StateDisplay = StateDisplay + (1 << 12) - (1 << 3);
        8'b00111 : StateDisplay = StateDisplay + (1 << 11) - (1 << 4);
        8'b01000 : StateDisplay = StateDisplay + (1 << 17) - (1 << 5);
        8'b01001 : StateDisplay = StateDisplay + (1 << 18) - (1 << 7);
        8'b01010 : StateDisplay = StateDisplay + (1 << 19) - (1 << 12);
        8'b01011 : StateDisplay = StateDisplay + (1 << 21) - (1 << 11);
        8'b01100 : StateDisplay = StateDisplay + (1 << 26) - (1 << 17);
        8'b01101 : StateDisplay = StateDisplay + (1 << 25) - (1 << 18);
        8'b01110 : StateDisplay = StateDisplay + (1 << 24) - (1 << 19);
        8'b01111 : StateDisplay = StateDisplay + (1 << 23) - (1 << 21);
        8'b10000 : StateDisplay = StateDisplay + (1 << 22) - (1 << 26);
        8'b10001 : StateDisplay = StateDisplay + (1 << 14) - (1 << 25);
        8'b10010 : StateDisplay = StateDisplay + (1 << 15) - (1 << 24);
        8'b10011 : StateDisplay = StateDisplay + (1 << 16) - (1 << 23);
        8'b10100 : StateDisplay = StateDisplay + (1 << 10) - (1 << 22);
        8'b10101 : StateDisplay = StateDisplay + (1 << 9)  - (1 << 14);
        8'b10110 : StateDisplay = StateDisplay + (1 << 8)  - (1 << 15);
        8'b10111 : StateDisplay = StateDisplay + (1 << 0)  - (1 << 16);
        8'b11000 : StateDisplay = StateDisplay + (1 << 1)  - (1 << 10);
        8'b11001 : StateDisplay = StateDisplay + (1 << 2)  - (1 << 9);
        8'b11010 : StateDisplay = StateDisplay             - (1 << 8);
        8'b11011 : StateDisplay = StateDisplay             - (1 << 0);
        8'b11100 : StateDisplay = StateDisplay             - (1 << 1);
        8'b11101 : StateDisplay = StateDisplay             - (1 << 2);
        8'b11110 : SnakeDisplay = 8'b1111_1111;
      endcase
      StateLedAll = (StateLedAll >> 1) + (StateLedAll[15] ? 0 : (1 << 17));
      StateLedRed = StateLedAll[17:8];
      StateLedGrn = StateLedAll[7:0];
      SnakeDisplay = SnakeDisplay + 1;
     end
    else if (Stopwatch < RTN0CYCLE)
     begin
      if (Stopwatch == RTN5START)
       begin
        StateDisplay = 28'b0000000_0000000_0000000_0000000; //  H
        StateLedAll = 18'b11111_11111__0000_0000;
        TextPacer = 8'b0000_0000;
       end
      //  Cycle text at a readable pace -- TextPacer matches XXXX_X000
      if (TextPacer[2:0] == 3'b000)
       begin
        StateDisplay = StateDisplay << 7;
        case (TextPacer)
         8'b0000_1000 : StateDisplay = StateDisplay + 7'b1110110; //  H
         8'b0001_0000 : StateDisplay = StateDisplay + 7'b1111001; //  E
         8'b0001_1000 : StateDisplay = StateDisplay + 7'b0111000; //  L
         8'b0010_0000 : StateDisplay = StateDisplay + 7'b0111000; //  L
         8'b0010_1000 : StateDisplay = StateDisplay + 7'b1011100; //  o
         8'b0011_0000 : StateDisplay = StateDisplay + 7'b0000000; //  _
         8'b0011_1000 : StateDisplay = StateDisplay + 7'b1110110; //  H
         8'b0100_0000 : StateDisplay = StateDisplay + 7'b1110111; //  A
         8'b0100_1000 : StateDisplay = StateDisplay + 7'b0111110; //  V
         8'b0101_0000 : StateDisplay = StateDisplay + 7'b1111001; //  E
         8'b0101_1000 : StateDisplay = StateDisplay + 7'b0000000; //  _
         8'b0110_0000 : StateDisplay = StateDisplay + 7'b1110111; //  A
         8'b0110_1000 : StateDisplay = StateDisplay + 7'b0000000; //  _
         8'b0111_0000 : StateDisplay = StateDisplay + 7'b1010100; //  n
         8'b0111_1000 : StateDisplay = StateDisplay + 7'b0110000; //  I
         8'b1000_0000 : StateDisplay = StateDisplay + 7'b0111001; //  C
         8'b1000_1000 : StateDisplay = StateDisplay + 7'b1111001; //  E
         8'b1001_0000 : StateDisplay = StateDisplay + 7'b0000000; //  _
         8'b1001_1000 : StateDisplay = StateDisplay + 7'b1011110; //  d
         8'b1010_0000 : StateDisplay = StateDisplay + 7'b1110111; //  A
         8'b1010_1000 : StateDisplay = StateDisplay + 7'b1101110; //  Y
        endcase
       end
      SnakeDisplay = SnakeDisplay + 1;
      StateLedAll = ~StateLedAll;
      TextPacer = TextPacer + 1;
      StateLedRed = StateLedAll[17:8];
      StateLedGrn = StateLedAll[7:0];
     end
    //  Restart
    else
     begin
      Stopwatch = ~(16'b0000_0000__0000_0000);
     end
    //  Increment state tracker
    Stopwatch = Stopwatch + 1;
   end

  //  Connect output signal lines to ports
  assign Disp3 = ~StateDisplay[27:21];
  assign Disp2 = ~StateDisplay[20:14];
  assign Disp1 = ~StateDisplay[13:7];
  assign Disp0 = ~StateDisplay[6:0];
  assign LedRed = StateLedRed;
  assign LedGrn = StateLedGrn;
endmodule
