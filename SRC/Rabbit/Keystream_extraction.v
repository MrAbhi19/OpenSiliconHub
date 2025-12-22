module keystream_extract (
  input  [31:0] X0, X1, X2, X3, X4, X5, X6, X7,
  output [127:0] S
);

  assign S[15:0]    = X0[15:0]  ^ X5[31:16];
  assign S[31:16]   = X0[31:16] ^ X3[15:0];
  assign S[47:32]   = X2[15:0]  ^ X7[31:16];
  assign S[63:48]   = X2[31:16] ^ X5[15:0];
  assign S[79:64]   = X4[15:0]  ^ X1[31:16];
  assign S[95:80]   = X4[31:16] ^ X7[15:0];
  assign S[111:96]  = X6[15:0]  ^ X3[31:16];
  assign S[127:112] = X6[31:16] ^ X1[15:0];

endmodule
