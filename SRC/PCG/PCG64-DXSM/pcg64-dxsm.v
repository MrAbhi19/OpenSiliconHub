// ============================================================================
// PCG64-DXSM Pseudo-Random Number Generator
// Author: MrAbhi19
// ----------------------------------------------------------------------------
// Methodology:
// - Uses a 128-bit Linear Congruential Generator (LCG) for state update.
// - Each cycle: state = state * multiplier + increment (mod 2^128).
// - Output permutation DXSM (Double XOR Shift Multiply) is applied to the
//   high 64 bits of the state to produce the final 64-bit random number.
// - DXSM improves statistical quality by scrambling bits with XOR-shifts
//   and multiplications by carefully chosen odd constants.
// ----------------------------------------------------------------------------
// Limitations:
// - Not cryptographically secure.
// - Best suited for simulations, Monte Carlo methods, and scientific computing.
// ============================================================================

module pcg_dxsm (
  input clk,
  input rst,
  input en,
  input [127:0] data_in,   // Seed input
  output reg [63:0] out    // Random number output
);

  reg [127:0] state;       // 128-bit internal state
  reg [63:0] state1;       // High 64 bits of state
  reg [63:0] z;

  // Constants for LCG
  localparam [127:0] MULT = 128'h2360ED051FC65DA44385DF649FCCF645; // PCG64 multiplier
  localparam [127:0] INC  = 128'h5851F42D4C957F2D14057B7EF767814F; // PCG64 increment

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Initialize state with seed
      state <= data_in;
      out   <= 64'd0;
    end else if (en) begin
      // Step 1: Advance state using LCG
      state <= state * MULT + INC;

      // Step 2: Extract high 64 bits
      state1 <= state[127:64];

      // Step 3: Apply DXSM permutation
      // DXSM: Double XOR Shift Multiply
      // Scrambles state1 with XOR-shifts and multiplications
      z = state1;
      z = (z ^ (z >> 32)) * 64'h9E3779B97F4A7C15; // First scramble
      z = (z ^ (z >> 29)) * 64'hBF58476D1CE4E5B9; // Second scramble
      z = z ^ (z >> 32);                          // Final XOR shift

      // Step 4: Output result
      out <= z;
    end
  end
endmodule
