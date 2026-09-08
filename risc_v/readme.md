# Assignment 5: Student RISC-V-style CPU

**Name:** Umesh Khadka  
**Roll No.:** THA079BEI047

## Overview

This assignment contains a small educational CPU assembled from the lab's 8-bit ALU,
8x8 register file, and instruction memory. It is RISC-V-inspired, not a binary
compatible RISC-V implementation.

This implementation reuses relevant modules from the previous assignments,
including the ALU, instruction memory, and register file. Those modules were
organized into the CPU structure and received minor corrections and
improvements where needed for integration, including a combinational control
decoder, consistent register widths, data memory support, and processor control
signals.

The processor is intentionally small and easy to trace in simulation. It uses a
single-cycle datapath: one instruction is fetched, decoded, executed, and
committed on each clock cycle. The design uses 8-bit data values, eight general
purpose registers, a 4-bit program counter, 16 instruction words, and 16 bytes
of data memory.

## Folder structure

- `top_modules_cores/`: synthesizable CPU modules and the top-level processor.
- `testbenches/`: one testbench for every module, plus the processor integration testbench.

The core files are `processor.v`, `cu.v`, `instruction_memory.v`,
`register_file_8x8.v`, `data_memory.v`, and `alu.v` in `top_modules_cores/`.

## Files

- `top_modules_cores/processor.v` - single-cycle processor and program counter
- `top_modules_cores/cu.v` - instruction decoder and control signals
- `top_modules_cores/alu.v` - reused and locally integrated 8-bit ALU
- `top_modules_cores/register_file_8x8.v` - reused 8x8 register file
- `top_modules_cores/instruction_memory.v` - reused 16-word instruction memory
- `top_modules_cores/data_memory.v` - 16-byte read/write data memory
- `testbenches/` - module-level and processor-level testbenches
- `testbenches/processor_tb.vcd` - generated processor waveform for GTKWave

## Instruction format

The opcode is `instruction[15:12]`. Register fields use three bits:
`rd=[11:9]`, `rs1=[8:6]`, and `rs2=[5:3]`. Immediate instructions use a signed
six-bit immediate in `[5:0]`.

`0000` ADD, `0001` SUB, `0010` AND, `0011` OR, `0100` XOR, `0101` ADDI,
`0110` LD, `0111` ST, `1000` BEQ, `1001` JUMP, and `1111` HALT.

### Instruction summary

| Opcode | Instruction | Description |
| --- | --- | --- |
| `0000` | `ADD` | Add two registers and write the result to `rd` |
| `0001` | `SUB` | Subtract `rs2` from `rs1` and write to `rd` |
| `0010` | `AND` | Bitwise AND of two registers |
| `0011` | `OR` | Bitwise OR of two registers |
| `0100` | `XOR` | Bitwise XOR of two registers |
| `0101` | `ADDI` | Add a signed six-bit immediate to `rs1` |
| `0110` | `LD` | Load data memory using `rs1 + immediate` |
| `0111` | `ST` | Store `rd` into data memory using `rs1 + immediate` |
| `1000` | `BEQ` | Branch by the immediate when the two operands are equal |
| `1001` | `JUMP` | Jump to the four-bit instruction address |
| `1111` | `HALT` | Stop instruction execution |

Register 0 is reset to zero like every other register in this basic student
implementation; programs can use registers `r0` through `r7`. Memory arrays
are initialized or loaded by the testbench, which keeps the design simple for
simulation and classroom experimentation.

## Datapath operation

The program counter addresses the instruction memory. The control unit decodes
the current instruction and selects register operands, the ALU operation,
memory access, and the next program-counter value. The register file has two
asynchronous read ports and one synchronous write port. Loads select data
memory output as the register write data, while stores write the second operand
to data memory on the active clock edge.

## Testbench and waveform

Each core has a corresponding testbench. The testbenches generate VCD waveform
files so the signal transitions can be inspected in GTKWave. The processor
testbench runs a small program that calculates `5 + 7`, writes the result to
register 3, stores it in data memory address 1, and then halts.

The included waveform is `testbenches/processor_tb.vcd`. It can be opened after
simulation with GTKWave.

### Processor waveform preview

The following image was captured from the included processor waveform. It shows
the clocked execution of the sample instructions `ADDI`, `ADD`, `ST`, and
`HALT`, including the instruction bus, register addresses, ALU-related control
signals, and write data.

![Student RISC-V processor waveform](risc_waveform.png)

## Compile and simulate

With Icarus Verilog:

```powershell
cd risc_v/testbenches
iverilog -o processor_tb.vvp processor_tb.v ../top_modules_cores/processor.v ../top_modules_cores/cu.v ../top_modules_cores/alu.v ../top_modules_cores/register_file_8x8.v ../top_modules_cores/instruction_memory.v ../top_modules_cores/data_memory.v
vvp processor_tb.vvp
gtkwave processor_tb.vcd
```

The simulation should print `PASS` and produce `processor_tb.vcd`.