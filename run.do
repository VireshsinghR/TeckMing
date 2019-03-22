vlib work
vmap work work
vlog -sv mem.v tb.sv
vsim -sv_seed 23 -novopt work.mem_tb

add wave -position insertpoint  \
sim:/mem_tb/dut/clk \
sim:/mem_tb/dut/rst \
sim:/mem_tb/dut/en \
sim:/mem_tb/dut/wr_rd \
sim:/mem_tb/dut/addr \
sim:/mem_tb/dut/wr_data \
sim:/mem_tb/dut/rd_data \
sim:/mem_tb/dut/mem_1k \

run -all
