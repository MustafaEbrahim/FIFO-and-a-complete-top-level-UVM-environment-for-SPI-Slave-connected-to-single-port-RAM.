import SPI_slave_package::*;
module tb_SPI_slave (interface_SPI.TESTBENCH inst_interface );
	SPI_class SPI_ports =new();
	logic MOSI, SS_n, clk, rst_n, tx_valid;
	logic [7:0] tx_data ;
	logic MISO , MISO_expected ;
	logic rx_valid, rx_valid_expected;
	logic [9:0] rx_data,rx_data_expected,data;
    logic [1:0] state;

    assign clk =inst_interface.clk;
    assign MISO=inst_interface.MISO;
    assign MISO_expected=inst_interface.MISO_expected;
    assign rx_valid=inst_interface.rx_valid;
    assign rx_valid_expected=inst_interface.rx_valid_expected;
    assign rx_data_expected=inst_interface.rx_data_expected;
    assign rx_data=inst_interface.rx_data;

    assign inst_interface.MOSI=MOSI;
    assign inst_interface.SS_n=SS_n;
    assign inst_interface.tx_valid=tx_valid;
    assign inst_interface.tx_data=tx_data;
    assign inst_interface.rst_n=rst_n;

    integer correct_counts=0;
    integer error_counts  =0;

    logic repeater;
	// SPI_Slave DUT (.*);
	// SPI_Golden  DUT_Golden (.*);

	always@(clk)begin
		SPI_ports.clk=clk;
	end
   
task instantiate();
    SS_n    = SPI_ports.SS_n    ;
    tx_data = SPI_ports.tx_data ;
    tx_valid= SPI_ports.tx_valid;
    rst_n   = SPI_ports.rst_n   ;
    SPI_ports.ParallelToSerial();
    MOSI    =SPI_ports.MOSI;
	
endtask 

task reset_Asserted();
	SPI_ports.rst_n = 0 ;
	SPI_ports.select_SS(1);
	instantiate();
	SPI_ports.opcode_0(state);
	reset_check();
	SPI_ports.rst_n = 1;
    rst_n = SPI_ports.rst_n;
endtask 

task reset_check();
	@(negedge clk)begin
        if (rx_data==0 && rx_data_expected==0)begin
    		if (rx_valid==0 && rx_valid_expected==0)
    		    if (MISO==0 && MISO_expected==0)begin
    		    	correct_counts++;
    		    end
    		    else begin
    		    	error_counts++;
    		        $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,MISO_expected );
    		
    		    end
    		else begin
    		    error_counts++;
    		    $display("%0t ns , there is an error they must be zeros : rx_valid = %0d and rx_valid_expected = %0d ",$time(),rx_valid,rx_valid_expected );
    		end	
        end
        else begin
    		error_counts++;
    		$display("%0t ns , there is an error they must be zeros : rx_data = %0d and rx_data_expected = %0d ",$time(),rx_data,rx_data_expected );
        end	
    end
endtask 
task delay_cycle();
	@(negedge clk) repeater++ ;
endtask 

task delay_10cycles();
	repeat(11)begin
		instantiate();
		@(negedge clk) begin
            SPI_ports.Set_value();
		end
	end

	if (state[0]==0)
	    data =SPI_ports.expected_add[9:0];
    else 
    	data=SPI_ports.expected_Data[9:0];

	if (rx_data==data && rx_data_expected==data)begin
        if (rx_valid==rx_valid_expected)
    		if (MISO== MISO_expected)begin
    		    	correct_counts++;
    		    end
    		    else begin
    		    	error_counts++;
    		        $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,MISO_expected );
    		
    		    end
        else begin
    		error_counts++;
    		$display("%0t ns , there is an error : rx_valid = %0d and rx_valid_expected = %0d ",$time(),rx_valid,rx_valid_expected );
    	end	
    end
    else begin
        error_counts++;
    	$display("%0t ns , there is an error : rx_data = %0d and rx_data_expected = %0d ",$time(),rx_data,rx_data_expected );
    	$display("Exact_data =%0d ",data);
    end

endtask 
task delay_18cycles();

	delay_10cycles() ;
    if (rx_valid == 1 )begin
            delay_cycle();
    	for(int i = 7 ; i >= 0 ; i--) begin
    	@(negedge clk)begin
    		if ( tx_valid == 1)begin
    			if (MISO == SPI_ports.tx_data[i] && MISO_expected == SPI_ports.tx_data[i])begin
    			    correct_counts++;
    			    SPI_ports.MISO =MISO;
    			    SPI_ports.Data_out();
    		    end
    		    else begin
    			    error_counts++;
    			    $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,MISO_expected );
    			    $display("Exact_MISO =%0d ",SPI_ports.tx_data[i]);
    		    end
    		end 
    		else begin
    			if (MISO == MISO_expected )begin
    			    correct_counts++;
    			    SPI_ports.MISO =MISO;
    			    SPI_ports.Data_out();
    		    end
    		    else begin
    			    error_counts++;
    			    $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,MISO_expected );
    		    end
    		end
    	end
    end
    end
    else begin
    	for(int i = 7 ; i >= 0 ; i--) begin
    	@(negedge clk)begin
    			if (MISO == MISO_expected )begin
    			    correct_counts++;
    			    SPI_ports.MISO =MISO;
    			    SPI_ports.Data_out();
    		    end
    		    else begin
    			    error_counts++;
    			    $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,MISO_expected );
    		    end
    	end
    end
    end
    
endtask 
 
always @(SPI_ports.opcode)begin
    	state = SPI_ports.opcode;
    end

initial begin
	SPI_ports.Get_information();
    #1 SPI_ports.Set_tx_valid (0);
    reset_Asserted ();//task for reset 
   	for (int i = 0; i < 1600 ; i++) begin

   		SPI_ports.Set_tx_valid (1);
        reset_Asserted ();//task for reset 
        SPI_ports.select_SS(1);
   		instantiate();
   		reset_check();
   		for (int j = 0; j < 4; j++) begin
   			SPI_ports.select_SS(0);//start communication
   			SS_n = 0;
   			delay_cycle();
   			if (rst_n == 0)
   				reset_check();
   			else begin
   				if (state==2'b11)
   			    delay_18cycles();
   			    else 
   				delay_10cycles();
   			end
            SPI_ports.MISO =MISO;
            SPI_ports.rx_data=rx_data;
            SPI_ports.rx_valid=rx_valid;
   			SPI_ports.select_SS(1);//end communication
   			instantiate();
   			reset_check();
            SPI_ports.rx_data=rx_data;
            SPI_ports.rx_valid=rx_valid;
            if (i < 255)
                SPI_ports.opcode_0(state);
            else if (i==510 || i < 765 )begin
            	// reset_Asserted ();
                SPI_ports.opcode_1(state);
            end
            else if (i==765 || i < 1020) begin
            	// reset_Asserted ();
            	SPI_ports.writing(state);
            end
            else if (i==1020 || i < 1200)begin
            	// reset_Asserted ();
            	SPI_ports.Reading(state);
            end
            else if (i==1200 || i < 1500) begin
            	// reset_Asserted ();
            	SPI_ports.opcode_0(state);
            end
            SPI_ports.SPI_Slave_cover.sample();	
   		end
   		SPI_ports.Increment_array();
   	end

   	for (int i = 0; i < 1500 ; i++) begin

   	    SPI_ports.Set_tx_valid (0);
        reset_Asserted ();//task for reset 
        SPI_ports.select_SS(1);
   		instantiate();
   		reset_check();
   		for (int j = 0; j < 4; j++) begin
   			SPI_ports.select_SS(0);//start communication
   			SS_n = 0;
   			delay_cycle();
   			
   			if (rst_n == 0)
   				reset_check();
   			else begin
   				if (state==2'b11)
   			    delay_18cycles();
   			    else 
   				delay_10cycles();
   			end
            SPI_ports.MISO =MISO;
            SPI_ports.rx_data=rx_data;
            SPI_ports.rx_valid=rx_valid;
   			SPI_ports.select_SS(1);//end communication
   			instantiate();
   			reset_check();
            SPI_ports.rx_data=rx_data;
            SPI_ports.rx_valid=rx_valid;
            if (i < 255)
                SPI_ports.opcode_0(state);
            else if (i==510 || i < 765 )begin
            	// reset_Asserted ();
                SPI_ports.opcode_1(state);
            end
            else if (i==765 || i < 1020) begin
            	// reset_Asserted ();
            	SPI_ports.writing(state);
            end
            else if (i==1020 || i < 1200)begin
            	// reset_Asserted ();
            	SPI_ports.Reading(state);
            end
            else if (i==1200 || i < 1500) begin
            	// reset_Asserted ();
            	SPI_ports.opcode_0(state);
            end
   		end
   		SPI_ports.Increment_array();
   		if (i==500 || i==700 || i==1000 ||i==1300)begin
   			reset_Asserted ();
   		end
   	end
    SPI_ports.select_SS(1);//end communication
    instantiate();
    delay_cycle();
    SPI_ports.select_SS(0);//end communication
    instantiate();
    delay_cycle();
    SPI_ports.select_SS(1);//end communication
    instantiate();
    delay_cycle();
    SPI_ports.select_SS(0);//end communication
    instantiate();
    delay_cycle();

   	$display("correct_counts =%0d and error_counts=%0d ",correct_counts,error_counts );
   	$stop;
end

endmodule 