interface interface_SPI (clk);
	
   	input bit clk ;
   	parameter IDLE = 0;
	parameter CHK_CMD = 1;
	parameter WRITE = 2;
	parameter READ_ADD = 3;
	parameter READ_DATA = 4;
    
	logic MOSI, SS_n, rst_n, tx_valid;
	logic [7:0] tx_data;
	logic MISO,MISO_expected;
	logic rx_valid , rx_valid_expected;
	logic  [9:0] rx_data , rx_data_expected;

	modport DUT_Design (input clk, rst_n, SS_n, MOSI, tx_valid ,tx_data,
	                   output MISO, rx_valid , rx_data);


	modport TESTBENCH  (input clk, MISO , rx_valid , rx_data,
		                MISO_expected , rx_valid_expected , rx_data_expected,
	                   output  rst_n, SS_n, MOSI, tx_valid ,tx_data );

	modport GOLDEN_REF(input clk, rst_n, SS_n, MOSI, tx_valid ,tx_data,
	                   output MISO_expected , rx_valid_expected , rx_data_expected );
endinterface 
