`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:14:44 12/17/2013
// Design Name:   memory
// Module Name:   F:/C/ISE/My_Processer_v1/test_memory.v
// Project Name:  My_Processer_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_memory;

	// Inputs
	reg reset;
	reg clock;
	reg enable;
	reg start;

	// Instantiate the Unit Under Test (UUT)
	memory uut (
		.reset(reset), 
		.clock(clock), 
		.enable(enable), 
		.start(start)
	);
	
	always #1 clock = ~clock;

	initial begin
	
		$monitor("DATA   :%h %h %h %h %h %h %h %h", 
		uut.d_memory[0],uut.d_memory[1],uut.d_memory[2],uut.d_memory[3],
		uut.d_memory[4],uut.d_memory[5],uut.d_memory[6],uut.d_memory[7],);
		//uut.cpu1.pc,uut.cpu1.id_ir, uut.cpu1.ex_ir,uut.cpu1.mem_ir,uut.cpu1.wb_ir,
		//uut.cpu1.d_we, uut.cpu1.d_addr, uut.cpu1.d_dataout);
		
		enable <= 1; start <= 0; clock <= 0;
		#10 reset <= 0;
		#10 reset <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
		#2000
		$display("ADDRESS:m[0]:m[1]:m[2]:m[3]:m[4]:m[5]:m[6]:m[7]");
	end
      
endmodule

