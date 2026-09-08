`timescale 1ps/1ps

module data_memory_tb;
    reg clk = 1'b0;
    reg writeenable;
    reg [7:0] address, writedata;
    wire [7:0] readdata;

    data_memory dut(.clk(clk), .writeenable(writeenable), .address(address),
                    .writedata(writedata), .readdata(readdata));
    always #5 clk = ~clk;

    initial begin
        $dumpfile("data_memory_tb.vcd");
        $dumpvars(0, data_memory_tb);
    end

    initial begin
        address = 8'd3; writedata = 8'ha5; writeenable = 1'b1;
        @(posedge clk); #1;
        writeenable = 1'b0; #1;
        if (readdata !== 8'ha5) $display("FAIL DATA MEMORY readback");
        else $display("PASS DATA MEMORY readback=%h", readdata);
        $finish;
    end
endmodule
