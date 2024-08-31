package SPI_scoreboard_pkg;
   import uvm_pkg::*; //import uvm package
   import SPI_sequence_item_pkg::*;
   import SPI_config_pkg::*;
   `include "uvm_macros.svh" //import macros
   class SPI_scoreboard extends  uvm_scoreboard;
      `uvm_component_utils(SPI_scoreboard)
      uvm_analysis_export #(SPI_sequence_item) sb_export ;
      uvm_tlm_analysis_fifo #(SPI_sequence_item) sb_fifo ;
      SPI_sequence_item seq_item_sb ;
      logic [7:0] Expected_RAM [255:0] ;
      bit [10:0] wr_address,rd_address,wr_data ;
      logic [7:0] data_out ;
      logic MISO_ref ;
      integer counter = 0 ;
      integer Error_count = 0 ;
      integer correct_count = 0 ;

      function new (string name = "SPI_scoreboard",uvm_component parent = null);
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
               // $display("MISO_ref=%0b",MISO_ref);
               ref_model(seq_item_sb);
               if (seq_item_sb.rst_n==0 ||seq_item_sb.SS_n==1||seq_item_sb.state==Reading_data_s2)begin
                  if (MISO_ref === seq_item_sb.MISO) begin
                     correct_count++ ;
                     `uvm_info("run_phase", $sformatf("Correct MISO out : %s ",seq_item_sb.convert2string()),UVM_HIGH )
                  end
                  else begin
                     Error_count++;
                     `uvm_error("run_phase",$sformatf("Comparsion MISO failed , transaction recieved by the DUT :%s while the MISO_ref :%0b ",seq_item_sb.convert2string(),MISO_ref))
                   end
               end
            end 
         endtask 
         
         task ref_model(SPI_sequence_item seq_item_chk);
            if ( seq_item_chk.rst_n==0 || seq_item_chk.SS_n==1 )begin
               MISO_ref=0;
               counter = 0 ;
            end
            else if ( seq_item_chk.state === Writing_add )begin
               wr_address[10-counter] = seq_item_chk.MOSI ;
               counter=(counter+1)%11;
               // $display("wr_address=x000%0b",wr_address);
               // $display("counter = %0d",counter);
            end
            else if ( seq_item_chk.state === Writing_data )begin
               wr_data[10-counter] = seq_item_chk.MOSI ;
               counter=(counter+1)%11;
               // $display("wr_data=x00%0b",wr_data);
               //  $display("counter = %0d",counter);
               Expected_RAM[wr_address[7:0]] = wr_data[7:0] ;
               // $display("display RAM : RAM= %0p",Expected_RAM);
            end
            else if ( seq_item_chk.state === Reading_add )begin
               rd_address[10 - counter] = seq_item_chk.MOSI ;
               counter=(counter+1)%11;
               // $display("rd_address=x%0b",rd_address);
               // $display("counter = %0d",counter);
            end
            else if ( seq_item_chk.state === Reading_data_s1 )begin
               data_out = Expected_RAM [rd_address[7:0]];
               // $display("data_out from RAM = %0b",data_out);
               counter=(counter+1)%12;
               // $display("counter = %0d",counter);

            end
            else if ( seq_item_chk.state === Reading_data_s2 )begin
               MISO_ref = data_out[7];
               data_out = {data_out[6:0],1'b0};
               counter=(counter+1)%8;
               // $display("data_out =%0b",data_out);
               // $display("counter = %0d",counter);
            end
         endtask 

         function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transaction : %0d ",correct_count),UVM_MEDIUM )
            `uvm_info("report_phase",$sformatf("Total failed transaction : %0d ",Error_count),UVM_MEDIUM )
            
         endfunction 
   endclass  
endpackage 
