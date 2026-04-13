# 4-Bit Synchronous Calculator (Verilog RTL)

## Overview
A custom-designed 4-bit calculator implemented in Verilog. This project demonstrates synchronous logic design, pipeline stages, and localized memory management (SRAM-based).

## Key Features
* **Arithmetic Operations:** Supports Addition and Subtraction.
* **Signed Logic:** Fully supports 2's Complement representation for negative results.
* **Architecture:** Features a 1-cycle pipeline delay for data stability.
* **Self-Checking Testbench:** Includes a randomized stimulus generator with automated result verification.

## Simulation
The design was verified using EDA Playground and Icarus Verilog. 
* To see negative results correctly, set the waveform radix to **Signed Decimal**.
