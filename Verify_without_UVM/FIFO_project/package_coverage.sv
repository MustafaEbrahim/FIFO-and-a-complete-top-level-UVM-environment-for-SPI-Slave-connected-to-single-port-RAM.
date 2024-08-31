package package_coverage;
import package_transaction::*;
FIFO_transaction F_cvg_txn =new();
class FIFO_coverage ;
	
function void sample_data (FIFO_transaction F_txn);

            F_cvg_txn.clk         = F_txn.clk         ;
			F_cvg_txn.data_in     = F_txn.data_in     ;
			F_cvg_txn.data_out    = F_txn.data_out    ;
			F_cvg_txn.wr_en       = F_txn.wr_en       ;
			F_cvg_txn.rd_en       = F_txn.rd_en       ;
			F_cvg_txn.full        = F_txn.full        ;
			F_cvg_txn.empty       = F_txn.empty       ;
			F_cvg_txn.almostfull  = F_txn.almostfull  ;
			F_cvg_txn.almostempty = F_txn.almostempty ;
			F_cvg_txn.overflow    = F_txn.overflow    ;
			F_cvg_txn.underflow   = F_txn.underflow   ;
			F_cvg_txn.wr_ack      = F_txn.wr_ack      ;

			cover_group.sample ();
endfunction 
//  which are write enable, read enable and each output control signals (outputs except data_out) to make sure that all combinations of write and read enable took place in all state of the FIFO.	
covergroup cover_group;

	write_enable    :coverpoint F_cvg_txn.wr_en{ 
	bins write_1  = {1};
	bins write_0  = {0};
	}
	read_enable     :coverpoint F_cvg_txn.rd_en{
	bins read_1  = {1};
	bins read_0  = {0};
	}
	full_flag       :coverpoint F_cvg_txn.full {
	bins full_1  = {1};
	bins full_0  = {0};
	}
	empty_flag      :coverpoint F_cvg_txn.empty{
	bins empty_1  = {1};
	bins empty_0  = {0};
	}
	almostfull_flag :coverpoint F_cvg_txn.almostfull{
	bins almostfull_1  = {1};
	bins almostfull_0  = {0};
	}
	almostempty_flag:coverpoint F_cvg_txn.almostempty {
	bins almostempty_1  = {1};
	bins almostempty_0  = {0};
	}
	overflow_flag   :coverpoint F_cvg_txn.overflow    {
	bins overflow_1  = {1};
	bins overflow_0  = {0};
	}
	underflow_flag  :coverpoint F_cvg_txn.underflow   {
	bins underflow_1  = {1};
	bins underflow_0  = {0};
	}
	wr_ack_flag     :coverpoint F_cvg_txn.wr_ack  {
	bins wr_ack_1  = {1};
	bins wr_ack_0  = {0};
	}

	cross write_enable,read_enable,full_flag {
	ignore_bins ignored_1_will_not_happend =binsof (read_enable.read_1) && binsof (full_flag.full_1); 
	}
	cross write_enable,read_enable,empty_flag      ;
	cross write_enable,read_enable,almostfull_flag ;
	cross write_enable,read_enable,almostempty_flag;
	cross write_enable,read_enable,overflow_flag{
	ignore_bins ignored_2_will_not_happend =binsof (write_enable.write_0) && binsof (overflow_flag.overflow_1); 
	}
	cross write_enable,read_enable,underflow_flag{
	ignore_bins ignored_3_will_not_happend =binsof (read_enable.read_0) && binsof (underflow_flag.underflow_1); 
	}
	cross write_enable,read_enable,wr_ack_flag     ;
	endgroup 
	cover_group=new();
		endclass 
endpackage 