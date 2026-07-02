`timescale 1ps/1ps

`define N 8

module muxnto1_tb;

reg [`N-1:0] inp;
reg [$clog2(`N)-1:0] sel;

wire d_out;


muxnto1 uut(
    .inp(inp),
    .sel(sel),
    .d_out(d_out)
);


integer i;

initial begin

    $dumpfile("nbmux.vcd");
    $dumpvars(0, muxnto1_tb);


    $monitor("Time=%0t | sel=%b | d_out=%b",
              $time, sel, d_out);


    // give inputs
    inp = 8'b10101010;


    // test all selections
    for(i=0;i<`N;i=i+1) begin
        sel = i;
        #100;
    end


    $finish;

end

endmodule