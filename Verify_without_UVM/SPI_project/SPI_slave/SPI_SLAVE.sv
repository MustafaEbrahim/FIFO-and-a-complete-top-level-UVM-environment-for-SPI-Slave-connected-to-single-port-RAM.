module SPI_Slave #(IDLE=0 ,CHK_CMD = 1,WRITE = 2,READ_ADD = 3,READ_DATA = 4)(interface_SPI.DUT_Design inst_interface );

	logic MOSI, SS_n, clk, rst_n, tx_valid;
	logic [7:0] tx_data;
	logic MISO;
	logic rx_valid;
	logic  [9:0] rx_data;

	reg [2:0] cs, ns;//current state and next state 
	reg [9:0] PO;
	reg [7:0] temp;
	reg SO, flag_rd ;
	integer state_count = 0, final_count = 0;
	reg Act_input_output;

	assign clk = inst_interface.clk;
    assign rst_n=inst_interface.rst_n;
    assign SS_n =inst_interface.SS_n;
    assign MOSI =inst_interface.MOSI;
	always@(*)begin
        tx_valid=inst_interface.tx_valid;
        tx_data =inst_interface.tx_data;
        inst_interface.MISO = MISO;
        inst_interface.rx_valid =rx_valid;
        inst_interface.rx_data  =rx_data;
	end

	assign MISO = SO; // output of reading
	assign rx_data   = PO ; 
// state Memory
	always @(posedge clk ) begin //bug : reset must be syncrouns not Async
		if (!rst_n)begin
			cs <= IDLE;
		    flag_rd<=0;
		    final_count <=32'hFFFF_FFFF;
		    state_count <=32'hFFFF_FFFF;
		    temp <= 0 ;
		end
		else
		    cs <= ns;
	end
	always @ (cs)begin
		if (cs == IDLE)begin
			rx_valid = 0 ;
		    PO  = 0 ;
		    state_count = 0 ;
		    final_count = 0 ;
		    SO = 0 ;
		    Act_input_output = 0;
		end 	
	end

	always @(posedge clk) begin//* bug
		
		case (cs)
			  IDLE : begin

		      	rx_valid = 0 ;
		        PO  = 0 ;
		        state_count = 0 ;
		        final_count = 0 ;
		        SO = 0 ;
		        Act_input_output = 0;
		             end 
		      WRITE: begin //done

				if (state_count < 10 )begin //0 ,
					PO = {PO[8:0] , MOSI} ;
					state_count = state_count + 1 ;
					if (PO[9] ==1'b0 && state_count ==10)begin
					    rx_valid = 1 ;
				    end 
				    else 
				    	rx_valid = 0 ;
				end 
				else 
					rx_valid = 0 ;

			        end
		      READ_ADD: begin // done

		      	if (state_count<10 )begin
		      		PO = {PO[8:0] , MOSI} ;
		      		state_count = state_count + 1 ;
		      		rx_valid = 0 ;
		      	end 
		      	if (PO[9:8]==2'b10 && state_count==10)begin
		      		rx_valid = 1 ;
		      		flag_rd = 1;
		      	end
		      	else 
					rx_valid = 0 ;
			             end
		      READ_DATA: begin // done

		      	if (Act_input_output == 0)begin
		      		if (state_count<9 )begin
		      		    PO = {PO[8:0] , MOSI} ;
		      		    state_count = state_count + 1 ;
		      		    rx_valid = 0 ;
		      	    end
		      	    else begin
		      	    	 PO = {PO[8:0] , MOSI} ;
		      		    state_count = state_count + 1 ;
		      		    rx_valid = 0 ;
		      	    end

		      	    if (PO[9:8]==2'b11 && state_count== 10 )begin
		      		    rx_valid = 1 ;
		      		    Act_input_output = 1;
		      		    flag_rd = 0;
		      	    end
		      	end
		      	else begin
		      		state_count = state_count + 1 ;
		      		rx_valid = 0 ;
		      		if (tx_valid && state_count == 12 )begin
		      			temp = tx_data ;
		      		end 
		      		if (state_count >= 12 && final_count <= 7)begin
					    SO = temp [7 - final_count ];
					    rx_valid =0 ;
					    final_count = final_count + 1 ;    
				    end	
				end 
			            end
		      default: begin
		      	rx_valid = 0 ;
		        PO  = 0 ;
		        state_count = 0 ;
		        final_count = 0 ;
		        SO = 0 ;
		        Act_input_output = 0;
		     
		           end 		
		       endcase
	end

	always @(*) begin

		case (cs)
		    IDLE:
			    if (SS_n)
			        ns = IDLE;
			    else
			        ns = CHK_CMD;
		    CHK_CMD:
			    if (SS_n)
			        ns = IDLE;
			    else begin//SS_n = 0
			        if (MOSI==0) //MOSI = 0
				        ns = WRITE;
			        else  begin //MOSI = 1
				        if (!flag_rd) //flag_rd = 0
				            ns = READ_ADD;
				        else  //flag_rd = 1
				            ns = READ_DATA;
			        end
			    end
		    WRITE:
			    if (SS_n)
			        ns = IDLE;
			    else
			        ns = WRITE;
		    READ_ADD:
			    if (SS_n)
			        ns = IDLE;
			    else begin
			        ns = READ_ADD; 
			        // flag_rd = 1;
			    end
		    READ_DATA:
			    if (SS_n)
			        ns = IDLE;
			    else begin
			        ns = READ_DATA;
			        // flag_rd = 0;
			    end

		    default: ns = IDLE;
		endcase
	end

endmodule
