module Bi_count #(
  parameter SIZE = 1000
)(
  input  wire clk,
  input  wire reset,
  input  wire dir,    
  input  wire en,    
  output reg [$clog2(SIZE)-1:0] out
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 0;
    end
    else if (en) begin
      if (dir == 0) begin
        if (out == SIZE-1)
          out <= 0;
        else
          out <= out + 1;
      end
      else begin
        if (out == 0)
          out <= SIZE-1;
        else
          out <= out - 1;
      end
    end
  end
endmodule
