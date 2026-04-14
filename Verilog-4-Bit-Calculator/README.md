# 4-Bit Synchronous Calculator (Verilog RTL)

## 📌 Overview
A custom-designed 4-bit calculator implemented in **Verilog HDL**. This project demonstrates core digital design principles, including synchronous logic, pipeline architectures, and internal memory management.

Unlike typical combinational calculators, this design utilizes a registered output and a memory-based operand flow to mimic real-world processor behavior.

## 🚀 Key Features
* **Arithmetic Unit:** Supports Signed Addition and Subtraction.
* **Signed Logic:** Fully supports **2's Complement** representation for handling negative results correctly.
* **Pipelined Architecture:** Features a 1-cycle pipeline delay between operation selection and data output for improved signal integrity.
* **Memory Integration:** Integrated SRAM-based storage for operand management.
* **Advanced Verification:** Includes a **Self-Checking Testbench** with a randomized stimulus generator that validates 100+ operations, including handling of asynchronous resets.


## 💻 Simulation & Verification
The design was fully verified using **Icarus Verilog** and **EDA Playground**.

* **Testbench:** Automated verification comparing RTL results against a golden reference model.
* **Waveform Analysis:** * To view results correctly, set the waveform radix to **Signed Decimal**.
    * Verification confirms that `data_out` updates precisely 2 clock cycles after operand loading (Pipeline latency).


