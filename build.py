import os
import subprocess
import sys

# Configurações do projeto
VLOG = "iverilog"
VVP = "vvp"

SRC_DIR = "src"
TB_DIR = "testbench"
BUILD_DIR = "build"

# ALU
ALU_SRC = os.path.join(SRC_DIR, "stages/EX/ALU.v")
ALU_TB_DIR = os.path.join(TB_DIR, "stages/EX")
ALU_BUILD_DIR = os.path.join(BUILD_DIR, "alu")

ALU_TBS = [f for f in os.listdir(ALU_TB_DIR) if f.endswith("_tb.v")]
ALU_TARGETS = [os.path.join(ALU_BUILD_DIR, tb.replace(".v", "")) for tb in ALU_TBS]

# Decoder
DECODER_SRC = os.path.join(SRC_DIR, "decoder/InstructionDecoder.v")
DECODER_TB = os.path.join(TB_DIR, "decoder/InstructionDecoder_tb.v")
DECODER_BUILD_DIR = os.path.join(BUILD_DIR, "decoder")
DECODER_TARGET = os.path.join(DECODER_BUILD_DIR, "InstructionDecoder_tb")

def mkdir_p(path):
    if not os.path.exists(path):
        os.makedirs(path)

def run_cmd(cmd):
    print(f"> {' '.join(cmd)}")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Erro na execução do comando: {e.stderr}")
        sys.exit(e.returncode)

    
def build_alu():
    print("=== Build ALU Testbenches ===")
    mkdir_p(ALU_BUILD_DIR)
    # Arquivos extra que o ALU_tb usa
    alu_control = os.path.join(SRC_DIR, "stages/EX/control/ALUControl.v")
    control_unit = os.path.join(SRC_DIR, "stages/EX/control/ControlUnit.v")

    for tb in ALU_TBS:
        tb_path = os.path.join(ALU_TB_DIR, tb)
        target = os.path.join(ALU_BUILD_DIR, tb.replace(".v", ""))
        cmd = [VLOG, "-o", target, tb_path, ALU_SRC, alu_control, control_unit]
        run_cmd(cmd)


def test_alu():
    print("=== Test ALU ===")
    for target in ALU_TARGETS:
        print(f"Executando {target} ...")
        run_cmd([VVP, target])

def build_decoder():
    print("=== Build Decoder Testbench ===")
    mkdir_p(DECODER_BUILD_DIR)
    cmd = [VLOG, "-o", DECODER_TARGET, DECODER_TB, DECODER_SRC]
    run_cmd(cmd)

def test_decoder():
    print("=== Test Decoder ===")
    print(f"Executando {DECODER_TARGET} ...")
    run_cmd([VVP, DECODER_TARGET])

def main():
    if len(sys.argv) == 1:
        # Default: build all + test all
        build_alu()
        build_decoder()
        test_alu()
        test_decoder()
    else:
        cmd = sys.argv[1].lower()
        if cmd == "build":
            build_alu()
            build_decoder()
        elif cmd == "test":
            test_alu()
            test_decoder()
        elif cmd == "build_alu":
            build_alu()
        elif cmd == "test_alu":
            test_alu()
        elif cmd == "build_decoder":
            build_decoder()
        elif cmd == "test_decoder":
            test_decoder()
        else:
            print("Uso: python build_and_test.py [build|test|build_alu|test_alu|build_decoder|test_decoder]")

if __name__ == "__main__":
    main()
