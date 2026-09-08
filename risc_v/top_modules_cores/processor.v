`timescale 1ps/1ps

module processor(
	input wire clk,
	input wire rst_n,
	output wire [3:0] pc_out,
	output wire halted
);
	reg [3:0] pc;
	wire [15:0] instruction;
	wire [2:0] readreg1, readreg2, writereg;
	wire writeenable, alu_uses_immediate, memory_read, memory_write;
	wire branch_equal, jump, halt;
	wire [7:0] immediate;
	wire [3:0] alu_op;
	wire [7:0] regout1, regout2;
	wire [7:0] alu_b;
	wire [7:0] alu_result;
	wire [7:0] memory_data;
	wire [7:0] write_data;
	wire alu_carry;
	wire alu_zero;
	reg [3:0] next_pc;
	reg halted_reg;

	instruction_memory imem(.address(pc), .instruction(instruction));
	control_unit cu(
		.instruction(instruction),
        .readreg1(readreg1), 
        .readreg2(readreg2),
		.writereg(writereg), 
        .writeenable(writeenable), 
        .immediate(immediate),
		.alu_op(alu_op), 
        .alu_uses_immediate(alu_uses_immediate),
		.memory_read(memory_read), 
        .memory_write(memory_write),
		.branch_equal(branch_equal), 
        .jump(jump), 
        .halt(halt)
	);
	register_file_8x8 regs(
		.clk(clk), .rst_n(rst_n), 
        .readreg1(readreg1), 
        .readreg2(readreg2),
		.writereg(writereg), 
        .writeenable(writeenable && !halted_reg),
		.writedata(write_data), 
        .regout1(regout1), 
        .regout2(regout2)
	);
	alu datapath_alu(.A(regout1), 
        .B(alu_b), 
        .sel(alu_op),
		.result(alu_result), 
        .carry(alu_carry), 
        .zero(alu_zero));

	data_memory dmem(.clk(clk), 
        .writeenable(memory_write && !halted_reg),
		.address(alu_result), 
        .writedata(regout2), 
        .readdata(memory_data));

	assign alu_b = alu_uses_immediate ? immediate : regout2;
	assign write_data = memory_read ? memory_data : alu_result;
	assign pc_out = pc;
	assign halted = halted_reg;

	always @(*) begin
		next_pc = pc + 1'b1;
		if (branch_equal && (regout1 == regout2))
			next_pc = pc + immediate[3:0];
		if (jump)
			next_pc = instruction[3:0];
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			pc <= 4'h0;
			halted_reg <= 1'b0;
		end else if (!halted_reg) begin
			pc <= next_pc;
			if (halt)
				halted_reg <= 1'b1;
		end
	end
endmodule
