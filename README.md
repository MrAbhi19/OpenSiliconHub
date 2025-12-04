# Verilog Modules Library 
[![Verilog Lint (Strict Mode)](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/linting.yml/badge.svg)](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/linting.yml) [![Verilog Simulation](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml/badge.svg)](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml) 


A growing collection of **reusable, parameterized Verilog modules** for learning, prototyping, and integrating into larger digital design projects.  
Each module includes documentation, a testbench, simulation waveforms (when applicable), and clean RTL aimed at readability and reusability.

This project welcomes contributions of all kinds—new modules, tests, improvements, documentation, or design suggestions.

---

## ✨ Features

- **Reusable RTL** — Clean, synthesizable, parameterized modules.  
- **Full workflow support** — Testbenches, simulation scripts, and CI-based linting/simulation.  

---

## Getting started

How to use these modules in your projects?<br>
👉 [How to Use](#how-to-use)

---

## 🤝 Contribution Guidelines

Read the contribution guide here:  
👉 [Contribution Guidelines](./Contribution.md)

If you run into any issues or want help contributing, feel free to open a Discussion:  
👉 [Discussions](../../discussions)

---

## 🧰 Tools Used

### Software
- **Icarus Verilog** — Simulation  
- **Verilator** — Linting & static checks  
- **GTKWave** — Waveform viewing  
- **EDA Playground** — Quick online testing

### Hardware Targets for Benchmarks  
- **Lattice iCE40 UP5K**  
- **Xilinx Artix-7 XC7A35T**

---

## 📬 Contact / Discussions

For module requests, ideas, improvements, or collaboration, use the **GitHub Discussions** section of the repository.

---

# How to Use

Let’s consider a boolean expression: `((A + B) * C) * D`  
To implement this expression, we need two modules — **[MAC](./RTL/MAC.v)** and **[Multiplier](./RTL/Multiplier)**.

**Step 1:** Download `MAC.v` and `Multiplier.v` and add them to your work environment.  
**Step 2:** Instantiate them as shown below:

```Verilog
module top (
  input  [1:0] A_in, B_in,
  input  [3:0] C_in, D_in,
  output [7:0] ex_out
);

  wire connector;

  // Multiply-Accumulate: (A + B) * C
  MAC #(
    .WIDTH_A(2),  
    .WIDTH_B(2)  
  ) u_mac (
    .A(A_in),     
    .B(B_in),     
    .C(C_in),      
    .Y(connector)    
  );

  // Final multiplication: result * D
  Multiplier #(
    .WIDTH_A(4), 
    .WIDTH_B(4)    
  ) u_mult (
    .in1(connector),   
    .in2(D_in), 
    .out(ex_out)  
  );

endmodule
