module counter_update (
  input         clk,
  input         rst,
  input         en,
  input         carry_in,
  input  [31:0] C0_in, C1_in, C2_in, C3_in,
                C4_in, C5_in, C6_in, C7_in,
  output reg    carry_out,
  output reg [31:0] C0, C1, C2, C3, C4, C5, C6, C7
);

  reg [32:0] sum;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      carry_out <= 1'b0;
    end else if (en) begin
      sum = C0_in + 32'h4D34D34D + carry_in;
      C0 <= sum[31:0];
      carry_out <= sum[32];

      sum = C1_in + 32'hD34D34D3 + carry_out;
      C1 <= sum[31:0];
      carry_out <= sum[32];

      sum = C2_in + 32'h34D34D34 + carry_out;
      C2 <= sum[31:0];
      carry_out <= sum[32];

      sum = C3_in + 32'h4D34D34D + carry_out;
      C3 <= sum[31:0];
      carry_out <= sum[32];

      sum = C4_in + 32'hD34D34D3 + carry_out;
      C4 <= sum[31:0];
      carry_out <= sum[32];

      sum = C5_in + 32'h34D34D34 + carry_out;
      C5 <= sum[31:0];
      carry_out <= sum[32];

      sum = C6_in + 32'h4D34D34D + carry_out;
      C6 <= sum[31:0];
      carry_out <= sum[32];

      sum = C7_in + 32'hD34D34D3 + carry_out;
      C7 <= sum[31:0];
      carry_out <= sum[32];
    end
  end
endmodule
