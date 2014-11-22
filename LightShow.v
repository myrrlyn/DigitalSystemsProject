//  Alexander Payne, Adam Suter
//  Digital Systems Final Project
//  FPGA Board Light Show

module LightShow(Clock, Switches, Keys, LedRed, LedGrn, Hex0, Hex1, Hex2, Hex3);
  input        Clock;
  input   [9:0]Switches;
  input   [3:0]Keys;
  output  [9:0]LedRed;
  output  [7:0]LedGrn;
  output  [6:0]Hex0;
  output  [6:0]Hex1;
  output  [6:0]Hex2;
  output  [6:0]Hex3;
endmodule
