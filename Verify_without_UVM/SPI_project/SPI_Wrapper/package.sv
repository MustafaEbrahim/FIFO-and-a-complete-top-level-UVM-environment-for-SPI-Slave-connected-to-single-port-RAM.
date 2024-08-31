package SPI_slave_package;
	class SPI_class ;
	logic clk;
	logic SS_n;
	logic MOSI ;
	logic MISO;
	logic [1:0] opcode ;
	logic [7:0]  data ,address , Din ,add_rd,add_wr,data_rd,data_wr ;
	logic [10:0] data_reg;   // Register to store parallel data
    logic [10:0] expected_add,expected_Data;
    logic [7:0] parallel_data [0 : 255];
    logic [7:0] parallel_address[0 : 255];
    logic [7:0] Queue [$];
    integer shift_data =0 , shift_address = 0;
    integer i =0;
	logic  rst_n;

function void Set_value();
    if (SS_n==0 && rst_n==1)begin
        case (opcode)
        2'b00: expected_add  = {expected_add[9:0],MOSI};
        2'b01: expected_Data = {expected_Data[9:0],MOSI}; 
        2'b10: expected_add  = {expected_add[9:0],MOSI};
        2'b11: expected_Data = {expected_Data[9:0],MOSI}; 
        endcase // opcode
    end 
endfunction 

function void Data_out();
	data = {data,MISO};
endfunction

function void Get_information();
    for (int i = 0; i < 256; i++) begin
        Queue.push_front(i);
    end
    Queue.shuffle();
    for (int i = 0; i < 256; i++) begin
        parallel_address[i]=Queue.pop_front();
    end
    for (int i = 255; i >= 0; i--) begin
        Queue.push_front(i);
    end
    Queue.shuffle();
    for (int i = 0; i < 256; i++) begin
        parallel_data[i]=Queue.pop_front();
    end
endfunction 

function void ParallelToSerial();
    if (SS_n==0 && rst_n==1)begin//*
        // data_reg = {data_reg[9:0], 1'b0}; // Shift left
        // expected_add = {expected_add[9:0],MOSI}; 
        if (opcode==2'b00 || opcode ==2'b10)begin//*
            // Load parallel data into the data register on the rising edge of the clock
            if (shift_address == 5'b0) begin//*
                data_reg = {opcode[1],opcode,parallel_address[i]};
                address = parallel_address[i];
                if (opcode == 2'b00)
                    add_wr = parallel_address[i];
                else 
                    add_rd = parallel_address[i];
            end//*
            // Shift out data serially
            if (shift_address < 11) begin//*
                MOSI = data_reg[10];
                 // expected_add = {expected_add[9:0],MOSI};
                data_reg = {data_reg[9:0], 1'b0}; // Shift left
                shift_address = shift_address + 1'b1;
                if (shift_address == 11)
                    shift_address = 0 ; 
            end //*
        end//*
        else if (opcode==2'b01 || opcode==2'b11) begin
            if (shift_data== 5'b0)begin
                data_reg = {opcode[1],opcode,parallel_data[i]};
                Din = parallel_data[i] ;
                if (opcode == 2'b01)
                    data_wr = parallel_data[i] ;
                else 
                    data_rd = parallel_data[i] ;
            end
            if (shift_data < 11) begin
                MOSI = data_reg[10];
                data_reg = {data_reg[9:0], 1'b0}; // Shift left
                // expected_Data = {expected_Data[9:0],MOSI}; 
                shift_data = shift_data + 1'b1;
                if (shift_data == 11)
                    shift_data = 0 ; 
            end 
            // if (opcode==2'b11 && shift ==0)
            //     i++;
        end 
    end
    else 
        MOSI = 1 ;
endfunction 

function void select_SS(logic selet);
		SS_n=selet;
	endfunction  

function void opcode_0(logic[1:0] state);
    opcode =state;
    if (rst_n==0)
    	opcode=2'b00;
    else if (opcode==2'b00)
    	opcode=2'b01;
    else if (opcode==2'b01)
    	opcode=2'b10;
    else if (opcode==2'b10)
    	opcode=2'b11;
    else if (opcode==2'b11)
    	opcode=2'b00;
	
endfunction

function void writing(logic[1:0] state);
 opcode =state;
 if (rst_n==0)
    	opcode=2'b00;
    else if (opcode==2'b00)
    	opcode=2'b01;
    else if (opcode==2'b01)
    	opcode=2'b00;
    else 
    	opcode=2'b00;
	
endfunction

function void Reading(logic[1:0] state);
 opcode =state;
if (rst_n==0)
    	opcode=2'b00;
    else if (opcode==2'b11)
    	opcode=2'b10;
    else if (opcode==2'b10)
    	opcode=2'b11;
    else 
    	opcode=2'b10;
	
endfunction

function void Increment_array();
	i=(i+1)%255 ;
    shift_address = 0 ;
    shift_data    = 0 ;
endfunction 

covergroup SPI_Wrapper@(posedge clk);
    reset: coverpoint rst_n{
        bins reset_asserted ={0};
        bins reset_disable  ={1};
        }
    Address : coverpoint address ;
    Data : coverpoint Din ;
    Opcode: coverpoint opcode {
        bins writing_complete = (2'b00 => 2'b01);
        bins invalid_0 = (2'b00 => 2'b11);
        bins invalid_2 = (2'b01 => 2'b10);
        bins invalid_3 = (2'b10 => 2'b00);
        bins repeat_writing = (2'b01 => 2'b00);
        bins repeat_reading = (2'b11 => 2'b10);
        bins reading_complete = (2'b10 => 2'b11);
        }
    Send_Address_Data : coverpoint opcode{
     bins reading_add  = {2'b10};
     bins writing_add  = {2'b00};
     bins writing_data = {2'b01};
    }
    Recieving_Data :coverpoint opcode{
     bins reading_data = {2'b11}; 
    }
    Starting_Communication : coverpoint SS_n{
    bins Start = {0};
    bins End   = {1};
    bins transaction_back = (0 => 1 => 0) ;
    }

    Data_out : coverpoint data ;
    Sending_Address : cross Send_Address_Data , Address ;
    Sending_Data : cross Send_Address_Data , Data ;
    Receiving : cross Recieving_Data , Data_out ;
endgroup 
SPI_Wrapper =new();
	endclass 
endpackage 