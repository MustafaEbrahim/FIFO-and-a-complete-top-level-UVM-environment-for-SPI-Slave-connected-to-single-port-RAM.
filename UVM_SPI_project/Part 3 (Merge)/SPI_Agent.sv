package SPI_agent_pkg;
	import uvm_pkg::*;
	import SPI_monitor_pkg::*;
	import SPI_driver_pkg::*;
	import SPI_sequencer_pkg::*;
	import SPI_config_pkg::*;
	import SPI_sequence_item_pkg::*;
	
   `include "uvm_macros.svh" //import macros
class SPI_agent extends  uvm_agent;
	`uvm_component_utils(SPI_agent)
	 uvm_analysis_port #(SPI_sequence_item) agent_ap;
     SPI_sequencer sqr ;
     SPI_driver drv ;
     SPI_monitor mon ;
     SPI_config SPI_cfg ;

	function new(string name = "SPI_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
      		super.build_phase(phase);
      		if(!uvm_config_db#(SPI_config)::get(this,"","CFG_SPI",SPI_cfg))
      			`uvm_fatal("build_phase","Unable to get configuration object")
      		if (SPI_cfg.active == UVM_ACTIVE)begin
      			sqr =SPI_sequencer::type_id::create("sqr",this);
      		    drv=SPI_driver::type_id::create("drv",this);
      		end
      		mon=SPI_monitor::type_id::create("mon",this);
      		agent_ap= new ("agent_ap",this);
      	endfunction 

	function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		if (SPI_cfg.active == UVM_ACTIVE)begin
      			drv.SPI_driver_vif=SPI_cfg.SPI_config_vif;
      			drv.seq_item_port.connect(sqr.seq_item_export);
      		end 
      		mon.SPI_monitor_vif=SPI_cfg.SPI_config_vif;
      		mon.mon_ap.connect(agent_ap);
    endfunction  : connect_phase
endclass : SPI_agent
	
endpackage 