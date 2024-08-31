package RAM_config_pkg;
	import uvm_pkg::*; // Import the UVM package
`include "uvm_macros.svh" // Import UVM macros

class RAM_config extends  uvm_object ;
	`uvm_object_utils(RAM_config)
	virtual RAM_if ram_config_vif ;
	uvm_active_passive_enum active ;
	function new(string name = "RAM_config");
        super.new(name);
    endfunction 
endclass 
endpackage 