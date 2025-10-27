#include "rv32e_simulator.h"
#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include <signal.h>

// Global simulator instance for signal handling
RV32ESimulator* g_simulator = nullptr;

void signal_handler(int signal) {
    if (g_simulator) {
        std::cout << "\nReceived signal " << signal << ", stopping simulation..." << std::endl;
        g_simulator->stop();
    }
}

void print_help() {
    std::cout << "\n=== RV32E Simulator Commands ===" << std::endl;
    std::cout << "help                     - Show this help message" << std::endl;
    std::cout << "reset                    - Reset the processor" << std::endl;
    std::cout << "step                     - Execute one instruction (step mode)" << std::endl;
    std::cout << "run <cycles>             - Run for specified number of cycles" << std::endl;
    std::cout << "auto                     - Start continuous execution" << std::endl;
    std::cout << "stop                     - Stop continuous execution" << std::endl;
    std::cout << "" << std::endl;
    std::cout << "set step                 - Enable step-by-step mode" << std::endl;
    std::cout << "set auto                 - Enable auto run mode" << std::endl;
    std::cout << "set clock <period_ns>    - Set clock period in nanoseconds" << std::endl;
    std::cout << "" << std::endl;
    std::cout << "load <filename>          - Load instructions from file" << std::endl;
    std::cout << "write <addr> <value>     - Write value to data memory" << std::endl;
    std::cout << "read <addr>              - Read value from data memory" << std::endl;
    std::cout << "clear_mem                - Clear data memory" << std::endl;
    std::cout << "" << std::endl;
    std::cout << "show pc                  - Show program counter" << std::endl;
    std::cout << "show inst                - Show current instruction" << std::endl;
    std::cout << "show reg [num]           - Show register(s)" << std::endl;
    std::cout << "show mem                 - Show non-zero memory locations" << std::endl;
    std::cout << "show status              - Show processor status" << std::endl;
    std::cout << "" << std::endl;
    std::cout << "export <filename>        - Export state to JSON file" << std::endl;
    std::cout << "import <filename>        - Import state from JSON file" << std::endl;
    std::cout << "trace <filename>         - Enable VCD tracing" << std::endl;
    std::cout << "" << std::endl;
    std::cout << "quit                     - Exit simulator" << std::endl;
    std::cout << "=================================" << std::endl;
}

void show_processor_status(RV32ESimulator& sim) {
    std::cout << "\n=== Processor Status ===" << std::endl;
    std::cout << "PC: 0x" << std::hex << std::setw(8) << std::setfill('0') << sim.get_pc() << std::dec << std::endl;
    std::cout << "Instruction: 0x" << std::hex << std::setw(8) << std::setfill('0') << sim.get_current_instruction() << std::dec << std::endl;
    std::cout << "Cycles: " << sim.get_cycle_count() << std::endl;
    std::cout << "Stalled: " << (sim.is_stalled() ? "Yes" : "No") << std::endl;
    std::cout << "Flushed: " << (sim.is_flushed() ? "Yes" : "No") << std::endl;
    std::cout << "======================" << std::endl;
}

void show_registers(RV32ESimulator& sim, int reg_num = -1) {
    if (reg_num >= 0 && reg_num < 32) {
        std::cout << "x" << reg_num << " = 0x" << std::hex << std::setw(8) << std::setfill('0') 
                  << sim.read_register(reg_num) << std::dec << std::endl;
    } else {
        std::cout << "\n=== Registers ===" << std::endl;
        auto registers = sim.read_all_registers();
        for (int i = 0; i < 32; i += 4) {
            for (int j = 0; j < 4 && (i + j) < 32; j++) {
                std::cout << "x" << std::setw(2) << (i + j) << "=0x" 
                          << std::hex << std::setw(8) << std::setfill('0') 
                          << registers[i + j] << std::dec << "  ";
            }
            std::cout << std::endl;
        }
        std::cout << "=================" << std::endl;
    }
}

void show_memory(RV32ESimulator& sim) {
    std::cout << "\n=== Non-zero Data Memory ===" << std::endl;
    bool found_data = false;
    
    for (uint32_t addr = 0; addr < 256 * 4; addr += 4) {
        uint32_t value = sim.read_data_memory(addr);
        if (value != 0) {
            std::cout << "0x" << std::hex << std::setw(8) << std::setfill('0') << addr 
                      << ": 0x" << std::setw(8) << std::setfill('0') << value << std::dec << std::endl;
            found_data = true;
        }
    }
    
    if (!found_data) {
        std::cout << "(No non-zero data found)" << std::endl;
    }
    std::cout << "============================" << std::endl;
}

std::vector<std::string> split_string(const std::string& str) {
    std::vector<std::string> tokens;
    std::istringstream iss(str);
    std::string token;
    
    while (iss >> token) {
        tokens.push_back(token);
    }
    
    return tokens;
}

int main(int argc, char* argv[]) {
    std::cout << "RV32E Processor Simulator" << std::endl;
    std::cout << "=========================" << std::endl;
    
    // Setup signal handling
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    // Create and initialize simulator
    RV32ESimulator simulator;
    g_simulator = &simulator;
    
    bool enable_trace = false;
    std::string trace_file = "trace.vcd";
    
    // Parse command line arguments
    for (int i = 1; i < argc; i++) {
        std::string arg = argv[i];
        if (arg == "--trace" && i + 1 < argc) {
            enable_trace = true;
            trace_file = argv[++i];
        } else if (arg == "--help" || arg == "-h") {
            print_help();
            return 0;
        }
    }
    
    if (!simulator.initialize(enable_trace, trace_file)) {
        std::cerr << "Failed to initialize simulator" << std::endl;
        return 1;
    }
    
    std::cout << "Type 'help' for available commands" << std::endl;
    
    std::string input;
    while (true) {
        std::cout << "\nsim> ";
        std::getline(std::cin, input);
        
        if (input.empty()) continue;
        
        auto tokens = split_string(input);
        if (tokens.empty()) continue;
        
        std::string command = tokens[0];
        
        try {
            if (command == "help") {
                print_help();
            }
            else if (command == "quit" || command == "exit") {
                break;
            }
            else if (command == "reset") {
                simulator.reset();
            }
            else if (command == "step") {
                simulator.set_step_mode(true);
                simulator.step();
            }
            else if (command == "run" && tokens.size() > 1) {
                uint32_t cycles = std::stoul(tokens[1]);
                simulator.run_cycles(cycles);
            }
            else if (command == "auto") {
                simulator.set_auto_run(true);
                simulator.run_continuous();
            }
            else if (command == "stop") {
                simulator.stop();
            }
            else if (command == "set" && tokens.size() > 1) {
                if (tokens[1] == "step") {
                    simulator.set_step_mode(true);
                }
                else if (tokens[1] == "auto") {
                    simulator.set_auto_run(true);
                }
                else if (tokens[1] == "clock" && tokens.size() > 2) {
                    uint32_t period = std::stoul(tokens[2]);
                    simulator.set_clock_period(period);
                }
            }
            else if (command == "load" && tokens.size() > 1) {
                simulator.load_instruction_memory_from_file(tokens[1]);
            }
            else if (command == "write" && tokens.size() > 2) {
                uint32_t addr = std::stoul(tokens[1], nullptr, 0);
                uint32_t value = std::stoul(tokens[2], nullptr, 0);
                simulator.write_data_memory(addr, value);
                std::cout << "Written 0x" << std::hex << value << " to address 0x" << addr << std::dec << std::endl;
            }
            else if (command == "read" && tokens.size() > 1) {
                uint32_t addr = std::stoul(tokens[1], nullptr, 0);
                uint32_t value = simulator.read_data_memory(addr);
                std::cout << "Address 0x" << std::hex << addr << ": 0x" << value << std::dec << std::endl;
            }
            else if (command == "clear_mem") {
                simulator.clear_data_memory();
            }
            else if (command == "show" && tokens.size() > 1) {
                if (tokens[1] == "pc") {
                    std::cout << "PC: 0x" << std::hex << std::setw(8) << std::setfill('0') 
                              << simulator.get_pc() << std::dec << std::endl;
                }
                else if (tokens[1] == "inst") {
                    std::cout << "Instruction: 0x" << std::hex << std::setw(8) << std::setfill('0') 
                              << simulator.get_current_instruction() << std::dec << std::endl;
                }
                else if (tokens[1] == "reg") {
                    if (tokens.size() > 2) {
                        int reg_num = std::stoi(tokens[2]);
                        show_registers(simulator, reg_num);
                    } else {
                        show_registers(simulator);
                    }
                }
                else if (tokens[1] == "mem") {
                    show_memory(simulator);
                }
                else if (tokens[1] == "status") {
                    show_processor_status(simulator);
                }
            }
            else if (command == "export" && tokens.size() > 1) {
                simulator.export_state_to_file(tokens[1]);
            }
            else if (command == "import" && tokens.size() > 1) {
                simulator.import_state_from_file(tokens[1]);
            }
            else if (command == "trace" && tokens.size() > 1) {
                std::cout << "Note: Tracing must be enabled at startup with --trace option" << std::endl;
            }
            else {
                std::cout << "Unknown command: " << command << std::endl;
                std::cout << "Type 'help' for available commands" << std::endl;
            }
        }
        catch (const std::exception& e) {
            std::cerr << "Error: " << e.what() << std::endl;
        }
    }
    
    std::cout << "Goodbye!" << std::endl;
    g_simulator = nullptr;
    return 0;
}