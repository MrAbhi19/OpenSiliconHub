module rabbit_counter_update (
  input         clk,
  input         rst_n,        // active-low reset
  input  [255:0] counter_in,  // 8 x 32-bit counters (C0..C7)
  input          carry_in,    // carry bit b from previous iteration
  output reg [255:0] counter_out,
  output reg        carry_out
);

  // Constants A0..A7
  parameter A0 = 32'h4D34D34D;
  parameter A1 = 32'hD34D34D3;
  parameter A2 = 32'h34D34D34;
  parameter A3 = 32'h4D34D34D;
  parameter A4 = 32'hD34D34D3;
  parameter A5 = 32'h34D34D34;
  parameter A6 = 32'h4D34D34D;
  parameter A7 = 32'hD34D34D3;

  // Internal registers
  reg [31:0] C0, C1, C2, C3, C4, C5, C6, C7;
  reg [32:0] temp;
  reg        b;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset counters and carry
      counter_out <= 256'b0;
      carry_out   <= 1'b0;
    end else begin
      // unpack input counters
      C0 = counter_in[31:0];
      C1 = counter_in[63:32];
      C2 = counter_in[95:64];
      C3 = counter_in[127:96];
      C4 = counter_in[159:128];
      C5 = counter_in[191:160];
      C6 = counter_in[223:192];
      C7 = counter_in[255:224];

      b = carry_in;

      // sequential update loop
      temp = C0 + A0 + b; b = temp[32]; C0 = temp[31:0];
      temp = C1 + A1 + b; b = temp[32]; C1 = temp[31:0];
      temp = C2 + A2 + b; b = temp[32]; C2 = temp[31:0];
      temp = C3 + A3 + b; b = temp[32]; C3 = temp[31:0];
      temp = C4 + A4 + b; b = temp[32]; C4 = temp[31:0];
      temp = C5 + A5 + b; b = temp[32]; C5 = temp[31:0];
      temp = C6 + A6 + b; b = temp[32]; C6 = temp[31:0];
      temp = C7 + A7 + b; b = temp[32]; C7 = temp[31:0];

      // pack back
      counter_out <= {C7, C6, C5, C4, C3, C2, C1, C0};
      carry_out   <= b;
    end
  end

endmodule
