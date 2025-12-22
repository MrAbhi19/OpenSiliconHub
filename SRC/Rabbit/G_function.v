module g_function (
  input  [31:0] x,
  input  [31:0] c,
  output [31:0] g
);
  wire [31:0] sum = x + c;
  wire [63:0] sq  = sum * sum;

  assign g = sq[31:0] ^ sq[63:32];
endmodule
