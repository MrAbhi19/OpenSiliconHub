module Multiplier #(
  parameter WIDTH_A = 4,
  parameter WIDTH_B = 6,
  parameter DELAY   = 5   // number of pipeline stages
)(
  input                        clk,
  input  [WIDTH_A-1:0]        in1,
  input  [WIDTH_B-1:0]        in2,
  output [WIDTH_A+WIDTH_B-1:0] out
);

  // Raw product
  wire [WIDTH_A+WIDTH_B-1:0] mult_raw = in1 * in2;

  // Pipeline registers
  reg [WIDTH_A+WIDTH_B-1:0] pipe_reg [0:DELAY-1];

  integer i;

  always @(posedge clk) begin
    pipe_reg[0] <= mult_raw;
    for (i = 1; i < DELAY; i = i + 1) begin
      pipe_reg[i] <= pipe_reg[i-1];
    end
  end

  assign out = pipe_reg[DELAY-1];

endmodule
