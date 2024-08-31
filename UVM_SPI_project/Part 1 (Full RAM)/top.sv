import RAM_test_pkg::*; // import for test package
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
	RAM_if RAMif (clk);
	Dp_Sync_RAM DUT_RAM (clk, RAMif.rst_n, RAMif.din, RAMif.rx_valid, RAMif.dout, RAMif.tx_valid);
	initial begin
		uvm_config_db#(virtual RAM_if)::set(null,"uvm_test_top","RAM_IF",RAMif);
		run_test ("RAM_test");
	end
endmodule 
