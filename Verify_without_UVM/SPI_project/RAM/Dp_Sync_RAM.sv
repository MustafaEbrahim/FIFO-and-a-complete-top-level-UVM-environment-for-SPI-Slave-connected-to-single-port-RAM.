module Dp_Sync_RAM #(ADDR_SIZE=8,MEM_DEPTH=256)(interface_RAM.DUT_Design inst_interface );

	 logic clk, rst_n, rx_valid;
	 logic [9:0] din;
	 logic tx_valid;
	 logic [7:0] dout;
    
    assign clk      = inst_interface.clk;
    assign rst_n    = inst_interface.rst_n;
    assign rx_valid = inst_interface.rx_valid;
    assign din      = inst_interface.din;

    assign inst_interface.dout     = dout;
    assign inst_interface.tx_valid = tx_valid ;

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



	