interface RAM_if ();
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8  ;
    logic rst_n     ;
    logic [9:0] din ;
    logic rx_valid  ;
    logic [7:0] dout;
    logic tx_valid ;
endinterface 

