// Rabbit cipher g-function as a module
module G_function (
    input  wire [31:0] counter,
    input  wire [31:0] state,
    output wire [31:0] g_out
);

    // Intermediate signals
    wire [31:0] u;
    wire [63:0] square;

    // Compute u = counter + state
    assign u = counter + state;

    // Square u (64-bit result)
    assign square = u * u;

    // XOR upper and lower halves
    assign g_out = square[63:32] ^ square[31:0];

endmodule
