`timescale 1ps/1ps

module processor_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    wire [3:0] pc;
    wire halted;

    processor dut(.clk(clk), .rst_n(rst_n), .pc_out(pc), .halted(halted));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);
    end

    initial begin
        // ADDI r1, r0, 5; ADDI r2, r0, 7; ADD r3, r1, r2; ST r3, [r0+1]; HALT
        dut.imem.memory[0] = 16'h5205;
        dut.imem.memory[1] = 16'h5407;
        dut.imem.memory[2] = 16'h0650;
        dut.imem.memory[3] = 16'h7601;
        dut.imem.memory[4] = 16'hf000;
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        wait (halted);
        #1;
        if (dut.regs.regs[3] !== 8'd12 || dut.dmem.memory[1] !== 8'd12)
            $display("FAIL: r3=%0d memory[1]=%0d", dut.regs.regs[3], dut.dmem.memory[1]);
        else
            $display("PASS: r3=%0d memory[1]=%0d", dut.regs.regs[3], dut.dmem.memory[1]);
        $finish;
    end
endmodule