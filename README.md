# Full-Custom Mini-Processor: 4-bit ALU with 64-bit SRAM Matrix Integration
## Developed using Cadence Virtuoso | 45nm CMOS Technology

### Project Overview
This project features the full-custom, transistor-level design of a mini-processor system. It integrates a 4-bit Arithmetic Logic Unit (ALU) with a 64-bit SRAM memory architecture. The system manages data flow from user input to memory storage and supports feedback loops for complex calculations.

### Technical Specifications
* **ALU:** 4-bit addition and subtraction using Sign and Magnitude representation.
* **Memory:** 64-bit SRAM Matrix (16 words x 4 bits).
* **Peripherals:**
    * **4x16 Decoder:** For precise row addressing.
    * **Precharge Circuitry:** To stabilize bitlines before operations.
    * **Sense Amplifier:** Differential amplifier for reliable data reading.
* **Synchronization:** Dual-stage D-Latch buffers for operand alignment and timing control.

### Physical Design Flow (RTL-to-GDS)
1. **Schematic & Hierarchical Design:** Built from the ground up, starting from NMOS/PMOS transistors to logic gates, macros (SRAM), and top-level integration.
2. **Floorplanning:** Managed a complex layout where memory cells, decoders, and logic units are strategically placed to optimize chip area.
3. **Routing & Connectivity:** Executed manual and automated routing across metal layers to ensure 100% signal connectivity.
4. **Physical Verification (Sign-off):**
    * **DRC (Design Rule Check):** Validated that the layout adheres to all 125nm manufacturing constraints.
    * **LVS (Layout vs. Schematic):** Confirmed perfect structural matching between the physical implementation and the electrical netlist.

### Key Engineering Challenges & Solutions
* **Timing & Synchronization:** Solved data arrival race conditions at the ALU by implementing a dual-stage D-Latch synchronization scheme, ensuring operands from memory are sampled simultaneously.
* **Memory Density:** Optimized the 64-bit SRAM matrix layout through tight cell-abutment and shared power-rail routing, reducing overall silicon area.
* **Signal Integrity:** Managed the high fan-out of the 4x16 Decoder to ensure stable word-line activation across the entire memory matrix.
* **Data Flow Control:** Integrated 2-to-1 Multiplexers to handle the write-back path, allowing the system to toggle between new user inputs and ALU computed results seamlessly.

### Results
* **Status:** DRC Clean & LVS Matched.
* **Functional Verification:** Successfully verified the complete system logic (ALU + Memory) through comprehensive simulations, ensuring data integrity across all operations.

---

### Gallery

| Top-Level Layout | SRAM Matrix |
| :---: | :---: |
| ![Layout](images/full_layout.jpg) | ![SRAM](images/memory_matrix.jpg) |

| DRC & LVS Verification |
| :---: |
| ![DRC_LVS](images/drc_lvs.jpg) |
