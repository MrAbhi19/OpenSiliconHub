module Pre_Scaler #(
  parameter DIVISOR=4
)(
  input wire clk_in,
  input wire reset_n,
  output reg clk_out
);
  localparam max_count=(DIVISOR>1) ? DIVISOR-1 : 1;
  reg [$clog2(DIVISOR)-1:0] bit_count; 

  always @(posedge clk_in or negedge reset_n) begin
    if (!reset_n) begin
      bit_count <= 0;
      clk_out   <= 0;
    end else begin
      if (bit_count == $clog2(DIVISOR)'(max_count)) begin
        bit_count <= 0;
        clk_out   <= ~clk_out;
      end else begin
        bit_count <= bit_count + 1;
      end
    end
  end
  
endmodule
