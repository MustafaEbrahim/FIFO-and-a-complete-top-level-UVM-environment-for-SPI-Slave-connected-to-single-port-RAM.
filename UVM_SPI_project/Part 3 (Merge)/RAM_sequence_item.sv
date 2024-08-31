package RAM_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh" // Import UVM macros
class RAM_sequence_item extends  uvm_sequence_item;
	`uvm_object_utils (RAM_sequence_item)
    
    // rand logic rst_n;
    bit [1:0] opcode ;
    logic rst_n ;
    bit [7:0] address,data_wr,addr_wr,addr_rd;
    rand logic [9:0] din;
    rand logic rx_valid;
    logic [7:0] dout;
    logic tx_valid;

    constraint ports {
    // rst_n    dist {1:=1000 , 0:=10};
    rx_valid dist {1:=1000 , 0:=10};
    din[9:8] == opcode ;
    din[7:0] == address ; 

    }
    function void opcode_0(bit[1:0] state);
 opcode =state;
// if (rst_n==0)
//         opcode=2'b00;
    if (opcode==2'b00)
        opcode=2'b01;
    else if (opcode==2'b01)
        opcode=2'b10;
    else if (opcode==2'b10)
        opcode=2'b11;
    else if (opcode==2'b11)
        opcode=2'b00;
    
endfunction  

function void writing(bit[1:0] state);
 opcode =state;
 // if (rst_n==0)
 //        opcode=2'b00;
    if (opcode==2'b00)
        opcode=2'b01;
    else if (opcode==2'b01)
        opcode=2'b00;
    else 
        opcode=2'b00;
    
endfunction
function void Reading(bit[1:0] state);
 opcode =state;
// if (rst_n==0)
//         opcode=2'b00;
    if (opcode==2'b11)
        opcode=2'b10;
    else if (opcode==2'b10)
        opcode=2'b11;
    else 
        opcode=2'b10;
    
endfunction

    function new (string name = "RAM_sequence_item");
    	super.new(name);
    	
    endfunction 

    function string convert2string();
    	return $sformatf("%s din =%0b , rx_valid =%0b , tx_valid =%0b , dout=%0b ",super.convert2string 
            ,din,rx_valid,tx_valid,dout);
    endfunction 

    function string convert2string_stimulus();
    	return $sformatf(" din =%0b , rx_valid =%0b ",din,rx_valid );
    endfunction 

endclass 
endpackage 
