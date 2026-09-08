# Top Modules and Cores

This folder contains the synthesizable modules for the RISC-V-style processor:

The ALU, instruction memory, and register file are based on relevant modules
from the previous FPGA assignments. Their interfaces are adapted for this
processor and combined with the control unit, processor datapath, and data
memory.

- `processor.v`: top-level single-cycle processor
- `cu.v`: control unit / instruction decoder
- `alu.v`: 8-bit arithmetic and logic unit
- `register_file_8x8.v`: eight 8-bit registers
- `instruction_memory.v`: 16-word instruction memory
- `data_memory.v`: 16-byte data memory

The matching module testbenches are in `../testbenches/`.
