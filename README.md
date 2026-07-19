# Parameterized UART IP Core

A fully synthesizable, high-performance UART (Universal Asynchronous Receiver-Transmitter) IP Core modeled in Verilog HDL. This design provides robust asynchronous serial communication capabilities, optimized for integration into modern System-on-Chip (SoC) architectures and FPGA platforms.

## Key Technical Features
* **Independent Tx/Rx Data Paths:** Decoupled Transmitter and Receiver architectures utilizing dedicated Mealy/Moore Finite State Machines (FSMs) for precise control flow handling.
* * **Configurable Baud Rate Generator:** Built-in parameterized clock divider supporting standard baud rates (e.g., 9600, 115200) based on system clock inputs.
* * **16x Over-Sampling Receiver:** Employs a robust 16x over-sampling mechanism with mid-bit synchronization filtering to suppress line noise and ensure reliable data recovery.
* * **Comprehensive Error Detection:** Hardware-level monitoring and reporting for common framing errors, parity errors, and overrun conditions.
* * **Flexible Frame Formatting:** Configurable word length (7 or 8 data bits), optional parity bit generation/checking (Even/Odd/None), and stop bit configurations.
       
* ## Architecture & Design Blocks
* * **Baud Rate Generator:** Derived tick generator providing high-frequency sampling pulse synchronization.
* * **UART Transmitter (Tx):** Parallel-to-serial conversion block with automated Start, Parity, and Stop bit insertion.
* * **UART Receiver (Rx):** Serial-to-parallel shifting logic with glitch-filtering start-bit verification.
             
* ## Simulation & Verification
* * **HDL Language:** Verilog HDL
* * **Verification Environment:** ModelSim SE
* * **Testbench Methodology:** Self-checking behavioral testbench simulating full-duplex communication loopbacks, varying clock skew configurations, and noise injection scenarios to validate receiver filtering and error flags.
