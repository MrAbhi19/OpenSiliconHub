module Modulo_counter #(
  parameter DIVISOR = 10
)(
  input wire clk,
  input wire reset_n,
  output reg [$clog2(DIVISOR)-1:0] count
);

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      count <= 0;
    else if (count == DIVISOR-1)
      count <= 0;
    else
      count <= count + 1;
  end
endmodule
