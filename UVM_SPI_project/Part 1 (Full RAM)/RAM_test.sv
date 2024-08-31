package RAM_test_pkg;
    import uvm_pkg::*; //import uvm package
    import RAM_env_pkg::*;
    import RAM_config_pkg::*;
    import RAM_sequence_item_pkg::*;
    import RAM_sequence_pkg::*;
    
   `include "uvm_macros.svh" //import macros
   class RAM_test extends  uvm_test;
    `uvm_component_utils(RAM_test)
    RAM_env env ;
    virtual RAM_if RAM_test_vif ;
    RAM_config RAM_config_obj_test ;
    RAM_reset_sequence reset_sequence ;
    RAM_sequence_1th sequence_1th ;
    RAM_sequence_2th sequence_2th ;
    RAM_sequence_3th sequence_3th ;
    RAM_sequence_4th sequence_4th ;
    RAM_sequence_5th sequence_5th ;
    
    // Constructor
    function new(string name = "name", uvm_component parent=null);
        super.new(name, parent);
    endfunction 

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = RAM_env::type_id::create("env",this);
        RAM_config_obj_test  = RAM_config::type_id::create("RAM_config_obj_test",this);
        reset_sequence =RAM_reset_sequence :: type_id :: create ("reset_sequence",this);
        sequence_1th =RAM_sequence_1th :: type_id :: create ("sequence_1th",this);
        sequence_2th =RAM_sequence_2th :: type_id :: create ("sequence_2th",this);
        sequence_3th =RAM_sequence_3th :: type_id :: create ("sequence_3th",this);
        sequence_4th =RAM_sequence_4th :: type_id :: create ("sequence_4th",this);
        sequence_5th =RAM_sequence_5th :: type_id :: create ("sequence_5th",this);
        
        if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_IF", RAM_config_obj_test.ram_config_vif ))begin
            `uvm_fatal("build_phase","Test - unable to get the virtual interface of shift_reg from the uvm_config_db")
        end 
            uvm_config_db#(RAM_config)::set(this, "*", "CFG", RAM_config_obj_test);
    endfunction 

   task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        reset_sequence.start(env.agent.sqr);
        `uvm_info("run_phase","Reset Asserted",UVM_LOW)
        `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
        `uvm_info("run_phase","Seq 1 Generation Started",UVM_LOW)
        sequence_1th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 1 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 2 Generation Started",UVM_LOW)
        sequence_2th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 2 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 3 Generation Started",UVM_LOW)
        sequence_3th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 3 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 4 Generation Started",UVM_LOW)
        sequence_4th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 4 Generation End",UVM_LOW)
        `uvm_info("run_phase","Seq 5 Generation Started",UVM_LOW)
        sequence_5th.start(env.agent.sqr);
        `uvm_info("run_phase","Seq 5 Generation End",UVM_LOW)
        phase.drop_objection(this);
   endtask 
   endclass 
endpackage 