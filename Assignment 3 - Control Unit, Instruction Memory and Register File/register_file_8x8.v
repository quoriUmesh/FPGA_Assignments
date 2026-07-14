`timescale 1ps/1ps

// Eight 8-bit registers, with two asynchronous read ports and one write port.
module register_file_8x8(
    input  wire       clk,
    input  wire       rst_n,

    //Read register address for ALU operands. i.e. ALU reads these 
    //registers of address here for operands.
    input  wire [2:0] readreg1,
    input  wire [2:0] readreg2,

    //Answer of ALU is written in this register. Also initial values are stored using this.
    input  wire [2:0] writereg,
    input  wire       writeenable,

    //Data to write into register. Either ALU result or operands loaded into registers.
    input  wire [7:0] writedata,

    //Contents of register address readreg1 and readreg2
    output wire [7:0] regout1,
    output wire [7:0] regout2
);

    //8 8bit registers
    reg [7:0] regs [0:7];
    integer i;

    assign regout1 = regs[readreg1];
    assign regout2 = regs[readreg2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                regs[i] <= 8'h00;
        end else if (writeenable) begin
            regs[writereg] <= writedata;
        end
    end
endmodule
