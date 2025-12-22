module state_update (
  input         clk,
  input         rst,
  input         en,
  input  [31:0] X0_in, X1_in, X2_in, X3_in,
                X4_in, X5_in, X6_in, X7_in,
  input  [31:0] C0, C1, C2, C3, C4, C5, C6, C7,
  output reg [31:0] X0, X1, X2, X3, X4, X5, X6, X7
);

  wire [31:0] G0, G1, G2, G3, G4, G5, G6, G7;

  g_function g0(X0_in, C0, G0);
  g_function g1(X1_in, C1, G1);
  g_function g2(X2_in, C2, G2);
  g_function g3(X3_in, C3, G3);
  g_function g4(X4_in, C4, G4);
  g_function g5(X5_in, C5, G5);
  g_function g6(X6_in, C6, G6);
  g_function g7(X7_in, C7, G7);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
    end else if (en) begin
      X0 <= G0 + {G7[15:0], G7[31:16]} + {G6[15:0], G6[31:16]};
      X1 <= G1 + {G0[23:0], G0[31:24]} + G7;
      X2 <= G2 + {G1[15:0], G1[31:16]} + {G0[15:0], G0[31:16]};
      X3 <= G3 + {G2[23:0], G2[31:24]} + G1;
      X4 <= G4 + {G3[15:0], G3[31:16]} + {G2[15:0], G2[31:16]};
      X5 <= G5 + {G4[23:0], G4[31:24]} + G3;
      X6 <= G6 + {G5[15:0], G5[31:16]} + {G4[15:0], G4[31:16]};
      X7 <= G7 + {G6[23:0], G6[31:24]} + G5;
    end
  end
endmodule
