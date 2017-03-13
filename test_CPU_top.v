`timescale 1ns / 1ps
`define exec 1'b1
`define idle 1'b0
`define HALT 5'b00001
`define LOAD 5'b00010
`define STORE 5'b00011
`define ADD 5'b01000
`define BZ 5'b11010
`define BN 5'b11100
`define CMP 5'b01100
`define gr0 3'b000
`define gr1 3'b001
`define gr2 3'b010
`define gr3 3'b011
`define NOP 5'b00000
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:48:21 12/14/2013
// Design Name:   CPU_top
// Module Name:   F:/C/ISE/My_Processer_v1/test_CPU_top.v
// Project Name:  My_Processer_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_CPU_top;

	// Inputs
	reg reset;
	reg clock;
	reg enable;
	reg start;
	reg [15:0] i_datain;
	reg [15:0] d_datain;

	// Outputs
	wire d_we;
	wire [7:0] i_addr;
	wire [7:0] d_addr;
	wire [15:0] d_dataout;

	// Instantiate the Unit Under Test (UUT)
	CPU_top uut (
		.reset(reset), 
		.clock(clock), 
		.enable(enable), 
		.start(start), 
		.i_datain(i_datain), 
		.d_datain(d_datain), 
		.d_we(d_we), 
		.i_addr(i_addr), 
		.d_addr(d_addr), 
		.d_dataout(d_dataout)
	);
	always #5 clock = ~clock;
	initial begin
		//************************************************//
		//* You need to complete the testbench below     *//
		//* by yourself according to your operation set  *//
		//************************************************//

		//************* test pattern *************//	
		/*
		$display("pc:\tid_ir:\t\treg_A:\treg_B:\treg_C:\td_addr:\td_dataout:\td_we:\treC1:\tgr1:\tgr2:\tgr3");
		$monitor("%h:\t%b:\t%h:\t%h:\t%h:\t%h:\t%h:\t%b:\t%h:\t%h:\t%h:\t%h", 
			uut.pc, uut.id_ir, uut.reg_A, uut.reg_B, uut.reg_C,
			d_addr, d_dataout, d_we, uut.reg_C1, uut.gr[1], uut.gr[2], uut.gr[3], uut.zf);
		*/
		$monitor("%h %h %h",uut.pc, uut.reg_C, uut.nf);
		enable <= 1; start <= 0; i_datain <= 0; d_datain <= 0; clock <= 0;

		#10 reset <= 0;
		#10 reset <= 1;
		#10 enable <= 1;
		#10 start <=1;
		#10 start <= 0;
		
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= 16'b01000_001_0001_0001;
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= 16'b01001_010_0000_0001;
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`HALT, 11'b000_0000_0000};
		/*
			i_datain <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0000};
		#10 i_datain <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0001};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
			d_datain <=16'h00AB;  // 3 clk later from LOAD
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
			d_datain <=16'h3C00;  // 3 clk later from LOAD
		#10 i_datain <= {`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`NOP, 11'b000_0000_0000};
		#10 i_datain <= {`STORE, `gr3, 1'b0, `gr0, 4'b0010};
		#10 i_datain <= {`HALT, 11'b000_0000_0000};
		*/
	end
      
endmodule

