package RAM_env_pkg;
	import uvm_pkg::*; //import uvm package
	import RAM_agent_pkg::*;
	import RAM_scoreboard_pkg::*;
	import RAM_coverage_pkg::*;
   `include "uvm_macros.svh" //import macros
 class RAM_env extends uvm_env;
 	`uvm_component_utils(RAM_env)
 	RAM_agent agent ;
 	RAM_scoreboard scoreboard ;
 	RAM_coverage coverage ;

 	function new (string name = "RAM_env",uvm_component parent = null );
 		super.new(name,parent);
 	endfunction 

 	function void build_phase(uvm_phase phase);
 		super.build_phase(phase);
        scoreboard =RAM_scoreboard::type_id::create("scoreboard",this);
        coverage =RAM_coverage::type_id::create("coverage",this);
        agent =RAM_agent::type_id::create("agent",this);
 	endfunction 
 	
 	function void connect_phase(uvm_phase phase);
 	       super.connect_phase(phase);
 		agent.agent_ap.connect(scoreboard.sb_export);
 		agent.agent_ap.connect(coverage.cov_export);
 	endfunction 
 endclass 
endpackage 