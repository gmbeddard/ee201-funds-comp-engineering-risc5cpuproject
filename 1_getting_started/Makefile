IVERILOG=iverilog # Command to run Icarus Verilog, you can specify a full path if need be
IVERILOG_FLAGS="-g2012"
VVP=vvp # Command to run vvp (Icarus Verilog runtime), specify a full path if necessary

VERILATOR=verilator # Command to run Verilator
# Flags to run verilator in "lint mode" (i.e., syntax checking only)
VERILATOR_FLAGS=--lint-only -Wno-STMTDLY -Wno-UNOPTFLAT -Wno-UNUSED

# Typing "make" with no arguments will run the "all" target
all: counter


counter:
	@# Run Verilator first to check for any code errors
	@$(VERILATOR) $(VERILATOR_FLAGS) counter.sv # counter_test.sv
	@# Then run the iverilog "compiler"
	@$(IVERILOG) $(IVERILOG_FLAGS) counter.sv counter_test.sv
	@# And finally execute the simulation
	@$(VVP) a.out

