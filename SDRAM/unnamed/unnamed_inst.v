	unnamed u0 (
		.clk           (<connected-to-clk>),           //                clk.clk
		.reset         (<connected-to-reset>),         //              reset.reset
		.SRAM_DQ       (<connected-to-SRAM_DQ>),       // external_interface.DQ
		.SRAM_ADDR     (<connected-to-SRAM_ADDR>),     //                   .ADDR
		.SRAM_LB_N     (<connected-to-SRAM_LB_N>),     //                   .LB_N
		.SRAM_UB_N     (<connected-to-SRAM_UB_N>),     //                   .UB_N
		.SRAM_CE_N     (<connected-to-SRAM_CE_N>),     //                   .CE_N
		.SRAM_OE_N     (<connected-to-SRAM_OE_N>),     //                   .OE_N
		.SRAM_WE_N     (<connected-to-SRAM_WE_N>),     //                   .WE_N
		.address       (<connected-to-address>),       //  avalon_sram_slave.address
		.byteenable    (<connected-to-byteenable>),    //                   .byteenable
		.read          (<connected-to-read>),          //                   .read
		.write         (<connected-to-write>),         //                   .write
		.writedata     (<connected-to-writedata>),     //                   .writedata
		.readdata      (<connected-to-readdata>),      //                   .readdata
		.readdatavalid (<connected-to-readdatavalid>)  //                   .readdatavalid
	);

