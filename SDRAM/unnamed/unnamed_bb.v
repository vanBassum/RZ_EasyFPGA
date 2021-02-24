
module unnamed (
	clk,
	reset,
	SRAM_DQ,
	SRAM_ADDR,
	SRAM_LB_N,
	SRAM_UB_N,
	SRAM_CE_N,
	SRAM_OE_N,
	SRAM_WE_N,
	address,
	byteenable,
	read,
	write,
	writedata,
	readdata,
	readdatavalid);	

	input		clk;
	input		reset;
	inout	[15:0]	SRAM_DQ;
	output	[19:0]	SRAM_ADDR;
	output		SRAM_LB_N;
	output		SRAM_UB_N;
	output		SRAM_CE_N;
	output		SRAM_OE_N;
	output		SRAM_WE_N;
	input	[19:0]	address;
	input	[1:0]	byteenable;
	input		read;
	input		write;
	input	[15:0]	writedata;
	output	[15:0]	readdata;
	output		readdatavalid;
endmodule
