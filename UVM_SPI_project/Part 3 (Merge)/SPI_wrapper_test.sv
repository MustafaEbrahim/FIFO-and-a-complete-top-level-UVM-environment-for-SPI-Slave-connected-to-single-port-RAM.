package SPI_test_pkg;
    import uvm_pkg::*; //import uvm package
    import SPI_env_pkg::*;
    import SPI_config_pkg::*;
    import SPI_sequence_item_pkg::*;
    import SPI_sequence_pkg::*;
    import RAM_env_pkg::*;
    import RAM_config_pkg::*;
    
   `include "uvm_macros.svh" //import macros
   class SPI_test extends  uvm_test;
    `uvm_component_utils(SPI_test)
    //Environment
    SPI_env env ;
    RAM_env env_RAM ;
    //config Object
    RAM_config RAM_config_obj_test ;
    SPI_config SPI_config_obj_test ;
    //Virtual interface
    virtual RAM_if RAM_test_vif ;
    virtual SPI_if SPI_test_vif ;
    //Sequence 
    SPI_sequence_1th sequence_1th ;
    SPI_sequence_2th sequence_2th ;
    SPI_sequence_3th sequence_3th ;
        // Constructor
    function new(string name = "name", uvm_component parent=null);
        super.new(name, parent);
    endfunction 

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = SPI_env::type_id::create("env",this);
        env_RAM = RAM_env::type_id::create("env_RAM",this);
        RAM_config_obj_test  = RAM_config::type_id::create("RAM_config_obj_test",this);
        SPI_config_obj_test  = SPI_config::type_id::create("SPI_config_obj_test",this);
        sequence_1th =SPI_sequence_1th :: type_id :: create ("sequence_1th",this);
        sequence_2th =SPI_sequence_2th :: type_id :: create ("sequence_2th",this);
        sequence_3th =SPI_sequence_3th :: type_id :: create ("sequence_3th",this);
        
        if (!uvm_config_db#(virtual SPI_if)::get(this, "", "SPI_IF", SPI_config_obj_test.SPI_config_vif ))begin
            `uvm_fatal("build_phase","Test - unable to get the virtual interface of shift_reg from the uvm_config_db")
        end 
            uvm_config_db#(SPI_config)::set(this, "*", "CFG_SPI", SPI_config_obj_test);
        if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_IF", RAM_config_obj_test.ram_config_vif ))begin
            `uvm_fatal("build_phase","Test - unable to get the virtual interface of shift_reg from the uvm_config_db")
        end 
            uvm_config_db#(RAM_config)::set(this, "*", "CFG_RAM", RAM_config_obj_test);
         SPI_config_obj_test.active = UVM_ACTIVE ;
         RAM_config_obj_test.active = UVM_PASSIVE ;
    endfunction 

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase","Seq 1 Generation Started",UVM_LOW)
        sequence_1th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 1 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 2 Generation Started",UVM_LOW)
        sequence_2th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 2 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 3 Generation Started",UVM_LOW)
        sequence_3th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 3 Generation End",UVM_LOW)
        phase.drop_objection(this);
   endtask 
   endclass 
endpackage 