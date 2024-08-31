package package_scoreboard;

import shared_package::*;  
import package_transaction::*;
class FIFO_scoreboard;
  
bit clk_ref ; 
logic [FIFO_WIDTH-1:0]  data_out_ref ;
logic  wr_en_ref;
logic  rd_en_ref;
logic  rst_n_ref;
logic  full_ref ;
logic  empty_ref;
logic  almostfull_ref ;
logic  almostempty_ref;
logic  overflow_ref   ;
logic  underflow_ref  ;
logic  wr_ack_ref     ;


function void reference_model(FIFO_transaction values_object);
// calculate the expected value
  clk_ref        = values_object.clk               ;

  full_ref       = values_object.full_expect       ;
  empty_ref      = values_object.empty_expect      ;
  almostfull_ref = values_object.almostfull_expect ;
  almostempty_ref= values_object.almostempty_expect;
  overflow_ref   = values_object.overflow_expect   ;
  underflow_ref  = values_object.underflow_expect  ;
  wr_ack_ref     = values_object.wr_ack_expect     ;
  data_out_ref   = values_object.data_out_expect   ;

endfunction 
function void check_data(FIFO_transaction values_object);
    reference_model(values_object);

    if(data_out_ref===values_object.data_out)
        Correct_counts++;
   else begin
    $display("There is an error in %0t ns , data_out_ref != data_out ,data_out_ref=%0d ,values_object.data_out =%0d ",$time(),data_out_ref,values_object.full);
    Error_counts++;
   end

   if (full_ref === values_object.full)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , full_ref != full ,full_ref=%0d ,values_object.full =%0d ",$time(),full_ref,values_object.full);
   	Error_counts++;
   end

   if (almostfull_ref === values_object.almostfull)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , almostfull_ref != almostfull ,almostfull_ref=%0d ,almostfull =%0d ",$time(),almostfull_ref,values_object.almostfull);
   	Error_counts++;
   end

   if (empty_ref === values_object.empty)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , empty_ref != empty ,empty_ref=%0d ,empty =%0d ",$time(),empty_ref,values_object.empty);
   	Error_counts++;
   end

   if (almostempty_ref === values_object.almostempty)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , almostempty_ref != almostempty ,almostempty_ref=%0d ,values_object.almostempty =%0d ",$time(),almostempty_ref,values_object.almostempty);
   	Error_counts++;
   end

   if (overflow_ref === values_object.overflow)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , overflow_ref != overflow ,overflow_ref=%0d ,values_object.overflow =%0d ",$time(),overflow_ref,values_object.overflow);
   	Error_counts++;
   end

   if (underflow_ref === values_object.underflow)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , underflow_ref != underflow ,underflow_ref=%0d ,values_object.underflow =%0d ",$time(),underflow_ref,values_object.underflow);
   	Error_counts++;
   end

   if (wr_ack_ref === values_object.wr_ack)
   	Correct_counts++;
   else begin
   	$display("There is an error in %0t ns , wr_ack_ref != wr_ack ,wr_ack_ref=%0d ,values_object.wr_ack =%0d ",$time(),wr_ack_ref,values_object.wr_ack);
   	Error_counts++;
   end
	
endfunction 
endclass 
endpackage 