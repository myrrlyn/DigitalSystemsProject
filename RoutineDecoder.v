//  Alexander Payne, Adam Suter
//  Routine demultiplexer

module RoutineDecoder(Clock, Select,
 R0,
 R1,
 R2,
 R3,
 NewChoice,
 Disp3, Disp2, Disp1, Disp0,
 LedRed, LedGrn);
  input        Clock;
  //  Select line can take up to a 16-bit number, though this is overkill
  input  [15:0]Select;
  //  Routines
  input  [46:0]R0;
  input  [46:0]R1;
  input  [46:0]R2;
  input  [46:0]R3;
  //  Signal to reset all routines
  output       NewChoice;
  //  Actual pin outputs
  output  [9:0]LedRed;
  output  [7:0]LedGrn;
  output  [6:0]Disp0;
  output  [6:0]Disp1;
  output  [6:0]Disp2;
  output  [6:0]Disp3;

  //  Routine output bus
  reg          NewChoice;
  reg    [45:0]Out;
  //  Current routine memory
  reg          Await;
  //  Sampled random-input bits
  wire    [1:0]RandomChoice;
  assign RandomChoice = Select[7:6];

  //  Select next routine on the completion signal
  always @ (posedge Clock)
   begin
    if (RandomChoice == 2'b11)
     begin
      NewChoice = 1'b0;
      Out = R3[45:0];
      Await = R3[46];
     end
    else if (RandomChoice == 2'b10)
     begin
      NewChoice = 1'b0;
      Out = R2[45:0];
      Await = R2[46];
     end
    else if (RandomChoice == 2'b01)
     begin
      NewChoice = 1'b0;
      Out = R1[45:0];
      Await = R1[46];
     end
    else if (RandomChoice == 2'b00)
     begin
      NewChoice = 1'b0;
      Out = R0[45:0];
      Await = R0[46];
     end
   end

  //  Decompress the routine bus into pin groups.
  assign LedRed = Out[45:36];
  assign LedGrn = Out[35:28];
  assign Disp3   = Out[27:21];
  assign Disp2   = Out[20:14];
  assign Disp1   = Out[13:7];
  assign Disp0   = Out[6:0];
//  myrrBcd7sdDecoder Hex3Display(Select[15:12], Disp3);
//  myrrBcd7sdDecoder Hex2Display(Select[11:8], Disp2);
//  myrrBcd7sdDecoder Hex1Display(Select[7:4], Disp1);
//  myrrBcd7sdDecoder Hex0Display(Select[3:0], Disp0);
endmodule
