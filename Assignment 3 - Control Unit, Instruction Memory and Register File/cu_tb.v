`timescale 1ps/1ps

module cu_tb;

reg clk, rst_n;
reg [15:0] instruction;

wire [3:0] readreg2;
wire [3:0] readreg1;
wire [3:0] writereg;
wire writeenable;
wire [3:0] alu_op;


control_unit uut(
    .clk(clk),
    .rst_n(rst_n),
    .instruction(instruction),
    .readreg2(readreg2),
    .readreg1(readreg1),
    .writereg(writereg),
    .writeenable(writeenable),
    .alu_op(alu_op)
);

always #5 clk = ~clk;

initial begin 

    $dumpfile("cu.vcd");
    $dumpvars(0, uut);

    $monitor("Time = %0t | clk = %b rst_n = %b instruction = %b | readreg1 = %b readreg2=%b writereg = %b alu_op=%b",
        $time, clk, rst_n, readreg1,readreg2,writereg,writeenable, alu_op);

        clk = 0 ;
        rst_n = 0;
        
       instruction = 16'h0001;
       #10

       instruction = 16'h00aa;
       #10

       instruction = 16'habab;
       #10
    
    $finish;

end

endmodule
