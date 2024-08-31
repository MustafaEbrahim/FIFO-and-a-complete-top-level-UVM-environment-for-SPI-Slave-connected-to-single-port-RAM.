vlib work
vlog testbench.sv Dp_Sync_RAM.sv top.sv package.sv Golden_model_RAM.sv interface.sv +cover
vsim -voptargs=+acc work.top -cover
run -all
coverage save top.ucdb -du Dp_Sync_RAM -onexit
coverage report -detail -cvg -comments -output fcover_report.txt {}
quit -sim
vlog testbench.sv Dp_Sync_RAM.sv top.sv package.sv Golden_model_RAM.sv interface.sv +cover
vsim -voptargs=+acc work.top -cover
run -all
coverage save top.ucdb -du Dp_Sync_RAM -onexit
quit -sim
vcover report top.ucdb -details -annotate -all -output Code_coverage_report.txt