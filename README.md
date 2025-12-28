<h1 align="center">OpenSiliconHub</h1>

<p align="center">
  <!-- Verilog Lint Badge -->
  <a href="https://github.com/MrAbhi19/Verilog_Library/actions/workflows/linting.yml">
    <img src="https://github.com/MrAbhi19/Verilog_Library/actions/workflows/linting.yml/badge.svg" alt="Verilog Lint (Strict Mode)">
  </a>
  <!-- Verilog Simulation Badge -->
  <a href="https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml">
    <img src="https://github.com/MrAbhi19/Verilog_Library/actions/workflows/verilog-test.yml/badge.svg" alt="Verilog Simulation">
  </a>
  <!-- GitHub Release Badge -->
  <a href="https://github.com/MrAbhi19/OpenSiliconHub/releases">
    <img src="https://img.shields.io/github/release/MrAbhi19/OpenSiliconHub.svg" alt="GitHub Release">
  </a>
  <!-- Zenodo DOI Badge -->
  <a href="https://doi.org/10.5281/zenodo.17895634">
    <img src="https://zenodo.org/badge/1097102485.svg" alt="DOI">
  </a>
</p>


<p align="center"><i>Reusable Verilog cores focused on cryptography, DSP, and neural acceleration</i></p>


A growing collection of reusable, parameterized hardware cores for learning, prototyping, and integration into advanced digital design projects. Our primary focus is on cryptographic cores, DSP cores, neural accelerators, and other high‑performance building blocks for modern systems.


Whether you’re a beginner exploring Verilog or an experienced designer, your contributions are welcome!

---

## Getting Started

This repository contains multiple independent, reusable Verilog hardware cores.
Each core can be explored, simulated, and integrated individually using standard
HDL tools.

This section provides general guidance to help new users get started quickly.
Core-specific instructions may vary and are typically documented within the
respective core directories.

### Prerequisites
- A Verilog simulator (e.g., Icarus Verilog, Verilator, or a compatible simulator)
- GTKWave or a compatible waveform viewer (optional, for signal inspection)

### General Simulation Flow
1. Navigate to the directory of the desired hardware core.
2. Compile the Verilog source files along with the corresponding testbench.
3. Run the simulation using your chosen simulator.
4. Inspect simulation logs or waveforms to verify correct functionality.

---

## Core Examples

We focus on building **powerful hardware cores** that can serve as reusable building blocks.  
Here’s a snapshot of what we have right now and what we might consider building later:

###  Cryptographic Cores
- **ChaCha20** stream cipher   [➡️](./SRC/Chacha20/)
- **AES** block cipher   [➡️](./SRC/AES/)
- **PRNGs** — Multiple modules including PCG64-DXSM, SplitMix64, philox-4*32-10, and 5 other PRNG variants [➡️](./SRC/)
- SHA‑1 / SHA‑256 hash cores
- RSA / ECC accelerators
- Grain‑128 / Grain‑128a

---

###  DSP Cores
- FIR, IIR filter modules
- FFT (Fast Fourier Transform) prototype
- Convolution engines for signal/image processing

---

###  Neural Acceleration
- Basic matrix multiplication core
- Convolutional layer accelerators
- Activation function modules (ReLU, Sigmoid, Tanh)
- RNN/LSTM building blocks
- Quantized neural network primitives

---

##  Contribution Guidelines

Read the contribution guide here:  
👉 [Contribution Guidelines](./Contribution.md)

If you run into any issues or want help contributing, feel free to open a Discussion:  
👉 [Discussions](../../discussions)

---

##  Tools Used

### Software (Commonly Used)
- [Icarus Verilog](http://iverilog.icarus.com/) — Simulation  
- [Verilator](https://www.veripool.org/verilator/) — Linting & static checks  
- [GTKWave](http://gtkwave.sourceforge.net/) — Waveform viewing  
- [EDA Playground](https://www.edaplayground.com/) — Quick online testing


### Hardware Targets for Benchmarks  
- **Lattice iCE40 UP5K**  
- **Xilinx Artix-7 XC7A35T**

---

##  Citation

If you use this work in your research, please cite it using the Zenodo DOI:

[![DOI](https://zenodo.org/badge/1097102485.svg)](https://doi.org/10.5281/zenodo.17895634)

### BibTeX
```bibtex
@misc{OpenSiliconHub_ChaCha20_2025,
  author       = {Abhilash M},
  title        = {OpenSiliconHub: ChaCha20 Hardware Core},
  year         = {2025},
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.17895634},
  url          = {https://doi.org/10.5281/zenodo.17895634}
}
```

##  Contact / Discussions

For module requests, ideas, improvements, or collaboration, use the **GitHub Discussions** section of the repository.

---

##  License
This project is licensed under the MIT License — see [LICENSE](./LICENSE) for details.

---
