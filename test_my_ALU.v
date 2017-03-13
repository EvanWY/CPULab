`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:04:17 12/16/2013
// Design Name:   my_ALU
// Module Name:   F:/C/ISE/My_Processer_v1/test_my_ALU.v
// Project Name:  My_Processer_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: my_ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_my_ALU;

	// Inputs
	reg [15:0] in_A;
	reg [15:0] in_B;
	reg [4:0] in_op;
	reg in_cf;

	// Outputs
	wire [15:0] out_C;
	wire out_zf;
	wire out_nf;
	wire out_cf;

	// Instantiate the Unit Under Test (UUT)
	my_ALU uut (
		.in_A(in_A), 
		.in_B(in_B), 
		.in_op(in_op), 
		.in_cf(in_cf), 
		.out_C(out_C), 
		.out_zf(out_zf), 
		.out_nf(out_nf), 
		.out_cf(out_cf)
	);

	initial begin
		// Initialize Inputs
		in_A = 0;
		in_B = 0;
		in_op = 5'b01000;
		in_cf = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		in_A = 3;
		in_B = 4;
        
		// Add stimulus here

	end
      
endmodule

