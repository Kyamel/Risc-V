import { execSync, spawnSync } from "child_process";
import { join } from "path";
import { existsSync } from "fs";

// Configurações
const SRC_DIR = "src";
const TB_FILE = "sim/main.cpp sim/cli/simulator.cpp sim/cli/tui.cpp sim/core/memdumper.cpp sim/core/dumpload.cpp";
const OUTPUT_DIR = "obj_dir";
const VCD_FILE = "waveform.vcd";
const PROGRAM_HEX = "programs/exemplo.hex";

// Lista de arquivos fonte
const SOURCES = [
  `${SRC_DIR}/main.v`,
  `${SRC_DIR}/core/rv32e_cpu.v`,
  `${SRC_DIR}/memory/instruction_memory.v`,
  `${SRC_DIR}/core/constants.v`,
  `${SRC_DIR}/stages/if_stage.v`,
  `${SRC_DIR}/stages/id_stage.v`,
  `${SRC_DIR}/stages/ex_stage.v`,
  `${SRC_DIR}/stages/mem_stage.v`,
  `${SRC_DIR}/stages/wb_stage.v`,
  `${SRC_DIR}/control/control_unit.v`,
  `${SRC_DIR}/control/hazard_detection.v`,
  `${SRC_DIR}/control/forwarding_unit.v`,
  `${SRC_DIR}/control/stall_controller.v`,
  `${SRC_DIR}/components/branch_unit.v`,
  `${SRC_DIR}/components/register_file.v`,
  `${SRC_DIR}/components/alu.v`,
  `${SRC_DIR}/components/immediate_generator.v`,
  `${SRC_DIR}/components/pc_generator.v`,
];

// Opções do Verilator
const VERILATOR_OPTS = [
  "-Wall",
  "--trace",
  "-DSIMULATION",
  "--compiler", "clang",
  "--build",
  "--Mdir", OUTPUT_DIR,
  `-I${SRC_DIR}/core`,
  "--Wno-fatal",
];

// Junta o comando
const verilatorCmd = [
  "verilator",
  ...VERILATOR_OPTS,
  "-cc",
  ...SOURCES,
  "--exe", TB_FILE
];

try {
  console.log("Compilando com Verilator...");
  execSync(verilatorCmd.join(" "), { stdio: "inherit" });

  console.log("Compilação bem-sucedida!");

  // Entra no diretório de build
  process.chdir(OUTPUT_DIR);
  console.log("Executando make...");
  execSync("make -f Vmain.mk", { stdio: "inherit" });

  // Volta ao diretório original
  process.chdir("..");

  const executable = join(OUTPUT_DIR, "Vmain");
  if (existsSync(executable)) {
    console.log(`Executando simulação com programa ${PROGRAM_HEX}...`);
    const sim = spawnSync(executable, [PROGRAM_HEX, `--vcd=${VCD_FILE}`], {
      stdio: "inherit",
      timeout: 60000,
    });
    if (sim.error) throw sim.error;
  } else {
    console.error(`Erro: Executável não encontrado em ${executable}`);
    process.exit(1);
  }
} catch (error) {
  console.error("Erro durante o build ou execução:", error.message);
  process.exit(1);
}
