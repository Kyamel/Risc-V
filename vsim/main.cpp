#include <iostream>
#include <string>
#include "cli/simulator.h"
#include "cli/tui.h"

void print_help(const std::string& prog_name) {
    std::cout << "Usage:\n"
              << "  " << prog_name << "             - Run simulation (default 10 cycles)\n"
              << "  " << prog_name << " file.json   - View processor state from JSON\n"
              << "  " << prog_name << " --help|-h   - Show this help message\n";
}

int main(int argc, char** argv) {
    std::string prog_name = argv[0];

    if (argc == 1) {
        // No arguments - run simulation
        RiscvSimulator simulator;
        simulator.run_simulation(10);  // Default 10 cycles
    } 
    else if (argc == 2) {
        std::string arg = argv[1];

        if (arg == "-h" || arg == "--help") {
            print_help(prog_name);
            return 0;
        }

        // Argument is JSON file - run TUI
        Tui::view_state(arg);
    }
    else {
        print_help(prog_name);
        return 1;
    }

    return 0;
}
