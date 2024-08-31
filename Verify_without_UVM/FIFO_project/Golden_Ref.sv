module FIFO_GOLDEN (interface_FIFO.GOLDEN_REF inst_interface);
// module Golden (data_in , clk , rst_n , wr_en , rd_en , data_out_expect , wr_ack_expect , overflow_expect , full_expect ,
//  empty_expect , almostfull_expect , almostempty_expect , underflow_expect);
// parameter FIFO_WIDTH=16;
// parameter FIFO_DEPTH=8 ;
typedef logic [15:0] data_bus; // Define a 16-bit data bus type
// logic [inst_interface.FIFO_WIDTH-1:0] data_in;
 data_bus data_in;
 bit clk;
 logic  rst_n, wr_en, rd_en;
// logic [inst_interface.FIFO_WIDTH-1:0] data_out_expect;
 data_bus data_out_expect;
 logic wr_ack_expect, overflow_expect;
 logic full_expect, empty_expect, almostfull_expect, almostempty_expect, underflow_expect;
bit  deleted_queue;

assign inst_interface.wr_ack_expect     =wr_ack_expect;
assign inst_interface.overflow_expect   =overflow_expect;
assign inst_interface.underflow_expect  =underflow_expect;
assign inst_interface.full_expect       =full_expect;
assign inst_interface.empty_expect      =empty_expect;
assign inst_interface.almostfull_expect =almostfull_expect;
assign inst_interface.almostempty_expect=almostempty_expect;
assign inst_interface.data_out_expect   =data_out_expect;

assign clk= inst_interface.clk;
assign rst_n=inst_interface.rst_n;
assign wr_en=inst_interface.wr_en;
assign rd_en=inst_interface.rd_en;
assign data_in=inst_interface.data_in;

data_bus data_queue[$]; // Declare a queue of 16-bit data buses
always@(*)begin
	if (data_queue.size()==7)
		almostfull_expect=1;
	else 
		almostfull_expect=0;
	if (data_queue.size()==1)
		almostempty_expect=1;
	else 
		almostempty_expect=0;
	if (data_queue.size()==8)
		full_expect =1;
	else 
		full_expect =0;
	if (data_queue.size()==0)
		empty_expect=1;
	else 
		empty_expect=0;

	if (deleted_queue){almostempty_expect,almostfull_expect,full_expect,empty_expect,overflow_expect,underflow_expect}=6'b000_100;
end

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
	    data_queue.delete();
	    deleted_queue=1;
	end 
	else if (wr_en) begin
		 deleted_queue=0;
		if (full_expect==0)begin
			wr_ack_expect=1;
			overflow_expect=0;
			data_queue.push_back(data_in);
		end
		else begin
			overflow_expect=1;
			wr_ack_expect  =0;
		end 
      end 
	else begin
		wr_ack_expect  =0;
		overflow_expect=0;
	end

end 
always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) 
	    data_queue.delete();
	else if (rd_en)begin
		 deleted_queue=0;
		if (empty_expect==0)begin
			underflow_expect=0;
			data_out_expect=data_queue.pop_front();
		end
		else 
			underflow_expect=1;
	end
	else 
		underflow_expect=0;
	end

endmodule 