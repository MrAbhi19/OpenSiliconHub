module counter #(
  parameter A = 32'h4D34D34D  // Golden ratio constant 
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        en,       // enable signal
    input  wire        carry_in, // carry from previous counter
    output reg  [31:0] c,        // current counter value
    output reg         carry_out // carry to next counter
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c         <= 32'd0;   // reset counter
            carry_out <= 1'b0;
        end else if (en) begin
            // Perform increment with constant and carry
            {carry_out, c} <= c + A + carry_in;
        end
    end

endmodule
