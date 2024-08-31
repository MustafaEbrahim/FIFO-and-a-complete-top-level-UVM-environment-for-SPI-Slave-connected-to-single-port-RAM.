interface interface_FIFO (clk);
	
input bit  clk;
parameter FIFO_WIDTH=16;
parameter FIFO_DEPTH=8 ;
logic [FIFO_WIDTH-1:0] data_in , data_out,data_out_expect ;
logic  wr_en;
logic  rd_en;
logic  rst_n;
logic  full,full_expect  ;
logic  empty,empty_expect;
logic  almostfull,almostfull_expect  ;
logic  almostempty,almostempty_expect;
logic  overflow,overflow_expect      ;
logic  underflow,underflow_expect    ;
logic  wr_ack,wr_ack_expect          ;

	modport DUT_Design (input clk,rst_n,data_in,wr_en,rd_en,
		         output data_out,full,empty,almostempty,almostfull,overflow,underflow,wr_ack);
	// modport DUT_Assertion (input clk,rst_n,data_in,wr_en,rd_en,
	// 	         output data_out,full,empty,almostempty,almostfull,overflow,underflow,wr_ack);
	modport TESTBENCH(input data_out,full,empty,almostempty,almostfull,overflow,underflow,wr_ack, clk,
		              data_out_expect,full_expect,empty_expect,almostempty_expect,almostfull_expect
		         ,overflow_expect,underflow_expect,wr_ack_expect,
		         output rst_n,data_in,wr_en,rd_en);
	modport MONITOR (input clk,rst_n,data_in,wr_en,rd_en,data_out,
		             full,empty,almostempty,almostfull,overflow,underflow,wr_ack,
		             data_out_expect,full_expect,empty_expect,almostempty_expect,almostfull_expect
		         ,overflow_expect,underflow_expect,wr_ack_expect);
	modport GOLDEN_REF(input clk,rst_n,data_in,wr_en,rd_en,
		         output data_out_expect,full_expect,empty_expect,almostempty_expect,almostfull_expect
		         ,overflow_expect,underflow_expect,wr_ack_expect);
endinterface 
