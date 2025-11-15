module PWM_Generator #(
  parameter PERIOD=100
)(
  input wire clk,
  input wire reset_n,
  input wire [$clog2(PERIOD)-1:0] duty,
  output reg pwm_out
)
  reg [$clog2(PERIOD)-1:0] counter;

  always@(posedge clk or negedge reset_n) begin
    if (!reset_n)
      counter<=0;
    else if (counter == PERIOD-1)
      counter<=0;
    else
      counter<=counter+1;
  end
  always@(*) begin
    if(counter<duty)
      pwm_out<=1;
    else
      pwm_out<=0;
  end 
endmodule
