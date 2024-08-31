package RAM_sequencer_pkg;
import uvm_pkg::*;
import RAM_sequence_item_pkg::*;

	`include "uvm_macros.svh" // Import UVM macros
class RAM_sequencer extends uvm_sequencer #(RAM_sequence_item);
	`uvm_component_utils(RAM_sequencer)
	function  new(string name = "RAM_sequencer",uvm_component parent = null);
		super.new(name,parent);
		
	endfunction 
endclass  
endpackage 
