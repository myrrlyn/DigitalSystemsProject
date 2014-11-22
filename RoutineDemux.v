//  Alexander Payne, Adam Suter
//  Routine demultiplexer

module RoutineDecoder(Select,
 R0,
 R1,
 LedRed, LedGrn,
 Hex0, Hex1, Hex2, Hex3);
  input   [9:0]Select;
  input   [45:0]R0;
  input   [45:0]R1;
  reg     [45:0]Out;
  output  [9:0]LedRed;
  output  [7:0]LedGrn;
  output  [6:0]Hex0;
  output  [6:0]Hex1;
  output  [6:0]Hex2;
  output  [6:0]Hex3;

  always @ (*)
  begin
    if (Select == 10'b00000_00001)
      Out = R1;
    else
      Out = R0;
  end

  assign LedRed = Out[45:36];
  assign LedGrn = Out[35:28];
  assign Hex3   = Out[27:21];
  assign Hex2   = Out[20:14];
  assign Hex1   = Out[13:7];
  assign Hex0   = Out[6:0];
endmodule
