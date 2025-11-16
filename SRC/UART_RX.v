module UART_RX(
  input wire clk,
  input wire reset,
  input wire rx_line,
  output reg [7:0] data,
  output reg rx_busy,
  output reg rx_done,
  output reg rx_error
);
  parameter clk_freq = 50000000;
  parameter baud_rate = 9600;
  localparam clks_per_bit = clk_freq / baud_rate;

  reg [3:0] bit_index;
  reg [15:0] clk_count;
  reg [9:0] s_reg;
  reg rx_line_prev;
  reg [1:0] state;

  localparam IDLE = 2'b00,
             START = 2'b01,
             DATA = 2'b10,
             STOP = 2'b11;

  wire rx_falling_edge = rx_line_prev && !rx_line;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      clk_count <= 0;
      bit_index <= 0;
      rx_busy <= 0;
      rx_done <= 0;
      rx_error <= 0;
      data <= 8'b0;
      s_reg <= 10'b1111111111;
      rx_line_prev <= 1;
    end else begin
      rx_line_prev <= rx_line;
      rx_done <= 0;

      case (state)
        IDLE: begin
          if (rx_falling_edge) begin
            state <= START;
            clk_count <= 0;
            rx_busy <= 1;
          end
        end

        START: begin
          if (clk_count == 16'd(clks_per_bit/2)) begin
            if (rx_line == 0) begin
              clk_count <= 0;
              bit_index <= 0;
              state <= DATA;
            end else begin
              state <= IDLE; // False start bit
              rx_busy <= 0;
            end
          end else begin
            clk_count <= clk_count + 1;
          end
        end

        DATA: begin
          if (clk_count == 16'd(clks_per_bit - 1)) begin
            clk_count <= 0;
            s_reg[bit_index + 1] <= rx_line; // bits 1 to 8
            bit_index <= bit_index + 1;
            if (bit_index == 7)
              state <= STOP;
          end else begin
            clk_count <= clk_count + 1;
          end
        end

        STOP: begin
          if (clk_count == 16'd(clks_per_bit - 1)) begin
            clk_count <= 0;
            s_reg[9] <= rx_line; // stop bit
            data <= s_reg[8:1];
            rx_done <= 1;
            rx_busy <= 0;
            state <= IDLE;
            rx_error <= (s_reg[9] != 1'b1); // stop bit must be 1
          end else begin
            clk_count <= clk_count + 1;
          end
        end
      endcase
    end
  end
endmodule
