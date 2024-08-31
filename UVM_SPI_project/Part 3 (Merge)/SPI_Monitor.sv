package SPI_monitor_pkg;
	import uvm_pkg::*;
	import SPI_sequence_item_pkg::*;
`include "uvm_macros.svh" // Import UVM macros
class SPI_monitor extends  uvm_monitor ;
	`uvm_component_utils(SPI_monitor)
	virtual SPI_if SPI_monitor_vif;
	SPI_sequence_item rsp_seq_item ;
	integer counter = 0 ;
	logic [7:0] data;
	logic [2:0] state;
	bit [10:0] wr_address,rd_address,wr_data ;
	uvm_analysis_port # (SPI_sequence_item) mon_ap;
	bit [7:0] RAM [255:0];

	function new (string name = "SPI_monitor",uvm_component parent = null);
		super.new(name ,parent);
		
	endfunction 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_ap =new("mon_ap" ,this);
		
	endfunction 
	task run_phase(uvm_phase phase);
		super.run_phase (phase);
		forever begin
			rsp_seq_item = SPI_sequence_item::type_id::create("rsp_seq_item");
			@(negedge SPI_monitor_vif.clk );
			rsp_seq_item.SS_n  = SPI_monitor_vif.SS_n ;
			rsp_seq_item.rst_n = SPI_monitor_vif.rst_n ;
			rsp_seq_item.MOSI  = SPI_monitor_vif.MOSI ;
			rsp_seq_item.MISO  = SPI_monitor_vif.MISO ;
			case ( SPI_monitor_vif.state )
			    Writing_add: state = 3'b000 ;
			    Writing_data: state=3'b001 ;
			    Reading_add: state=3'b010 ;
			    Reading_data_s1: state=3'b011 ;
			    Reading_data_s2:state=3'b100 ;
			    None :state=3'b101 ;
			endcase
			for (int i = 0 ; i <= state ; i++)begin
				if (i==0)begin
					rsp_seq_item.state=rsp_seq_item.state.first();
				end
				else begin
					rsp_seq_item.state=rsp_seq_item.state.next() ;
				end
			end
			if (SPI_monitor_vif.rst_n==0 || SPI_monitor_vif.SS_n==1)begin
				counter= 0 ;
			end
			else begin
				case (SPI_monitor_vif.state)
				Writing_add:begin
					wr_address[10-counter] = SPI_monitor_vif.MOSI;
					if (counter==10)begin
						rsp_seq_item.add_wr = wr_address[7:0] ;
					end
					counter = ( counter + 1 ) % 11 ;
				end  
				Writing_data:begin
					wr_data[10-counter] = SPI_monitor_vif.MOSI;
					if (counter==10)begin
						rsp_seq_item.data_wr = wr_data[7:0] ;
						RAM[rsp_seq_item.add_wr] = rsp_seq_item.data_wr;
					end
					counter = ( counter + 1 ) % 11 ;
				end  
				Reading_add:begin
					rd_address[10-counter] = SPI_monitor_vif.MOSI;
					if (counter==10)begin
						rsp_seq_item.add_rd = rd_address[7:0] ;
					end
					counter = ( counter + 1 ) % 11 ;
				end  
				Reading_data_s1:begin
					counter=(counter+1)%12;
				end  
				Reading_data_s2:begin 
					if(counter==7)begin
						rsp_seq_item.data_rd=RAM [rsp_seq_item.add_rd];
					end
					counter=(counter+1)%8;
				end 
				default: counter = 0 ;
			endcase
			end

			mon_ap.write(rsp_seq_item);
			`uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_HIGH)
		end
		
	endtask : run_phase
endclass 
endpackage 