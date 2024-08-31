package RAM_sequence_pkg;
	import uvm_pkg::*;
	import RAM_sequence_item_pkg::*;
	`include "uvm_macros.svh" // Import UVM macros
class RAM_reset_sequence extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_reset_sequence)

    RAM_sequence_item seq_item ;
	function new(string name = "RAM_reset_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(10)begin
			seq_item = RAM_sequence_item::type_id::create("seq_item");
		start_item(seq_item);
		assert(seq_item.randomize());
		seq_item.din=$random();
		seq_item.rst_n=0      ;
		seq_item.rx_valid=0   ;
        finish_item(seq_item);
		end
		
	endtask : body

endclass 

class RAM_sequence_1th extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_sequence_1th)

    RAM_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;
	function new(string name = "RAM_sequence_1th");
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

    task body();
        Get_infor();
        for(int i=0 ; i <5000 ; i++)begin
            if (i%250==0)begin
                Get_infor();
            end
          	seq_item = RAM_sequence_item::type_id::create("seq_item");
     		start_item(seq_item);
               seq_item.opcode_0(opcode);
               case (seq_item.opcode)
                2'b00 : seq_item.address = Random_address [counter_wr];
                2'b01 :begin
                 seq_item.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 256 ;
                       end 
                2'b10 : seq_item.address = Random_address [counter_rd];
                2'b11 :begin
                 seq_item.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 256 ;
                       end 
               endcase
               assert (seq_item.randomize());
               seq_item.rx_valid=1;
               opcode=seq_item.opcode ;
            finish_item(seq_item);
        end 
	endtask 

endclass

class RAM_sequence_2th extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_sequence_2th)

    RAM_sequence_item seq_item ;
    bit [1:0] opcode;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;
	function new(string name = "RAM_sequence_2th");
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

    task body();
        Get_infor();
        for(int i=0 ; i <5000 ; i++)begin
            if (i%250==0)begin
                Get_infor();
            end
          	seq_item = RAM_sequence_item::type_id::create("seq_item");
     		start_item(seq_item);
               seq_item.opcode_0(opcode);
               case (seq_item.opcode)
                2'b00 : seq_item.address = Random_address [counter_wr];
                2'b01 :begin
                 seq_item.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                       end 
                2'b10 : seq_item.address = Random_address [counter_rd];
                2'b11 :begin
                 seq_item.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (seq_item.randomize());
               opcode=seq_item.opcode ;
            finish_item(seq_item);
        end 
	endtask 

endclass

class RAM_sequence_3th extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_sequence_3th)

    RAM_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_wr = 0 ;

	function new(string name = "RAM_sequence_3th");
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

	task body();
        Get_infor();
		for(int i=0 ; i <5000 ; i++)begin
            if (i%250==0)begin
                Get_infor();
            end
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
          	seq_item.writing(opcode);
               case (seq_item.opcode)
                2'b00 : seq_item.address = Random_address [counter_wr];
                2'b01 :begin
                 seq_item.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                    end 
               endcase
               assert (seq_item.randomize());
               seq_item.rx_valid = 1 ;
               opcode=seq_item.opcode ;
            finish_item(seq_item);
        end 
	endtask 

endclass

class RAM_sequence_4th extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_sequence_4th)

    RAM_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;

	function new(string name = "RAM_sequence_4th");
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

    task body();
        Get_infor();
        for(int i=0 ; i <5000 ; i++)begin
            if (i%250==0)begin
                Get_infor();
            end
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
          	seq_item.Reading(seq_item.opcode);
               case (seq_item.opcode)
                2'b10 : seq_item.address = Random_address [counter_rd];
                2'b11 :begin
                 seq_item.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (seq_item.randomize());
               seq_item.rx_valid  = 1 ;
               opcode=seq_item.opcode ;
            finish_item(seq_item);
        end 
	endtask 

endclass


class RAM_sequence_5th extends  uvm_sequence #(RAM_sequence_item);

	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(RAM_sequence_5th)

    RAM_sequence_item seq_item ;
    bit[1:0] opcode ;
    logic [7:0] Random_address[0 : 255];
    logic [7:0] Random_data [0 : 255];
    logic [7:0] Queue [$];
    integer counter_rd = 0 ;
    integer counter_wr = 0 ;
	function new(string name = "RAM_sequence_5th");
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

    task body();
        Get_infor();
        for(int i=0 ; i <5000 ; i++)begin
            if (i%200==0)begin
                Get_infor();
            end
            seq_item = RAM_sequence_item::type_id::create("seq_item");
            start_item(seq_item);
          	seq_item.opcode_0(opcode);
               case (seq_item.opcode)
                2'b00 : seq_item.address = Random_address [counter_wr];
                2'b01 :begin
                 seq_item.address = Random_data  [counter_wr];
                 counter_wr = ( counter_wr + 1 ) % 255 ;
                       end 
                2'b10 : seq_item.address = Random_address [counter_rd];
                2'b11 :begin
                 seq_item.address = Random_data [counter_rd];
                 counter_rd = ( counter_rd + 1 ) % 255 ;
                       end 
               endcase
               assert (seq_item.randomize());
               seq_item.rx_valid = 0 ;
               opcode=seq_item.opcode ;
            finish_item(seq_item);
        end 
	endtask 

endclass
	
endpackage 