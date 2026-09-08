`timescale 1ps/1ps

module instruction_memory_tb;
    reg [3:0] address;
    wire [15:0] instruction;

    instruction_memory dut(.address(address), .instruction(instruction));

    initial begin
        $dumpfile("instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);
    end

    initial begin
        dut.memory[0] = 16'h1234;
        dut.memory[15] = 16'habcd;
        address = 4'd0; #1;
        if (instruction !== 16'h1234) $display("FAIL IMEM address 0");
        else $display("PASS IMEM address 0");
        address = 4'd15; #1;
        if (instruction !== 16'habcd) $display("FAIL IMEM address 15");
        else $display("PASS IMEM address 15");
        $finish;
    end
endmodule
