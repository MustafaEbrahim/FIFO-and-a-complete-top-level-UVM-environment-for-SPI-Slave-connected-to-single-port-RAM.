package SPI_config_pkg;
	import uvm_pkg::*; // Import the UVM package
`include "uvm_macros.svh" // Import UVM macros

class SPI_config extends  uvm_object ;
	`uvm_object_utils(SPI_config)

	virtual SPI_if SPI_config_vif ;

	function new(string name = "SPI_config");
        super.new(name);
    endfunction 
endclass 
endpackage 