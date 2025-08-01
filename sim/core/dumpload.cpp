#include "dumpload.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <bitset>
#include <vector>
#include <algorithm>

using json = nlohmann::json;
using namespace std;

DumpLoad::DumpLoad(const string& filename) {
    ifstream in(filename);
    if (!in.is_open()) {
        throw runtime_error("Error opening file: " + filename);
    }
    
    try {
        in >> state;
        
        // Validate required fields
        if (!state.contains("registers")) {
            state["registers"] = json::array();
        }
        if (!state.contains("imem")) {
            state["imem"] = json::array();
        }
        if (!state.contains("dmem")) {
            state["dmem"] = json::array();
        }
        if (!state.contains("pc")) {
            state["pc"] = "0x00000000";
        }
        if (!state.contains("current_instruction")) {
            state["current_instruction"] = "0x00000000";
        }
    } catch (const json::exception& e) {
        throw runtime_error("JSON parsing error: " + string(e.what()));
    }
}

void DumpLoad::printRegisters() {
    cout << "\n=== Registers ===\n";
    cout << left << setw(8) << "Name" 
         << setw(10) << "ABI" 
         << setw(12) << "Value (hex)" 
         << "Value (bin)" << endl;
    cout << string(50, '-') << endl;

    const vector<string> abi_names = {
        "zero",  // x0 - Hard-wired zero
        "ra",    // x1 - Return address
        "sp",    // x2 - Stack pointer
        "gp",    // x3 - Global pointer
        "tp",    // x4 - Thread pointer
        "t0",    // x5 - Temporary/alternate link register
        "t1",    // x6 - Temporaries
        "t2",    // x7
        "s0",    // x8 - Saved register/frame pointer
        "s1",    // x9 - Saved register
        "a0",    // x10 - Function arguments/return values
        "a1",    // x11 - Function arguments/return values
        "a2",    // x12 - Function arguments
        "a3",    // x13
        "a4",    // x14
        "a5",    // x15
        "a6",    // x16
        "a7",    // x17
        "s2",    // x18 - Saved registers
        "s3",    // x19
        "s4",    // x20
        "s5",    // x21
        "s6",    // x22
        "s7",    // x23
        "s8",    // x24
        "s9",    // x25
        "s10",   // x26
        "s11",   // x27
        "t3",    // x28 - Temporaries
        "t4",    // x29
        "t5",    // x30
        "t6"     // x31
    };

    for (const auto& reg : state["registers"]) {
        try {
            string name = reg["name"];
            int reg_num = stoi(name.substr(1));
            string abi = (reg_num < abi_names.size()) ? abi_names[reg_num] : "";
            string hex_val = reg["value"];
            uint32_t value = stoul(hex_val.substr(2), nullptr, 16);
            
            cout << left << setw(8) << name 
                 << setw(10) << abi 
                 << setw(12) << hex_val 
                 << bitset<32>(value) << endl;
        } catch (const exception& e) {
            cerr << "Error processing register: " << e.what() << endl;
        }
    }
}

void DumpLoad::printInstructionMemory(uint32_t start_addr, uint32_t count) {
    cout << "\n=== Instruction Memory ===\n";
    cout << "Current PC: " << state["pc"] << "\n\n";
    
    if (state["imem"].empty()) {
        cout << "Instruction memory is empty or not loaded.\n";
        return;
    }

    cout << left << setw(12) << "Address" << "Instruction" << endl;
    cout << string(30, '-') << endl;

    uint32_t printed = 0;
    for (const auto& entry : state["imem"]) {
        try {
            string addr_str = entry["address"].get<string>();
            uint32_t addr = stoul(addr_str.substr(2), nullptr, 16); // Remove "0x" e converte de hex
            
            if (addr >= start_addr && printed < count) {
                cout << addr_str << "  " << entry["value"] << endl;
                printed++;
            }
        } catch (const exception& e) {
            cerr << "Error processing instruction memory entry: " << e.what() << endl;
        }
    }
}

void DumpLoad::printDataMemory(uint32_t start_addr, uint32_t count) {
    cout << "\n=== Data Memory ===\n";
    
    if (state["dmem"].empty()) {
        cout << "Data memory is empty or not accessed.\n";
        return;
    }

    cout << left << setw(12) << "Address" << "Value" << endl;
    cout << string(30, '-') << endl;

    uint32_t printed = 0;
    for (const auto& entry : state["dmem"]) {
        try {
            string addr_str = entry["address"].get<string>();
            uint32_t addr = stoul(addr_str.substr(2), nullptr, 16); // Remove "0x" e converte de hex
            
            if (addr >= start_addr && printed < count) {
                cout << addr_str << "  " << entry["value"] << endl;
                printed++;
            }
        } catch (const exception& e) {
            cerr << "Error processing data memory entry: " << e.what() << endl;
        }
    }
}

const json& DumpLoad::getRegisters() const { 
    return state["registers"]; 
}

const json& DumpLoad::getInstructionMemory() const { 
    return state["imem"]; 
}

const json& DumpLoad::getDataMemory() const { 
    return state["dmem"]; 
}

string DumpLoad::getPC() const { 
    return state["pc"].get<string>(); 
}

string DumpLoad::getCurrentInstruction() const { 
    return state["current_instruction"].get<string>(); 
}