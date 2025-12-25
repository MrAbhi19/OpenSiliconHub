module rabbit_keystream (
  input          clk,
  input          rst, 
  input          en,
  input  [127:0] key,
  input  [63:0]  nonce,
  output reg     done,
  output reg [127:0] keystream
);

  // State and counter registers
  reg  [255:0] state;
  reg  [255:0] counter_reg;
  reg          carry;

  // Derive initial state words from key
  function [255:0] make_subkeys;
    input [127:0] key_in;
    begin
      make_subkeys[31:0]    = {key_in[31:16]  , key_in[15:0]};        // X0 = K1 || K0
      make_subkeys[63:32]   = {key_in[111:96] , key_in[95:80]};       // X1 = K6 || K5
      make_subkeys[95:64]   = {key_in[63:48]  , key_in[47:32]};       // X2 = K3 || K2
      make_subkeys[127:96]  = {key_in[15:0]   , key_in[127:112]};     // X3 = K0 || K7
      make_subkeys[159:128] = {key_in[95:80]  , key_in[79:64]};       // X4 = K5 || K4
      make_subkeys[191:160] = {key_in[47:32]  , key_in[31:16]};       // X5 = K2 || K1
      make_subkeys[223:192] = {key_in[127:112], key_in[111:96]};      // X6 = K7 || K6
      make_subkeys[255:224] = {key_in[79:64]  , key_in[63:48]};       // X7 = K4 || K3
    end
  endfunction

  // Derive initial counters from key
  function [255:0] make_counter;
    input [127:0] key_in;
    begin
      make_counter[31:0]    = {key_in[79:64] , key_in[95:80]};        // C0 = K4 || K5
      make_counter[63:32]   = {key_in[31:16] , key_in[47:32]};        // C1 = K1 || K2
      make_counter[95:64]   = {key_in[111:96], key_in[127:112]};      // C2 = K6 || K7
      make_counter[127:96]  = {key_in[47:32] , key_in[63:48]};        // C3 = K3 || K4
      make_counter[159:128] = {key_in[15:0]  , key_in[31:16]};        // C4 = K0 || K1
      make_counter[191:160] = {key_in[95:80] , key_in[111:96]};       // C5 = K5 || K6
      make_counter[223:192] = {key_in[47:32] , key_in[63:48]};        // C6 = K2 || K3
      make_counter[255:224] = {key_in[127:112], key_in[15:0]};        // C7 = K7 || K0
    end
  endfunction

  // Apply IV to counters (nonce mixing)
  function [255:0] make_iv;
    input [255:0] ctr_in;
    input [63:0]  IV;   // 64-bit IV/nonce
    begin
      make_iv[31:0]    = ctr_in[31:0]    ^ IV[31:0];                       // C0
      make_iv[63:32]   = ctr_in[63:32]   ^ {IV[63:48], IV[31:16]};          // C1
      make_iv[95:64]   = ctr_in[95:64]   ^ IV[63:32];                       // C2
      make_iv[127:96]  = ctr_in[127:96]  ^ {IV[47:32], IV[15:0]};           // C3
      make_iv[159:128] = ctr_in[159:128] ^ IV[31:0];                        // C4
      make_iv[191:160] = ctr_in[191:160] ^ {IV[63:48], IV[31:16]};          // C5
      make_iv[223:192] = ctr_in[223:192] ^ IV[63:32];                       // C6
      make_iv[255:224] = ctr_in[255:224] ^ {IV[47:32], IV[15:0]};           // C7
    end
  endfunction

  // Rotate left 32-bit
  function [31:0] rotl32;
    input [31:0] x;   // input word
    input [4:0]  n;   // rotation amount (0–31)
    begin
      rotl32 = (x << n) | (x >> (32 - n));
    end
  endfunction

  // g-function
  function [31:0] g_func;
    input [31:0] u;
    input [31:0] v;
    reg   [63:0] temp;
    begin
      temp   = (u + v) * (u + v);             // square the sum
      g_func = temp[31:0] ^ temp[63:32];      // XOR low and high halves
    end
  endfunction

  // Next-state update from g-function outputs
  function [255:0] make_next_state;
    input [255:0] st_in;   // interface consistency (unused in arithmetic here)
    input [255:0] g_in;    // 8 x 32-bit g-function outputs
    begin
      make_next_state[31:0]    = g_in[31:0]    + rotl32(g_in[255:224],16) + rotl32(g_in[223:192],16);
      make_next_state[63:32]   = g_in[63:32]   + rotl32(g_in[31:0],8)     + g_in[255:224];
      make_next_state[95:64]   = g_in[95:64]   + rotl32(g_in[63:32],16)   + rotl32(g_in[31:0],16);
      make_next_state[127:96]  = g_in[127:96]  + rotl32(g_in[95:64],8)    + g_in[63:32];
      make_next_state[159:128] = g_in[159:128] + rotl32(g_in[127:96],16)  + rotl32(g_in[95:64],16);
      make_next_state[191:160] = g_in[191:160] + rotl32(g_in[159:128],8)  + g_in[127:96];
      make_next_state[223:192] = g_in[223:192] + rotl32(g_in[191:160],16) + rotl32(g_in[159:128],16);
      make_next_state[255:224] = g_in[255:224] + rotl32(g_in[223:192],8)  + g_in[191:160];
    end
  endfunction

  // Keystream extraction
  function [127:0] make_extraction;
    input [255:0] ns_in; // 8 x 32-bit words (X0..X7)
    begin
      make_extraction[15:0]    = ns_in[15:0]    ^ ns_in[175:160];  // X0[15:0] ^ X5[31:16]
      make_extraction[31:16]   = ns_in[31:16]   ^ ns_in[111:96];   // X0[31:16] ^ X3[15:0]
      make_extraction[47:32]   = ns_in[79:64]   ^ ns_in[239:224];  // X2[15:0] ^ X7[31:16]
      make_extraction[63:48]   = ns_in[95:80]   ^ ns_in[159:144];  // X2[31:16] ^ X5[15:0]
      make_extraction[79:64]   = ns_in[143:128] ^ ns_in[47:32];    // X4[15:0] ^ X1[31:16]
      make_extraction[95:80]   = ns_in[159:144] ^ ns_in[223:208];  // X4[31:16] ^ X7[15:0]
      make_extraction[111:96]  = ns_in[207:192] ^ ns_in[127:112];  // X6[15:0] ^ X3[31:16]
      make_extraction[127:112] = ns_in[223:208] ^ ns_in[63:48];    // X6[31:16] ^ X1[15:0]
    end
  endfunction

  // Reinit counter mixing
  function [255:0] apply_reinit;
    input          done_in;        // apply reinit only when done=1
    input  [255:0] ctr_in;         // counters C0..C7
    input  [255:0] ns_in;          // state words X0..X7
    begin
      if (done_in) begin
        apply_reinit[31:0]    = ctr_in[31:0]    ^ ns_in[159:128]; // C0 ^ X4
        apply_reinit[63:32]   = ctr_in[63:32]   ^ ns_in[191:160]; // C1 ^ X5
        apply_reinit[95:64]   = ctr_in[95:64]   ^ ns_in[223:192]; // C2 ^ X6
        apply_reinit[127:96]  = ctr_in[127:96]  ^ ns_in[255:224]; // C3 ^ X7
        apply_reinit[159:128] = ctr_in[159:128] ^ ns_in[31:0];    // C4 ^ X0
        apply_reinit[191:160] = ctr_in[191:160] ^ ns_in[63:32];   // C5 ^ X1
        apply_reinit[223:192] = ctr_in[223:192] ^ ns_in[95:64];   // C6 ^ X2
        apply_reinit[255:224] = ctr_in[255:224] ^ ns_in[127:96];  // C7 ^ X3
      end else begin
        apply_reinit = ctr_in; // pass through
      end
    end
  endfunction

  rabbit_counter_update counter_update_inst (
    .clk(clk),
    .rst_n(rst_n),
    .counter_in(counter_reg),
    .carry_in(carry_reg),
    .counter_out(counter_next),
    .carry_out(carry_next)
  );


  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state     <= 256'b0;
      counter_reg <= 256'b0;
      carry     <= 1'b0;
      keystream <= 128'b0;
      done      <= 1'b0;
    end else if (en) begin
      state       <= make_subkeys(key);
      counter_reg <= make_iv(make_counter(key), nonce);
      
      // Placeholder: compute g[], next_state, extraction, reinit, etc.
      // You will add your pipeline/iteration here and assert done appropriately.
      done        <= 1'b0;  // keep low until iteration completes
    end
  end

endmodule
