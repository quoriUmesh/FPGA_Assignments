`timescale 1ps/1ps

module alu_tb;
    reg [7:0] a, b;
    reg [3:0] sel;
    wire [7:0] result;
    wire carry, zero;

    alu dut(.A(a), .B(b), .sel(sel), .result(result), .carry(carry), .zero(zero));

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    task check;
        input [7:0] expected;
        begin
            #1;
            if (result !== expected)
                $display("FAIL ALU sel=%h result=%h expected=%h", sel, result, expected);
            else
                $display("PASS ALU sel=%h result=%h", sel, result);
        end
    endtask

    initial begin
        a = 8'd9; b = 8'd4;
        sel = 4'h0; check(8'd13);
        sel = 4'h1; check(8'd5);
        sel = 4'h2; check(8'd0);
        sel = 4'h3; check(8'd13);
        sel = 4'h4; check(8'd13);
        $finish;
    end
endmodule
