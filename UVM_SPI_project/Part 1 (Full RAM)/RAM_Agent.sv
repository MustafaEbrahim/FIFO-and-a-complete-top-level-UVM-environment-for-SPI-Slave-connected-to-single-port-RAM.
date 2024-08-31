package RAM_agent_pkg;
	import uvm_pkg::*;
	import RAM_monitor_pkg::*;
	import RAM_driver_pkg::*;
	import RAM_sequencer_pkg::*;
	import RAM_config_pkg::*;
	import RAM_sequence_item_pkg::*;
	
   `include "uvm_macros.svh" //import macros
class RAM_agent extends  uvm_agent;
	`uvm_component_utils(RAM_agent)
	 uvm_analysis_port #(RAM_sequence_item) agent_ap;
     RAM_sequencer sqr ;
     RAM_driver drv ;
     RAM_monitor mon ;
     RAM_config RAM_cfg ;

	function new(string name = "RAM_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
      		super.build_phase(phase);
      		if(!uvm_config_db#(RAM_config)::get(this,"","CFG",RAM_cfg))
      			`uvm_fatal("build_phase","Unable to get configuration object")
      		sqr =RAM_sequencer::type_id::create("sqr",this);
      		drv=RAM_driver::type_id::create("drv",this);
      		mon=RAM_monitor::type_id::create("mon",this);
      		agent_ap= new ("agent_ap",this);
      		
      	endfunction 

	function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		drv.RAM_driver_vif=RAM_cfg.ram_config_vif;
      		mon.RAM_monitor_vif=RAM_cfg.ram_config_vif;
      		drv.seq_item_port.connect(sqr.seq_item_export);
      		mon.mon_ap.connect(agent_ap);
    endfunction  : connect_phase

endclass : RAM_agent
	
endpackage 