module top();
	bit clk;
	always #10 clk=~clk;
	interface_RAM inst_interface(clk);
	Dp_Sync_RAM DUT_Design (inst_interface);
	RAM_Golden  GOLDEN_REF (inst_interface);
	tb_RAM      TESTBENCH  (inst_interface);
	RAM_Assertion_sva ASSERTION (inst_interface);

     bind Dp_Sync_RAM  RAM_Assertion_sva sva_inst (inst_interface);

endmodule