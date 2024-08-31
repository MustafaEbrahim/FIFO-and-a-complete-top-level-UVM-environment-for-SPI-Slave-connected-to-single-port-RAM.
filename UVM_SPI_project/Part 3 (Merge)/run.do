vlib work
vlog -f slc_file.txt -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
coverage save RAM_CV.ucdb -onexit -du Dp_Sync_RAM_wrapper
run -all
quit -sim
vcover report RAM_CV.ucdb -all -annotate -details -output code_coverage_RAM.txt
vlib work
vlog -f slc_file.txt -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
coverage save SPI_Wrapper_CV.ucdb -onexit -du SPI_Wrapper
run -all
quit -sim
vcover report SPI_Wrapper_CV.ucdb -all -annotate -details -output code_coverage_SPI_Wrapper.txt
vlib work
vlog -f slc_file.txt -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
run -all
coverage report -detail -cvg -comments -output fcover_report.txt {}
quit -sim