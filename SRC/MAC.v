module MAC #(
  parameter WIDTH=8
)(
  input [WIDTH-1] A,B,
  input [2*WIDTH-1:0] C,
  output [2*WIDTH-1:0] Y
);
  assign Y=(A*B)+C;
endmodule
