module Multiplier #(
  parameter WIDTH_A=4,
  parameter WIDTH_B=6
)(
  input [WIDTH_A-1:0] in1,
  input [WIDTH_B-1:0] in2,
  output [WIDTH_A+WIDTH_B-1:0] out
);
  assign out=in1*in2;
endmodule
