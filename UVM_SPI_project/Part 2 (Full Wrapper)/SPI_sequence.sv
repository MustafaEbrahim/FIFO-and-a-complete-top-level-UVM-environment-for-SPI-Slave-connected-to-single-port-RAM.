package SPI_sequence_pkg;
	import uvm_pkg::*;
	import SPI_sequence_item_pkg::*;
	`include "uvm_macros.svh" // Import UVM macros
class SPI_sequence_1th extends  uvm_sequence #(SPI_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(SPI_sequence_1th)

    SPI_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [10:0]address , data ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;

	function new(string name = "SPI_sequence_1th");
		super.new(name);
	endfunction 

	task Get_infor();
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

    task Reset();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; 
        seq_item.rst_n = 0 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task Start_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 0 ; // Start Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task End_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; // End Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task body();
        for (int i = 0; i < 1000; i++) begin
            if (i%250==0)begin
                Get_infor();
                Reset();
            end
            Start_Communication();
            //Writing_Address
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.state =Writing_add;
                seq_item.add_wr= Random_address[counter_wr] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                address = {3'b000,Random_address[counter_wr]};
                seq_item.MOSI  =  address [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            Start_Communication();
            //Writing_Data
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.state =Writing_data ;
                seq_item.data_wr= Random_data[counter_wr] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b001,Random_data[counter_wr]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end

            End_Communication();
            Start_Communication();
            //Reading_Address
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.state =Reading_add;
                seq_item.add_rd= Random_address[counter_wr] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                address = {3'b110,Random_address[counter_wr]};
                seq_item.MOSI  =  address [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            Start_Communication();
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                seq_item.state =Reading_data_s1;
                start_item(seq_item);
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b111,Random_data[counter_wr]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end
            Start_Communication();
            for (int j = 8; j >= 1 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.state =Reading_data_s2;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b111,Random_data[counter_wr]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            counter_wr = ( counter_wr + 1 ) % 255 ;
        end
	endtask 
endclass

class SPI_sequence_2th extends  uvm_sequence #(SPI_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(SPI_sequence_2th)

    
    SPI_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [10:0]address , data ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;

    function new(string name = "SPI_sequence_2th");
        super.new(name);
    endfunction 

    task Get_infor();
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

     task Reset();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; 
        seq_item.rst_n = 0 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task Start_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 0 ; // Start Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task End_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; // End Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask  

    task body();
        for (int i = 0; i < 1000; i++) begin
            if (i%250==0)begin
                Get_infor();
                Reset();
            end
            Start_Communication();
            //Writing_Address
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.add_wr= Random_address[counter_wr] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                address = {3'b000,Random_address[counter_wr]};
                seq_item.MOSI  =  address [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            Start_Communication();
            //Writing_Data
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.data_wr= Random_data[counter_wr] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b001,Random_data[counter_wr]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            counter_wr = ( counter_wr + 1 ) % 255 ;
        end
    endtask 

endclass

class SPI_sequence_3th extends  uvm_sequence #(SPI_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(SPI_sequence_3th)

    
    SPI_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [10:0]address , data ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;

    function new(string name = "SPI_sequence_3th");
        super.new(name);
    endfunction 

    task Get_infor();
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

     task Reset();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; 
        seq_item.rst_n = 0 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task Start_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 0 ; // Start Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask 

    task End_Communication();
        seq_item = SPI_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.state = None ;
        seq_item.SS_n= 1 ; // End Communication
        seq_item.rst_n = 1 ;
        seq_item.MOSI=$random ;
        finish_item(seq_item);
    endtask  

    task body();
        for (int i = 0; i < 1000; i++) begin
            if (i%250==0)begin
                Get_infor();
                Reset();
            end
            Start_Communication();
            //Reading_Address
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.add_rd= Random_address[counter_rd] ;
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                address = {3'b110,Random_address[counter_rd]};
                seq_item.MOSI  =  address [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            Start_Communication();
            for (int j = 10; j >= 0 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b111,Random_data[counter_rd]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end
            Start_Communication();
            for (int j = 8; j >= 1 ; j--) begin
                seq_item = SPI_sequence_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.SS_n  = 0 ;
                seq_item.rst_n = 1 ;
                data = {3'b111,Random_data[counter_rd]};
                seq_item.MOSI  =  data [j] ;
                finish_item(seq_item);
            end
            End_Communication();
            counter_rd = ( counter_rd + 1 ) % 255 ;
        end
    endtask  
endclass
endpackage 