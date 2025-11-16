module MAC #(
  parameter WIDTH_A=8,
  parameter WIDTH_B=12
)(
  input [WIDTH_A-1:0] A,
  input [WIDTH_B-1:0] B,
  input [WIDTH_A+WIDTH_B-1:0] C,
  output [WIDTH_A+WIDTH_B-1:0] Y
);
  assign Y=(A*B)+C;
endmodule
