`timescale 1ps/1ps

// Combinational decoder for the small 8-bit processor.
module control_unit(
  input wire [15:0] instruction,
  output reg [2:0] readreg1,
  output reg [2:0] readreg2,
  output reg [2:0] writereg,
  output reg writeenable,
  output reg [7:0] immediate,
  output reg [3:0] alu_op,
  output reg alu_uses_immediate,
  output reg memory_read,
  output reg memory_write,
  output reg branch_equal,
  output reg jump,
  output reg halt
);
  wire [3:0] opcode = instruction[15:12];

  always @(*) begin
    readreg1 = instruction[8:6];
    readreg2 = instruction[5:3];
    writereg = instruction[11:9];
    writeenable = 1'b0;
    immediate = {{2{instruction[5]}}, instruction[5:0]};
    alu_op = 4'b0000;
    alu_uses_immediate = 1'b0;
    memory_read = 1'b0;
    memory_write = 1'b0;
    branch_equal = 1'b0;
    jump = 1'b0;
    halt = 1'b0;

    case (opcode)
      4'h0: begin writeenable = 1'b1; alu_op = 4'h0; end
      4'h1: begin writeenable = 1'b1; alu_op = 4'h1; end
      4'h2: begin writeenable = 1'b1; alu_op = 4'h2; end
      4'h3: begin writeenable = 1'b1; alu_op = 4'h3; end
      4'h4: begin writeenable = 1'b1; alu_op = 4'h4; end
      4'h5: begin writeenable = 1'b1; alu_op = 4'h0; alu_uses_immediate = 1'b1; end
      4'h6: begin writeenable = 1'b1; alu_op = 4'h0; alu_uses_immediate = 1'b1; memory_read = 1'b1; end
      4'h7: begin
        readreg2 = instruction[11:9];
        alu_op = 4'h0;
        alu_uses_immediate = 1'b1;
        memory_write = 1'b1;
      end
      4'h8: branch_equal = 1'b1;
      4'h9: jump = 1'b1;
      4'hf: halt = 1'b1;
      default: begin end
    endcase
  end
endmodule

