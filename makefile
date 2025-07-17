# Ferramentas
VLOG=iverilog
VVP=vvp

# Diretórios base
SRC_DIR=src
TB_DIR=testbench
BUILD_DIR=build

# Paths específicos
ALU_DIR=$(SRC_DIR)/stages/ex/alu/ops
ALU_TB_DIR=$(TB_DIR)/stages/ex/alu/ops
ALU_BUILD_DIR=$(BUILD_DIR)/alu_ops

# Fonte e testbench para ALU ops
ALU_SRCS=$(wildcard $(ALU_DIR)/*.v)
ALU_TBS=$(wildcard $(ALU_TB_DIR)/*.v)
ALU_TARGETS=$(patsubst $(ALU_TB_DIR)/%.v,$(ALU_BUILD_DIR)/%,$(ALU_TBS))

# Parametro: qual target construir/testar, padrão 'all'
TARGET ?= all

# Target padrão: build + run todos os testbenches da ALU ops
all: build test

# Build de todos os ALU ops testbenches
build: $(ALU_TARGETS)

# Executa todos os testbenches compilados
test:
	@for tb in $(ALU_TARGETS); do \
		echo "Executando $$tb..."; \
		$(VVP) $$tb; \
	done

# Regra para compilar e gerar o executável de cada testbench
$(ALU_BUILD_DIR)/%: $(ALU_TB_DIR)/%.v $(ALU_SRCS)
	@mkdir -p $(ALU_BUILD_DIR)
	$(VLOG) -o $@ $^

# Build/testar apenas um testbench específico:
# make run MODULE=add_tb
run: $(ALU_BUILD_DIR)/$(MODULE)
	$(VVP) $(ALU_BUILD_DIR)/$(MODULE)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all build test run clean
