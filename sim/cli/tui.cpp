#include "tui.h"
#include "../core/dumpload.h"
#include <iostream>
#include <iomanip>
#include <string>
#include <bitset>

using json = nlohmann::json;
using namespace std;

// Variável estática para manter uma única instância de DumpLoad
static unique_ptr<DumpLoad> dumpLoader = nullptr;

void Tui::printRegisters(const nlohmann::json& j) {
    if (!dumpLoader) {
        cerr << "Error: DumpLoad not initialized!" << endl;
        return;
    }
    dumpLoader->printRegisters();
}

void Tui::printMemory(const nlohmann::json& j, const std::string& mem_type, 
                     uint32_t start, uint32_t count) {
    if (!dumpLoader) {
        cerr << "Error: DumpLoad not initialized!" << endl;
        return;
    }

    if (mem_type == "imem") {
        dumpLoader->printInstructionMemory(start, count);
    } else if (mem_type == "dmem") {
        dumpLoader->printDataMemory(start, count);
    } else {
        cerr << "Invalid memory type: " << mem_type << endl;
    }
}

void Tui::printPCAndInstruction(const nlohmann::json& j) {
    if (!dumpLoader) {
        cerr << "Error: DumpLoad not initialized!" << endl;
        return;
    }

    cout << "\n=== Program Counter ===\n";
    cout << "PC: " << dumpLoader->getPC() << "\n";
    cout << "Current instruction: " << dumpLoader->getCurrentInstruction() << "\n";
}

void Tui::view_state(const std::string& json_file) {
    try {
        // Inicializa o DumpLoad uma única vez
        dumpLoader = make_unique<DumpLoad>(json_file);
        
        // Imprime todas as informações do estado
        printPCAndInstruction({});
        printRegisters({});
        printMemory({}, "imem");
        printMemory({}, "dmem");
        
    } catch (const exception& e) {
        cerr << "Error viewing state: " << e.what() << endl;
        dumpLoader.reset(); // Garante que o loader seja limpo em caso de erro
    }
}