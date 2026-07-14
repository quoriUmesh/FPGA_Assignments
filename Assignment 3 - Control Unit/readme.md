# Assignment 3: Control Unit

**Name:** Umesh Khadka  
**Roll No.:** THA079BEI047

## Overview

This assignment implements a simple synchronous control unit in iVerilog. The control unit decodes the 4-bit opcode in a 16-bit instruction and generates the control signals required by the register file and ALU. Its outputs select the source and destination registers, enable register writes, and choose the required ALU operation.

**For now we have neglected the 2's complement, immediate and select operand outputs.

The instruction format is divided as follows:

| Bits | Field |
| --- | --- |
| `15:12` | Opcode |
| `11:8` | Source register 1 |
| `7:4` | Source register 2 |
| `3:0` | Destination register |

The implemented operations are ADD, SUB, AND, OR, XOR, increment, decrement, compare, and load. The design is triggered on the rising edge of the clock and uses an active-low reset.

## Control Unit Architecture

![Control unit architecture](architecture.png)

## Testbench Simulation Waveform

The following GTKWave waveform shows the control-unit simulation results from the testbench.

![GTKWave testbench waveform](cu_waveform.png)
