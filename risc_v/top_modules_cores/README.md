# Top Modules and Cores

This folder contains the synthesizable modules for the student RISC-V-style CPU:

The ALU, instruction memory, and register file are relevant modules reused from
the previous FPGA assignments. They were integrated with minor corrections and
improvements to make their widths and control interfaces consistent with the
student processor.

- `processor.v`: top-level single-cycle processor
- `cu.v`: control unit / instruction decoder
- `alu.v`: 8-bit arithmetic and logic unit
- `register_file_8x8.v`: eight 8-bit registers
- `instruction_memory.v`: 16-word instruction memory
- `data_memory.v`: 16-byte data memory

The matching module testbenches are in `../testbenches/`.
