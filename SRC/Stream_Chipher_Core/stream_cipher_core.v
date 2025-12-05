module stream_cipher_core (
  input        clk,
  input        rst_n,

  input  [7:0] seed,       // secret key
  input        load,       // load seed
  
  input  [7:0] plaintext,  // user message byte
  input        valid_in,   // asserts plaintext is valid

  output reg [7:0] ciphertext,
  output reg        valid_out
);

  reg [7:0] lfsr;

  // Feedback taps for polynomial x^8 + x^6 + x^5 + x^4 + 1
  wire fb = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

  integer i;
  reg [7:0] temp;    // temporary LFSR state
  reg [7:0] ks;      // 8 keystream bits

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lfsr <= 8'h1;
      ciphertext <= 8'h00;
      valid_out <= 1'b0;

    end else if (load) begin
      lfsr <= seed; // load key

    end else if (valid_in) begin
      temp = lfsr;
      
      // generate 8 keystream bits
      for (i = 0; i < 8; i = i + 1) begin
        ks[i] = temp[0];  // LSB is keystream
        temp = {temp[6:0], (temp[7] ^ temp[5] ^ temp[4] ^ temp[3])};
      end

      ciphertext <= plaintext ^ ks;
      valid_out  <= 1'b1;

      lfsr <= temp; // update real register after generating 8 bits

    end else begin
      valid_out <= 1'b0;
    end
  end

endmodule
