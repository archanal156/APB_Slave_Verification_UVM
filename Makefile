# APB Slave UVM Verification - Makefile
# Usage:
#   make questa   -> compile & run with Questa/ModelSim
#   make vcs      -> compile & run with Synopsys VCS
#   make clean    -> remove simulator-generated junk

TOP        = tb/top.sv
UVM_HOME  ?= $(shell which questa_uvm_home 2>/dev/null || echo "")

questa:
	vlib work
	vlog -sv +incdir+tb +incdir+rtl -f filelist.f
	vsim -c work.testbench -do "run -all; quit"

vcs:
	vcs -sverilog -ntb_opts uvm -timescale=1ns/1ps -f filelist.f -o simv
	./simv

clean:
	rm -rf work transcript *.wlf csrc simv simv.daidir \
	       ucli.key vc_hdrs.h *.log dump.vcd xcelium.d *.history
