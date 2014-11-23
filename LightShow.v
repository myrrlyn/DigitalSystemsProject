//  Alexander Payne, Adam Suter
//  Digital Systems Final Project
//  FPGA Board Light Show

module LightShow(Clock, Switches, Keys, Disp3, Disp2, Disp1, Disp0, LedRed, LedGrn);
  //  Onboard clock
  input        Clock;
  //  Onboard switches - 0 when down, 1 when up
  input   [9:0]Switches;
  //  Onboard keys - 1 by default, 0 when pressed
  input   [3:0]Keys;
  //  Seven-segment displays. Ordered 3210.
  //  Each bus is ordered GFEDCBA, 1 for off, 0 for on. Segments are labelled
  //  clockwise from top starting with A.
  output  [6:0]Disp3;
  output  [6:0]Disp2;
  output  [6:0]Disp1;
  output  [6:0]Disp0;
  //  Red LEDs above switches. Ordered 9876543210. 0 is off, 1 is on.
  output  [9:0]LedRed;
  //  Green LEDs above keys. Ordered 76543210. 0 is off, 1 is on.
  output  [7:0]LedGrn;

  //  Clock wires
  wire ClockPulseLights;
  wire ClockPulseDisplay;
  wire ClockPulseJoint;

  //  Variable-frequency clocks.
  myrr50MCustomH ClockLights(Clock, FreqLights, ClockPulseLights);
  myrr50MCustomH ClockDisplay(Clock, FreqDisplay, ClockPulseDisplay);
  myrr50MCustomH ClockJoint(Clock, FreqJoint, ClockPulseJoint);

endmodule
