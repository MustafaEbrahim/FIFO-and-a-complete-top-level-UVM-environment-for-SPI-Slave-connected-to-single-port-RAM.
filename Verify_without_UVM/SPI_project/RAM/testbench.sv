import package_RAM::*;
typedef enum logic [1:0] {Write_address=2'b00 ,Write_data=2'b01, Read_address=2'b10 ,Read_data=2'b11} state_e;
module tb_RAM (interface_RAM.TESTBENCH inst_interface);

	RAM class_RAM =new();
    bit clk ;
    logic rst_n     ;
    logic [9:0] din ;
    logic rx_valid  ;
    logic [7:0] dout,dout_expect;
    logic tx_valid,tx_valid_expect ;
    logic [1:0] opcode;
    integer Correct_count =0;
    integer Error_count   =0;
    state_e state;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;

assign clk             = inst_interface.clk;
assign dout            = inst_interface.dout;
assign dout_expect     = inst_interface.dout_expect ;
assign tx_valid        = inst_interface.tx_valid;
assign tx_valid_expect = inst_interface.tx_valid_expect; 
assign inst_interface.rst_n    = rst_n;
assign inst_interface.din      = din;
assign inst_interface.rx_valid = rx_valid;



   always @(din)begin
   	case (din[9:8])
   		2'b00: state=Write_address; 
   		2'b01: state=Write_data;
   		2'b10: state=Read_address;
   		2'b11: state=Read_data;
   	
   	endcase
   end

    always@(clk)begin
        class_RAM.clk=clk;
    end

    task inst();

    	rst_n    = class_RAM.rst_n;
    	din      = class_RAM.din;
    	rx_valid = class_RAM.rx_valid;
        opcode   = class_RAM.opcode;
        
        @(negedge clk)begin
        	if (dout===dout_expect)
        		Correct_count++;
        	else begin
        		Error_count++;
        		$display("There is an Error in %0t ,dout != dout_expect ,dout =%0h and dout_expect=%0h ",$time(),dout,dout_expect);
        	end
        	if (tx_valid==tx_valid_expect)
        		Correct_count++;
        	else begin
        		Error_count++;
        		$display("There is an Error in %0t ,tx_valid != tx_valid_expect ,tx_valid =%0h and tx_valid_expect=%0h ,",$time(),tx_valid,tx_valid_expect);
        	end
        end
        class_RAM.dout=dout;
        class_RAM.tx_valid=tx_valid;
        class_RAM.Data_out();
    endtask 

task Get_information();
    for (int i = 0; i < 256; i++) begin
        Queue.push_front(i);
    end
    Queue.shuffle();
    for (int i = 0; i < 256; i++) begin
        Random_address[i]=Queue.pop_front();
    end
    for (int i = 255; i >= 0; i--) begin
        Queue.push_front(i);
    end
    Queue.shuffle();
    for (int i = 0; i < 256; i++) begin
        Random_data[i]=Queue.pop_front();
    end
endtask

initial begin
    Get_information();//address and data are ready 
    opcode = 0 ;
    for (int i = 0; i < 6; i++) begin
       if (i==0)begin//testing Reset
            assert (class_RAM.randomize());
            class_RAM.rst_n=0;
            inst();
       end

       else if (i==1)begin//write addr -> write data -> read addr -> read data
           for (int j = 0; j < 1500; j++) begin
               class_RAM.opcode_0(opcode);
               case (class_RAM.opcode)
                2'b00 : class_RAM.address = Random_address [counter_wr];
                2'b01 :begin
                 class_RAM.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 256 ;
                       end 
                2'b10 : class_RAM.address = Random_address [counter_rd];
                2'b11 :begin
                 class_RAM.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 256 ;
                       end 
               endcase
               assert (class_RAM.randomize());
               class_RAM.rx_valid=1;
               inst();
           end
       end
       else if (i==2)begin//write addr -> write data -> read addr -> read data
           for (int j = 0; j < 500; j++) begin
               class_RAM.opcode_0(opcode);
               case (class_RAM.opcode)
                2'b00 : class_RAM.address = Random_address [counter_wr];
                2'b01 :begin
                 class_RAM.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                       end 
                2'b10 : class_RAM.address = Random_address [counter_rd];
                2'b11 :begin
                 class_RAM.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (class_RAM.randomize());
               inst();
           end
       end
        else if (i==3)begin//write addr -> write data -> read addr -> read data
           for (int k = 0; k < 600; k++) begin
               class_RAM.writing(opcode);
               case (class_RAM.opcode)
                2'b00 : class_RAM.address = Random_address [counter_wr];
                2'b01 :begin
                 class_RAM.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                    end 
               endcase
               assert (class_RAM.randomize());
               class_RAM.rx_valid = 1 ;
               inst();
           end
       end
        else if (i==4)begin//write addr -> write data -> read addr -> read data
           for (int L = 0; L < 800; L++) begin
               class_RAM.Reading(opcode);
               case (class_RAM.opcode)
                2'b10 : class_RAM.address = Random_address [counter_rd];
                2'b11 :begin
                 class_RAM.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (class_RAM.randomize());
               class_RAM.rx_valid  = 1 ;
               inst();
           end
       end
        else if (i==5)begin//write addr -> write data -> read addr -> read data
           for (int M = 0; M < 1000; M++) begin
               class_RAM.opcode_0(opcode);
               case (class_RAM.opcode)
                2'b00 : class_RAM.address = Random_address [counter_wr];
                2'b01 :begin
                 class_RAM.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                       end 
                2'b10 : class_RAM.address = Random_address [counter_rd];
                2'b11 :begin
                 class_RAM.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (class_RAM.randomize());
               class_RAM.rx_valid = 0 ;
               inst();
           end
       end


    end

    	$display("The total correct count =%0d ,The total Error count =%0d ",Correct_count/2,Error_count );
    	$stop;
    end
endmodule 





