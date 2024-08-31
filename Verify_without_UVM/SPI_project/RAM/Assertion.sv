module RAM_Assertion_sva (interface_RAM.ASSERTION inst_interface );
    bit  clk;
    logic rst_n     ;
    logic [9:0] din ;
    logic rx_valid  ;
    logic [7:0] dout, dout_expect;
    logic tx_valid ,tx_valid_expect ;
    logic [1:0] opcode;

    assign clk      = inst_interface.clk;
    assign rst_n    = inst_interface.rst_n;
    assign rx_valid = inst_interface.rx_valid;
    assign din      = inst_interface.din;
    assign dout_expect     = inst_interface.dout_expect;
    assign tx_valid_expect = inst_interface.tx_valid_expect ;
    assign dout     = inst_interface.dout;
    assign tx_valid = inst_interface.tx_valid ;
    assign opcode   = din[9:8];


	property DATA_OUT;
	@(posedge clk) disable iff (~rst_n )
	 (opcode == 2'b00)  |=> (opcode == 2'b01) |=> (opcode == 2'b10) |=> (opcode == 2'b11) |=> (dout == dout_expect) |-> (tx_valid == tx_valid_expect); 
	endproperty

	 property RESET;
    @(posedge clk)
     (rst_n==0) |=> (dout==0) |->(tx_valid==0);
	endproperty

	 property ENABLE ;
    @(posedge clk) disable iff (~rst_n)
     (rx_valid==0) |=> ($past(dout)==dout) ;
	endproperty

		DATA_OUT_Assertion: assert property (DATA_OUT) else $display("DATA_OUT fail");
        RESET_Assertion   : assert property (RESET)    else $display("RESET fail   ");
        ENABLE_Assertion  : assert property (ENABLE)   else $display("ENABLE fail  ");

        DATA_OUT_Cover: cover property (DATA_OUT) $display("DATA_OUT pass");
        RESET_Cover   : cover property (RESET)    $display("RESET pass   ");
        ENABLE_Cover  : cover property (ENABLE)   $display("ENABLE pass  ");

    endmodule