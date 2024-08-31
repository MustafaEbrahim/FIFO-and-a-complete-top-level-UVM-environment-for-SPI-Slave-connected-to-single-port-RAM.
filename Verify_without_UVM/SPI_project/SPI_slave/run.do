vlib work
vlog package.sv SPI_SLAVE.sv testbench.sv SPI_Golden.sv top.sv interface.sv +cover
vsim -voptargs=+acc work.top -cover
run -all
coverage save top.ucdb -du SPI_Slave -onexit
coverage report -detail -cvg -comments -output fcover_report.txt {}
quit -sim
vcover report top.ucdb -details -annotate -all -output Code_coverage_report.txt 
