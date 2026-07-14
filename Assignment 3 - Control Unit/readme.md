# Assignment 3: Control Unit

**Name:** Umesh Khadka  
**Roll No.:** THA079BEI047

## Overview

This assignment implements a simple synchronous control unit in iVerilog. The control unit decodes the 4-bit opcode in a 16-bit instruction and generates the control signals required by the register file and ALU. Its outputs select the source and destination registers, enable register writes, and choose the required ALU operation.

> For now, the 2's-complement, immediate, and select-operand outputs are not used.

The instruction format is divided as follows:

| Bits | Field |
| --- | --- |
| `15:12` | Opcode |
| `11:8` | Source register 1 |
| `7:4` | Source register 2 |
| `3:0` | Destination register |


Here we use two registers reg1 and reg2 to store the address of two sources and writereg to store the vaddress of destination of the operation. CU gives corresponding ALU op_code as output, ALU takes it as selection input, takes values from address stored in reg1 and reg2 and outputs the result, which is then stored in the address in writereg.

The implemented operations are ADD, SUB, AND, OR, XOR, increment, decrement, compare, and load. The design is triggered on the rising edge of the clock and uses an active-low reset.

## Control Unit Architecture

![Control unit architecture](architecture.png)

## Compile and Simulate

Run these commands from this assignment folder. The first command compiles the control unit and its testbench, the second runs the simulation and produces `cu.vcd`, and the last opens the waveform in GTKWave.

```powershell
iverilog -o cu_tb.vvp cu.v cu_tb.v
vvp cu_tb.vvp
gtkwave cu.vcd
```

## Testbench Simulation Waveform

The following GTKWave waveform shows the control-unit simulation results from the testbench.

![GTKWave testbench waveform](cu_waveform.png)
