import package_coverage::*;
import package_scoreboard::*;
import package_transaction::*;
import shared_package::*;

module tb_FIFO (interface_FIFO.TESTBENCH inst_interface );

FIFO_transaction class_random_ports =new();
bit  clk;
logic [FIFO_WIDTH-1:0] data_in , data_out,data_out_expect ;
logic  wr_en;
logic  rd_en;
logic  rst_n;
logic  full ,full_expect ;
logic  empty,empty_expect;
logic  almostfull,almostfull_expect ;
logic  almostempty,almostempty_expect;
logic  overflow ,overflow_expect    ;
logic  underflow, underflow_expect  ;
logic  wr_ack   ,wr_ack_expect      ;	

assign wr_ack_expect      = inst_interface.wr_ack_expect     ;
assign empty_expect       = inst_interface.empty_expect      ;
assign overflow_expect    = inst_interface.overflow_expect   ;
assign full_expect        = inst_interface.full_expect       ;
assign almostfull_expect  = inst_interface.almostfull_expect ;
assign almostempty_expect = inst_interface.almostempty_expect;
assign data_out_expect    = inst_interface.data_out_expect   ;
assign underflow_expect   = inst_interface.underflow_expect  ;

assign wr_ack      = inst_interface.wr_ack     ;
assign empty       = inst_interface.empty      ;
assign overflow    = inst_interface.overflow   ;
assign full        = inst_interface.full       ;
assign almostfull  = inst_interface.almostfull ;
assign almostempty = inst_interface.almostempty;
assign data_out    = inst_interface.data_out   ;
assign underflow   = inst_interface.underflow  ;


assign clk         = inst_interface.clk        ;
assign inst_interface.rst_n      = rst_n  ;
assign inst_interface.wr_en      = wr_en  ;
assign inst_interface.rd_en      = rd_en  ;
assign inst_interface.data_in    = data_in;

// integer correct_count = 0 ;
// integer error_count   = 0 ;

// FIFO   DUT_1 (data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
// Golden DUT_2 (data_in , clk , rst_n , wr_en , rd_en , data_out_expect , wr_ack_expect , overflow_expect , full_expect ,
//  empty_expect , almostfull_expect , almostempty_expect , underflow_expect);


// //clock Generator 
// initial begin
// 	clk  =0;
// 	wr_en=0;
// 	rd_en=0;
// 	rst_n=0;
// 	forever
// 	#10 clk=~clk;
// end
task inst_values();
	rst_n  =class_random_ports.rst_n  ;
	@(negedge clk)begin
	data_in=class_random_ports.data_in;
	wr_en  =class_random_ports.wr_en  ;
	rd_en  =class_random_ports.rd_en  ;	
	end
endtask 
 

initial begin
	test_finished=0;
	for (int i=0;i<5000;i++)begin
	assert(class_random_ports.randomize());
		if (i==0)
		 class_random_ports.rst_n=0;
		inst_values();
	end
    
	test_finished=1;
end
endmodule 
