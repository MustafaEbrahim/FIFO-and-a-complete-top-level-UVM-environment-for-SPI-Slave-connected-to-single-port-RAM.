package RAM_coverage_pkg;
	import uvm_pkg::*;
	import RAM_sequence_item_pkg::*;
`include "uvm_macros.svh" // Import UVM macros

class RAM_coverage extends  uvm_component;
	`uvm_component_utils(RAM_coverage)
	uvm_analysis_export #(RAM_sequence_item ) cov_export;
	uvm_tlm_analysis_fifo #(RAM_sequence_item ) cov_fifo ;
	RAM_sequence_item  seq_item_cov ;

   covergroup cvr_gp;
        reset: coverpoint seq_item_cov.rst_n{
        bins reset_asserted ={0};
        bins reset_disable  ={1};
        }

        data_valid:coverpoint seq_item_cov.din[9:8]{
        bins writing_complete = (2'b00 => 2'b01);
        bins writing = {2'b00};
        bins reading = {2'b10};
        bins change_wr_rd =(2'b01 => 2'b10);
        bins change_rd_wr =(2'b11 => 2'b00); 
        bins default_values []={2'b00,2'b01,2'b10,2'b11};
        }
        data_written   :coverpoint seq_item_cov.data_wr;
        data_read      :coverpoint seq_item_cov.dout   ;
        address_written:coverpoint seq_item_cov.addr_wr;
        address_read   :coverpoint seq_item_cov.addr_rd;

        receive_valid: coverpoint seq_item_cov.rx_valid{
        bins receive_asserted ={1};
        bins receive_disable  ={0};
        }
        send_valid:coverpoint seq_item_cov.tx_valid{
        bins send_asserted ={1};
        bins send_disable  ={0};
        }
        
        Writing_address: cross address_written,receive_valid{
         // ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
        }
        Writing_data: cross data_written,receive_valid{
         // ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
        }
        reading_address: cross address_read,receive_valid{
         ignore_bins ignore_bin1 = binsof (receive_valid.receive_disable);
        }
        reading_data: cross data_read,receive_valid{
         ignore_bins ignore_bin1 = binsof (receive_valid.receive_disable );
        }
        
    endgroup 

	function new (string name = "RAM_coverage" , uvm_component parent = null);
		super.new(name , parent) ; 
		cvr_gp =new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase (phase);
		cov_export=new("cov_export",this);
		cov_fifo = new("cov_fifo",this);
	 endfunction 

	 function void connect_phase(uvm_phase phase);
	 	super.connect_phase (phase);
	 	cov_export.connect(cov_fifo.analysis_export);
	 endfunction 

	 task run_phase(uvm_phase phase);
	 	super.run_phase(phase);
	 	forever begin
	 	cov_fifo.get(seq_item_cov);
	 	cvr_gp.sample();
	 	end
	 	
	 endtask 
endclass 
endpackage 