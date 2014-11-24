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
  //  Signal to reset all routines. Tie this to bit 46 of the active routine.
  //  All routines send their SIGOUT on bit 46, and reset to 0-state when their
  //  local Reset line goes high. This output line will be tied back to the
  //  Reset inputs of the Routine modules, triggering a global reset when the
  //  selected Routine finishes. We have no reason to care about unused Routine
  //  SIGOUT completion signals.
  output       NewChoice;
  //  Actual pin outputs
  output  [9:0]LedRed;
  output  [7:0]LedGrn;
  output  [6:0]Disp0;
  output  [6:0]Disp1;
  output  [6:0]Disp2;
  output  [6:0]Disp3;

  //  Initialization flag -- used to determine if the program is just starting
  //  or continuing.
  reg          Init;
  //  Routine output bus
  reg          NewChoice;
  reg    [45:0]Out;
  //  Current routine memory
  reg     [1:0]CurrentRoutine;
  //  Sampled random-input bits
  wire    [1:0]RandomChoice;
  assign RandomChoice[1] = Select[15];
  assign RandomChoice[0] = Select[11];

  //  Select next routine on the completion signal
  always @ (posedge Clock)
   begin
    //  All registers are initialized to zero, so if this is zero, the program
    //  has just started, and we will want to immediately display a routine
    //  rather than waiting on other functions to allow a display choice. This
    //  is especially mandatory as without it, NO routine will be displayed for
    //  an unacceptably long interval upon startup.
    if (Init == 1'b0)
     begin
      //  Display Routine0
      CurrentRoutine = 2'b0000;
      //  Once bootstrapped, the process is self-sustaining, so this flag should
      //  be disabled.
      Init = 1'b1;
     end
    //  Alter CurrentRoutine when NewChoice pulses. Hopefully, this changeover
    //  will be done shortly before the actual output line changes over, but it
    //  shouldn't really matter. Note that NewChoice should never be HIGH for
    //  consecutive clock cycles, so this condition should only ever fire at
    //  end-of-routine. This should also add to the apparent randomness of the
    //  selection PRNG, which is random in large scale but periodic in detail.
    if (NewChoice == 1'b1)
     begin
      CurrentRoutine = RandomChoice;
     end
    case (CurrentRoutine)
      2'b00:
       begin
        Out = R0[45:0];
        NewChoice = R0[46];
       end
      2'b01:
       begin
        Out = R1[45:0];
        NewChoice = R1[46];
       end
      2'b1:
       begin
        Out = R2[45:0];
        NewChoice = R2[46];
       end
      2'b11:
       begin
        Out = R3[45:0];
        NewChoice = R3[46];
       end
      default:
       begin
        Out = R0[45:0];
        NewChoice = R0[46];
       end
    endcase
   end

  //  Decompress the routine bus into pin groups.
  assign LedRed[9:2] = Out[45:38];
  assign LedRed[1:0] = Out[37:36];
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
