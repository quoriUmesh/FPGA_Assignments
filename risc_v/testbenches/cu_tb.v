`timescale 1ps/1ps

module cu_tb;
    reg [15:0] instruction;
    wire [2:0] readreg1, readreg2, writereg;
    wire writeenable, alu_uses_immediate, memory_read, memory_write;
    wire branch_equal, jump, halt;
    wire [7:0] immediate;
    wire [3:0] alu_op;

    control_unit dut(.*);

    initial begin
        $dumpfile("cu_tb.vcd");
        $dumpvars(0, cu_tb);
    end

    initial begin
        instruction = 16'h5205; #1;
        if (writereg !== 3'd1 || readreg1 !== 3'd0 || !writeenable || immediate !== 8'd5)
            $display("FAIL CU ADDI decode");
        else
            $display("PASS CU ADDI decode");

        instruction = 16'h7601; #1;
        if (!memory_write || readreg1 !== 3'd0 || readreg2 !== 3'd3 || immediate !== 8'd1)
            $display("FAIL CU STORE decode");
        else
            $display("PASS CU STORE decode");

        instruction = 16'hf000; #1;
        if (!halt)
            $display("FAIL CU HALT decode");
        else
            $display("PASS CU HALT decode");
        $finish;
    end
endmodule
