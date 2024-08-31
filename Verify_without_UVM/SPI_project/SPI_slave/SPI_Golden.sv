module SPI_Golden #(IDLE=0 ,CHK_CMD = 1,WRITE = 2,READ_ADD = 3,READ_DATA = 4)(interface_SPI.GOLDEN_REF inst_interface );

logic clk, rst_n, SS_n, MOSI, tx_valid;
logic [7:0] tx_data , temp;

logic MISO_expected , rx_valid_expected;
logic [9:0] rx_data_expected;

assign clk = inst_interface.clk;
assign rst_n=inst_interface.rst_n;
assign SS_n =inst_interface.SS_n;
assign MOSI =inst_interface.MOSI;


always@(*)begin
     tx_valid=inst_interface.tx_valid;
     tx_data =inst_interface.tx_data;

     inst_interface.MISO_expected=MISO_expected;
     inst_interface.rx_valid_expected =rx_valid_expected;
     inst_interface.rx_data_expected  =rx_data_expected;
end
(* fsm_encoding="sequential" *)
reg [2:0] cs, ns;// current state

reg address_recieved;
integer counter_sp;
integer counter_ps;
always@(cs)begin
	if (cs == IDLE)
		rx_data_expected <= 0;
		rx_valid_expected <= 0;
		MISO_expected  <= 0;
		counter_sp <= 0;
		counter_ps <= 8;
end

//State memory
always @(posedge clk) begin
	if (~rst_n) begin
		// reset
		cs <= IDLE;
	end
	else begin
		cs <= ns;
	end
end

//Next state logic
always @(*) begin
	case(cs)
	    IDLE:
	        if (SS_n) begin
	        	ns = IDLE;
	        end
	        else begin
	        	ns = CHK_CMD;
	        end
	    READ_ADD:
	        if (SS_n) begin
	        	ns = IDLE;
	        end
	        else begin
	        	ns = READ_ADD;
	        	// address_recieved = 1;// i received the address
	        end
	    CHK_CMD:
	        if (SS_n) begin
	        	ns = IDLE;
	        end
	        else if (MOSI) begin
	        	if (address_recieved == 1) begin
	        		ns = READ_DATA;
	        	end
	        	else begin
	        		ns = READ_ADD;
	        	end
	        end
	        else begin
	        	ns = WRITE;
	        end
	    WRITE:
	        if (SS_n) begin
	        	ns = IDLE;
	        end
	        else begin
	        	ns = WRITE;
	        end
	    READ_DATA:
	        if (SS_n) begin
	        	ns = IDLE;
	        end
	        else begin
	        	ns = READ_DATA;
	            // address_recieved = 0;
	        end
	    default: ns = IDLE;
	endcase
end

//Output logic
always @(posedge clk) begin
	if (~rst_n) begin
		// reset
		rx_data_expected <= 0;
		rx_valid_expected <= 0;
		MISO_expected  <= 0;
		counter_sp <= 0;
		counter_ps <= 8;
		address_recieved <= 0 ;
		temp <= 0 ;
	end
	else begin
		case(cs)
		    WRITE: begin
		    	if (counter_sp<10) begin
		    	 	rx_data_expected = {rx_data_expected,MOSI};//shifting
		    	    counter_sp = counter_sp + 1;
		    	    rx_valid_expected = 0;
		    	end
		    	if (counter_sp==10 && rx_data_expected[9]==1'b0) begin
		    		rx_valid_expected <= 1;

		    	end
		    end
		    READ_ADD: begin
		    	if (counter_sp<10) begin
		    	 	rx_data_expected = {rx_data_expected,MOSI};
		    	    counter_sp = counter_sp + 1;
		    	end
		    	if (counter_sp==10 && rx_data_expected[9:8]==2'b10) begin
		    		rx_valid_expected = 1;
		    		address_recieved = 1;
		    	end
		    end
		    READ_DATA: begin

		    	if (counter_sp <11 )begin
		    		if (counter_sp<10) begin
		    	 	    rx_data_expected = {rx_data_expected,MOSI};
		    	        counter_sp = counter_sp + 1;
		    	        rx_valid_expected = 0 ;
		    	    end
		    	    if (counter_sp == 10 && rx_data_expected[9:8]==2'b11)begin
		    		    rx_valid_expected = 1 ;
		    		    counter_sp = counter_sp + 1;
		    		    address_recieved = 0;
		    	    end
		    	end
               else begin
		      		counter_sp = counter_sp + 1;
		      		rx_valid_expected = 0 ;
		      		if (tx_valid && counter_sp == 13 )begin
		      			temp = tx_data ;
		      		end 
		      		if (counter_sp >= 13 && counter_ps > 0)begin
					    MISO_expected = temp [counter_ps - 1 ];
					    rx_valid_expected =0 ;
					    counter_ps = counter_ps - 1;    
				     end	
				end
                end 
		endcase
	end
end
endmodule