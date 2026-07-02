`timescale 1ps/1ps

module alu(
    input [7:0] a,
    input [7:0] b,
    input[3:0] sel,
    output reg [7:0] out,
    output reg carry_out
);

