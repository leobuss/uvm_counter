VLOG = vlog
VSIM = vsim
VLIB = vlib
VMAP = vmap

INC = +incdir+.
TOP = tb_top
LIB ?= work

# usage: make compile FILE=filename.sv LIB=work_j
compile:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make compile FILE=<file> [LIB=<library>]"; \
		exit 1; \
	fi
	@if [ ! -d "$(LIB)" ]; then \
		$(VLIB) $(LIB); \
	fi
	$(VLOG) -work $(LIB) -sv $(INC) $(FILE)

# List of files for full testbench compile
FILES = \
	socetlib_counter.svh \
	counter_interface.svh \
	counter_transaction.svh \
	counter_sequencer.svh \
	counter_sequence.svh \
	counter_driver.svh \
	counter_monitor.svh \
	counter_agent.svh \
	counter_scoreboard.svh \
	counter_env.svh \
	counter_test.svh \
	tb_top.sv

# Full compile
# usage: make compile_all LIB=work_j
compile_all:
	@if [ ! -d "$(LIB)" ]; then \
		$(VLIB) $(LIB); \
	fi
	$(VLOG) -work $(LIB) -sv $(INC) $(FILES)

# usage: make run LIB=work_j
run:
	@rm -rf $(LIB)
	$(MAKE) compile_all LIB=$(LIB)
	$(VSIM) -c $(LIB).$(TOP) -do "run -all; quit"

# usage: make gui LIB=work_j
gui:
	@rm -rf $(LIB)
	$(MAKE) compile_all LIB=$(LIB)
	$(VSIM) -voptargs="+acc" $(LIB).$(TOP) -do "add wave -r /*; run -all"
