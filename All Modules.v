//  Alexander Payne
//  All Verilog Modules

//  1-bit 2->1 Multiplexer
module myrrMux121(Input1, Input0, Select, Output);
  //  1-bit Input lines
  input   Input1, Input0;
  //  1-bit Select line
  input   Select;
  //  1-bit Output line
  output  Output;

  //  Use ternary operator to assign Inputs to Output against Select
  assign  Output = Select ? Input1 : Input0;
endmodule

//  4-bit 2->1 Multiplexer
module myrrMux421(Input0, Input1, Select, Output);
  //  4-bit Input lines
  input   [3:0]Input0;
  input   [3:0]Input1;
  //  1-bit Select line
  input   Select;
  //  4-bit Output line
  output  [3:0]Output;

  //  Use ternary operator to assign Inputs to Output against Select
  assign  Output = Select ? Input1 : Input0;
endmodule

//  1-bit 4->1 Multiplexer
module myrrMux141(Input3, Input2, Input1, Input0, Select, Output);
  //  1-bit Input lines
  input   Input3, Input2, Input1, Input0;
  //  2-bit Select line
  input   [1:0]Select;
  //  1-bit Output line
  output  Output;
  //  Tie internal multiplexers together
  wire    [1:0]Internal;

  //  Select from high pair
  myrrMux121 Comp1(Input3, Input2, Select[0], Internal[1]);
  //  Select from low pair
  myrrMux121 Comp0(Input1, Input0, Select[0], Internal[0]);
  //  Select from selections
  myrrMux121 CompY(Internal1, Internal0, Select[1], Output);
endmodule

//  8->1 Multiplexer
module myrrMux81(Input7, Input6, Input5, Input4, Input3, Input2, Input1, Input0, Select, Output);
  //  1-bit Input lines
  input   Input7, Input6, Input5, Input4, Input3, Input2, Input1, Input0;
  //  3-bit Select line
  input   [2:0]Select;
  //  1-bit Output line
  output  Output;
  //  Tie internal multiplexers together
  wire    [1:0]Internal;

  //  Select from high four
  myrrMux141 Comp1(Input7, Input6, Input5, Input4, Select[1:0], Internal[1]);
  //  Select from low four
  myrrMux141 Comp0(Input3, Input2, Input1, Input0, Select[1:0], Internal[0]);
  //  Select from selections
  myrrMux121 CompY(Internal1, Internal0, Select[2], Output);
endmodule

//#endregion

//#region Encoders

//  2->4 Decoder, HIGH Enable
module myrrDecoder24(Enable, Input, Output);
  //  Enabling line
  input   Enable;
  //  2-bit input line
  input   [1:0]Input;
  //  4-bit output line
  output  [3:0]Output;
  reg     [3:0]Output;

  always @ (Enable, Input)
  begin
    //  The decoder will only return meaningful results when Enable is high
    if (Enable == 1'b1)
      case (Input)
        2'b00 : Output = 4'b0001;
        2'b01 : Output = 4'b0010;
        2'b10 : Output = 4'b0100;
        2'b11 : Output = 4'b1000;
        //  Error state (unreachable, but just in case)
        default : Output = 4'bZZZZ;
      endcase
    //  When Enable is not high, the output lines are grounded
    else
      Output = 4'bZZZZ;
  end
endmodule

//  4->2 Priority Encoder
module myrrEncoder42(Input, Output);
  //  Quad-stream input line
  input   [3:0]Input;
  //  Dual-stream output line
  output  [1:0]Output;
  reg     [1:0]Output;

  //  Recalculate on input state changes
  always @ (Input)
  begin
  //  Case statements fire on the first matching block and end immediately,
  //   ignoring the rest -- exactly what priority encoding demands
    case (Input)
      4'b1XXX : Output = 2'b11;
      4'b01XX : Output = 2'b10;
      4'b001X : Output = 2'b01;
      4'b0001 : Output = 2'b00;
      //  Error state (12 possible matches)
      default : Output = 2'bZZ;
    endcase
  end
endmodule

//  10-Switch -> Digit Priority Encoder
module myrrNumDisplay(Input, Output);
  //  10 Switches
  input  [9:0]Input;
  //  4-bit BCD Number
  output [3:0]Output;
  reg    [3:0]Output;

  always @ (Input)
  begin
    if (Input[9] == 1)
      Output = 4'b1001;
    else if (Input[8] == 1)
      Output = 4'b1000;
    else if (Input[7] == 1)
      Output = 4'b0111;
    else if (Input[6] == 1)
      Output = 4'b0110;
    else if (Input[5] == 1)
      Output = 4'b0101;
    else if (Input[4] == 1)
      Output = 4'b0100;
    else if (Input[3] == 1)
      Output = 4'b0011;
    else if (Input[2] == 1)
      Output = 4'b0010;
    else if (Input[1] == 1)
      Output = 4'b0001;
    else if (Input[0] == 1)
      Output = 4'b0000;
    else
      Output = 4'b1110;
/*
    //  At present this is inoperable
    case (Input)
      10'b00000_00000 : Output = 4'b1110;
      10'b00000_00001 : Output = 4'b0000;
      10'b00000_0001X : Output = 4'b0001;
      10'b00000_001XX : Output = 4'b0010;
      10'b00000_01XXX : Output = 4'b0011;
      10'b00000_1XXXX : Output = 4'b0100;
      10'b00001_XXXXX : Output = 4'b0101;
      10'b0001X_XXXXX : Output = 4'b0110;
      10'b001XX_XXXXX : Output = 4'b0111;
      10'b01XXX_XXXXX : Output = 4'b1000;
      10'b1XXXX_XXXXX : Output = 4'b1001;
    endcase
*/
  end
endmodule

//#endregion

//  Two-state BCD Display
module myrrBcd7sdDecoder11(Input, Output);
  input  Input;
  output [6:0]Output;
  assign Output = Input ? 7'b1111001 : 7'b1000000;
  //  Display sections:      GFEDCBA      GFEDCBA
endmodule

//  Single-cell BCD -> Display Decoder
module myrrBcd7sdDecoder14(Input, Output);
  //  4-bit driving line
  input  [3:0]Input;
  //  7-bit driver line
  output [6:0]Output;
  reg    [6:0]Output;

  always @ (Input)
  begin
    case (Input)
      //  SSD section  :    GFEDCBA  //    _       _
      4'b0000 : Output = 7'b1000000; // 0 | |   |  _|
      4'b0001 : Output = 7'b1111001; // 1 |_|   | |_
      4'b0010 : Output = 7'b0100100; // 2  _       _
      4'b0011 : Output = 7'b0110000; // 3  _| |_| |_
      4'b0100 : Output = 7'b0011001; // 4  _|   |  _|
      4'b0101 : Output = 7'b0010010; // 5  _   _   _
      4'b0110 : Output = 7'b0000010; // 6 |_    | |_|
      4'b0111 : Output = 7'b1111000; // 7 |_|   | |_|
      4'b1000 : Output = 7'b0000000; // 8  _       A
      4'b1001 : Output = 7'b0010000; // 9 |_|     FGB
      //  SSD section  :    GFEDCBA  //    _|     EDC
      4'b1010 : Output = 7'b0001000; // A  _       _
      4'b1011 : Output = 7'b0000011; // B |_| |_  |
      4'b1100 : Output = 7'b1000110; // C | | |_| |_
      4'b1101 : Output = 7'b0100001; // D      _   _
      4'b1110 : Output = 7'b0000110; // E  _| |_  |_
      4'b1111 : Output = 7'b0001110; // F |_| |_  |
      default : Output = 7'b0000110; // E for Error - only needed for non-hex
      //  SSD section  :    GFEDCBA
    endcase
  end
endmodule

//  BCD -> Seven-Segment Display Decoder
//  This module is designed to be used when only one cell's worth of information
//  needs to be displayed, but the other three cells are desired to be muted.
module myrrBcd7sdDecoder44(Input, Display0, Display1, Display2, Display3);
  //  4-bit BCD input line
  input  [3:0]Input;
  //  7-bit SSD driving line
  output [6:0]Display0;
  output [6:0]Display1;
  output [6:0]Display2;
  output [6:0]Display3;
  reg    [6:0]Display0;
  reg    [6:0]Display1;
  reg    [6:0]Display2;
  reg    [6:0]Display3;
  reg    [27:0]Internal;

  always @ (Input)
  begin
    case (Input)
      //  SSD section    :     GFEDCBA GFEDCBA GFEDCBA GFEDCBA  //   _       _
      4'b0000 : Internal = 28'b1111111_1111111_1111111_1000000; //  | |   |  _|
      4'b0001 : Internal = 28'b1111111_1111111_1111111_1111001; //  |_|   | |_
      4'b0010 : Internal = 28'b1111111_1111111_1111111_0100100; //   _       _
      4'b0011 : Internal = 28'b1111111_1111111_1111111_0110000; //   _| |_| |_
      4'b0100 : Internal = 28'b1111111_1111111_1111111_0011001; //   _|   |  _|
      4'b0101 : Internal = 28'b1111111_1111111_1111111_0010010; //   _   _   _
      4'b0110 : Internal = 28'b1111111_1111111_1111111_0000010; //  |_    | |_|
      4'b0111 : Internal = 28'b1111111_1111111_1111111_1111000; //  |_|   | |_|
      4'b1000 : Internal = 28'b1111111_1111111_1111111_0000000; //   _
      4'b1001 : Internal = 28'b1111111_1111111_1111111_0010000; //  |_|
      //  SSD section    :     GFEDCBA GFEDCBA GFEDCBA GFEDCBA  //   _|
      //  OPTIONAL - PRINT DisplayADECIMAL CHARS
      4'b1010 : Internal = 28'b1111111_1111111_1111111_0001000; //   _       _
      4'b1011 : Internal = 28'b1111111_1111111_1111111_1100000; //  |_| |_  |
      4'b1100 : Internal = 28'b1111111_1111111_1111111_0110001; //  | | |_| |_
      4'b1101 : Internal = 28'b1111111_1111111_1111111_1000010; //       _   _
      4'b1110 : Internal = 28'b1111111_1111111_1111111_0110000; //   _| |_  |_
      4'b1111 : Internal = 28'b1111111_1111111_1111111_0111000; //  |_| |_  |
      //  If any signal other than 0-9 is transmitted, print Err for error
      default : Internal = 28'b1111111_0000110_0101111_0101111;
    endcase

    Display3[6:0] = Internal[27:21];
    Display2[6:0] = Internal[20:14];
    Display1[6:0] = Internal[13:7];
    Display0[6:0] = Internal[6:0];
  end
endmodule

//  1-bit to BCD Converter
module myrrBinBcd1(Input, Output);
  input       Input;
  output [3:0]Output;

  assign Output[3] = 0;
  assign Output[2] = 0;
  assign Output[1] = 0;
  assign Output[0] = Input;
endmodule

//  3-bit to BCD Converter
module myrrBinBcd3(Input, Output);
  input  [2:0]Input;
  output [3:0]Output;

  assign Output[3] = 0;
  assign Output[2] = Input[2];
  assign Output[1] = Input[1];
  assign Output[0] = Input[0];
endmodule

//#region Arithmetic and Logic Units

//  4-bit comparator with hierarchical design

//  Compare two single bits
module myrrComp1(A, B, GT, EQ, LT);
  //  1-bit input lines
  input   A;
  input   B;
  //  Output lines in form A OUTPUT B
  output  GT, EQ, LT;
  reg     GT, EQ, LT;

  //  Fire at any input state change
  always @ (A, B)
  begin
    //  EQ = A XNOR B (true for 00 and 11)
    EQ = ~(A ^ B);
    //  GT is true for ~EQ and A&~B (true for 10)
    GT = (~EQ & (A & ~B));
    //  LT is true for ~EQ and ~A&B (true for 01)
    LT = (~EQ & (~A & B));
  end
endmodule

//  Compare two bit-pairs using two single comparators
module myrrComp2(A, B, GT, EQ, LT);
  //  2-bit input lines
  input   [1:0]A;
  input   [1:0]B;
  //  Output lines in form A OUTPUT B
  output  GT, EQ, LT;
  reg     GT, EQ, LT;
  //  Internal storage for both bit comparisons
  wire    [1:0]Internal_GT;
  wire    [1:0]Internal_EQ;
  wire    [1:0]Internal_LT;

  //  Compare the high bits
  myrrComp1 Comp1(A[1], B[1], Internal_GT[1], Internal_EQ[1], Internal_LT[1]);
  //  Compare the low bits
  myrrComp1 Comp0(A[0], B[0], Internal_GT[0], Internal_EQ[0], Internal_LT[0]);

  //  Fire at any input state change
  always @ (A, B)
  begin
    //  EQ is true for EQ-EQ
    EQ = (Internal_EQ[1] & Internal_EQ[0]);
    //  GT is true for GT-** and EQ-GT
    GT = (Internal_GT[1] | (Internal_EQ[1] & Internal_GT[0]));
    //  LT is true for LT-** and EQ-LT
    LT = (Internal_LT[1] | (Internal_EQ[1] & Internal_LT[0]));
  end
endmodule

//  Compare four bit-pairs using two dual comparators
module myrrComp4(A, B, GT, EQ, LT);
  //  4-bit input lines
  input   [3:0]A;
  input   [3:0]B;
  //  Output lines in form A OUTPUT B
  output  GT, EQ, LT;
  reg     GT, EQ, LT;
  //  Internal storage for all bit comparisons
  wire    [1:0]Internal_GT;
  wire    [1:0]Internal_EQ;
  wire    [1:0]Internal_LT;

  //  Compare high pair
  myrrComp2 Comp32(A[3:2], B[3:2], Internal_GT[1], Internal_EQ[1], Internal_LT[1]);
  //  Compare low pair
  myrrComp2 Comp10(A[1:0], B[1:0], Internal_GT[0], Internal_EQ[0], Internal_LT[0]);

  //  Fire at any input state change
  always @ (A, B)
  begin
    //  EQ is true for (EQ)-(EQ)
    EQ = (Internal_EQ[1] & Internal_EQ[0]);
    //  GT is true for (GT)-(**) and (EQ)-(GT)
    GT = (Internal_GT[1] | (Internal_EQ[1] & Internal_GT[0]));
    //  LT is true for (LT)-(**) and (EQ)-(LT)
    LT = (Internal_LT[1] | (Internal_EQ[1] & Internal_LT[0]));
  end
endmodule

//  Renders comparison results
module myrrCompDisplay(GT, EQ, LT, Display3, Display2, Display1, Display0);
  input  GT;
  input  EQ;
  input  LT;
  output [6:0]Display3;
  output [6:0]Display2;
  output [6:0]Display1;
  output [6:0]Display0;
  reg    [6:0]Display3;
  reg    [6:0]Display2;
  reg    [6:0]Display1;
  reg    [6:0]Display0;
  reg    [27:0]Output;

  always @ (GT, EQ, LT)
  begin
    if (GT == 1 && EQ == 0 && LT == 0)
      Output = 28'b1111111_1111111_0000010_0000111;
    else if (GT == 0 && EQ == 1 && LT == 0)
      Output = 28'b1111111_1111111_0000110_0011000;
    else if (GT == 0 && EQ == 0 && LT == 1)
      Output = 28'b1111111_1111111_1000111_0000111;
    else
      Output = 28'b1111111_0000110_0101111_0101111;

    Display3[6:0] = Output[27:21];
    Display2[6:0] = Output[20:14];
    Display1[6:0] = Output[13:7];
    Display0[6:0] = Output[6:0];
  end
endmodule

//  Single-bit adder
module myrrAdd1(A, B, CInput, SUM, COutput);
  //  Augend
  input  A;
  //  Addend
  input  B;
  //  Carry-in
  input  CInput;
  //  Output
  output SUM;
  //  Carry-out
  output COutput;

  assign SUM     = ((A ^ B) ^ CInput);
  assign COutput = ((A & B) | ((A ^ B) & CInput));
endmodule

//  4-bit Ripple-carry ALU
module myrrAddRC4(CInput, A, B, Select, COutput, SUM);
  input       CInput;
  input  [3:0]A;
  input  [3:0]B;
  input       Select;
  output      COutput;
  output [3:0]SUM;

  wire   [3:0]Internal_S;
  wire        Internal_0;
  wire        Internal_1;
  wire        Internal_2;

  myrrAdd1 Add0(A[0], B[0], CInput, Internal_S[0], Internal_0);
  myrrAdd1 Add1(A[1], B[1], CInput, Internal_S[1], Internal_1);
  myrrAdd1 Add2(A[2], B[2], CInput, Internal_S[2], Internal_2);
  myrrAdd1 Add3(A[3], B[3], CInput, Internal_S[3], COutput);

  assign SUM = Internal_S;
endmodule

//  4-bit AND2 gate
module myrrAnd42(A, B, Output);
  input  [3:0]A;
  input  [3:0]B;
  output [3:0]Output;
  assign Output = A & B;
endmodule

//  3-bit latched ALU
module myrrAluAddSubAndNnd3(Input0, Input1, CInput, Select, Output, COutput);
  input  [2:0]Input0;
  input  [2:0]Input1;
  input       CInput;
  input  [1:0]Select;
  output [2:0]Output;
  output     COutput;

  reg    [2:0]Output;
  reg        COutput;

  wire        Internal0;
  wire        Internal1;
  wire        Internal2;
  wire   [2:0]Internal_SUM;

  myrrAdd1 Add0(Input0[0], Input1[0] ^ Select[0], CInput | Select[0], Internal_SUM[0], Internal0);
  myrrAdd1 Add1(Input0[1], Input1[1] ^ Select[0], InternalS0, Internal_SUM[1], Internal1);
  myrrAdd1 Add2(Input0[2], Input1[2] ^ Select[0], InternalS1, Internal_SUM[2], Internal2);

  always @ (*)
  begin
    //  Adder
    if (Select == 2'b00)
    begin
      Output = Internal_SUM;
      COutput = Internal2;
    end
    //  Subtractor
    else if (Select == 2'b01)
    begin
      Output = Internal_SUM;
      COutput = Internal2;
    end
    //  Bitwise AND
    else if (Select == 2'b10)
    begin
      Output = Input0 & Input1;
      COutput = 1'b0;
    end
    //  Bitwise NAND
    else if (Select == 2'b11)
    begin
      Output = ~(Input0 & Input1);
      COutput = 1'b0;
    end
    //  Error (Unreachable)
    else
    begin
      Output = 3'bZZZ;
      COutput = 1'bZ;
    end
  end
endmodule

//#endregion

//#region Latches

//  S-R Active-High NOR Latch
module myrrNorLatch(S, R, QA, QB);
  //  Set
  input  wire S;
  //  Reset
  input  wire R;
  //  Actual output
  output wire QA;
  //  Inverse of output
  output wire QB;
  //  Internal connections
         wire Internal0;
         wire Internal1;

  //  Tie outputs to wires
  assign QA = Internal1;
  assign QB = Internal0;

  //  Tie wires to each other and logic
  assign Internal1 = ~(Internal0 | S);
  assign Internal0 = ~(Internal1 | R);
endmodule

//  S-R Active-Low NAND Latch
module myrrNandLatch(S, R, QA, QB);
  //  Set
  input  wire S;
  //  Reset
  input  wire R;
  //  Actual output
  output wire QA;
  //  Inverse of output
  output wire QB;
  //  Internal connections
         wire Internal0;
         wire Internal1;

  //  Tie outputs to wires
  assign QA = Internal1;
  assign QB = Internal0;

  //  Tie wires to each other and logic
  assign Internal1 = ~(Internal0 & S);
  assign Internal0 = ~(Internal1 & R);
endmodule

//  1-bit D Latch
module myrrDLatch1(D, Clock, Q);
  //  Input
  input  D;
  //  Enabling (clock) signal
  input  Clock;
  //  Output
  output Q;
  reg    Q;

  always @ (D, Clock)
  begin
    if (Clock == 1'b1)
      Q = D;
  end
endmodule

//  3-bit D Latch
module myrrDLatch3(D, Clock, Q);
  input  [2:0]D;
  input       Clock;
  output [2:0]Q;

  myrrDLatch1 Latch0(D[0], Clock, Q[0]);
  myrrDLatch1 Latch1(D[1], Clock, Q[1]);
  myrrDLatch1 Latch2(D[2], Clock, Q[2]);
endmodule

//  1-bit D Latch With Reset
module myrrDLatch1R(D, R, Clock, Q);
  input  D;
  input  R;
  input  Clock;
  output Q;
  reg    Q;

  always @ (D, R, Clock)
  begin
    //  Always set to zero at Reset input
    if (R == 1'b1)
      Q = 0;
    //  When Reset is inactive, set only at Clock signals
    else if (Clock == 1'b1)
      Q = D;
  end
endmodule

//  3-bit D Latch With Reset
module myrrDLatch3R(D, R, Clock, Q);
  input  [2:0]D;
  input       R;
  input       Clock;
  output [2:0]Q;

  myrrDLatch1R Latch0(D[0], R, Clock, Q[0]);
  myrrDLatch1R Latch1(D[1], R, Clock, Q[1]);
  myrrDLatch1R Latch2(D[2], R, Clock, Q[2]);
endmodule

//  4-bit D Latch With Reset
module myrrDLatch4R(D, R, Clock, Q);
  input  [3:0]D;
  input  R;
  input  Clock;
  output [3:0]Q;

  myrrDLatch1R Latch0(D[0], R, Clock, Q[0]);
  myrrDLatch1R Latch1(D[1], R, Clock, Q[1]);
  myrrDLatch1R Latch2(D[2], R, Clock, Q[2]);
  myrrDLatch1R Latch3(D[3], R, Clock, Q[3]);
endmodule

//#endregion

//#region LAB TWELVE THINGS

//  Positive-edge D FlipFlop
module myrrDFlopPos(D, Clock, Clear, Q);
  input  D;
  input  Clock;
  input  Clear;
  output Q;
  reg    Q;

  always @ (posedge Clock)
  begin
    if (Clear == 1'b1)
      Q = 1'b0;
    else
      Q = D;
    end
endmodule

//  Negative-edge JK FlipFlop
module myrrJkFlopNeg(J, K, Clock, Clear, Q);
  input  J;
  input  K;
  input  Clock;
  input  Clear;
  output Q;
  reg    Q;
  wire   [1:0]Internal;

  assign Internal[1] = J;
  assign Internal[0] = K;

  always @ (negedge Clock or posedge Clear)
  begin
    if (Clear == 1'b1)
      Q = 0;
    else
      case (Internal)
        2'b00 : Q = Q;
        2'b01 : Q = 0;
        2'b10 : Q = 1;
        2'b11 : Q = ~Q;
      endcase
  end
endmodule

//  Negative-edge JK FlipFlop with single input
module myrrSyncCounterNeg(In, Clock, Clear, Q);
  input  In;
  input  Clock;
  input  Clear;
  output Q;

  myrrJkFlopNeg SyncCounter(In, In, Clock, Clear, Q);
endmodule

//  Base-6 counter
module myrrCount06(Clock, ClearInput, Output);
  input  Clock;
  input  ClearInput;
  output [3:0]Output;
  wire   Internal;
  wire   Clear;

  assign Internal = Output[0] & Output[1];
  assign Output[3] = 1'b0;

  myrrSyncCounterNeg Bit0(     1'b1, Clock, Clear, Output[0]);
  myrrSyncCounterNeg Bit1(Output[0], Clock, Clear, Output[1]);
  myrrSyncCounterNeg Bit2( Internal, Clock, Clear, Output[2]);

  assign Clear = (Output[2] & Output[1]) | ClearInput;
endmodule

//  Base-10 counter
module myrrCount10(Clock, ClearInput, Output, ClearOutput);
  input  Clock;
  input  ClearInput;
  output [3:0]Output;
  output ClearOutput;
  wire   [1:0]Internal;
  wire   Clear;

  assign Internal[0] = Output[0] & Output[1];
  assign Internal[1] = Output[0] & Output[1] & Output[2];

  myrrSyncCounterNeg Bit0(       1'b1, Clock, Clear, Output[0]);
  myrrSyncCounterNeg Bit1(  Output[0], Clock, Clear, Output[1]);
  myrrSyncCounterNeg Bit2(Internal[0], Clock, Clear, Output[2]);
  myrrSyncCounterNeg Bit3(Internal[1], Clock, Clear, Output[3]);

  assign Clear = (Output[3] & Output[1]) | ClearInput;
  assign ClearOutput = Clear;
endmodule

//  Base-60 counter
module myrrCount60(Clock, ClearInput, Output10, Output06);
  input  Clock;
  input  ClearInput;
  output [3:0]Output10;
  output [3:0]Output06;
  wire        Clear10;

  // Count to ten using the input clock
  myrrCount10 LoCount(Clock, ClearInput, Output10, Clear10);
  // Count to six using the reset signal of the prior counter as the clock posedge
  myrrCount06 HiCount(Clear10, ClearInput, Output06);
endmodule

//  Stopwatch
module myrrStopwatch(Clock, ClearInput, Output10, Output06);
  input       Clock;
  input       ClearInput;
  output [3:0]Output10;
  output [3:0]Output06;
  wire        Clear10;
  wire        Clear06;
  wire   [3:0]Internal;
  
  //  Create the internal synchronizing logic
  assign Internal[0] = Output10[0] & Output10[1];
  assign Internal[1] = Internal[0] & Output10[2];
  assign Internal[2] = Output06[0] & Output06[1];
  assign Internal[3] = Internal[2] & Output06[2];
  
  //  Count the ones based on the input clock
  //  Arguments are: Previous out, system clock, cycle/reset, current out
  myrrSyncCounterNeg TenBit0(       1'b1, Clock, Clear10, Output10[0]);
  myrrSyncCounterNeg TenBit1(Output10[0], Clock, Clear10, Output10[1]);
  myrrSyncCounterNeg TenBit2(Internal[0], Clock, Clear10, Output10[2]);
  myrrSyncCounterNeg TenBit3(Internal[1], Clock, Clear10, Output10[3]);
  
  //  Count the tens based on the ones-counter reset
  //  Arguments are: Previous out, ones-reset, cycle/reset, current out
  myrrSyncCounterNeg SixBit0(       1'b1, Clear10, Clear06, Output06[0]);
  myrrSyncCounterNeg SixBit1(Output06[0], Clear10, Clear06, Output06[1]);
  myrrSyncCounterNeg SixBit2(Internal[2], Clear10, Clear06, Output06[2]);
  myrrSyncCounterNeg SixBit3(Internal[3], Clear10, Clear06, Output06[3]);
  
  //  Each Clear## is the triggered by the logical value of the mod number or the system interrupt.
  assign Clear10 = (Output10 == 4'b1010) | ClearInput;
  assign Clear06 = (Output06 == 4'b0110) | ClearInput;
endmodule

//  Self-contained stopwatch module
module myrrSealedStopwatch(Clock, FreqSelect, Reset, Disp0, Disp1, Disp2, Disp3);
  //  FPGA clock pin
  input       Clock;
  //  Selector line for the internal frequency-divider multiplexer
  input       FreqSelect;
  //  Resets the stopwatch to zero
  input       Reset;
  //  Seven-segment display encoded output
  output [6:0]Disp0;
  output [6:0]Disp1;
  output [6:0]Disp2;
  output [6:0]Disp3;

  //  Clock lines
  wire   [2:0]ClockInternal;
  //  BCD-encoded counter containers
  //  [6:4] for Tens, [3:0] for Ones
  wire   [7:0]Count;
  //  Iteration resets
  //  [1] for Tens, [0] for Ones
  wire   [1:0]Cycle;
  //  Internal synchronization wires
  wire   [2:0]Sync;

  //  Define internal synchronization logic
  assign Sync[0] = Count[0] & Count[1];
  assign Sync[1] =  Sync[0] & Count[2];
  assign Sync[2] = Count[4] & Count[5];
  //  Define cycle/reset logic
  assign Cycle[0] = Count[3:0] == 4'b1010 | Reset;
  assign Cycle[1] = Count[6:4] == 3'b110  | Reset;
  
  //  Multiplex the input clock to frequency dividers
  myrr50M01H ClockSlow(Clock, ClockInternal[1]);
  myrr50M10H ClockFast(Clock, ClockInternal[2]);
  myrrMux121 ClockMixr(ClockInternal[2], ClockInternal[1], FreqSelect, ClockInternal[0]);
  
  //  Count to ten, iterating every clock pulse
  myrrSyncCounterNeg OneBit0(    1'b1, ClockInternal[0], Cycle[0], Count[0]);
  myrrSyncCounterNeg OneBit1(Count[0], ClockInternal[0], Cycle[0], Count[1]);
  myrrSyncCounterNeg OneBit2( Sync[0], ClockInternal[0], Cycle[0], Count[2]);
  myrrSyncCounterNeg OneBit3( Sync[1], ClockInternal[0], Cycle[0], Count[3]);
  
  //  Count to six, iterating every ten-count cycle
  myrrSyncCounterNeg TenBit0(    1'b1, Cycle[0], Cycle[1], Count[4]);
  myrrSyncCounterNeg TenBit1(Count[4], Cycle[0], Cycle[1], Count[5]);
  myrrSyncCounterNeg TenBit2( Sync[2], Cycle[0], Cycle[1], Count[6]);
  assign Count[7] = 1'b0; //  Permanently empty bit necessary for the encoder
  
  //  Convert BCD to 7SD encoding
  myrrBcd7sdDecoder14 DisplayOnes(Count[3:0], Disp0[6:0]);
  myrrBcd7sdDecoder14 DisplayTens(Count[7:4], Disp1[6:0]);
  
  //  Just to showcase s
  assign Disp2 = 7'b1111111;
  assign Disp3 = 7'b1111111;
endmodule
