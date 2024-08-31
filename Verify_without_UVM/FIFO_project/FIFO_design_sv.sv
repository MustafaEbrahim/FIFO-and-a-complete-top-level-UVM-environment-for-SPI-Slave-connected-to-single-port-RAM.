////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO #(parameter FIFO_DEPTH = 8, FIFO_WIDTH = 16)(interface_FIFO.DUT_Design inst_interface);

logic [inst_interface.FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [inst_interface.FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;


assign inst_interface.wr_ack      = wr_ack;
assign inst_interface.overflow    = overflow;
assign inst_interface.underflow   = underflow;
assign inst_interface.full        = full;
assign inst_interface.empty       = empty;
assign inst_interface.almostfull  = almostfull;
assign inst_interface.almostempty = almostempty;
assign inst_interface.data_out    = data_out;
assign clk= inst_interface.clk;
assign rst_n=inst_interface.rst_n;
assign wr_en=inst_interface.wr_en;
assign rd_en=inst_interface.rd_en;
assign data_in=inst_interface.data_in;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr:0] count ;
reg [max_fifo_addr-1:0] wr_ptr,rd_ptr ;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		overflow <=0;
	end
	else if (wr_en ) begin
		if (full==0)begin
		    mem[wr_ptr] <= data_in;
		    wr_ack <= 1;
		    wr_ptr <= wr_ptr + 1;
		    overflow <=0;	
		end
		else begin
		    wr_ack  <= 0;
			overflow<= 1;
		end
	end
	else begin
		overflow  <= 0;
		wr_ack    <= 0;
	end
end 

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow <=0;
	end
	else if (rd_en ) begin
		if (empty==0)begin
			data_out <= mem[rd_ptr];
		      rd_ptr <= rd_ptr + 1;
		   underflow <=0;
		end
		else 
			underflow <=1;
	end 
	else 
		underflow <=0;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if (({wr_en, rd_en} == 2'b11) && empty)
			count <= count + 1;
		else if (({wr_en, rd_en} == 2'b11) && full)
			count <= count - 1;
	end
end

always@(count)begin
	if (count==FIFO_DEPTH )
		full=1;
	else 
		full=0;
	if (count==0)
		empty=1;
	else 
		empty=0;
	if (count==(FIFO_DEPTH-1))
		almostfull=1;
	else 
		almostfull=0;
	if (count == 1)
		almostempty=1;
	else 
		almostempty=0;
end
// Assertion guarded by the SIM macro
    `ifdef SIM
    // assertion here
    property EMPTY;
	@(posedge clk) disable iff (!rst_n)
	 (count==0) |-> empty |-> (!full); 
	endproperty

	 property ALMOSTEMPTY;
    @(posedge clk) disable iff (!rst_n)
     (count==1) |-> (!empty)|-> almostempty; 
	endproperty

	 property ALMOSTFULL ;
    @(posedge clk) disable iff (!rst_n)
     (count==7) |-> almostfull ;
	endproperty

	property FULL ;
    @(posedge clk) disable iff (!rst_n)
     (count==8) |-> (full) |-> (!almostfull); 
	endproperty

	property OVERFLOW ;
    @(posedge clk) disable iff (!rst_n) 
     (wr_en && full ) |=>        overflow ; 
	endproperty

	property UNDERFLOW ;
    @(posedge clk) disable iff (!rst_n)
     // (rd_en && empty) |=> $past(underflow) ; 
     (rd_en && empty) |=> underflow ;
	endproperty

	property WR_ACK_HIGH ;
    @(posedge clk) disable iff (!rst_n)
     // (wr_en && (!full) ) |=> ($past(wr_ack)); 
     (wr_en && (!full) ) |=> wr_ack;
	endproperty

	property WR_ACK_LOW ;
    @(posedge clk) disable iff (!rst_n)
     // (wr_en && full ) |=> (!($past(wr_ack))); 
     (wr_en && full ) |=> (!wr_ack); 
	endproperty

	property COUNTER_0 ;
    @(posedge clk ) !rst_n |=> (count==0); 
	endproperty

	property COUNTER_INC_10 ;
    @(posedge clk) disable iff (!rst_n)
    ( ({wr_en, rd_en} == 2'b10) && !full)  |=> (count ==( $past(count)+1))   ;
	endproperty

	property COUNTER_INC_01 ;
    @(posedge clk) disable iff (!rst_n)
    ( ({wr_en, rd_en} == 2'b01) && !empty)  |=> (count ==( $past(count)-1))   ;
	endproperty

	property COUNTER_INC_11_WR ;
    @(posedge clk) disable iff (!rst_n)
    (({wr_en, rd_en} == 2'b11) && empty)  |=> (count ==( $past(count)+1))   ;
	endproperty

	property COUNTER_INC_11_RD ;
    @(posedge clk) disable iff (!rst_n)
    (({wr_en, rd_en} == 2'b11) && full)  |=> (count ==( $past(count)-1))   ;
	endproperty


	property COUNTER_STUN ;
    @(posedge clk) disable iff (!rst_n)
    // (((rd_en && empty) && (!wr_en))||((wr_en && full) && (!rd_en)) ) |=> ($past($past(count))==($past(count)));
    (((rd_en && empty) && (!wr_en))||((wr_en && full) && (!rd_en)) ) |=> ($past(count) == (count));
	endproperty


		FULL_assertion             : assert property (FULL)           else $display("FULL_assertion fail"          );
        EMPTY_assertion            : assert property (EMPTY)          else $display("EMPTY_assertion fail"         );
        ALMOSTFULL_assertion       : assert property (ALMOSTFULL)     else $display("ALMOSTFULL_assertion fail"    );
        ALMOSTEMPTY_assertion      : assert property (ALMOSTEMPTY)    else $display("ALMOSTEMPTY_assertion fail"   );
        OVERFLOW_assertion         : assert property (OVERFLOW)       else $display("OVERFLOW_assertion"           );
        UNDERFLOW_assertion        : assert property (UNDERFLOW)      else $display("UNDERFLOW_assertion"          );
        WR_ACK_HIGH_assertion      : assert property (WR_ACK_HIGH)    else $display("WR_ACK_HIGH_assertion"        );
        WR_ACK_LOW_assertion       : assert property (WR_ACK_LOW)     else $display("WR_ACK_LOW_assertion"         );
        COUNTER_0_assertion        : assert property (COUNTER_0)      else $display("COUNTER_0_assertion"          );
        COUNTER_INC_10_assertion   : assert property (COUNTER_INC_10) else $display("COUNTER_INC_WR_assertion fail");
        COUNTER_INC_01_assertion   : assert property (COUNTER_INC_01)   else $display("COUNTER_INC_WR_assertion fail");
        COUNTER_INC_11_WR_assertion: assert property (COUNTER_INC_11_WR) else $display("COUNTER_INC_WR_assertion fail");
        COUNTER_INC_11_RD_assertion: assert property (COUNTER_INC_11_RD) else $display("COUNTER_INC_WR_assertion fail");
        COUNTER_STUN_assertion     : assert property (COUNTER_STUN)      else $display("COUNTER_STUN_assertion fail"  );

        FULL_cover          : cover property (FULL)            $display("FULL_assertion Pass"          );
        EMPTY_cover         : cover property (EMPTY)           $display("EMPTY_assertion Pass"         );
        ALMOSTFULL_cover    : cover property (ALMOSTFULL)      $display("ALMOSTFULL_assertion Pass"    );
        ALMOSTEMPTY_cover   : cover property (ALMOSTEMPTY)     $display("ALMOSTEMPTY_assertion Pass"   );
        OVERFLOW_cover      : cover property (OVERFLOW)        $display("OVERFLOW_assertion"           );
        UNDERFLOW_cover     : cover property (UNDERFLOW)       $display("UNDERFLOW_assertion"          );
        WR_ACK_HIGH_cover   : cover property (WR_ACK_HIGH)     $display("WR_ACK_HIGH_assertion"        );
        WR_ACK_LOW_cover    : cover property (WR_ACK_LOW)      $display("WR_ACK_LOW_assertion"         );
        COUNTER_0_cover     : cover property (COUNTER_0)       $display("COUNTER_0_assertion"          );
        COUNTER_INC_10_cover: cover property (COUNTER_INC_10)  $display("COUNTER_INC_WR_assertion Pass");
        COUNTER_INC_01_cover: cover property (COUNTER_INC_01)  $display("COUNTER_INC_WR_assertion Pass");
        COUNTER_INC_11_WR_cover: cover property (COUNTER_INC_11_WR)  $display("COUNTER_INC_WR_assertion Pass");
        COUNTER_INC_11_RD_cover: cover property (COUNTER_INC_11_RD)  $display("COUNTER_INC_WR_assertion Pass");
        COUNTER_STUN_cover  : cover property (COUNTER_STUN)    $display("COUNTER_STUN_assertion Pass"  );
    `endif

endmodule