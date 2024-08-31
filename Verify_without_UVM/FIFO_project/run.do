# First Section (Assertions and Simulation)
vlib work
vlog shared_package.sv package_coverage.sv top.sv package_fifo_scoreboard.sv package_transaction.sv FIFO_design_sv.sv Golden_Ref.sv interface.sv Monitor.sv test_check.sv +cover
vlog -work work -vopt -sv -stats=none +incdir+path_to_assertions_dir +define+SIM FIFO_design_sv.sv
vsim -voptargs=+acc work.top -cover
run -all
coverage save top.ucdb -du FIFO -onexit
coverage report -detail -assert -cvg -directive -comments -output Assertion_Fcoverage_reports.txt {}
quit -sim

# Second Section (Code Coverage)
vlog shared_package.sv package_coverage.sv top.sv package_fifo_scoreboard.sv package_transaction.sv FIFO_design_sv.sv Golden_Ref.sv interface.sv Monitor.sv test_check.sv +cover
vsim -voptargs=+acc work.top -cover
run -all
coverage save top.ucdb -du FIFO -onexit
quit -sim
vcover report top.ucdb -details -annotate -all -output Code_coverage_reports.txt
