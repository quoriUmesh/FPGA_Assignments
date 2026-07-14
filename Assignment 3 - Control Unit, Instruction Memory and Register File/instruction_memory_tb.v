`timescale 1ps/1ps

module instruction_memory_tb;
    reg [3:0] address;
    wire [15:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("instruction_memory.vcd");
        $dumpvars(0, uut);

        uut.memory[0] = 16'h0123;
        uut.memory[1] = 16'h4567;

        address = 4'd0;
        #10;
        if (instruction !== 16'h0123) begin
            $display("FAIL: incorrect instruction at address 0.");
            $finish;
        end

        address = 4'd1;
        #10;
        if (instruction !== 16'h4567) begin
            $display("FAIL: incorrect instruction at address 1.");
            $finish;
        end

        $display("PASS: instruction memory test completed successfully.");
        $finish;
    end
endmodule
