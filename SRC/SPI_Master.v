module Spi_Master(
  input wire clk,
  input wire reset_n, //active low
  input wire start,
  input wire [7:0] data_in,
  input wire miso,
  output reg mosi,
  output reg sclk,
  output reg [7:0] data_out,
  output reg done,
  output reg cs
)
  localparam IDLE=3'b000, SHIFT=3'b010, DONE=3'b011

  reg [2:0] bit_count;
  reg [7:0] shift_reg;
  reg [2:0] STATE;
  
  always@(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      STATE<=IDLE;
      cs<=1;
      done<=0;
      bit_count<=0;
      sclk<=0;
    end else begin
      case (STATE)
        IDLE: begin
          done <=0;
          cs<=1;
          sclk<=0;
          if (start) begin
            shift_reg<=data_in;
            bit_count<=7;
            cs<=0;
            STATE<=SHIFT;
          end
        end
        SHIFT: begin
          sclk<=~sclk;
          if (sclk==0)
            mosi<=shift_reg[bit_count];
          else begin
            shift_reg[bit_count]<=miso;
            if (bit_count==0)
              STATE<=DONE;
            else 
              bit_count<=bit_count-1;
          end
        end
        
          DONE: begin
            cs<=1;
            done<=1;
            data_out<=shift_reg;
            STATE<=IDLE;
          end
      endcase
    end
  end
endmodule
