vlog top.sv
vsim -novopt -suppress 12110 top +testcase=test_rand_wr_rd
add wave -position insertpoint sim:/top/dut/*
run -all
