# Verilog Modules Library [![Lint Status](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-lint.yml/badge.svg)](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-lint.yml)          [![Verilog Simulation](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml/badge.svg)](https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml)

![License](https://img.shields.io/github/license/MrAbhi19/Verilog_Library)

A growing collection of reusable, parameterized Verilog modules designed for learning, rapid prototyping, and integration into larger digital design projects. The goal of this repository is to maintain a clean, modular, and extensible library of hardware building blocks—each paired with testbenches, simulation waveforms, and clear documentation.

This project is open for contributions in all forms: modules, testbenches, waveform captures, documentation, and ideas for upcoming designs.

---
## 🛡️ Linting Policy

This repository enforces **strict linting** using Verilator in GitHub Actions:

- **Warnings are treated as errors** — even minor issues like unused signals or width mismatches will fail the workflow.
- **Style and synthesis safety enforced** — checks include unused signals, width mismatches, implicit nets, unreachable code, and clock/reset handling.

This strict setup guarantees that all HDL code here is **clean, reproducible, and synthesis‑safe**.  
**✅ Every module in this repository is lint‑clean under Verilator strict mode.**

---
## ✨ Features

- **Reusable modules** — Clean, synthesizable Verilog with parameterization wherever applicable.
- **Structured directories** — Each module has its own folder containing:
  - Source files (`.v`)
  - Testbench
  - Waveform outputs (`.vcd` / screenshots)
  - Notes or design explanations
- **Beginner-friendly** — Easy for students, hobbyists, and engineers.
- **Open for collaboration** — Ideas and discussions welcome in the GitHub Discussions section.

---

## 🧩 Available Modules

This list will grow as new modules are added.  
Examples:
## 🧩 Available Modules


| Module                | Description / Notes                                      |
|-----------------------|----------------------------------------------------------|
| **SPI (Master/Slave)**| Serial Peripheral Interface communication modules        |
| **UART (TX/RX)**      | Universal Asynchronous Receiver/Transmitter (serial comms)|
| **ALU**               | Arithmetic Logic Unit for basic operations               |
| **Bidirectional Counter** | Counts up and down with control signals             |
| **Pre-Scaler**        | Frequency divider for clock management                   |
| **Shift Registers**   | SISO, SIPO, PISO, PIPO variants                          |
| **Gray-Coded Counter**| Counter with Gray code output                            |
| **Priority Encoder**  | Encodes highest-priority active input                    |

---

## 🚀 Contributions Welcome

Contributions are open in multiple categories:

### 1. Verilog Modules  
Submit reusable, parameterized modules with a short description.

### 2. Testbenches  
Add or improve testbenches for existing modules.

### 3. Waveforms  
Upload `.vcd` files or screenshots using tools like GTKWave.

### 4. Optimizations & Refactoring  
Enhance clarity, parameterization, or performance of current modules.

### 5. Documentation  
Improve descriptions, add diagrams, or explain design logic.

### 6. Ideas and Proposals  
Use the **Discussions** tab to propose:
- New modules  
- Improvements  
- Coding standards  
- Simulation methodology  

---

## 📝 Contribution Guidelines

1. Fork the repository.  
2. Create a new branch for your module or fix.  
3. Add your module in a new folder following the structure above.  
4. Include:
   - Module file  
   - Testbench  
   - Waveform (if possible)  
   - Short module notes  
5. Submit a pull request with a clear explanation.  

For proposals or questions, start a GitHub Discussion before a PR.

---

## 🧪 Recommended Tools

- **Icarus Verilog** — Simulation  
- **Verilator** — Linting and cycle-accurate simulation  
- **GTKWave** — Waveform viewing  
- **EDA Playground** — Online quick testing  
- **VS Code + Verilog HDL extensions** — Coding environment  

---

## 📬 Contact / Discussions

For module requests, ideas, improvements, or collaboration, use the **GitHub Discussions** section of this repository.
