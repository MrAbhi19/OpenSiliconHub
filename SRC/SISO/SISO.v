module SISO #(
  parameter WIDTH=8
)(
  input wire in,clk,enable,reset,
  output reg out,done,busy
);
  reg [$clog2(WIDTH)-1:0] bit_count;
  reg [WIDTH-1:0] shift_reg;
  
  always@(posedge clk or posedge reset) begin
    if (reset) begin
      bit_count<=0;
      done<=0;
      busy<=0;
      out<=0;
    end
    else if (enable) begin
      shift_reg<={shift_reg[WIDTH-2:0],in};
      out<=shift_reg[WIDTH-1];
      busy<=1;

      if (bit_count==$clog2(WIDTH)'(WIDTH-1)) begin
        bit_count<=0;
        done<=1;
        busy<=0;
      end
      else begin
        bit_count<=bit_count+1;
      end
    end
    else begin
      busy<=0;
      done<=0;
    end
  end
endmodule
        
