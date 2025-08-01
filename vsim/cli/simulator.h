#ifndef SIMULATOR_H
#define SIMULATOR_H

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vmain.h"
#include <string>
#include "../core/memdumper.h"

class RiscvSimulator {
private:
    VerilatedVcdC* tfp;
    Vmain* top;
    int cycle_count;
    
    void initialize();
    void reset();
    void execute_cycle(int cycle);
    void finalize();
    void dump_state(const std::string& filename);

public:
    RiscvSimulator();
    ~RiscvSimulator();
    
    void run_simulation(int num_cycles);
};

#endif // SIMULATOR_H