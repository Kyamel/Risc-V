const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configurações de diretórios
const SRC_DIR = "src";
const TB_DIR = "tb";
const BUILD_DIR = "build";
const BIN_DIR = path.join(BUILD_DIR, "bin");
const LOG_DIR = path.join(BUILD_DIR, "log");
const CONFIG_PATH = path.join(__dirname, 'test_config.json');

// Carrega a configuração dos módulos do JSON
const MODULES = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));

/**
 * Compila e executa simulação usando Icarus Verilog
 * @param {string} moduleName Nome do módulo
 * @param {string[]} sources Lista de arquivos fonte
 * @param {string} tbFile Arquivo de testbench
 * @returns {boolean} True se o teste passou, False caso contrário
 */
function runIcarus(moduleName, sources, tbFile) {
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
    ].join(' ');

    console.log(`\n🔧 Compilando módulo: ${moduleName}`);
    
    try {
        // Executa a compilação
        const compileOutput = execSync(compileCmd, { 
            encoding: 'utf-8',
            stdio: ['inherit', 'pipe', 'pipe'] // stdin, stdout, stderr
        });

        // Salva logs de compilação
        fs.writeFileSync(logCompile, compileOutput.stdout || '');
        if (compileOutput.stderr) {
            fs.appendFileSync(logCompile, `\n${compileOutput.stderr}`);
        }

        console.log("🚀 Executando simulação...");
        
        // Executa a simulação
        const simOutput = execSync(`vvp ${outputFile}`, { 
            encoding: 'utf-8',
            stdio: ['inherit', 'pipe', 'pipe'] // stdin, stdout, stderr
        });

        // Exibe e salva a saída da simulação
        console.log(simOutput.stdout || '');
        if (simOutput.stderr) {
            console.log("⚠️ STDERR:");
            console.log(simOutput.stderr);
        }

        fs.writeFileSync(logSim, simOutput.stdout || '');
        if (simOutput.stderr) {
            fs.appendFileSync(logSim, `\n${simOutput.stderr}`);
        }

        console.log(`✅ Teste de '${moduleName}' passou!`);
        return true;
    } catch (error) {
        // Tratamento de erros
        if (error.stdout) {
            console.log(error.stdout);
            fs.writeFileSync(logCompile, error.stdout);
        }
        if (error.stderr) {
            console.log("❌ Erros:");
            console.log(error.stderr);
            fs.appendFileSync(logCompile, `\n${error.stderr}`);
        }

        console.log(`❌ Erro no teste de '${moduleName}'. Verifique o log:`);
        console.log(`   📝 ${error.signal ? logSim : logCompile}`);
        return false;
    }
}

function main() {
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
        const success = runIcarus(
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
    console.log(`✅ Passaram: ${passed}`);
    console.log(`❌ Falharam: ${failed}`);
    console.log(`📁 Executáveis: ${path.resolve(BIN_DIR)}`);
    console.log(`📁 Logs: ${path.resolve(LOG_DIR)}`);

    process.exit(failed > 0 ? 1 : 0);
}

main();