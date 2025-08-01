#!/bin/bash

# Configurações
SRC_DIR="src"
TB_FILE="sim/main.cpp"
OUTPUT_DIR="obj_dir"
VCD_FILE="waveform.vcd"
PROGRAM_HEX="programs/exemplo.hex"

# Lista de arquivos fonte (igual ao seu sources.json)
SOURCES=(
    "$SRC_DIR/main.v"
    "$SRC_DIR/core/rv32e_cpu.v"
    "$SRC_DIR/memory/instruction_memory.v"
    "$SRC_DIR/core/constants.v"
    "$SRC_DIR/stages/if_stage.v"
    "$SRC_DIR/stages/id_stage.v"
    "$SRC_DIR/stages/ex_stage.v"
    "$SRC_DIR/stages/mem_stage.v"
    "$SRC_DIR/stages/wb_stage.v"
    "$SRC_DIR/control/control_unit.v"
    "$SRC_DIR/control/hazard_detection.v"
    "$SRC_DIR/control/forwarding_unit.v"
    "$SRC_DIR/control/stall_controller.v"
    "$SRC_DIR/components/branch_unit.v"
    "$SRC_DIR/components/register_file.v"
    "$SRC_DIR/components/alu.v"
    "$SRC_DIR/components/immediate_generator.v"
    "$SRC_DIR/components/pc_generator.v"
)

# Opções de compilação equivalentes às do Icarus
VERILATOR_OPTS=(
    "-Wall"                 # Ativa todos os warnings
    "--trace"              # Habilita geração de traces (para VCD)
    "-DSIMULATION"         # Define macro SIMULATION (equivalente ao -D no Icarus)
    "--compiler" "clang"   # Usa clang como compilador (pode ser gcc também)
    "--build"              # Compila e linka automaticamente
    "--Mdir" "$OUTPUT_DIR" # Diretório de saída
    "-I$SRC_DIR/core"      # Inclui path para os includes (como constants.v)

     # Opção para continuar mesmo com warnings
    "--Wno-fatal"
)

# Comando de compilação
echo "Compilando com Verilator..."
verilator "${VERILATOR_OPTS[@]}" -cc "${SOURCES[@]}" --exe "$TB_FILE"

# Verifica se a compilação foi bem sucedida
if [ $? -eq 0 ]; then
    echo "Compilação bem-sucedida!"
    
    # Entra no diretório de output para fazer o build
    cd "$OUTPUT_DIR"
    make -f Vmain.mk
    
    # Volta ao diretório original e executa
    cd ..
    if [ -f "$OUTPUT_DIR/Vmain" ]; then
        echo "Executando simulação com programa $PROGRAM_HEX..."
        time "$OUTPUT_DIR/Vmain" "$PROGRAM_HEX" "--vcd=$VCD_FILE"
    else
        echo "Erro: Executável não encontrado em $OUTPUT_DIR/Vmain"
        exit 1
    fi
else
    echo "Erro durante a compilação com Verilator"
    exit 1
fi