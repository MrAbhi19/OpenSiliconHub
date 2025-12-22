// Top-level Rabbit keystream generator (pure Verilog-2001, finalized)
module rabbit(
  input         clk,
  input         rst,
  input         en,
  input         load,           // load initial key/IV state
  input  [127:0] key,
  input  [63:0]  IV,
  output [127:0] out,
  output        done
);

  // Expand 128-bit key into 8 × 32-bit words (keep as wires)
  wire [31:0] W0, W1, W2, W3, W4, W5, W6, W7;
  assign W0 = {key[15:0],  key[63:48]};
  assign W1 = {key[47:32], key[95:80]};
  assign W2 = {key[79:64], key[111:96]};
  assign W3 = {key[111:96], key[127:112]};
  assign W4 = {key[31:16], key[79:64]};
  assign W5 = {key[63:48], key[111:96]};
  assign W6 = {key[95:80], key[15:0]};
  assign W7 = {key[127:112], key[47:32]};

  // Counter chain signals
  wire [31:0] C0, C1, C2, C3, C4, C5, C6, C7;
  wire        carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7;

  // Initial counter values (key schedule + IV mixing per current design)
  wire [31:0] init_C0 = {W4[31:16], W4[15:0]} ^ {16'd0, IV[15:0]};
  wire [31:0] init_C1 = {W5[31:16], W5[15:0]} ^ {16'd0, IV[31:16]};
  wire [31:0] init_C2 = {W6[31:16], W6[15:0]} ^ {16'd0, IV[47:32]};
  wire [31:0] init_C3 = {W7[31:16], W7[15:0]} ^ {16'd0, IV[63:48]};
  wire [31:0] init_C4 = W0;
  wire [31:0] init_C5 = W1;
  wire [31:0] init_C6 = W2;
  wire [31:0] init_C7 = W3;

  // Instantiate 8 counters with distinct constants (A0..A7)
  // Pattern: 4D34D34D, D34D34D3, 34D34D34 repeating
  counter #(.A(32'h4D34D34D)) c0(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C0), .carry_in(1'b0),
    .c(C0), .carry_out(carry0)
  );

  counter #(.A(32'hD34D34D3)) c1(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C1), .carry_in(carry0),
    .c(C1), .carry_out(carry1)
  );

  counter #(.A(32'h34D34D34)) c2(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C2), .carry_in(carry1),
    .c(C2), .carry_out(carry2)
  );

  counter #(.A(32'h4D34D34D)) c3(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C3), .carry_in(carry2),
    .c(C3), .carry_out(carry3)
  );

  counter #(.A(32'hD34D34D3)) c4(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C4), .carry_in(carry3),
    .c(C4), .carry_out(carry4)
  );

  counter #(.A(32'h34D34D34)) c5(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C5), .carry_in(carry4),
    .c(C5), .carry_out(carry5)
  );

  counter #(.A(32'h4D34D34D)) c6(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C6), .carry_in(carry5),
    .c(C6), .carry_out(carry6)
  );

  counter #(.A(32'hD34D34D3)) c7(
    .clk(clk), .rst(rst), .en(en), .load(load),
    .init_val(init_C7), .carry_in(carry6),
    .c(C7), .carry_out(carry7)
  );

  // State registers (X0–X7)
  reg [31:0] X0, X1, X2, X3, X4, X5, X6, X7;

  // G-function outputs
  wire [31:0] g0, g1, g2, g3, g4, g5, g6, g7;

  // Instantiate 8 g-functions
  G_function g_inst0(.counter(C0), .state(X0), .g_out(g0));
  G_function g_inst1(.counter(C1), .state(X1), .g_out(g1));
  G_function g_inst2(.counter(C2), .state(X2), .g_out(g2));
  G_function g_inst3(.counter(C3), .state(X3), .g_out(g3));
  G_function g_inst4(.counter(C4), .state(X4), .g_out(g4));
  G_function g_inst5(.counter(C5), .state(X5), .g_out(g5));
  G_function g_inst6(.counter(C6), .state(X6), .g_out(g6));
  G_function g_inst7(.counter(C7), .state(X7), .g_out(g7));

  // Next-state wires from state_update
  wire [31:0] X0_next, X1_next, X2_next, X3_next;
  wire [31:0] X4_next, X5_next, X6_next, X7_next;

  // Instantiate the state_update block
  state_update u_state_update (
    .g0(g0), .g1(g1), .g2(g2), .g3(g3),
    .g4(g4), .g5(g5), .g6(g6), .g7(g7),
    .x0_next(X0_next), .x1_next(X1_next),
    .x2_next(X2_next), .x3_next(X3_next),
    .x4_next(X4_next), .x5_next(X5_next),
    .x6_next(X6_next), .x7_next(X7_next)
  );

  // State register update
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Initialize from key schedule
      X0 <= W0; X1 <= W1; X2 <= W2; X3 <= W3;
      X4 <= W4; X5 <= W5; X6 <= W6; X7 <= W7;
    end else if (load) begin
      // Reinitialize (counters already mix IV on load)
      X0 <= W0; X1 <= W1; X2 <= W2; X3 <= W3;
      X4 <= W4; X5 <= W5; X6 <= W6; X7 <= W7;
    end else if (en) begin
      // Advance the Rabbit state
      X0 <= X0_next; X1 <= X1_next;
      X2 <= X2_next; X3 <= X3_next;
      X4 <= X4_next; X5 <= X5_next;
      X6 <= X6_next; X7 <= X7_next;
    end
  end

  // Keystream words via dedicated module
  wire [31:0] S0, S1, S2, S3;
  keystream_generator u_keystream (
    .x0(X0), .x1(X1), .x2(X2), .x3(X3),
    .x4(X4), .x5(X5), .x6(X6), .x7(X7),
    .s0(S0), .s1(S1), .s2(S2), .s3(S3)
  );

  // Warm-up iteration counter for done signal (assert after 4 iterations)
  reg [2:0] init_count;
  reg       done_reg;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      init_count <= 3'd0;
      done_reg   <= 1'b0;
    end else if (load) begin
      init_count <= 3'd0;
      done_reg   <= 1'b0;
    end else if (en && !done_reg) begin
      if (init_count == 3'd3) begin
        done_reg <= 1'b1;  // after 4 iterations (0,1,2,3)
      end else begin
        init_count <= init_count + 1'b1;
      end
    end
  end
  assign done = done_reg;

  // Concatenate to 128-bit output, gated until initialization done
  assign out = done ? {S0, S1, S2, S3} : 128'd0;

endmodule
