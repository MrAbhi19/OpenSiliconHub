module Matrix_multiplier #(
  parameter N  = 3,   // matrix dimension
  parameter DW = 8    // data width per element
)(
  input  wire [N*N*DW-1:0] A_flat,
  input  wire [N*N*DW-1:0] B_flat,
  output reg  [N*N*(2*DW + $clog2(N))-1:0] C_flat
);

  localparam AW = 2*DW + $clog2(N);

  integer i, j, k;
  reg [AW-1:0] acc;

  always @* begin
    C_flat = '0;
    for (i = 0; i < N; i = i + 1) begin
      for (j = 0; j < N; j = j + 1) begin
        acc = 0;
        for (k = 0; k < N; k = k + 1) begin
          acc = acc + A_flat[(i*N + k)*DW +: DW] *
                        B_flat[(k*N + j)*DW +: DW];
        end
        C_flat[(i*N + j)*AW +: AW] = acc;
      end
    end
  end

endmodule
