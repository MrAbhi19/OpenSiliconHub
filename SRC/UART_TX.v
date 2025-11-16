module UART_TX#(
  parameter clk_freq=50000000,
  parameter baud_rate=9600
)(
  input wire clk,reset,tx_start,
  input wire [7:0] data,
  output reg tx_line,tx_busy,tx_done
);
  
  localparam clks_per_bit=clk_freq/baud_rate;
  reg [15:0] clk_count;
  reg [3:0] bit_index;
  reg [9:0] s_reg<=10'b1111111111;

  always@(posedge clk or posedge reset) begin
    if (reset) begin
      tx_busy<=0;
      clk_count<=0;
      bit_index<=0;
      tx_line<=1;
      tx_done<=0;
    end else begin
      if (tx_start && !tx_busy) begin
        s_reg<={1'b1,data,1'b0};
        tx_busy<=1;
        clk_count<=0;
        bit_index<=0;
        tx_done<=0;
      end else if (tx_busy) begin
        if (clk_count<clks_per_bit-1)
          clk_count<=clk_count+1;
        else begin
          clk_count<=0;
          tx_line<=s_reg[bit_index];
          bit_index<=bit_index+1;
          if (bit_index==9) begin
            tx_busy<=0;
            tx_done<=1;
            tx_line<=1;
          end
        end
      end
    end
  end
endmodule
