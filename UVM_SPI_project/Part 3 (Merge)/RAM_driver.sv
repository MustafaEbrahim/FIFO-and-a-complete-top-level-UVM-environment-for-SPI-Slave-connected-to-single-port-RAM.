package RAM_driver_pkg;
import uvm_pkg::*; // Import the UVM package
import RAM_config_pkg::*;
import RAM_sequence_item_pkg::*;
import RAM_sequencer_pkg::*;

`include "uvm_macros.svh" // Import UVM macros
class RAM_driver extends uvm_driver #(RAM_sequence_item);
    `uvm_component_utils(RAM_driver)

    virtual RAM_if RAM_driver_vif;
    RAM_config RAM_config_obj_driver ;
    RAM_sequence_item stim_seq_item ;

    function new(string name = "RAM_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(RAM_config)::get(this, "", "CFG_RAM", RAM_config_obj_driver))begin
            `uvm_fatal("Driver", "Virtual interface not found")
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        RAM_driver_vif = RAM_config_obj_driver.ram_config_vif ;
    endfunction 

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stim_seq_item = RAM_sequence_item::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);
            RAM_driver_vif.din=stim_seq_item.din ;
            RAM_driver_vif.rst_n=stim_seq_item.rst_n ;
            RAM_driver_vif.rx_valid=stim_seq_item.rx_valid ;
            #2
                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH) 
               seq_item_port.item_done();
        end
    endtask
endclass

endpackage