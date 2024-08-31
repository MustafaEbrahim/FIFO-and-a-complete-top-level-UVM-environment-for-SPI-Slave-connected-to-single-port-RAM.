interface interface_SPI (clk);
	//(MOSI, SS_n, clk, rst_n, MISO);
   	input bit clk ;
	logic MOSI, SS_n, rst_n;
	logic MISO;

	modport DUT_Wrapper (input clk , rst_n , MOSI , SS_n,
		                     output MISO);

	modport TESTBENCH  (input clk, MISO ,
	                   output  rst_n, SS_n, MOSI);

endinterface 
