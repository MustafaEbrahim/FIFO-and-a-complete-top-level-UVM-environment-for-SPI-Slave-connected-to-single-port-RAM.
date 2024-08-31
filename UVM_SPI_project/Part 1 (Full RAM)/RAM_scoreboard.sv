package RAM_scoreboard_pkg;
   import uvm_pkg::*; //import uvm package
   import RAM_sequence_item_pkg::*;
   import RAM_config_pkg::*;
   `include "uvm_macros.svh" //import macros
   class RAM_scoreboard extends  uvm_scoreboard;
      `uvm_component_utils(RAM_scoreboard)
      uvm_analysis_export #(RAM_sequence_item) sb_export ;
      uvm_tlm_analysis_fifo #(RAM_sequence_item) sb_fifo ;
      RAM_sequence_item seq_item_sb ;

      parameter MEM_DEPTH = 256;
      parameter ADDR_SIZE = 8  ;

      logic [7:0] dout_expect;
      logic tx_valid_expect; 

      logic [7:0] mem [MEM_DEPTH-1:0];
      logic [7:0] address_rd,address_wr;

      integer Error_count = 0 ;
      integer correct_count = 0 ;

      function new (string name = "RAM_scoreboard",uvm_component parent = null);
         super.new (name , parent);
      endfunction

      function void build_phase(uvm_phase phase);
         super.build_phase (phase);
         sb_export = new ("sb_export",this);
         sb_fifo = new ("sb_fifo",this);
       endfunction 

       function void connect_phase(uvm_phase phase);
         super.connect_phase(phase);
         sb_export.connect(sb_fifo.analysis_export);
       endfunction 

         task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
               sb_fifo.get(seq_item_sb);
               ref_model(seq_item_sb);
               if (dout_expect === seq_item_sb.dout) begin
                   correct_count++ ;
                  `uvm_info("run_phase", $sformatf("Correct data out : %s ",seq_item_sb.convert2string()),UVM_HIGH )
               end
               else begin
                  Error_count++;
                  `uvm_error("run_phase",$sformatf("Comparsion out failed , transaction recieved by the DUT :%s while the refernece out:%0b ",seq_item_sb.convert2string(),dout_expect))
               end

               if (tx_valid_expect=== seq_item_sb.tx_valid) begin
                correct_count++;
               `uvm_info("run_phase", $sformatf("Correct data out : %s ",seq_item_sb.convert2string()),UVM_HIGH )
               end
               else begin
                  Error_count++;
                  `uvm_error("run_phase",$sformatf("Comparsion tx_valid failed , transaction recieved by the DUT :%s while the refernece tx_valid=%0b ",seq_item_sb.convert2string(),tx_valid_expect))
               end
               
            end   
         endtask 
         
         task ref_model(RAM_sequence_item seq_item_chk);

            if (~seq_item_chk.rst_n) begin
      // reset
               dout_expect = 0;
               tx_valid_expect = 0;
               address_rd = 0;
               address_wr = 0;
            end
            else if (seq_item_chk.rx_valid == 1'b1)begin
               tx_valid_expect = 0;
               if (seq_item_chk.din [9:8]== 2'b00)
                  address_wr = seq_item_chk.din[7:0];
               else if (seq_item_chk.din [9:8]==2'b01)
                  mem[address_wr] = seq_item_chk.din[7:0];
               else if (seq_item_chk.din [9:8]==2'b10 )
                  address_rd = seq_item_chk.din[7:0];
               else if (seq_item_chk.din [9:8]==2'b11) begin
                  dout_expect = mem[address_rd];
                  tx_valid_expect = 1;
               end
            end
            else 
                 tx_valid_expect = 0; 
         endtask 

         function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transaction : %0d ",correct_count),UVM_MEDIUM )
            `uvm_info("report_phase",$sformatf("Total failed transaction : %0d ",Error_count),UVM_MEDIUM )
            
         endfunction 
   endclass  
endpackage 
