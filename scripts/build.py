# scripts/run_tests.py

import subprocess
import sys
from pathlib import Path

# Diretórios principais
SRC_DIR = Path("src")
TB_DIR = Path("tb")
BUILD_DIR = Path("build")
BIN_DIR = BUILD_DIR / "bin"
LOG_DIR = BUILD_DIR / "log"

# Módulos e seus arquivos
MODULES = {
    "alu": {
        "sources": [
            SRC_DIR / "components" / "alu.v",
        ],
        "tb": TB_DIR / "components" / "tb_alu.v",
    },
    "ex_stage": {
        "sources": [
            SRC_DIR / "stages" / "ex_stage.v",
            SRC_DIR / "components" / "alu.v",
            SRC_DIR / "components" / "immediate_generator.v",
        ],
        "tb": TB_DIR / "stages" / "tb_ex_stage.v",
    },
    "id_stage": {
        "sources": [
            SRC_DIR / "stages" / "id_stage.v",
            SRC_DIR / "components" / "immediate_generator.v",
            SRC_DIR / "control" / "control_unit.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "stages" / "tb_id_stage.v",
    },
    "mem_stage": {
        "sources": [
            SRC_DIR / "stages" / "mem_stage.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "stages" / "tb_mem_stage.v",
    },
    "wb_stage": {
        "sources": [
            SRC_DIR / "stages" / "wb_stage.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "stages" / "tb_wb_stage.v",
    },
    "instruction_memory": {
        "sources": [
            SRC_DIR / "memory" / "instruction_memory.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "memory" / "tb_instruction_memory.v",
    },
    "data_memory": {
        "sources": [
            SRC_DIR / "memory" / "data_memory.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "memory" / "tb_data_memory.v",
    },
    "pc_generator": {
        "sources": [
            SRC_DIR / "components" / "pc_generator.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "components" / "tb_pc_generator.v",
    },
    "branch_unit": {
        "sources": [
            SRC_DIR / "components" / "branch_unit.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "components" / "tb_branch_unit.v",
    },
    "memory_interface": {
        "sources": [
            SRC_DIR / "components" / "memory_interface.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "components" / "tb_memory_interface.v",
    },
    "control_unit": {
        "sources": [
            SRC_DIR / "control" / "control_unit.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "control" / "tb_control_unit.v",
    },
    "forwarding_unit": {
        "sources": [
            SRC_DIR / "control" / "forwarding_unit.v",
            SRC_DIR / "core" / "constants.v",
        ],
        "tb": TB_DIR / "control" / "tb_forwarding_unit.v",
    },
}

def run_icarus(module_name, sources, tb_file):
    """Compila e executa simulação usando Icarus Verilog"""
    BIN_DIR.mkdir(parents=True, exist_ok=True)
    LOG_DIR.mkdir(parents=True, exist_ok=True)

    output_file = BIN_DIR / f"{module_name}.vvp"
    log_compile = LOG_DIR / f"{module_name}_compile.log"
    log_sim = LOG_DIR / f"{module_name}_simulate.log"

    cmd_compile = [
        "iverilog", "-DSIMULATION", "-g2005-sv", "-Wall", "-o", str(output_file),
        
        "-I", str(SRC_DIR / "core"),
        *map(str, sources),
        str(tb_file)
    ]

    print(f"\n🔧 Compilando módulo: {module_name}")
    result_compile = subprocess.run(
        cmd_compile,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace"
    )

    with open(log_compile, "w", encoding="utf-8") as f:
        f.write(result_compile.stdout or "")
        f.write("\n")
        f.write(result_compile.stderr or "")

    if result_compile.returncode != 0:
        print("❌ Erro na compilação. Verifique o log:")
        print(f"   📝 {log_compile}")
        return False

    print("🚀 Executando simulação...")
    result_run = subprocess.run(
        ["vvp", str(output_file)],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace"
    )

    # Sempre exibe no terminal
    print(result_run.stdout or "")
    if result_run.stderr:
        print("⚠️ STDERR:")
        print(result_run.stderr)

    # Também salva no log
    with open(log_sim, "w", encoding="utf-8") as f:
        f.write(result_run.stdout or "")
        f.write("\n")
        f.write(result_run.stderr or "")

    if result_run.returncode != 0:
        print("❌ Erro na simulação. Verifique o log:")
        print(f"   📝 {log_sim}")
        return False

    print(f"✅ Teste de '{module_name}' passou!")
    return True

def main():
    BIN_DIR.mkdir(parents=True, exist_ok=True)
    LOG_DIR.mkdir(parents=True, exist_ok=True)

    selected_modules = sys.argv[1:] if len(sys.argv) > 1 else MODULES.keys()

    passed = 0
    failed = 0

    for module in selected_modules:
        if module not in MODULES:
            print(f"⚠️  Módulo '{module}' não encontrado.")
            failed += 1
            continue

        print("=" * 50)
        print(f"🧪 Iniciando teste do módulo: {module}")
        info = MODULES[module]
        success = run_icarus(module, info["sources"], info["tb"])
        if success:
            passed += 1
        else:
            failed += 1

    print("=" * 50)
    print(f"\n📊 Resumo dos testes:")
    print(f"✅ Passaram: {passed}")
    print(f"❌ Falharam: {failed}")
    print(f"📁 Executáveis: {BIN_DIR.resolve()}")
    print(f"📁 Logs: {LOG_DIR.resolve()}")

    sys.exit(1 if failed > 0 else 0)

if __name__ == "__main__":
    main()
