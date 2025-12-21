// Rabbit cipher state update block
module state_update (
    input  wire [31:0] g0,
    input  wire [31:0] g1,
    input  wire [31:0] g2,
    input  wire [31:0] g3,
    input  wire [31:0] g4,
    input  wire [31:0] g5,
    input  wire [31:0] g6,
    input  wire [31:0] g7,
    output wire [31:0] x0_next,
    output wire [31:0] x1_next,
    output wire [31:0] x2_next,
    output wire [31:0] x3_next,
    output wire [31:0] x4_next,
    output wire [31:0] x5_next,
    output wire [31:0] x6_next,
    output wire [31:0] x7_next
);

    // Each new state word is a sum of g-function outputs with rotations
    assign x0_next = g0 + {g7[15:0], g7[31:16]} + {g6[15:0], g6[31:16]};
    assign x1_next = g1 + {g0[15:0], g0[31:16]} + {g7[15:0], g7[31:16]};
    assign x2_next = g2 + {g1[15:0], g1[31:16]} + {g0[15:0], g0[31:16]};
    assign x3_next = g3 + {g2[15:0], g2[31:16]} + {g1[15:0], g1[31:16]};
    assign x4_next = g4 + {g3[15:0], g3[31:16]} + {g2[15:0], g2[31:16]};
    assign x5_next = g5 + {g4[15:0], g4[31:16]} + {g3[15:0], g3[31:16]};
    assign x6_next = g6 + {g5[15:0], g5[31:16]} + {g4[15:0], g4[31:16]};
    assign x7_next = g7 + {g6[15:0], g6[31:16]} + {g5[15:0], g5[31:16]};

endmodule
