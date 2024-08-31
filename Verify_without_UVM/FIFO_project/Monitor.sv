//import the shared package
import shared_package::*;
//import class packages
import package_transaction::*;
import package_coverage   ::*;
import package_scoreboard ::*;

module monitor (interface_FIFO.MONITOR inst_interface);
	//creat objects of different classes
FIFO_transaction class_transaction =new();
FIFO_scoreboard  class_scoreboard  =new();
FIFO_coverage    class_coverage    =new();
	
	 initial begin
forever begin
	@(negedge inst_interface.clk)begin

		class_transaction.clk         =inst_interface.clk    ;
		class_transaction.rst_n       =inst_interface.rst_n  ;
		class_transaction.wr_en       =inst_interface.wr_en  ; 
		class_transaction.rd_en       =inst_interface.rd_en  ;
		class_transaction.data_in     =inst_interface.data_in;

		class_transaction.wr_ack      =inst_interface.wr_ack   ;
		class_transaction.overflow    =inst_interface.overflow ;
		class_transaction.full        =inst_interface.full     ;
		class_transaction.almostfull  =inst_interface.almostfull ;
		class_transaction.almostempty =inst_interface.almostempty;
		class_transaction.data_out    =inst_interface.data_out   ;
		class_transaction.underflow   =inst_interface.underflow  ;
		class_transaction.empty       =inst_interface.empty  ;

		class_transaction.data_out_expect   =inst_interface.data_out_expect;
		class_transaction.full_expect       =inst_interface.full_expect;
		class_transaction.empty_expect      =inst_interface.empty_expect;
		class_transaction.almostfull_expect =inst_interface.almostfull_expect;
		class_transaction.almostempty_expect=inst_interface.almostempty_expect;
		class_transaction.overflow_expect   =inst_interface.overflow_expect;
		class_transaction.underflow_expect  =inst_interface.underflow_expect;
		class_transaction.wr_ack_expect     =inst_interface.wr_ack_expect;
          
                fork 
         // process 1
         begin
         	class_coverage.sample_data(class_transaction);
         end
         
         // process 2

         begin
         	class_scoreboard.check_data(class_transaction);
         end

		join

          end

	if (test_finished==1)begin
	 $display("Total Correct counts = %0d and total Error counts = %0d",Correct_counts/8,Error_counts);
	 $stop;	
	end
	
end
    // $monitor("wr_ack = %b, overflow = %b, almostfull = %b, full = %b, almostempty = %b,
    //  data_out = %b ,clk = %b, rst_n = %b, wr_en = %b,rd_en = %b, data_in = %b", wr_ack,overflow,
    //  almostfull,full,almostempty,data_out,rst_n,wr_en,rd_en,data_in );
  end
endmodule 
