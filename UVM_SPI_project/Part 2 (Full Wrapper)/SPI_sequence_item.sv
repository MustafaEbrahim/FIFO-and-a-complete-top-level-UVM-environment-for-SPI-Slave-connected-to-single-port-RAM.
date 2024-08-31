package SPI_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh" // Import UVM macros
typedef enum logic [2:0] {Writing_add=3'b000,Writing_data=3'b001,Reading_add=3'b010,Reading_data_s1=3'b011,Reading_data_s2=3'b100,None=3'b101} e_state;

class SPI_sequence_item extends  uvm_sequence_item;
	`uvm_object_utils (SPI_sequence_item)
    
    logic SS_n;
    logic MOSI ;
    logic MISO;
    e_state state ;
    bit [7:0]  add_rd, add_wr , data_rd , data_wr ;
    logic  rst_n;

    function new (string name = "SPI_sequence_item");
    	super.new(name);
    	
    endfunction 

    function string convert2string();
    	return $sformatf("%s SS_n = %0b , MOSI =%0b , rst_n =%0b , MISO=%0b ,state = %0s",super.convert2string 
            ,SS_n,MOSI,rst_n,MISO,state);
    endfunction 

    function string convert2string_stimulus();
    	return $sformatf(" SS_n = %0b , MOSI =%0b , rst_n =%0b ,state = %0s",SS_n,MOSI,rst_n,state );
    endfunction 

endclass 
endpackage 
