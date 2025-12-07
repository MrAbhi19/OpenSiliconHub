// ============================================================================
// SplitMix64 Pseudo-Random Number Generator (PRNG)
// Author: MrAbhi19
// ----------------------------------------------------------------------------
// This module implements the SplitMix64 algorithm in hardware (Verilog).
// SplitMix64 is a fast, non-cryptographic PRNG widely used for seeding other
// generators (like xorshift or PCG). It produces 64-bit pseudo-random outputs
// with excellent statistical properties.
//
// Key design choices:
// 1. Increment constant: 0x9E3779B97F4A7C15
//    - Derived from the golden ratio scaled to 64 bits.
//    - Ensures the state cycles through the entire 64-bit space uniformly.
//    - Prevents short repeating cycles and distributes values evenly.
//
// 2. Multiplication constants:
//    - 0xBF58476D1CE4E5B9
//    - 0x94D049BB133111EB
//    - These are large odd numbers chosen empirically to maximize bit mixing.
//    - Multiplication by odd constants ensures invertibility modulo 2^64.
//    - They create avalanche effects: small changes in input produce large,
//      unpredictable changes in output.
//
// 3. XOR-shift steps:
//    - XOR with shifted versions of the state scrambles high/low bits.
//    - Combined with multiplication, this produces high-quality randomness.
//
// ----------------------------------------------------------------------------
// Limitations:
// - Not cryptographically secure (predictable if state is known).
// - Best used for simulations, randomized algorithms, or seeding other PRNGs.
// ============================================================================

module splitmix64 (
  input clk,              // Clock signal
  input rst,              // Reset signal (synchronous to clk)
  input en,               // Enable signal (generate new random number)
  input [63:0] data_in,   // Seed input (initial state)
  output reg [63:0] out   // Random number output
);

  reg [63:0] state;       // Internal state register
  reg [63:0] z;           // Temporary variable for mixing

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Initialize state with seed when reset is asserted
      state <= data_in;
      out   <= 64'd0;
    end else if (en) begin
      // Step 1: Increment state by golden ratio constant
      // This ensures the state moves through the entire 64-bit space.
      state <= state + 64'h9E3779B97F4A7C15;

      // Step 2: Apply mixing transformations
      z = state;
      z = (z ^ (z >> 30)) * 64'hBF58476D1CE4E5B9;  // First scramble
      z = (z ^ (z >> 27)) * 64'h94D049BB133111EB;  // Second scramble
      z = z ^ (z >> 31);                           // Final XOR shift

      // Step 3: Output the mixed value
      out <= z;
    end
  end
endmodule
