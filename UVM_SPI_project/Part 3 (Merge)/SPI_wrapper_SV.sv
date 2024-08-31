module SPI_Wrapper(SS_n,clk,rst_n,MOSI,MISO );
	//(MOSI, SS_n, clk, rst_n, MISO);
	input logic MOSI, SS_n, clk, rst_n;
	output logic MISO;
	logic rx_valid_wrapper, tx_valid_wrapper,tx_valid_ref;
	logic [9:0] rx_data_wrapper;
	logic [7:0] tx_data_wrapper,tx_ref;
	assign tx_data_wrapper = tx_ref ;
	assign tx_valid_wrapper= tx_valid_ref;
	SPI_Slave_wrapper DUT_2 (MOSI, SS_n, clk, rst_n, tx_data_wrapper, tx_valid_wrapper, MISO, rx_data_wrapper, rx_valid_wrapper);
endmodule
