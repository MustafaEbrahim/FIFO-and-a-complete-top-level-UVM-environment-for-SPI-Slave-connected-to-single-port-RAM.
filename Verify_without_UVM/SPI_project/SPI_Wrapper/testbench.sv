import SPI_slave_package::*;
module tb_SPI_Wrapper (interface_SPI.TESTBENCH inst_interface );
	SPI_class Wrapper =new();
	logic MOSI, SS_n, clk, rst_n;
	logic  MISO;
    logic [1:0] state;

    logic [7:0] RAM [255:0];
    logic [7:0] output_parallel_MISO;

    assign clk =inst_interface.clk;
    assign MISO = inst_interface.MISO ;

    assign inst_interface.MOSI=MOSI;
    assign inst_interface.SS_n=SS_n;
    assign inst_interface.rst_n=rst_n;

    integer correct_counts=0;
    integer error_counts  =0;

    logic repeater=0;

	always@(clk)begin
		Wrapper.clk=clk;
	end
   
task instantiate();
    SS_n    = Wrapper.SS_n    ;
    rst_n   = Wrapper.rst_n   ;
    Wrapper.ParallelToSerial();
    MOSI    =Wrapper.MOSI;

endtask 

task reset_Asserted();
	Wrapper.rst_n = 0 ;
	Wrapper.select_SS(1);
	instantiate();
	Wrapper.opcode_0(state);
	reset_check();
	Wrapper.rst_n = 1;
    rst_n = Wrapper.rst_n;

endtask 

task reset_check();
	@(negedge clk)begin
    		    if (MISO==0 )begin
    		    	correct_counts++;
    		    end
    		    else begin
    		    	error_counts++;
    		        $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO, 0 );
    		    end
    end
endtask 
task delay_cycle();
	@(negedge clk) repeater++ ;
endtask 

task delay_11cycles();
	repeat(11)begin
		instantiate();
		@(negedge clk) begin
            Wrapper.Set_value();
		end
	end
    if (state == 2'b01)
        RAM[Wrapper.add_wr] = Wrapper.data_wr;
endtask 
task delay_18cycles();
	delay_11cycles();
    delay_cycle();

    Wrapper.data_rd = RAM[Wrapper.add_rd] ;

    output_parallel_MISO = Wrapper.data_rd ;
    for(int i = 7 ; i >= 0 ; i--) begin
    	@(negedge clk)begin
    			if (MISO == output_parallel_MISO[i])begin
    			    correct_counts++;
    			    Wrapper.MISO =MISO;
    			    Wrapper.Data_out();
    		    end
    		    else begin
    			    error_counts++;
    			    $display("%0t ns , there is an error : MISO = %0d and MISO_expected = %0d ",$time(),MISO,Wrapper.Din[i] );
    		    end
    	end     	
    end
endtask 
 
always @(Wrapper.opcode)begin
    	state = Wrapper.opcode;
    end

initial begin
    Wrapper.Get_information();
    reset_Asserted ();//task for reset 
    for (int i = 0; i < 1300 ; i++) begin
        reset_Asserted ();//task for reset 
        Wrapper.select_SS(1);
        instantiate();
        reset_check();
        for (int j = 0; j < 4; j++) begin
            Wrapper.select_SS(0);//start communication
            SS_n = 0;
            delay_cycle();
            if (rst_n == 0)
                reset_check();
            else begin
                if (state==2'b11)
                delay_18cycles();
                else 
                delay_11cycles();
            end
            Wrapper.MISO =MISO;
            Wrapper.select_SS(1);//end communication
            instantiate();
            reset_check();

            if (i < 255)
            Wrapper.opcode_0(state);
            else if (i==255 || i < 555) begin
                // reset_Asserted ();
                Wrapper.writing(state);
            end
            else if (i==555 || i < 850)begin
                // reset_Asserted ();
                Wrapper.Reading(state);
            end
            else if (i==850 || i < 1300) begin
                // reset_Asserted ();
                Wrapper.opcode_0(state);
            end
        end
        Wrapper.Increment_array();
        if (i==1299)begin
            reset_Asserted ();//task for reset 
            Wrapper.select_SS(1);
            instantiate();
            reset_check();
            Wrapper.select_SS(0);//start communication
            SS_n = 0;
            Wrapper.opcode = 2'b11 ;
            delay_cycle();
            repeat(11)begin
                instantiate();
                @(negedge clk) begin
                    repeater++;
                end
            end
            delay_cycle();
            repeat(8)begin
                 @(negedge clk) begin
                    if (MISO==0) 
                        correct_counts++;
                    else 
                        error_counts++;
                end
            end
            Wrapper.MISO =MISO;
            Wrapper.select_SS(1);//end communication
            instantiate();
            reset_check();
        end
    end
    Wrapper.select_SS(1);//end communication
    instantiate();
    delay_cycle();
    if (MISO == 0 )
        correct_counts++;
    else 
        error_counts ++;
    Wrapper.select_SS(0);//end communication
    instantiate();
    delay_cycle();
    Wrapper.select_SS(1);//end communication
    instantiate();
    delay_cycle();
        if (MISO == 0 )
        correct_counts++;
    else 
        error_counts ++;
    Wrapper.select_SS(0);//end communication
    instantiate();
    delay_cycle();
   	$display("correct_counts =%0d and error_counts=%0d ",correct_counts ,error_counts );
   	$stop;
end

endmodule 