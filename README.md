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
</p>


<p align="center"><i>Reusable Verilog cores focused on cryptography, DSP, and neural acceleration</i></p>


A growing collection of reusable, parameterized hardware cores for learning, prototyping, and integration into advanced digital design projects. Our primary focus is on cryptographic cores, DSP cores, neural accelerators, and other high‑performance building blocks for modern systems.


Whether you’re a beginner exploring Verilog or an experienced designer, your contributions are welcome!

---

## ⚡ Core Examples

We focus on building **powerful hardware cores** that can serve as reusable building blocks.  
Here’s a snapshot of what we have right now and what we might consider building later:

### 🔐 Cryptographic Cores
- **ChaCha20** stream cipher   [➡️](./SRC/Chacha20/)
- **AES** block cipher   [➡️](./SRC/AES/)
- **PRNGs** — Multiple modules including PCG64-DXSM, SplitMix64, philox-4*32-10, and 5 other PRNG variants [➡️](./SRC/)
- SHA‑1 / SHA‑256 hash cores
- RSA / ECC accelerators
- Grain‑128 / Grain‑128a

---

### 🎵 DSP Cores
**What we have right now:**
- FIR, IIR filter modules
- FFT (Fast Fourier Transform) prototype
- convolution engines for signal/image processing

---

### 🧠 Neural Acceleration
**What we have right now:**
- Basic matrix multiplication core
- Convolutional layer accelerators
- Activation function modules (ReLU, Sigmoid, Tanh)
- RNN/LSTM building blocks
- Quantized neural network primitives

---

## 🤝 Contribution Guidelines

Read the contribution guide here:  
👉 [Contribution Guidelines](./Contribution.md)

If you run into any issues or want help contributing, feel free to open a Discussion:  
👉 [Discussions](../../discussions)

---

## 🧰 Tools Used

### Software
- [Icarus Verilog](http://iverilog.icarus.com/) — Simulation  
- [Verilator](https://www.veripool.org/verilator/) — Linting & static checks  
- [GTKWave](http://gtkwave.sourceforge.net/) — Waveform viewing  
- [EDA Playground](https://www.edaplayground.com/) — Quick online testing


### Hardware Targets for Benchmarks  
- **Lattice iCE40 UP5K**  
- **Xilinx Artix-7 XC7A35T**

---

## 📬 Contact / Discussions

For module requests, ideas, improvements, or collaboration, use the **GitHub Discussions** section of the repository.

---

## 📜 License
This project is licensed under the MIT License — see [LICENSE](./LICENSE) for details.

---
