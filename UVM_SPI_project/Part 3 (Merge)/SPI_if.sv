typedef enum logic [2:0] {Writing_add=3'b000,Writing_data=3'b001,Reading_add=3'b010,Reading_data_s1=3'b011,Reading_data_s2=3'b100,None=3'b101} e_state;
interface SPI_if (clk);
    //(MOSI, SS_n, clk, rst_n, MISO);
    input bit clk ;
    logic MOSI, SS_n, rst_n;
    logic MISO;
    e_state state;
endinterface 
