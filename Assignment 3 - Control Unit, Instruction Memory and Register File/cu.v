`timescale 1ps/1ps

module control_unit(
    input wire clk, rst_n,
    input wire [15:0] instruction,
    
    output reg [7:0] pc,
    //Register file control signals
    output reg [3:0] readreg2,
    output reg [3:0] readreg1,
    output reg [3:0] writereg,
    output reg       writeenable,
    //datapath mux contorls

    output reg [7:0] immediate,
    output reg  sel_2s_complement,
    output reg  sel_opreranad1,

    //ALU control signals
    output reg [3:0] alu_op

);


assign opcode = instruction[15:12];
assign source1 = instruction[11:8];
assign source2 = instruction[7:4];
assign destination = instruction[3:0];


//create a rising edge clock trigger
always @(posedge clk or negedge rst_n) begin

if(!rst_n) begin 
    readreg1 <= 0;
    readreg2 <= 0;
    writereg <= 0;
    writeenable <= 0;
end else begin
            
   case (instruction[15:12])
  
    4'b0000: begin //ADD
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 0;
   end

      4'b0001: begin //SUB
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 1;

   end

     4'b0010: begin //AND
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 2;
   end

     4'b0011: begin //OR
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 3;
   end

     4'b0100: begin //XOR
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 4;
   end
   
     4'b0101: begin //Increment
        readreg1 <= source1;
        writereg <= source1;
        writeenable <= 1'b1;
        alu_op <= 5;
   end

     4'b0110: begin //Decrement
        readreg1 <= source1;
        writereg <= source1;
        writeenable <= 1'b1;
        alu_op <= 6;
   end

      4'b0111: begin //CMP
        readreg1 <= source1; 
        readreg2 <= source2;
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 7;
   end

    4'b1000: begin //LOAD
        readreg1 <= source1; 
        writereg <= destination;
        writeenable <= 1'b1;
        alu_op <= 8;

    end
   default : writeenable <= 0;
   
   endcase
end //else end

end  //always end

always @(*) begin 
    pc <= pc + 1;
end


endmodule

