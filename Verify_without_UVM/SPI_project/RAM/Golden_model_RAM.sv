module RAM_Golden #(ADDR_SIZE=8,MEM_DEPTH=256)(interface_RAM.GOLDEN_REF inst_interface);

logic clk, rst_n, rx_valid;
logic [9:0] din;

logic [7:0] dout_expect;
logic tx_valid_expect;

assign clk      = inst_interface.clk;
assign rst_n    = inst_interface.rst_n;
assign rx_valid = inst_interface.rx_valid;
assign din      = inst_interface.din;

assign inst_interface.dout_expect     = dout_expect;
assign inst_interface.tx_valid_expect = tx_valid_expect ;

reg [7:0] mem [MEM_DEPTH-1:0];

reg [7:0] address_rd,address_wr;

always @(posedge clk) begin  //async rst is not supported with RAM
	if (~rst_n) begin
		// reset
		dout_expect <= 0;
		tx_valid_expect <= 0;
        address_rd <= 0;
		address_wr <= 0;
	end
	else if (rx_valid == 1'b1)begin
		tx_valid_expect <= 0;
		if (din [9:8]== 2'b00)
			address_wr <= din[7:0];
		else if (din [9:8]==2'b01)
				mem[address_wr] <= din[7:0];
		else if (din [9:8]==2'b10 )
			address_rd <= din[7:0];
		else if (din [9:8]==2'b11) begin
				dout_expect <= mem[address_rd];
				tx_valid_expect <= 1;
		end
	end
	else 
	tx_valid_expect <= 0;    

end
endmodule