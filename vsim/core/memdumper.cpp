#include "memdumper.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <ctime>
#include <sstream>
#include "Vmain.h"  // Include the generated Verilator header
#include "Vmain___024root.h"  // Include the root header

using json = nlohmann::json;

MemDumper::MemDumper(Vmain* top) : top_(top) {}

json MemDumper::dumpAll() {
    json j;
    
    // Dump instruction memory
    j["imem"] = json::array();
    for (int i = 0; i < 256; i++) {
        if (top_->rootp->main__DOT__imem__DOT__mem[i] != 0) {
            json entry;
            entry["address"] = toHex(i * 4);
            entry["value"] = toHex(top_->rootp->main__DOT__imem__DOT__mem[i]);
            j["imem"].push_back(entry);
        }
    }

    // Dump data memory
    j["dmem"] = json::array();
    for (int i = 0; i < 256; i++) {
        if (top_->rootp->main__DOT__dmem_internal[i] != 0) {
            json entry;
            entry["address"] = toHex(i * 4);
            entry["value"] = toHex(top_->rootp->main__DOT__dmem_internal[i]);
            j["dmem"].push_back(entry);
        }
    }

    // Dump registers
    j["registers"] = json::array();
    for (int i = 0; i < 32; i++) {
        json reg;
        reg["name"] = "x" + std::to_string(i);
        reg["value"] = toHex(top_->rootp->main__DOT__debug_registers_internal[i]);
        j["registers"].push_back(reg);
    }

    // Additional info
    j["pc"] = toHex(top_->debug_pc);
    j["current_instruction"] = toHex(top_->debug_instruction);
    j["timestamp"] = static_cast<int>(time(nullptr));
    j["meta"] = {
        {"version", "v0.0.1"},
        {"generator", "vsim"}
    };

    return j;
}

void MemDumper::saveToFile(const std::string& filename) {
    try {
        json data = dumpAll();
        std::ofstream out(filename);
        if (!out.is_open()) {
            throw std::runtime_error("Failed to open file: " + filename);
        }
        out << std::setw(4) << data << std::endl;
        out.close();
        std::cout << "Dados salvos em " << filename << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Erro ao salvar estado: " << e.what() << std::endl;
    }
}

std::string MemDumper::toHex(uint32_t value) {
    std::stringstream ss;
    ss << "0x" << std::hex << std::setw(8) << std::setfill('0') << value;
    return ss.str();
}

void dump_state_to_json(Vmain* top, const std::string& filename) {
    MemDumper dumper(top);
    dumper.saveToFile(filename);
}