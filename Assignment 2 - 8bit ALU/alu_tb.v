`timescale 1ns/1ps

module alu_tb;

reg [7:0] A;
reg [7:0] B;
reg [3:0] sel;

wire [7:0] result;
wire carry;
wire zero;

alu uut(
    .A(A),
    .B(B),
    .sel(sel),
    .result(result),
    .carry(carry),
    .zero(zero)
);

initial begin

    $dumpfile("alu.vcd");
    $dumpvars(0,alu_tb);

    $monitor("Time=%0t A=%d B=%d sel=%b Result=%d Carry=%b Zero=%b",
             $time,A,B,sel,result,carry,zero);

    A = 8'd25;
    B = 8'd10;

    sel = 4'b0000; #10;   // Add
    sel = 4'b0001; #10;   // Sub
    sel = 4'b0010; #10;   // AND
    sel = 4'b0011; #10;   // OR
    sel = 4'b0100; #10;   // XOR
    sel = 4'b0101; #10;   // NOT
    sel = 4'b0110; #10;   // Shift Left
    sel = 4'b0111; #10;   // Shift Right
    sel = 4'b1000; #10;   // Increment
    sel = 4'b1001; #10;   // Decrement

    A = 8'd255;
    B = 8'd1;
    sel = 4'b0000; #10;   // Overflow

    $finish;

end

endmodule