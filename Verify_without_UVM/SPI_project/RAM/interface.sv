interface interface_RAM (clk);
	
    input bit  clk;
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8  ;
    logic rst_n     ;
    logic [9:0] din ;
    logic rx_valid  ;
    logic [7:0] dout, dout_expect;
    logic tx_valid ,tx_valid_expect ;

	modport DUT_Design (input clk, rst_n, din, rx_valid,
	                   output dout, tx_valid);

	modport ASSERTION  (input clk, rst_n, din, rx_valid,
	                     dout, tx_valid,dout_expect, tx_valid_expect);

	modport TESTBENCH  (input clk, dout_expect, tx_valid_expect, dout, tx_valid,
	                   output rst_n, din, rx_valid );

	modport GOLDEN_REF(input clk, rst_n, din, rx_valid,
	                   output dout_expect, tx_valid_expect );
endinterface 
