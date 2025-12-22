module iv_setup (
  input         clk,
  input         rst,
  input         load_iv,
  input  [63:0] iv,
  input  [31:0] C0_in, C1_in, C2_in, C3_in,
                C4_in, C5_in, C6_in, C7_in,
  output reg [31:0] C0, C1, C2, C3, C4, C5, C6, C7
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // no-op
    end else if (load_iv) begin
      C0 <= C0_in ^ iv[31:0];
      C1 <= C1_in ^ {iv[63:48], iv[31:16]};
      C2 <= C2_in ^ iv[63:32];
      C3 <= C3_in ^ {iv[47:32], iv[15:0]};

      C4 <= C4_in ^ iv[31:0];
      C5 <= C5_in ^ {iv[63:48], iv[31:16]};
      C6 <= C6_in ^ iv[63:32];
      C7 <= C7_in ^ {iv[47:32], iv[15:0]};
    end
  end
endmodule
