module SIPO #(
  parameter WIDTH = 8,
  parameter SHIFT_DIR=0
)(
  input wire in,clk,reset,enable,
  output reg [WIDTH-1:0] out,
  output reg done,busy
);
  reg [$clog2(WIDTH)-1:0] bit_count;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin 
      out <= 0;
      bit_count <= 0;
      done <= 0;
      busy<=0;
    end
    else if (enable) begin
      if (SHIFT_DIR==0) begin
        out[bit_count]<=in;
      end else begin
        out[WIDTH-1-bit_count]<=in;
      end
      busy<=1;
      if (bit_count == $clog2(WIDTH)'(WIDTH-1)) begin
        bit_count <= 0;
        done <= 1;  
        busy<=0;
      end
      else begin
        bit_count <= bit_count + 1;
      end
    end
    else begin
      busy<=0;
      done<=0;
    end
  end
endmodule
