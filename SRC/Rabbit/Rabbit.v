module rabbit_top (
  input         clk,
  input         rst,
  input         load,     // load key and start key setup
  input         en,       // advance cipher
  input  [127:0] key,
  output [127:0] keystream,
  output        ready     // high when key setup is complete
);

  // ------------------------------------------------------------
  // Internal state registers
  // ------------------------------------------------------------
  reg [31:0] X0, X1, X2, X3, X4, X5, X6, X7;
  reg [31:0] C0, C1, C2, C3, C4, C5, C6, C7;
  reg        carry;

  // ------------------------------------------------------------
  // Wires between modules
  // ------------------------------------------------------------
  wire [31:0] X0_k, X1_k, X2_k, X3_k, X4_k, X5_k, X6_k, X7_k;
  wire [31:0] C0_k, C1_k, C2_k, C3_k, C4_k, C5_k, C6_k, C7_k;
  wire        carry_k;

  wire [31:0] C0_n, C1_n, C2_n, C3_n, C4_n, C5_n, C6_n, C7_n;
  wire        carry_n;

  wire [31:0] X0_n, X1_n, X2_n, X3_n, X4_n, X5_n, X6_n, X7_n;

  // ------------------------------------------------------------
  // Control
  // ------------------------------------------------------------
  reg [2:0] iter;
  reg       ready_r;

  assign ready = ready_r;

  // ------------------------------------------------------------
  // Key setup
  // ------------------------------------------------------------
  key_setup KS (
    .clk(clk),
    .rst(rst),
    .load(load),
    .key(key),
    .X0(X0_k), .X1(X1_k), .X2(X2_k), .X3(X3_k),
    .X4(X4_k), .X5(X5_k), .X6(X6_k), .X7(X7_k),
    .C0(C0_k), .C1(C1_k), .C2(C2_k), .C3(C3_k),
    .C4(C4_k), .C5(C5_k), .C6(C6_k), .C7(C7_k),
    .carry(carry_k)
  );

  // ------------------------------------------------------------
  // Counter update
  // ------------------------------------------------------------
  counter_update CU (
    .clk(clk),
    .rst(rst),
    .en(en),
    .carry_in(carry),
    .C0_in(C0), .C1_in(C1), .C2_in(C2), .C3_in(C3),
    .C4_in(C4), .C5_in(C5), .C6_in(C6), .C7_in(C7),
    .carry_out(carry_n),
    .C0(C0_n), .C1(C1_n), .C2(C2_n), .C3(C3_n),
    .C4(C4_n), .C5(C5_n), .C6(C6_n), .C7(C7_n)
  );

  // ------------------------------------------------------------
  // State update
  // ------------------------------------------------------------
  state_update SU (
    .clk(clk),
    .rst(rst),
    .en(en),
    .X0_in(X0), .X1_in(X1), .X2_in(X2), .X3_in(X3),
    .X4_in(X4), .X5_in(X5), .X6_in(X6), .X7_in(X7),
    .C0(C0_n), .C1(C1_n), .C2(C2_n), .C3(C3_n),
    .C4(C4_n), .C5(C5_n), .C6(C6_n), .C7(C7_n),
    .X0(X0_n), .X1(X1_n), .X2(X2_n), .X3(X3_n),
    .X4(X4_n), .X5(X5_n), .X6(X6_n), .X7(X7_n)
  );

  // ------------------------------------------------------------
  // Keystream extraction
  // ------------------------------------------------------------
  keystream_extract KE (
    .X0(X0), .X1(X1), .X2(X2), .X3(X3),
    .X4(X4), .X5(X5), .X6(X6), .X7(X7),
    .S(keystream)
  );

  // ------------------------------------------------------------
  // Sequential control and state registers
  // ------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      iter    <= 3'd0;
      ready_r <= 1'b0;
      carry   <= 1'b0;
    end else begin

      // Load key
      if (load) begin
        X0 <= X0_k; X1 <= X1_k; X2 <= X2_k; X3 <= X3_k;
        X4 <= X4_k; X5 <= X5_k; X6 <= X6_k; X7 <= X7_k;

        C0 <= C0_k; C1 <= C1_k; C2 <= C2_k; C3 <= C3_k;
        C4 <= C4_k; C5 <= C5_k; C6 <= C6_k; C7 <= C7_k;

        carry   <= carry_k;
        iter    <= 3'd0;
        ready_r <= 1'b0;
      end

      // Key setup iterations
      else if (en && !ready_r) begin
        X0 <= X0_n; X1 <= X1_n; X2 <= X2_n; X3 <= X3_n;
        X4 <= X4_n; X5 <= X5_n; X6 <= X6_n; X7 <= X7_n;

        C0 <= C0_n; C1 <= C1_n; C2 <= C2_n; C3 <= C3_n;
        C4 <= C4_n; C5 <= C5_n; C6 <= C6_n; C7 <= C7_n;

        carry <= carry_n;
        iter  <= iter + 3'd1;

        // After 4 iterations: counter reinitialization
        if (iter == 3'd3) begin
          C0 <= C0_n ^ X4;
          C1 <= C1_n ^ X5;
          C2 <= C2_n ^ X6;
          C3 <= C3_n ^ X7;
          C4 <= C4_n ^ X0;
          C5 <= C5_n ^ X1;
          C6 <= C6_n ^ X2;
          C7 <= C7_n ^ X3;

          ready_r <= 1'b1;
        end
      end

      // Normal keystream generation
      else if (en && ready_r) begin
        X0 <= X0_n; X1 <= X1_n; X2 <= X2_n; X3 <= X3_n;
        X4 <= X4_n; X5 <= X5_n; X6 <= X6_n; X7 <= X7_n;

        C0 <= C0_n; C1 <= C1_n; C2 <= C2_n; C3 <= C3_n;
        C4 <= C4_n; C5 <= C5_n; C6 <= C6_n; C7 <= C7_n;

        carry <= carry_n;
      end
    end
  end

endmodule
