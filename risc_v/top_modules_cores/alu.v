`timescale 1ps/1ps

// The assignment ALU, kept locally so the CPU folder is self-contained.
module alu(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [3:0] sel,
    output reg [7:0] result,
    output reg carry,
    output wire zero
);
    assign zero = (result == 8'h00);

    always @(*) begin
        carry = 1'b0;
        case (sel)
            4'h0: {carry, result} = A + B;
            4'h1: {carry, result} = A - B;
            4'h2: result = A & B;
            4'h3: result = A | B;
            4'h4: result = A ^ B;
            default: result = 8'h00;
        endcase
    end
endmodule