module rabbit_top (
    input         clk,
    input         rst,
    input         load,
    input         en,
    input  [127:0] key,
    input  [63:0]  iv,
    output [127:0] keystream,
    output        ready
);

  // ------------------------------------------------------------
  // Internal state
  // ------------------------------------------------------------
  reg [31:0] X [0:7];
  reg [31:0] C [0:7];
  reg        carry;

  // FSM
  reg [2:0] state;
  reg [2:0] iter;

  localparam IDLE      = 3'd0,
             KEY_ITER  = 3'd1,
             KEY_XOR   = 3'd2,
             IV_XOR    = 3'd3,
             IV_ITER   = 3'd4,
             RUN       = 3'd5;

  assign ready = (state == RUN);

  // ------------------------------------------------------------
  // Submodules
  // ------------------------------------------------------------
  wire [31:0] C_next [0:7];
  wire        carry_next;

  counter ctr (
    C[0], C[1], C[2], C[3],
    C[4], C[5], C[6], C[7],
    carry,
    C_next[0], C_next[1], C_next[2], C_next[3],
    C_next[4], C_next[5], C_next[6], C_next[7],
    carry_next
  );

  wire [31:0] X_next [0:7];

  state_update su (
    X[0], X[1], X[2], X[3],
    X[4], X[5], X[6], X[7],
    C_next[0], C_next[1], C_next[2], C_next[3],
    C_next[4], C_next[5], C_next[6], C_next[7],
    X_next[0], X_next[1], X_next[2], X_next[3],
    X_next[4], X_next[5], X_next[6], X_next[7]
  );

  keystream_extraction ks (
    X[0], X[1], X[2], X[3],
    X[4], X[5], X[6], X[7],
    keystream
  );

  // ------------------------------------------------------------
  // Sequential control
  // ------------------------------------------------------------
  integer i;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      iter  <= 0;
      carry <= 0;
    end else begin

      case (state)

        // ------------------------------------------------------
        IDLE: begin
          if (load) begin
            // Key expansion (RFC §2.2)
            X[0] <= {key[31:16],  key[15:0]};
            X[1] <= {key[79:64],  key[63:48]};
            X[2] <= {key[47:32],  key[31:16]};
            X[3] <= {key[15:0],   key[127:112]};
            X[4] <= {key[95:80],  key[79:64]};
            X[5] <= {key[63:48],  key[47:32]};
            X[6] <= {key[127:112],key[111:96]};
            X[7] <= {key[111:96], key[95:80]};

            C[0] <= {key[95:80],  key[111:96]};
            C[1] <= {key[31:16],  key[47:32]};
            C[2] <= {key[127:112],key[15:0]};
            C[3] <= {key[63:48],  key[79:64]};
            C[4] <= {key[15:0],   key[31:16]};
            C[5] <= {key[111:96], key[127:112]};
            C[6] <= {key[47:32],  key[63:48]};
            C[7] <= {key[79:64],  key[95:80]};

            carry <= 0;
            iter  <= 0;
            state <= KEY_ITER;
          end
        end

        // ------------------------------------------------------
        KEY_ITER, IV_ITER, RUN: begin
          if (en) begin
            for (i=0;i<8;i=i+1) begin
              X[i] <= X_next[i];
              C[i] <= C_next[i];
            end
            carry <= carry_next;
            iter  <= iter + 1;

            if ((state == KEY_ITER || state == IV_ITER) && iter == 3) begin
              iter  <= 0;
              state <= (state == KEY_ITER) ? KEY_XOR :
                       (state == IV_ITER)  ? RUN     : state;
            end
          end
        end

        // ------------------------------------------------------
        KEY_XOR: begin
          C[0] <= C[0] ^ X[4];
          C[1] <= C[1] ^ X[5];
          C[2] <= C[2] ^ X[6];
          C[3] <= C[3] ^ X[7];
          C[4] <= C[4] ^ X[0];
          C[5] <= C[5] ^ X[1];
          C[6] <= C[6] ^ X[2];
          C[7] <= C[7] ^ X[3];
          state <= IV_XOR;
        end

        // ------------------------------------------------------
        IV_XOR: begin
          C[0] <= C[0] ^ iv[31:0];
          C[1] <= C[1] ^ {iv[63:48], iv[31:16]};
          C[2] <= C[2] ^ iv[63:32];
          C[3] <= C[3] ^ {iv[47:32], iv[15:0]};
          C[4] <= C[4] ^ iv[31:0];
          C[5] <= C[5] ^ {iv[63:48], iv[31:16]};
          C[6] <= C[6] ^ iv[63:32];
          C[7] <= C[7] ^ {iv[47:32], iv[15:0]};
          state <= IV_ITER;
        end

      endcase
    end
  end

endmodule
