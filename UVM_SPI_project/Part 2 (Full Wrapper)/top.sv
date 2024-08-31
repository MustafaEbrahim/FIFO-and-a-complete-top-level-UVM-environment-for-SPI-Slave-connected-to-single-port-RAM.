import SPI_test_pkg::*; // import for test package
import uvm_pkg::*; //import uvm package
`include "uvm_macros.svh" //import macros
module top ();
	bit clk ; 
	//Clock Generation
	initial begin
		forever 
		#1 clk = ~clk ;
	end
	//instatiate design (ALSU) and interface and pass clock tot he interface
	SPI_if SPIif (clk);
	SPI_Wrapper DUT(SPIif.SS_n,SPIif.clk,SPIif.rst_n,SPIif.MOSI,SPIif.MISO );
	initial begin
		uvm_config_db#(virtual SPI_if)::set(null,"uvm_test_top","SPI_IF",SPIif);
		run_test ("SPI_test");
	end
endmodule 
