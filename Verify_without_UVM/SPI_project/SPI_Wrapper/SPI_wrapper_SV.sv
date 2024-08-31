module SPI_Wrapper(interface_SPI.DUT_Wrapper inst_interface );
	//(MOSI, SS_n, clk, rst_n, MISO);
	logic MOSI, SS_n, clk, rst_n;
	logic MISO;
	logic rx_valid_wrapper, tx_valid_wrapper;
	logic [9:0] rx_data_wrapper;
	logic [7:0] tx_data_wrapper;

	assign clk   = inst_interface.clk ;
	assign SS_n  = inst_interface.SS_n ;
	assign rst_n = inst_interface.rst_n ;
	assign MOSI = inst_interface.MOSI ;
	assign inst_interface.MISO = MISO ; 

	SPI_Slave_wrapper DUT (MOSI, SS_n, clk, rst_n, tx_data_wrapper, tx_valid_wrapper, MISO, rx_data_wrapper, rx_valid_wrapper);
	Dp_Sync_RAM_wrapper RAM (clk, rst_n, rx_data_wrapper, rx_valid_wrapper, tx_data_wrapper, tx_valid_wrapper);

endmodule
