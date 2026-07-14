`timescale 1ps/1ps

// 16-word instruction memory. The testbench loads memory[] directly.
module instruction_memory(
    input  wire [3:0] address,
    output wire [15:0] instruction
);
    reg [15:0] memory [0:15];

    assign instruction = memory[address];
endmodule
