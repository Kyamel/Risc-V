# Makefile for RV32E Simulator with Verilator

# Project settings
PROJECT = rv32e_sim
TOPMODULE = main

# Directories
SRC_DIR = ../src
VERILOG_SOURCES = main.sv $(SRC_DIR)/core/rv32e_cpu.v $(SRC_DIR)/core/constants.v $(SRC_DIR)/core/pipeline_registers.v
VERILOG_SOURCES += $(wildcard $(SRC_DIR)/stages/*.v) $(wildcard $(SRC_DIR)/components/*.v)
VERILOG_SOURCES += $(wildcard $(SRC_DIR)/control/*.v) $(wildcard $(SRC_DIR)/memory/*.v)

# Build directory
BUILD_DIR = obj_dir

# Verilator settings
VERILATOR = verilator
VERILATOR_FLAGS = --cc --exe --build --trace
VERILATOR_FLAGS += -Wall -Wno-UNUSED -Wno-UNOPTFLAT -Wno-EOFNEWLINE -Wno-GENUNNAMED -Wno-UNDRIVEN
VERILATOR_FLAGS += --top-module $(TOPMODULE)
VERILATOR_FLAGS += -I$(SRC_DIR)/core -I$(SRC_DIR)/stages -I$(SRC_DIR)/components -I$(SRC_DIR)/control -I$(SRC_DIR)/memory

# C++ settings
CXX = g++
CXXFLAGS = -std=c++17 -O2 -Wall -Wextra
CXXFLAGS += -I$(BUILD_DIR) -I/usr/share/verilator/include
CXXFLAGS += -I/usr/share/verilator/include/vltstd

# Libraries
LIBS = -ljsoncpp
VERILATOR_LIBS = /usr/share/verilator/include/verilated.cpp
VERILATOR_LIBS += /usr/share/verilator/include/verilated_vcd_c.cpp

# Source files
CPP_SOURCES = main.cpp rv32e_simulator.cpp

# Targets
.PHONY: all clean run install-deps check-deps

all: check-deps $(PROJECT)

# Check dependencies
check-deps:
	@echo "Checking dependencies..."
	@which verilator > /dev/null || (echo "Error: Verilator not found. Please install with 'sudo apt install verilator' or similar" && exit 1)
	@pkg-config --exists jsoncpp || (echo "Error: jsoncpp not found. Please install with 'sudo apt install libjsoncpp-dev' or similar" && exit 1)
	@echo "Dependencies OK"

# Install common dependencies (Ubuntu/Debian)
install-deps:
	sudo apt update
	sudo apt install -y verilator libjsoncpp-dev build-essential

# Build the simulator
$(PROJECT): $(VERILOG_SOURCES) $(CPP_SOURCES)
	@echo "Building Verilog model with Verilator..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILOG_SOURCES) $(CPP_SOURCES) $(VERILATOR_LIBS) -LDFLAGS "$(LIBS)" -o $(PROJECT)
	@echo "Build complete: $(BUILD_DIR)/$(PROJECT)"

# Alternative build method (if the above doesn't work)
$(PROJECT)-alt: $(VERILOG_SOURCES)
	@echo "Building Verilog model (alternative method)..."
	$(VERILATOR) --cc --trace $(VERILOG_SOURCES) --top-module $(TOPMODULE) $(VERILATOR_FLAGS)
	@echo "Compiling C++ simulator..."
	$(CXX) $(CXXFLAGS) -o $(PROJECT) main.cpp rv32e_simulator.cpp \
		$(BUILD_DIR)/V$(TOPMODULE)__ALL.a $(VERILATOR_LIBS) $(LIBS)

# Run the simulator
run: $(PROJECT)
	./$(BUILD_DIR)/$(PROJECT)

# Run with VCD tracing
run-trace: $(PROJECT)
	./$(BUILD_DIR)/$(PROJECT) --trace simulation.vcd

# Clean build files
clean:
	rm -rf $(BUILD_DIR) $(PROJECT) *.vcd *.json

# Show available Verilog files
show-sources:
	@echo "Verilog sources:"
	@echo $(VERILOG_SOURCES) | tr ' ' '\n'

# Help
help:
	@echo "Available targets:"
	@echo "  all          - Build the simulator (default)"
	@echo "  check-deps   - Check if dependencies are installed"
	@echo "  install-deps - Install dependencies (Ubuntu/Debian)"
	@echo "  run          - Build and run the simulator"
	@echo "  run-trace    - Build and run with VCD tracing"
	@echo "  clean        - Clean build files"
	@echo "  show-sources - Show detected Verilog source files"
	@echo "  help         - Show this help"