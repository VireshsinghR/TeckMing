vlog -sv 1kb_ram.v ram_tb.sv

vsim -novopt -sv_seed random ram_tb

add wave -position insertpoint sim:/ram_tb/*

add wave -position insertpoint sim:/ram_tb/dut/ram_mem

run -all
