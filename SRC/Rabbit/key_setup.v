module key_setup (
  input         clk,
  input         rst,
  input         load,
  input  [127:0] key,
  output reg [31:0] X0, X1, X2, X3, X4, X5, X6, X7,
  output reg [31:0] C0, C1, C2, C3, C4, C5, C6, C7,
  output reg        carry
);

  wire [15:0] K0 = key[15:0];
  wire [15:0] K1 = key[31:16];
  wire [15:0] K2 = key[47:32];
  wire [15:0] K3 = key[63:48];
  wire [15:0] K4 = key[79:64];
  wire [15:0] K5 = key[95:80];
  wire [15:0] K6 = key[111:96];
  wire [15:0] K7 = key[127:112];

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      carry <= 1'b0;
    end else if (load) begin
      carry <= 1'b0;

      // j = 0 (even)
      X0 <= {K1, K0};
      C0 <= {K4, K5};

      // j = 1 (odd)
      X1 <= {K6, K5};
      C1 <= {K1, K2};

      // j = 2 (even)
      X2 <= {K3, K2};
      C2 <= {K6, K7};

      // j = 3 (odd)
      X3 <= {K0, K7};
      C3 <= {K3, K4};

      // j = 4 (even)
      X4 <= {K5, K4};
      C4 <= {K0, K1};

      // j = 5 (odd)
      X5 <= {K2, K1};
      C5 <= {K5, K6};

      // j = 6 (even)
      X6 <= {K7, K6};
      C6 <= {K2, K3};

      // j = 7 (odd)
      X7 <= {K4, K3};
      C7 <= {K7, K0};
    end
  end
endmodule
