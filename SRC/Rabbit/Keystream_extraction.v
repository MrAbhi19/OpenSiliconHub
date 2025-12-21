// Rabbit cipher keystream generator
module keystream_generator (
    input  wire [31:0] x0,
    input  wire [31:0] x1,
    input  wire [31:0] x2,
    input  wire [31:0] x3,
    input  wire [31:0] x4,
    input  wire [31:0] x5,
    input  wire [31:0] x6,
    input  wire [31:0] x7,
    output wire [31:0] s0,
    output wire [31:0] s1,
    output wire [31:0] s2,
    output wire [31:0] s3
);

    // Each keystream word is derived by XORing one state word
    // with rotated versions of two others (Rabbit spec)
    assign s0 = x0 ^ (x5 >> 16) ^ (x3 << 16);
    assign s1 = x2 ^ (x7 >> 16) ^ (x5 << 16);
    assign s2 = x4 ^ (x1 >> 16) ^ (x7 << 16);
    assign s3 = x6 ^ (x3 >> 16) ^ (x1 << 16);

endmodule
