vlib work
vlog -f slc_file.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/RAMif/*
run -all
