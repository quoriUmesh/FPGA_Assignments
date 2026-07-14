`timescale 1ps/1ps

module register_file_8x8_tb;
    reg clk, rst_n, writeenable;
    reg [2:0] readreg1, readreg2, writereg;
    reg [7:0] writedata;
    wire [7:0] regout1, regout2;

    register_file_8x8 uut (
        .clk(clk), .rst_n(rst_n),
        .readreg1(readreg1),
        .readreg2(readreg2),
        .writereg(writereg),
        .writeenable(writeenable),
        .writedata(writedata),
        .regout1(regout1),
        .regout2(regout2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_8x8.vcd");
        $dumpvars(0, uut);
        clk = 1'b0;
        rst_n = 1'b0;
        writeenable = 1'b0;
        readreg1 = 3'd0;
        readreg2 = 3'd0;
        writereg = 3'd0;
        writedata = 8'h00;

        #12 rst_n = 1'b1;

        // Write 8'hA5 to R3.
        writereg = 3'd3;
        writedata = 8'hA5;
        writeenable = 1'b1;
        @(posedge clk); #1;
        writeenable = 1'b0;

        readreg1 = 3'd3;
        readreg2 = 3'd0;
        #1;
        if (regout1 !== 8'hA5 || regout2 !== 8'h00) begin
            $display("FAIL: register-file read test failed.");
            $finish;
        end

        $display("PASS: 8x8 register file test completed successfully.");
        $finish;
    end
endmodule
