package package_RAM;
	class  RAM ;
    bit clk;
    rand logic rst_n;
    bit [1:0] opcode ;
    bit [7:0] address  , data_wr , addr_wr,addr_rd;
    rand logic [9:0] din;
    rand logic rx_valid;
    logic [7:0] dout;
    logic tx_valid;

    constraint ports {
    rst_n    dist {1:=1000 , 0:=10};
    rx_valid dist {1:=1000 , 0:=10};
    din[9:8] == opcode ;
    din[7:0] == address ; 

    }
function void Data_out();
  if (opcode==2'b00)
           addr_wr=din [7:0];
    else if (opcode==2'b01)
           data_wr=din [7:0];  
    else if (opcode==2'b10)
           addr_rd=din [7:0];  
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
function void set_rx_valid(logic select);
    rx_valid = select ;
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

    covergroup cvg@(posedge clk);
    	reset: coverpoint rst_n{
    	bins reset_asserted ={0};
    	bins reset_disable  ={1};
    	}

    	data_valid:coverpoint din[9:8]{
    	bins writing_complete = (2'b00 => 2'b01);
    	bins writing = {2'b00};
    	bins repeat_writing =(2'b01 => 2'b00 => 2'b01);
    	bins reading_complete = (2'b10 => 2'b11);
    	bins reading = {2'b10};
    	bins change_wr_rd =(2'b01 => 2'b10);
    	bins change_rd_wr =(2'b11 => 2'b00); 
    	bins repeat_reading =(2'b11 => 2'b10 => 2'b11);
    	bins default_values []={2'b00,2'b01,2'b10,2'b11};
    	}
    	data_written   :coverpoint data_wr;
        data_read      :coverpoint dout   ;
        address_written:coverpoint addr_wr;
        address_read   :coverpoint addr_rd;

    	receive_valid: coverpoint rx_valid{
    	bins receive_asserted ={1};
    	bins receive_disable  ={0};
    	}
        send_valid:coverpoint tx_valid{
        bins send_asserted ={1};
        bins send_disable  ={0};
        }
    	
        Writing_address: cross address_written,receive_valid{
         // ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
    	}
        Writing_data: cross data_written,receive_valid{
         // ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
        }
        reading_address: cross address_read,receive_valid{
         // ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
        }
        reading_data: cross data_read,receive_valid{
         ignore_bins ignore_bin1 = binsof (receive_valid. receive_disable);
        }
    	
    endgroup 
    cvg=new();
    endclass 
endpackage 