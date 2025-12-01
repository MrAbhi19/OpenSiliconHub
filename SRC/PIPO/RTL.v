module PIPO #(
  parameter WIDTH=8
)(
  input wire [WIDTH-1:0] in,
  input wire clk,reset,enable,
  output reg [WIDTH-1:0] out
);
  always@(posedge clk or posedge reset) begin
    if (reset) begin
      out<=0;
    end
    else if (enable) begin
      out<=in;
    end
  end
endmodule
