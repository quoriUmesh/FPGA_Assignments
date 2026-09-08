`timescale 1ps/1ps

module register_file_8x8_tb;
    reg clk = 1'b0, rst_n = 1'b0;
    reg [2:0] readreg1, readreg2, writereg;
    reg writeenable;
    reg [7:0] writedata;
    wire [7:0] regout1, regout2;

    register_file_8x8 dut(.*);
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_8x8_tb.vcd");
        $dumpvars(0, register_file_8x8_tb);
    end

    initial begin
        readreg1 = 0; readreg2 = 0; writereg = 3; writedata = 8'h5a; writeenable = 0;
        #2 rst_n = 1'b1;
        writeenable = 1'b1;
        @(posedge clk); #1;
        writeenable = 1'b0; readreg1 = 3;
        #1;
        if (regout1 !== 8'h5a) $display("FAIL REGISTER FILE readback");
        else $display("PASS REGISTER FILE readback=%h", regout1);
        $finish;
    end
endmodule
