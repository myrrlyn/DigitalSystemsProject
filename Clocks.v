//  50MHz -> 1Hz converter
module myrr50M01H(Clock, Control);
  input  Clock;
  output Control;
  reg    Control;
  reg    [31:0]Q;

  always @ (posedge Clock)
  begin
    if (Q == 32'd50_000_000)
    begin
      Q = 32'd0;
      Control = 1'b1;
    end
    else
    begin
      Q = Q + 1;
      Control = 1'b0;
    end
  end
endmodule

//  50MHz -> 10Hz converter
module myrr50M10H(Clock, Control);
  input  Clock;
  output Control;
  reg    Control;
  reg    [31:0]Q;

  always @ (posedge Clock)
  begin
    if (Q == 32'd5_000_000)
    begin
      Q = 32'd0;
      Control = 1'b1;
    end
    else
    begin
      Q = Q + 1;
      Control = 1'b0;
    end
  end
endmodule

//  This ought to be able to create a clock of any frequency <= 50MHz
//  Parameters:
//    Clock: 50MHz onboard clock
//    FreqSelect: 32-bit number literal OR variable bus line
//    OutputSignal: 1-bit binary line -- creates a 2E-8s pulse when the clock
//      reaches FreqSelect
module myrr50MCustomH(Clock, FreqSelect, OutputSignal);
  input         Clock;
  input   [31:0]FreqSelect;
  output        OutputSignal;
  reg           OutputSignal;
  reg     [31:0]Internal;

  always @ (posedge Clock)
  begin
    if (Internal == FreqSelect)
    begin
      Internal = 32'd0;
      OutputSignal = 1'b1;
    end
    else
    begin
      Internal = Internal + 1;
      OutputSignal = 1'b0;
    end
  end
endmodule
