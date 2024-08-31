module top();
	bit clk;
	always #10 clk=~clk;
	interface_FIFO inst_interface(clk);
	FIFO DUT_Design (inst_interface);
	// FIFO_Assertion_sva DUT_Assertion (inst_interface);
	FIFO_GOLDEN GOLDEN_REF (inst_interface);
	tb_FIFO TESTBENCH (inst_interface);
	monitor MONITOR(inst_interface);
	// bind FIFO  FIFO_Assertion_sva sva_inst (inst_interface);
endmodule