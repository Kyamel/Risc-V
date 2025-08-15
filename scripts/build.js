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
const WAVE_DIR = path.join(BUILD_DIR, "wave");

// Caminho para o arquivo de configuração
const CONFIG_PATH = path.join(__dirname, 'new.json');

// Carrega configuração dos módulos
const MODULES = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));

/**
 * Compila e executa simulação usando Icarus Verilog
 * @param {string} moduleName Nome do módulo
 * @param {string[]} sources Lista de arquivos fonte
 * @param {string} tbFile Arquivo de testbench
 * @param {boolean} generateWave Flag para gerar waveform
 * @returns {Promise<boolean>} True se o teste passou, False caso contrário
 */
async function runIcarus(moduleName, sources, tbFile, generateWave = false) {
    // Cria diretórios se não existirem
    fs.mkdirSync(BIN_DIR, { recursive: true });
    fs.mkdirSync(LOG_DIR, { recursive: true });
    if (generateWave) fs.mkdirSync(WAVE_DIR, { recursive: true });

    const outputFile = path.join(BIN_DIR, `${moduleName}.vvp`);
    const logCompile = path.join(LOG_DIR, `${moduleName}_compile.log`);
    const logSim = path.join(LOG_DIR, `${moduleName}_simulate.log`);
    const waveFile = path.join(WAVE_DIR, `${moduleName}.vcd`);

    // Opções de compilação
    const compileOptions = [
        "iverilog", "-DSIMULATION", "-g2005-sv", "-Wall", "-o", outputFile,
        "-I", path.join(SRC_DIR, "core")
    ];

    // Adiciona flag para geração de waveform se necessário
    if (generateWave) {
        compileOptions.push("-DDUMP_VCD");
    }

    // Adiciona arquivos fonte e testbench
    const compileCmd = [...compileOptions, ...sources, tbFile];

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

        // Se gerou waveform, mostra opção para abrir no GTKWave
        if (generateWave && fs.existsSync(waveFile)) {
            console.log(`🌊 Waveform gerado: ${waveFile}`);
            console.log("   Você pode visualizá-lo com o comando:");
            console.log(`   gtkwave ${waveFile}`);
            
            // Pergunta se deseja abrir automaticamente
            const readline = (await import('readline')).createInterface({
                input: process.stdin,
                output: process.stdout
            });
            
            const answer = await new Promise(resolve => {
                readline.question("Abrir no GTKWave agora? (s/N) ", resolve);
            });
            readline.close();
            
            if (answer.toLowerCase() === 's') {
                console.log("🔄 Abrindo GTKWave...");
                await executeCommand(["gtkwave", waveFile], null, true);
            }
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
        const logStream = logFile ? fs.createWriteStream(logFile) : null;
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
            if (logStream) {
                logStream.write(output);
                logStream.end();
            }
            resolve({ success: code === 0 });
        });

        child.on('error', (error) => {
            if (logStream) {
                logStream.write(`Error: ${error.message}\n`);
                logStream.end();
            }
            resolve({ success: false });
        });
    });
}

async function main() {
    // Cria diretórios se não existirem
    fs.mkdirSync(BIN_DIR, { recursive: true });
    fs.mkdirSync(LOG_DIR, { recursive: true });
    fs.mkdirSync(WAVE_DIR, { recursive: true });

    // Verifica se deve gerar waveforms
    const generateWave = process.argv.includes("--wave");
    const selectedModules = process.argv
        .slice(2)
        .filter(arg => arg !== "--wave");

    const modulesToTest = selectedModules.length > 0 
        ? selectedModules 
        : Object.keys(MODULES);

    let passed = 0;
    let failed = 0;

    for (const module of modulesToTest) {
        if (!MODULES[module]) {
            console.log(`⚠️  Módulo '${module}' não encontrado.`);
            failed++;
            continue;
        }

        console.log("=".repeat(50));
        console.log(`🧪 Iniciando teste do módulo: ${module}`);
        if (generateWave) console.log("🌊 Gerando waveform...");
        
        const info = MODULES[module];
        const success = await runIcarus(
            module,
            info.sources,
            info.tb,
            generateWave
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
    if (generateWave) console.log(`📁 Waveforms: ${path.resolve(WAVE_DIR)}`);

    process.exit(failed > 0 ? 1 : 0);
}

main();