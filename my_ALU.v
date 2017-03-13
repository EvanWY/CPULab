`timescale 1ns / 1ps

`define exec 1'b1
`define idle 1'b0

`define NOP 5'b00000
`define HALT 5'b00001
`define LOAD 5'b00010
`define STORE 5'b00011

`define LDIH 5'b10000
`define ADD 5'b01000
`define ADDI 5'b01001
`define ADDC 5'b10001
`define SUB 5'b01010
`define SUBI 5'b01011
`define SUBC 5'b10010

`define CMP 5'b01100
`define AND 5'b01101
`define OR 5'b01110
`define XOR 5'b01111

`define SLL 5'b00100
`define SRL 5'b00110
`define SLA 5'b00101
`define SRA 5'b00111

`define JUMP 5'b11000
`define JMPR 5'b11001
`define BZ 5'b11010
`define BNZ 5'b11011
`define BN 5'b11100
`define BNN 5'b11101
`define BC 5'b11110
`define BNC 5'b11111

`define NOT 5'b10100
`define NAND 5'b10101
`define NOR 5'b10110
`define XNOR 5'b10111

`define LDIL 5'b10011

module my_ALU(
	input [15:0] in_A,
	input [15:0] in_B,
	input [4:0] in_op,
	input in_cf,
	output reg [15:0] out_C,
	output reg out_cf);

reg [15:0] real_B;
reg [15:0] real_A;
reg real_cf;

always @ (*) begin

//********************** 预处理 **********************
	//处理真实进位信息in_op，一般情况下置为0，遇到减法置为0，遇到需要进位的加或者减，就读取in_cf
	if (in_op==`ADDC || in_op==`SUBC)
		real_cf = in_cf;
	else if (in_op==`SUB || in_op==`SUBI || in_op==`CMP)
		real_cf = 1'b1;
	else
		real_cf = 1'b0;
		
	//处理真实的被加数real_B，遇到减法则取反码（能够与进位构成补码）
	if (in_op==`SUB || in_op==`SUBI ||in_op==`SUBC ||in_op==`CMP)
		real_B = ~in_B;
	else
		real_B = in_B;
		
	//处理真实的real_A
	real_A = in_A;
		
//********************** 计算逻辑（同时处理进位标志位） **********************
	if (in_op == `AND) begin
		out_C = real_A & real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `OR) begin
		out_C = real_A | real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `XOR) begin
		out_C = real_A ^ real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `NOT) begin
		out_C = ~real_A;
		out_cf = 1'b0;
	end
	if (in_op == `NAND) begin
		out_C = ~(real_A & real_B);
		out_cf = 1'b0;
	end
	else if (in_op == `NOR) begin
		out_C = ~(real_A | real_B);
		out_cf = 1'b0;
	end
	else if (in_op == `XNOR) begin
		out_C = ~(real_A ^ real_B);
		out_cf = 1'b0;
	end
	else if (in_op == `SLL) begin
		out_C = real_A << real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `SRL) begin
		out_C = real_A >> real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `SLA) begin
		out_C = real_A <<< real_B;
		out_cf = 1'b0;
	end
	else if (in_op == `SRA) begin
		out_C = real_A >>> real_B;
		out_cf = 1'b0;
	end
	
	else if (in_op == `NOP || in_op == `HALT || in_op == `JUMP || in_op == `LDIL) begin
		out_C = real_B;
		out_cf = 1'b0;
	end
	
	else if (in_op == `LOAD || in_op == `STORE || in_op == `LDIH || in_op == `ADD || in_op == `ADDI
			|| in_op == `ADDC || in_op == `SUB || in_op == `SUBI || in_op == `SUBC || in_op == `CMP || in_op == `JMPR
			|| in_op == `BZ || in_op == `BNZ || in_op == `BN || in_op == `BNN || in_op == `BC || in_op == `BNC)
		{out_cf , out_C} = real_A + real_B + real_cf;
		
end


//*********************** FLAG处理 **************************

endmodule
