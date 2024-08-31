module top();
	bit clk;
	always #10 clk=~clk;
	interface_SPI inst_interface(clk);
	SPI_Slave DUT_Design (inst_interface);
	// SPI_Wrapper DUT_Wrapper (inst_interface);
	SPI_Golden  GOLDEN_REF (inst_interface);
	tb_SPI_slave TESTBENCH  (inst_interface);
endmodule