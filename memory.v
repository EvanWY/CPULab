`timescale 1ns / 1ps

module memory(
	input reset,
	input clock,
	input enable,
	input start,
	output [15:0] mem
	);

reg [15:0] i_memory[0:127];
reg [15:0] d_memory[0:127];

wire [15:0] i_datain;
wire [15:0] d_datain;
wire [7:0] i_addr;
wire [7:0] d_addr;
wire [15:0] d_dataout;

wire write_enable;
assign mem = d_memory[0];

assign i_datain = i_memory[i_addr[7:0]];
assign d_datain = d_memory[d_addr[7:0]];

initial
	$readmemb("bin_code.mem", i_memory);

always @ (*)
	if (write_enable)
		d_memory[d_addr[7:0]] = d_dataout;

CPU_top cpu1(
	.reset(reset),
	.clock(clock),
	.enable(enable),
	.start(start),
	.i_datain(i_datain),
	.d_datain(d_datain),
	.d_we(write_enable),
	.i_addr(i_addr),
	.d_addr(d_addr),
	.d_dataout(d_dataout)
);

endmodule
