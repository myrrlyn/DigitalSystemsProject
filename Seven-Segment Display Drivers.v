//  Alexander Payne, Adam Suter
//  BCD to Seven-Segment Display Decoder

module myrrBcd7sdDecoder(Input, Output);
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
      //  SSD section  :    GFEDCBA  //    _       A
      4'b1000 : Output = 7'b0000000; // 8 |_|     FGB
      4'b1001 : Output = 7'b0010000; // 9  _|     EDC
      4'b1010 : Output = 7'b0001000; // A  _       _
      4'b1011 : Output = 7'b0000011; // B |_| |_  |
      4'b1100 : Output = 7'b1000110; // C | | |_| |_
      4'b1101 : Output = 7'b0100001; // D      _   _
      4'b1110 : Output = 7'b0000110; // E  _| |_  |_
      4'b1111 : Output = 7'b0001110; // F |_| |_  |
      //  SSD section  :    GFEDCBA
    endcase
  end
endmodule
