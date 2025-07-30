import subprocess
import os
import sys

# Caminho base (pode ajustar)
CODE_DIR = "./code"
ASM_FILE = os.path.join(CODE_DIR, "prog.s")
OBJ_FILE = os.path.join(CODE_DIR, "prog.o")
ELF_FILE = os.path.join(CODE_DIR, "prog.elf")
HEX_FILE = os.path.join(CODE_DIR, "prog.hex")

def run_command(cmd, desc):
    print(f"==> {desc}")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Erro ao executar '{' '.join(cmd)}'")
        sys.exit(1)

def assemble():
    run_command(
        ["riscv32-none-elf-as", "-march=rv32e", "-o", OBJ_FILE, ASM_FILE],
        "Montando código assembly"
    )

def link():
    run_command(
        ["riscv32-none-elf-ld", "-Ttext=0x0", "-o", ELF_FILE, OBJ_FILE],
        "Linkando objeto para gerar ELF"
    )

def objcopy():
    run_command(
        ["riscv32-none-elf-objcopy", "-O", "verilog", ELF_FILE, HEX_FILE],
        "Convertendo ELF para .hex em formato Verilog"
    )

if __name__ == "__main__":
    if not os.path.exists(ASM_FILE):
        print(f"Arquivo '{ASM_FILE}' não encontrado.")
        sys.exit(1)

    assemble()
    link()
    objcopy()
    print("✅ Compilação concluída com sucesso.")
