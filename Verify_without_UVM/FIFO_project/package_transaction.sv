package package_transaction ;
	parameter FIFO_WIDTH=16;
    parameter FIFO_DEPTH=8 ;
class FIFO_transaction;
        bit  clk;
        rand logic [FIFO_WIDTH-1:0] data_in ;
             logic [FIFO_WIDTH-1:0] data_out ,data_out_expect ; 
        rand logic  wr_en;
        rand logic  rd_en;
        rand logic  rst_n;
        logic  full  , full_expect ;
        logic  empty , empty_expect;
        logic  almostfull , almostfull_expect ;
        logic  almostempty, almostempty_expect;
        logic  overflow   , overflow_expect   ;
        logic  underflow  , underflow_expect  ;
        logic  wr_ack     , wr_ack_expect     ;

        integer WR_EN_ON_DIST=70;
        integer RD_EN_ON_DIST=30;

constraint General {
    rst_n dist {1:/70,0:/30};
    wr_en dist {1:/WR_EN_ON_DIST,0:/(100 - WR_EN_ON_DIST)};
    rd_en dist {1:/RD_EN_ON_DIST,0:/(100 - RD_EN_ON_DIST)};
        }
		
endclass 
	
endpackage 