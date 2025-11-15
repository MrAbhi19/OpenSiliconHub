module PISO #(
  parameter SIZE = 8,
  parameter SHIFT_DIR = 0   
)(
  input wire [SIZE-1:0] in,
  input wire reset, clk, enable,
  output reg out, done, busy
);
  reg [$clog2(SIZE)-1:0] bit_count;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      done <= 0;
      busy <= 0;
      out <= 0;
      bit_count <= 0;
    end
    else if (enable) begin
      done <= 0; 

      if (SHIFT_DIR == 1) begin
        out <= in[SIZE-1-bit_count];  
      end else begin
        out <= in[bit_count];         
      end

      busy <= 1;

      if (bit_count == SIZE-1) begin
        bit_count <= 0;
        done <= 1;   
        busy <= 0;  
      end
      else begin
        bit_count <= bit_count + 1;
      end
    end
    else begin
      busy <= 0;
      done <= 0;
    end
  end
endmodule
