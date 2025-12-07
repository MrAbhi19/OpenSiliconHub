// -----------------------------------------------------------------------------
// Module: xorshift256+ (Xorshift256+ Pseudo-Random Number Generator)
// Author: MrAbhi19
// Description:
//   This module implements the Xorshift256+ algorithm (Sebastiano Vigna).
//   It maintains a 256-bit internal state (four 64-bit words). On each
//   enabled clock, it evolves the state via XOR/shift operations and outputs
//   the sum of two state words (the '+' output function), improving statistical
//   quality versus bare xorshift.
//
// State update (one step):
//   let s = {s0, s1, s2, s3} be the 4x64-bit state.
//   result = s0 + s3;
//   t = s1 << 17;
//   s2 ^= s0;  s3 ^= s1;  s1 ^= s2;  s0 ^= s3;
//   s2 ^= t;
//   s3 = rotl(s3, 45);
//   output 'result'.
//
// Ports:
//   clk   - Input clock.
//   rst   - Asynchronous reset.
//   en    - Enable step.
//   seed  - 256-bit seed (must be non-zero overall).
//   out   - 64-bit pseudo-random output.
//
// Notes:
//   - Not cryptographically secure. Do not use for security-sensitive purposes.
//   - Ensure the seed is not all zeros; otherwise the generator stalls.
//   - Period is 2^256 - 1.
// -----------------------------------------------------------------------------

module xorshift256_plus (
  input         clk,               // Clock input
  input         rst,               // Asynchronous reset
  input         en,                // Enable step
  input  [255:0] seed,             // 256-bit seed: {s3,s2,s1,s0}
  output reg [63:0] out            // 64-bit output
);

  // Four 64-bit state registers (total 256 bits)
  reg [63:0] s0, s1, s2, s3;

  // Rotate-left function for 64-bit words
  function [63:0] rotl64;
    input [63:0] x;
    input [5:0]  k;                // rotation distance 0..63
    begin
      rotl64 = (x << k) | (x >> (64 - k));
    end
  endfunction

  // Sequential logic: reset or one xorshift256+ step per enabled cycle
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Initialize state from seed; user must ensure non-zero seed
      s0  <= seed[ 63:  0];
      s1  <= seed[127: 64];
      s2  <= seed[191:128];
      s3  <= seed[255:192];
      out <= 64'd0;
    end else if (en) begin
      // Compute result first (sum of two state words)
      // Using non-blocking assignments, capture s0+s3 into 'out' before state mutates
      out <= s0 + s3;

      // Xorshift core
      // Temporary left shift of s1 by 17 bits
      // Use blocking temporaries inside the cycle for clarity (but state updates remain non-blocking)
      // The sequence below follows Vigna's xorshift256+ reference.
      // We use intermediate wires to keep readability if desired, but here we use direct ops.

      // Perform the XOR cascade
      s2 <= s2 ^ s0;
      s3 <= s3 ^ s1;
      s1 <= s1 ^ s2;
      s0 <= s0 ^ s3;

      // Mix in shifted s1
      s2 <= (s2 ^ (s1 << 17));

      // Final rotation of s3 by 45 bits
      s3 <= rotl64(s3, 45);
    end
  end

endmodule
