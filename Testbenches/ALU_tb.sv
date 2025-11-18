module ALU_tb;
  parameter WIDTH = 4;

  logic [WIDTH-1:0] A;
  logic [WIDTH-1:0] B;
  logic [2:0]        sel;
  logic [WIDTH:0]    out;

  ALU #(.WIDTH(WIDTH)) dut (
    .A(A),
    .B(B),
    .sel(sel),
    .out(out)
  );

  initial begin
    // Test 1: ADD
    A   = 4'b1001;
    B   = 4'b0011;
    sel = 3'b000; // ADD
    #10;

    $display("ADD: A=%b, B=%b -> out=%b (expected %b)",
              A,   B,      out,     A + B);

    // Test 2: AND
    A   = 4'b0111;
    B   = 4'b1010;
    sel = 3'b011; // AND
    #10;

    $display("AND: A=%b, B=%b -> out=%b (expected %b)",
              A,   B,      out,     A & B);

    $finish;
  end
endmodule
