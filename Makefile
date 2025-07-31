# Makefile for RISC-V Pipeline Tests

# Directories
SRC_DIR = src
TB_DIR = tb
BUILD_DIR = build

# Tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Include paths
INCLUDE_DIRS = -I$(SRC_DIR)/core -I$(SRC_DIR)/stages -I$(SRC_DIR)/components -I$(SRC_DIR)/control

# Source files for pipeline test
PIPELINE_SOURCES = \
	$(SRC_DIR)/core/constants.v \
	$(SRC_DIR)/stages/if_stage.v \
	$(SRC_DIR)/stages/id_stage.v \
	$(SRC_DIR)/stages/ex_stage.v \
	$(SRC_DIR)/components/pc_generator.v \
	$(SRC_DIR)/components/alu.v \
	$(SRC_DIR)/components/immediate_generator.v \
	$(SRC_DIR)/control/control_unit.v \
	$(TB_DIR)/stages/tb_pipeline_stages.v

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Pipeline stages test
pipeline_test: $(BUILD_DIR)
	$(IVERILOG) $(INCLUDE_DIRS) -o $(BUILD_DIR)/tb_pipeline_stages $(PIPELINE_SOURCES)
	$(VVP) $(BUILD_DIR)/tb_pipeline_stages

# View waveform
view_pipeline:
	$(GTKWAVE) pipeline_stages.vcd &

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd

# Run specific tests
test_pipeline: pipeline_test

.PHONY: clean test_pipeline view_pipeline pipeline_test