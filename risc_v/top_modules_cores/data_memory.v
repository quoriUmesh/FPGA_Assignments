`timescale 1ps/1ps

// 16-byte data memory. The testbench may preload memory[] hierarchically.
module data_memory(
    input wire clk,
    input wire writeenable,
    input wire [7:0] address,
    input wire [7:0] writedata,
    output wire [7:0] readdata
);
    reg [7:0] memory [0:15];
    assign readdata = memory[address[3:0]];

    always @(posedge clk) begin
        if (writeenable)
            memory[address[3:0]] <= writedata;
    end
endmodule