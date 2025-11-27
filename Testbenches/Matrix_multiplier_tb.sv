`timescale 1ns/1ps

module tb_Matrix_multiplier;

  // Parameters
  localparam int N  = 3;   // matrix dimension
  localparam int DW = 8;   // data width per element
  localparam int AW = 2*DW + $clog2(N);

  // DUT inputs/outputs
  logic [N*N*DW-1:0] A_flat;
  logic [N*N*DW-1:0] B_flat;
  logic [N*N*AW-1:0] C_flat;

  // Instantiate DUT
  Matrix_multiplier #(
    .N(N),
    .DW(DW)
  ) dut (
    .A_flat(A_flat),
    .B_flat(B_flat),
    .C_flat(C_flat)
  );

  // Reference model arrays
  logic [DW-1:0] A [N][N];
  logic [DW-1:0] B [N][N];
  logic [AW-1:0] C_ref [N][N];

  // Flatten arrays into packed vectors
  task automatic flatten_inputs();
    for (int i = 0; i < N; i++) begin
      for (int j = 0; j < N; j++) begin
        A_flat[(i*N + j)*DW +: DW] = A[i][j];
        B_flat[(i*N + j)*DW +: DW] = B[i][j];
      end
    end
  endtask

  // Compute reference multiplication
  task automatic compute_reference();
    for (int i = 0; i < N; i++) begin
      for (int j = 0; j < N; j++) begin
        C_ref[i][j] = '0;
        for (int k = 0; k < N; k++) begin
          C_ref[i][j] += A[i][k] * B[k][j];
        end
      end
    end
  endtask

  // Compare DUT vs reference
  task automatic check_results();
    for (int i = 0; i < N; i++) begin
      for (int j = 0; j < N; j++) begin
        if (C_flat[(i*N + j)*AW +: AW] !== C_ref[i][j]) begin
          $error("Mismatch at C[%0d][%0d]: DUT=%0d, REF=%0d",
                 i, j,
                 C_flat[(i*N + j)*AW +: AW],
                 C_ref[i][j]);
        end else begin
          $display("Match at C[%0d][%0d]: %0d",
                   i, j, C_ref[i][j]);
        end
      end
    end
  endtask

  // Test procedure
  initial begin
    // Run multiple randomized tests
    for (int t = 0; t < 5; t++) begin
      // Randomize matrices
      foreach (A[i,j]) A[i][j] = $urandom_range(0, 2**DW-1);
      foreach (B[i,j]) B[i][j] = $urandom_range(0, 2**DW-1);

      // Flatten and compute reference
      flatten_inputs();
      compute_reference();

      // Wait for combinational logic
      #1;

      $display("==== Test %0d ====", t);
      check_results();
    end

    $display("All tests completed.");
    $finish;
  end

endmodule
