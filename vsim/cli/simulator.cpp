#include "simulator.h"
#include <iostream>
#include <iomanip>

RiscvSimulator::RiscvSimulator() : tfp(nullptr), top(nullptr), cycle_count(0) {
    initialize();
}

RiscvSimulator::~RiscvSimulator() {
    finalize();
}

void RiscvSimulator::initialize() {
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top = new Vmain;
    top->trace(tfp, 99);
    tfp->open("simx.vcd");
    
    // Corrected signal names based on Vmain.h
    top->main__02Eclk = 0;
    top->main__02Ereset = 1;
    top->step_en = 0;
    
    std::cout << "\nStarting RISC-V processor simulation..." << std::endl;
}

void RiscvSimulator::reset() {
    for (int i = 0; i < 2; i++) {
        top->main__02Eclk = !top->main__02Eclk;
        top->main__02Ereset = (i == 0);
        top->eval();
        tfp->dump(10*i);
    }
    std::cout << "Reset complete. Ready to execute instructions." << std::endl;
}

void RiscvSimulator::execute_cycle(int cycle) {
    top->step_en = 1;
    top->main__02Eclk = 1;
    top->eval();
    tfp->dump(20 + 10*cycle);
    
    top->main__02Eclk = 0;
    top->eval();
    tfp->dump(25 + 10*cycle);
    
    std::cout << "Cycle " << cycle << ": PC = 0x" << std::hex << top->debug_pc 
              << ", Instruction = 0x" << top->debug_instruction << std::endl;
}

void RiscvSimulator::dump_state(const std::string& filename) {
    dump_state_to_json(top, filename);
    std::cout << "Processor state saved to " << filename << std::endl;
}

void RiscvSimulator::finalize() {
    dump_state("processor_state.json");
    if (top) {
        top->final();
        delete top;
        top = nullptr;
    }
    if (tfp) {
        tfp->close();
        delete tfp;
        tfp = nullptr;
    }
}

void RiscvSimulator::run_simulation(int num_cycles) {
    reset();
    
    for (int i = 0; i < num_cycles; i++) {
        execute_cycle(i);
        cycle_count++;
    }
}