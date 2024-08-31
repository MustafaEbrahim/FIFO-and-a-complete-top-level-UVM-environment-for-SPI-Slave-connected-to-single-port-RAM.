module Dp_Sync_RAM (clk, rst_n, din, rx_valid, dout, tx_valid);
parameter ADDR_SIZE=8 ;
parameter MEM_DEPTH=256 ;
	input  logic clk, rst_n, rx_valid;
	input  logic [9:0] din;
	output logic tx_valid;
	output logic [7:0] dout;
    
	reg [7:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] rd_addr,wr_addr ;
	
	always @(posedge clk ) begin // first bug : rst must be syncrouns no Ashync
		if (!rst_n) begin
		   dout <= 0;
		   tx_valid <= 0; //second bug : tx must take zero when rst_n is asserted
		   wr_addr <= 0 ;
		   rd_addr <= 0 ;//3th bug : when rst_n asserted , addr and not 2 internal signals it only one 
		end
		else if (rx_valid) begin
		   tx_valid <= 0;
		    case (din[9:8])
			2'b00:  wr_addr  <= din[7:0];
			2'b01: mem[wr_addr] <= din[7:0];
			2'b10: rd_addr <= din[7:0];
			default: {dout, tx_valid} <= {mem[rd_addr], 1'b1};
		   endcase
		end
		else begin
			tx_valid  <= 0 ;
		end
		 //4th bug : when rx_valid not asserted then tx_valid must down to zero
	end

endmodule



	