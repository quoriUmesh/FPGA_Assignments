`timescale 1ps/1ps

`define N 8

module muxnto1(
    input [`N-1:0] inp,
    input [$clog2(`N)-1:0] sel,
    output reg d_out
);

always @(*) begin
    
    d_out = inp[sel];    

end

endmodule