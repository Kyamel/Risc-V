#ifndef RV32E_SIMULATOR_H
#define RV32E_SIMULATOR_H

#include <verilated.h>
#include <verilated_vcd_c.h>
#include <jsoncpp/json/json.h>
#include <string>
#include <vector>
#include <memory>
#include <chrono>
#include <thread>

// Include the Verilated model
#include "Vmain.h"
#include "Vmain___024root.h"

class RV32ESimulator {
private:
    std::unique_ptr<Vmain> dut;        // Device Under Test
    std::unique_ptr<VerilatedVcdC> tfp; // Trace file pointer
    
    uint64_t sim_time;
    uint64_t cycles;
    bool trace_enabled;
    std::string trace_filename;
    
    // Clock control
    bool clk_state;
    uint32_t clock_period_ns;
    bool step_mode;
    bool auto_run;
    
public:
    RV32ESimulator();
    ~RV32ESimulator();
    
    // Initialization
    bool initialize(bool enable_trace = false, const std::string& trace_file = "trace.vcd");
    void cleanup();
    
    // Clock control
    void set_clock_period(uint32_t period_ns);
    void set_step_mode(bool enable);
    void set_auto_run(bool enable);
    
    // Simulation control
    void reset();
    void clock_tick();
    void step();
    void run_cycles(uint32_t num_cycles);
    void run_continuous();
    void stop();
    
    // Memory access
    void load_instruction_memory(const std::vector<uint32_t>& instructions);
    void load_instruction_memory_from_file(const std::string& filename);
    void write_data_memory(uint32_t address, uint32_t value);
    uint32_t read_data_memory(uint32_t address);
    void clear_data_memory();
    
    // Register access
    uint32_t read_register(uint8_t reg_num);
    std::vector<uint32_t> read_all_registers();
    
    // Debug information
    uint32_t get_pc();
    uint32_t get_current_instruction();
    bool is_stalled();
    bool is_flushed();
    uint64_t get_cycle_count();
    
    // JSON export/import
    Json::Value export_state_to_json();
    void export_state_to_file(const std::string& filename);
    bool import_state_from_json(const Json::Value& state);
    bool import_state_from_file(const std::string& filename);
    
    // Memory dumps
    Json::Value dump_instruction_memory();
    Json::Value dump_data_memory();
    Json::Value dump_registers();
    
private:
    void advance_time(uint32_t time_step);
    void update_trace();
    uint32_t address_to_index(uint32_t address);
};

#endif // RV32E_SIMULATOR_H