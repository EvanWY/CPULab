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

module CPU_top(
	input reset,
	input clock,
	input enable,
	input start,
	input [15:0] i_datain,
	input [15:0] d_datain,
	output d_we,
	output [7:0] i_addr,
	output [7:0] d_addr,
	output [15:0] d_dataout);

reg state;
reg next_state;
reg [7:0] pc;
reg [15:0] id_ir;
reg [7:0] ex_ir;
reg [7:0] mem_ir;
reg [7:0] wb_ir;
reg [15:0] gr[0:7];
reg [15:0] reg_B;
reg [15:0] reg_A;
reg [15:0] smdr;
reg [2:0] flag;
reg nf;
reg zf;
reg cf;
reg [15:0] reg_C;
reg dw;
reg cf0;
reg [15:0] smdr1;
reg [15:0] reg_C1;

wire [15:0] ALUo;
wire w_nf;
wire w_zf;
wire w_cf;


//************* CPU control *************//
always @(posedge clock)
	begin
		if (!reset)
			state <= `idle;
		else
			state <= next_state;
	end
	
always @(*)
	begin
		case (state)
			`idle : 
				if ((enable == 1'b1) && (start == 1'b1))
					next_state <= `exec;
				else	
					next_state <= `idle;
			`exec :
				if ((enable == 1'b0) || (wb_ir[7:3] == `HALT))
					next_state <= `idle;
				else
					next_state <= `exec;
		endcase
	end
	
	
	
//************* IF *************//
always @(posedge clock or negedge reset)
		if (!reset)
			begin
				id_ir <= 16'b0000_0000_0000_0000;
				pc <= 8'b0000_0000;
			end
			
		else if (state ==`exec)
			begin
				id_ir <= i_datain;
				
				if(((mem_ir[7:3] == `BZ)&& (zf == 1'b1)) 
				|| ((mem_ir[7:3] == `BNZ)&& (zf == 1'b0))
				|| ((mem_ir[7:3] == `BN)&& (nf == 1'b1))
				|| ((mem_ir[7:3] == `BNN)&& (nf == 1'b0))
				|| ((mem_ir[7:3] == `BC)&& (cf == 1'b1))
				|| ((mem_ir[7:3] == `BNC)&& (cf == 1'b0))
				|| (mem_ir[7:3] == `JUMP)
				|| (mem_ir[7:3] == `JMPR))
					pc <= reg_C[7:0];
				else
					pc <= pc + 1;
			end

//************* ID *************//
always @(posedge clock or negedge reset)
		if (!reset)
			begin
				reg_A <= 0;reg_B<=0;smdr<=0;ex_ir<=0;
			end
		else if (state == `exec)
			begin
			//********IR指令寄存器移位********
				ex_ir <= id_ir[15:8];
				
			//********smdr内存输入数据寄存器移位********
				if (id_ir[15:11] == `STORE)
					smdr <= gr[id_ir[10:8]];
					
			//************ reg_A ****************
				if (id_ir[15:14] == 2'b11 || ({id_ir[15:13], id_ir[11]} == 4'b0101) || (id_ir[15:11] == `LDIH))
					reg_A <= gr[id_ir[10:8]];
				else
					reg_A <= gr[id_ir[6:4]];
					
			//************ reg_B ****************
				if (id_ir[15:11] == `LDIH)
					reg_B <= {id_ir[7:0], 8'b0000_0000};
				else if (id_ir[15:14] == 2'b11 || ({id_ir[15:13], id_ir[11]} == 4'b0101) ||  id_ir[15:11] == `LDIL)
					reg_B <= {8'b0000_0000, id_ir[7:0]};
				else if (id_ir[15:12] == 4'b0001 || id_ir[15:13] == 3'b001)
					reg_B <= {12'b0000_0000_0000, id_ir[3:0]};
				else
					reg_B <= gr[id_ir[2:0]];
			end
			
//****** ALU 模块加载 **********		
my_ALU alu(
	.in_A(reg_A),
	.in_B(reg_B),
	.in_op(ex_ir[7:3]),
	.in_cf(cf0),
	.out_C(ALUo),
	.out_cf(w_cf)
);

//************* EX *************//	
always @(posedge clock or negedge reset)
		if (!reset)
			begin
				mem_ir <= 0; zf<=0; nf<=0; cf<=0;
				reg_C <= 0; dw <= 0; smdr1 <=0;
			end
		else if (state == `exec)
			begin
			//********IR指令寄存器移位********
				mem_ir <= ex_ir;
			//********reg_C结果寄存器********
				reg_C <= ALUo;
			//********* flag *************
				zf <= (reg_C == 16'b0000_0000_0000_0000) ? 1'b1 : 1'b0;
				nf <= reg_C[15];
				cf <= cf0;
				cf0 <= w_cf;
			//************ 处理smdr1以及dw ***************
				if (ex_ir[7:3] == `STORE)
					begin
						dw <= 1'b1;
						smdr1 <= smdr;
					end
				else
					dw <= 1'b0;
			end

//************* MEM *************//
always @(posedge clock or negedge reset)
		if (!reset)
			begin
				wb_ir <= 0;
				reg_C1 <= 0;
			end
		else if (state == `exec)
			begin
				wb_ir <= mem_ir;
				
				if (mem_ir[7:3] == `LOAD)
					reg_C1 <= d_datain;
				else
					reg_C1 <= reg_C;
			end
			
		
//************* WB *************//
always @(posedge clock or negedge reset)
		if (!reset)
			begin
				gr[0]<=0;gr[1]<=0;gr[2]<=0;gr[3]<=0;
				gr[4]<=0;gr[5]<=0;gr[6]<=0;gr[7]<=0;
			end
		else if (state == `exec)
			begin
				if (!(wb_ir[7:6] == 2'b11 || wb_ir[7:3] == `NOP || wb_ir[7:3] == `HALT 
				|| wb_ir[7:3] == `CMP || wb_ir[7:3] == `STORE))
					gr[wb_ir[2:0]] <= reg_C1;
			end
	
assign i_addr = pc;
assign d_addr = reg_C[7:0];
assign d_dataout = smdr1;
assign d_we = dw;

endmodule
