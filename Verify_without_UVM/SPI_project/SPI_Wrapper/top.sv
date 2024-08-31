module top();
	bit clk;
	always #10 clk=~clk;
	interface_SPI inst_interface(clk);
	SPI_Wrapper DUT_Wrapper (inst_interface);
	tb_SPI_Wrapper TESTBENCH  (inst_interface);
endmodule