package RAM_monitor_pkg;
	import uvm_pkg::*;
	import RAM_sequence_item_pkg::*;
`include "uvm_macros.svh" // Import UVM macros
class RAM_monitor extends  uvm_monitor ;
	`uvm_component_utils(RAM_monitor)
	virtual RAM_if RAM_monitor_vif;
	RAM_sequence_item rsp_seq_item ;
	uvm_analysis_port # (RAM_sequence_item) mon_ap;

	function new (string name = "RAM_monitor",uvm_component parent = null);
		super.new(name ,parent);
		
	endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_ap =new("mon_ap" ,this);
		
	endfunction 
	task run_phase(uvm_phase phase);
		super.run_phase (phase);
		forever begin
			rsp_seq_item = RAM_sequence_item::type_id::create("rsp_seq_item");
			@(negedge RAM_monitor_vif.clk );
			rsp_seq_item.din      = RAM_monitor_vif.din ;
			rsp_seq_item.rst_n    = RAM_monitor_vif.rst_n ;
			rsp_seq_item.rx_valid = RAM_monitor_vif.rx_valid ;
			rsp_seq_item.dout     = RAM_monitor_vif.dout ;
			rsp_seq_item.tx_valid = RAM_monitor_vif.tx_valid ;

			if (RAM_monitor_vif.din [9:8]==2'b00)
				rsp_seq_item.addr_wr = RAM_monitor_vif.din ;
			else if (RAM_monitor_vif.din [9:8]==2'b01)
				rsp_seq_item.data_wr = RAM_monitor_vif.din ;
			else if (RAM_monitor_vif.din [9:8]==2'b10)
				rsp_seq_item.addr_rd = RAM_monitor_vif.din ;
			mon_ap.write(rsp_seq_item);
			`uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)
		end
		
	endtask : run_phase
endclass 
endpackage 