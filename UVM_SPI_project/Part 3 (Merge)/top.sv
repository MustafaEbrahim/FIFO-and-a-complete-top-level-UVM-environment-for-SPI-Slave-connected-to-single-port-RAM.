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
	RAM_if RAMif ();

	SPI_Wrapper DUT (SPIif.SS_n,SPIif.clk,SPIif.rst_n,SPIif.MOSI,SPIif.MISO );
	Dp_Sync_RAM_wrapper DUT_RAM (RAMif.rst_n, RAMif.din, RAMif.rx_valid, RAMif.dout, RAMif.tx_valid);

    assign RAMif.rst_n =SPIif.rst_n ;
    assign RAMif.din = DUT.rx_data_wrapper ;
    assign RAMif.rx_valid = DUT.rx_valid_wrapper;
    assign DUT.tx_valid_ref=RAMif.tx_valid ;
    assign DUT.tx_ref = RAMif.dout ;
	
	initial begin
		uvm_config_db#(virtual SPI_if)::set(null,"uvm_test_top","SPI_IF",SPIif);
		uvm_config_db#(virtual RAM_if)::set(null,"uvm_test_top","RAM_IF",RAMif);
		run_test ("SPI_test");
	end
endmodule 
