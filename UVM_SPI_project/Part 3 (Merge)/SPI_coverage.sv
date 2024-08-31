package SPI_coverage_pkg;
	import uvm_pkg::*;
	import SPI_sequence_item_pkg::*;
`include "uvm_macros.svh" // Import UVM macros

class SPI_coverage extends  uvm_component;
	`uvm_component_utils(SPI_coverage)
	uvm_analysis_export #(SPI_sequence_item ) cov_export;
	uvm_tlm_analysis_fifo #(SPI_sequence_item ) cov_fifo ;
	SPI_sequence_item  seq_item_cov ;

   covergroup SPI_Wrapper;
    reset: coverpoint seq_item_cov.rst_n{
        bins reset_asserted ={0};
        bins reset_disable  ={1};
        }
    Address_write : coverpoint seq_item_cov.add_wr ;
    Data_write : coverpoint seq_item_cov.data_wr ;
    Data_read : coverpoint seq_item_cov.data_rd;
    Address_read: coverpoint seq_item_cov.add_rd ;

    Send_Address_wr : coverpoint seq_item_cov.state{
     bins writing_add  = {Writing_add};
    }
    Send_Address_rd: coverpoint seq_item_cov.state{
     bins reading_add  = {Reading_add};
    }
    send_Data_wr :coverpoint seq_item_cov.state{
    bins writing_data = {Writing_data};   
    }
    Recieving_Data_rd :coverpoint seq_item_cov.state{
     bins reading_data= {Reading_data_s2} ;
    }
    Sending_order_Read_data: coverpoint seq_item_cov.state{
     bins order_reading_data = {Reading_data_s1} ;
    } 
    Starting_Communication : coverpoint seq_item_cov.SS_n{
    bins Start = {0};
    bins End   = {1};
    bins transaction_back = (0 => 1 => 0) ;
    }
    Actualiy_sending_addr_wr: cross Send_Address_wr , Address_write ;
    Actualiy_sending_data_wr: cross send_Data_wr , Data_write;
    Actualiy_sending_addr_rd: cross Send_Address_rd,Address_read;
    Actualiy_recieving_data : cross Recieving_Data_rd , Data_read;
    
endgroup 

	function new (string name = "SPI_coverage" , uvm_component parent = null);
		super.new(name , parent) ; 
		SPI_Wrapper =new();
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
	 	SPI_Wrapper.sample();
	 	end
	 	
	 endtask 
endclass 
endpackage 