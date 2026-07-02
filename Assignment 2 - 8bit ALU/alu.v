module alu(
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] sel,

    output reg [7:0] result,
    output reg carry,
    output zero
);

always @(*) begin

    carry = 0;

    case(sel)

        4'b0000: begin
            {carry,result} = A + B;
        end

        4'b0001: begin
            {carry,result} = A - B;
        end

        4'b0010: begin
            result = A & B;
        end

        4'b0011: begin
            result = A | B;
        end

        4'b0100: begin
            result = A ^ B;
        end

        4'b0101: begin
            result = ~A;
        end

        4'b0110: begin
            result = A << 1;
        end

        4'b0111: begin
            result = A >> 1;
        end

        4'b1000: begin
            result = A + 1;
        end

        4'b1001: begin
            result = A - 1;
        end

        default: begin
            result = 8'b00000000;
            carry = 0;
        end

    endcase

end


endmodule