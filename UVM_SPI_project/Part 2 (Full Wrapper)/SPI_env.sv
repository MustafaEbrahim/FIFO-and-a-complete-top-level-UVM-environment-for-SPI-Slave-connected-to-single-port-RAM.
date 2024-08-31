package SPI_env_pkg;
	import uvm_pkg::*; //import uvm package
	import SPI_agent_pkg::*;
	import SPI_scoreboard_pkg::*;
	import SPI_coverage_pkg::*;
   `include "uvm_macros.svh" //import macros
 class SPI_env extends uvm_env;
 	`uvm_component_utils(SPI_env)
 	SPI_agent agent ;
 	SPI_scoreboard scoreboard ;
 	SPI_coverage coverage ;

 	function new (string name = "SPI_env",uvm_component parent = null );
 		super.new(name,parent);
 	endfunction 

 	function void build_phase(uvm_phase phase);
 		super.build_phase(phase);
        scoreboard =SPI_scoreboard::type_id::create("scoreboard",this);
        coverage =SPI_coverage::type_id::create("coverage",this);
        agent =SPI_agent::type_id::create("agent",this);
 	endfunction 
 	
 	function void connect_phase(uvm_phase phase);
 	       super.connect_phase(phase);
 		agent.agent_ap.connect(scoreboard.sb_export);
 		agent.agent_ap.connect(coverage.cov_export);
 	endfunction 
 endclass 
endpackage 