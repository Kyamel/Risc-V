import fs from 'fs';
import path from 'path';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Emular __dirname com ESModules
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Diretórios
const SRC_DIR = "src";
const TB_DIR = "tb";
const BUILD_DIR = "build";
const BIN_DIR = path.join(BUILD_DIR, "bin");
const LOG_DIR = path.join(BUILD_DIR, "log");

// Caminho para o arquivo de configuração
const CONFIG_PATH = path.join(__dirname, 'new.json');

// Carrega configuração dos módulos
const MODULES = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));


/**
 * Compila e executa simulação usando Icarus Verilog
 * @param {string} moduleName Nome do módulo
 * @param {string[]} sources Lista de arquivos fonte
 * @param {string} tbFile Arquivo de testbench
 * @returns {Promise<boolean>} True se o teste passou, False caso contrário
 */
async function runIcarus(moduleName, sources, tbFile) {
    // Cria diretórios se não existirem
    fs.mkdirSync(BIN_DIR, { recursive: true });
    fs.mkdirSync(LOG_DIR, { recursive: true });

    const outputFile = path.join(BIN_DIR, `${moduleName}.vvp`);
    const logCompile = path.join(LOG_DIR, `${moduleName}_compile.log`);
    const logSim = path.join(LOG_DIR, `${moduleName}_simulate.log`);

    // Comando de compilação
    const compileCmd = [
        "iverilog", "-DSIMULATION", "-g2005-sv", "-Wall", "-o", outputFile,
        "-I", path.join(SRC_DIR, "core"),
        ...sources,
        tbFile
    ];

    console.log(`\n🔧 Compilando módulo: ${moduleName}`);
    
    try {
        // Executa a compilação
        const compileResult = await executeCommand(compileCmd, logCompile);
        if (!compileResult.success) {
            console.log("❌ Erro na compilação. Verifique o log:");
            console.log(`   📝 ${logCompile}`);
            return false;
        }

        console.log("🚀 Executando simulação...");
        
        // Executa a simulação
        const simResult = await executeCommand(["vvp", outputFile], logSim, true);
        
        if (!simResult.success) {
            console.log("❌ Erro na simulação. Verifique o log:");
            console.log(`   📝 ${logSim}`);
            return false;
        }

        console.log(`✅ Teste de '${moduleName}' compilou! Verifique os testes acima.`);
        return true;
    } catch (error) {
        console.error(`❌ Erro inesperado: ${error.message}`);
        return false;
    }
}

/**
 * Executa um comando e captura a saída
 * @param {string[]} command Comando e argumentos
 * @param {string} logFile Arquivo de log
 * @param {boolean} showOutput Mostrar saída no console
 * @returns {Promise<{success: boolean}>} Resultado da execução
 */
function executeCommand(command, logFile, showOutput = false) {
    return new Promise((resolve) => {
        const logStream = fs.createWriteStream(logFile);
        const child = spawn(command[0], command.slice(1));

        let output = '';
        
        child.stdout.on('data', (data) => {
            const strData = data.toString();
            output += strData;
            if (showOutput) {
                process.stdout.write(strData);
            }
        });

        child.stderr.on('data', (data) => {
            const strData = data.toString();
            output += strData;
            if (showOutput) {
                process.stderr.write(strData);
            }
        });

        child.on('close', (code) => {
            logStream.write(output);
            logStream.end();
            resolve({ success: code === 0 });
        });

        child.on('error', (error) => {
            logStream.write(`Error: ${error.message}\n`);
            logStream.end();
            resolve({ success: false });
        });
    });
}

async function main() {
    // Cria diretórios se não existirem
    fs.mkdirSync(BIN_DIR, { recursive: true });
    fs.mkdirSync(LOG_DIR, { recursive: true });

    const selectedModules = process.argv.length > 2 
        ? process.argv.slice(2) 
        : Object.keys(MODULES);

    let passed = 0;
    let failed = 0;

    for (const module of selectedModules) {
        if (!MODULES[module]) {
            console.log(`⚠️  Módulo '${module}' não encontrado.`);
            failed++;
            continue;
        }

        console.log("=".repeat(50));
        console.log(`🧪 Iniciando teste do módulo: ${module}`);
        
        const info = MODULES[module];
        const success = await runIcarus(
            module,
            info.sources,
            info.tb
        );

        if (success) {
            passed++;
        } else {
            failed++;
        }
    }

    console.log("=".repeat(50));
    console.log(`\n📊 Resumo dos testes:`);
    console.log(`✅ Compilaram: ${passed}`);
    console.log(`❌ Falharam: ${failed}`);
    console.log(`📁 Executáveis: ${path.resolve(BIN_DIR)}`);
    console.log(`📁 Logs: ${path.resolve(LOG_DIR)}`);

    process.exit(failed > 0 ? 1 : 0);
}

main();