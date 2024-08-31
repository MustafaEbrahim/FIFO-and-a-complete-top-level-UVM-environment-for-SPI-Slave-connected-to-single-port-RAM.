package SPI_driver_pkg;
import uvm_pkg::*; // Import the UVM package
import SPI_config_pkg::*;
import SPI_sequence_item_pkg::*;
import SPI_sequencer_pkg::*;

`include "uvm_macros.svh" // Import UVM macros
class SPI_driver extends uvm_driver #(SPI_sequence_item);
    `uvm_component_utils(SPI_driver)

    virtual SPI_if SPI_driver_vif;
    SPI_config SPI_config_obj_driver ;
    SPI_sequence_item stim_seq_item ;
    logic [2:0] state ;

    function new(string name = "SPI_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(SPI_config)::get(this, "", "CFG_SPI", SPI_config_obj_driver))begin
            `uvm_fatal("Driver", "Virtual interface not found")
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        SPI_driver_vif = SPI_config_obj_driver.SPI_config_vif ;
    endfunction 

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stim_seq_item = SPI_sequence_item::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);
            SPI_driver_vif.SS_n=stim_seq_item.SS_n ;
            SPI_driver_vif.rst_n=stim_seq_item.rst_n ;
            SPI_driver_vif.MOSI=stim_seq_item.MOSI ;
            case ( stim_seq_item.state )
                Writing_add: state = 3'b000 ;
                Writing_data: state=3'b001 ;
                Reading_add: state=3'b010 ;
                Reading_data_s1: state=3'b011 ;
                Reading_data_s2:state=3'b100 ;
                None : state=3'b101 ;
            endcase
            for (int i = 0 ; i <= state ; i++)begin
                if (i==0)begin
                    SPI_driver_vif.state=SPI_driver_vif.state.first();
                end
                else begin
                    SPI_driver_vif.state=SPI_driver_vif.state.next() ;
                end
            end
            @(negedge SPI_driver_vif.clk) begin
                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH) 
               seq_item_port.item_done();
            end 
        end
    endtask
endclass

endpackage