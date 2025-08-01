#include "rv32e_simulator.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <stdexcept>

RV32ESimulator::RV32ESimulator() 
    : sim_time(0), cycles(0), trace_enabled(false), clk_state(false),
      clock_period_ns(10), step_mode(false), auto_run(false) {
    
    Verilated::traceEverOn(true);
    dut = std::make_unique<Vmain>();
}

RV32ESimulator::~RV32ESimulator() {
    cleanup();
}

bool RV32ESimulator::initialize(bool enable_trace, const std::string& trace_file) {
    try {
        // Initialize DUT
        dut->clk = 0;
        dut->reset = 1;
        dut->step_en = 0;
        dut->eval();
        
        // Setup tracing if requested
        trace_enabled = enable_trace;
        if (trace_enabled) {
            trace_filename = trace_file;
            tfp = std::make_unique<VerilatedVcdC>();
            dut->trace(tfp.get(), 99);
            tfp->open(trace_filename.c_str());
        }
        
        // Initial reset
        reset();
        
        std::cout << "RV32E Simulator initialized successfully!" << std::endl;
        return true;
    } catch (const std::exception& e) {
        std::cerr << "Error initializing simulator: " << e.what() << std::endl;
        return false;
    }
}

void RV32ESimulator::cleanup() {
    if (tfp) {
        tfp->close();
        tfp.reset();
    }
    dut.reset();
    Verilated::flushCall();
}

void RV32ESimulator::set_clock_period(uint32_t period_ns) {
    clock_period_ns = period_ns;
    std::cout << "Clock period set to " << period_ns << " ns" << std::endl;
}

void RV32ESimulator::set_step_mode(bool enable) {
    step_mode = enable;
    if (enable) {
        auto_run = false;
        std::cout << "Step mode enabled" << std::endl;
    } else {
        std::cout << "Step mode disabled" << std::endl;
    }
}

void RV32ESimulator::set_auto_run(bool enable) {
    auto_run = enable;
    if (enable) {
        step_mode = false;
        std::cout << "Auto run mode enabled" << std::endl;
    } else {
        std::cout << "Auto run mode disabled" << std::endl;
    }
}

void RV32ESimulator::reset() {
    std::cout << "Resetting processor..." << std::endl;
    
    // Assert reset
    dut->reset = 1;
    dut->step_en = 0;
    dut->clk = 0;
    
    // Run a few clock cycles with reset asserted
    for (int i = 0; i < 5; i++) {
        clock_tick();
    }
    
    // Deassert reset
    dut->reset = 0;
    clock_tick();
    
    cycles = 0;
    std::cout << "Reset complete" << std::endl;
}

void RV32ESimulator::clock_tick() {
    // Rising edge
    dut->clk = 1;
    dut->eval();
    advance_time(clock_period_ns / 2);
    update_trace();
    
    // Falling edge
    dut->clk = 0;
    dut->eval();
    advance_time(clock_period_ns / 2);
    update_trace();
    
    cycles++;
}

void RV32ESimulator::step() {
    if (!step_mode) {
        std::cout << "Warning: step() called but step mode not enabled" << std::endl;
    }
    
    dut->step_en = 1;
    clock_tick();
    dut->step_en = 0;
    
    std::cout << "Step executed - PC: 0x" << std::hex << get_pc() 
              << ", Instruction: 0x" << get_current_instruction() 
              << std::dec << std::endl;
}

void RV32ESimulator::run_cycles(uint32_t num_cycles) {
    std::cout << "Running " << num_cycles << " cycles..." << std::endl;
    
    dut->step_en = 1;
    for (uint32_t i = 0; i < num_cycles; i++) {
        clock_tick();
        
        if (i % 1000 == 0 && i > 0) {
            std::cout << "Completed " << i << " cycles" << std::endl;
        }
    }
    dut->step_en = 0;
    
    std::cout << "Completed " << num_cycles << " cycles" << std::endl;
}

void RV32ESimulator::run_continuous() {
    if (!auto_run) {
        std::cout << "Auto run mode not enabled" << std::endl;
        return;
    }
    
    std::cout << "Starting continuous execution (press Ctrl+C to stop)..." << std::endl;
    dut->step_en = 1;
    
    while (auto_run) {
        clock_tick();
        
        // Add a small delay to prevent overwhelming the system
        std::this_thread::sleep_for(std::chrono::microseconds(clock_period_ns / 1000));
    }
    
    dut->step_en = 0;
}

void RV32ESimulator::stop() {
    auto_run = false;
    dut->step_en = 0;
    std::cout << "Execution stopped" << std::endl;
}

void RV32ESimulator::load_instruction_memory(const std::vector<uint32_t>& instructions) {
    std::cout << "Loading " << instructions.size() << " instructions..." << std::endl;
    
    for (size_t i = 0; i < instructions.size() && i < 256; i++) {
        dut->rootp->main__DOT__imem_internal[i] = instructions[i];
    }
    
    std::cout << "Instructions loaded successfully" << std::endl;
}

void RV32ESimulator::load_instruction_memory_from_file(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Could not open file: " + filename);
    }
    
    std::vector<uint32_t> instructions;
    std::string line;
    
    while (std::getline(file, line)) {
        if (line.empty() || line[0] == '#') continue; // Skip empty lines and comments
        
        try {
            uint32_t instruction = std::stoul(line, nullptr, 16);
            instructions.push_back(instruction);
        } catch (const std::exception& e) {
            std::cerr << "Error parsing instruction: " << line << std::endl;
        }
    }
    
    load_instruction_memory(instructions);
}

void RV32ESimulator::write_data_memory(uint32_t address, uint32_t value) {
    uint32_t index = address_to_index(address);
    if (index < 256) {
        dut->rootp->main__DOT__dmem_internal[index] = value;
    }
}

uint32_t RV32ESimulator::read_data_memory(uint32_t address) {
    uint32_t index = address_to_index(address);
    if (index < 256) {
        return dut->rootp->main__DOT__dmem_internal[index];
    }
    return 0;
}

void RV32ESimulator::clear_data_memory() {
    for (int i = 0; i < 256; i++) {
        dut->rootp->main__DOT__dmem_internal[i] = 0;
    }
    std::cout << "Data memory cleared" << std::endl;
}

uint32_t RV32ESimulator::read_register(uint8_t reg_num) {
    if (reg_num < 32) {
        return dut->rootp->main__DOT__debug_registers_internal[reg_num];
    }
    return 0;
}

std::vector<uint32_t> RV32ESimulator::read_all_registers() {
    std::vector<uint32_t> registers(32);
    for (int i = 0; i < 32; i++) {
        registers[i] = dut->rootp->main__DOT__debug_registers_internal[i];
    }
    return registers;
}

uint32_t RV32ESimulator::get_pc() {
    return dut->debug_pc;
}

uint32_t RV32ESimulator::get_current_instruction() {
    return dut->debug_instruction;
}

bool RV32ESimulator::is_stalled() {
    return dut->debug_stall;
}

bool RV32ESimulator::is_flushed() {
    return dut->debug_flush;
}

uint64_t RV32ESimulator::get_cycle_count() {
    return cycles;
}

Json::Value RV32ESimulator::export_state_to_json() {
    Json::Value state;
    
    // Basic state
    state["pc"] = get_pc();
    state["instruction"] = get_current_instruction();
    state["cycles"] = static_cast<Json::UInt64>(cycles);
    state["stalled"] = is_stalled();
    state["flushed"] = is_flushed();
    
    // Registers
    Json::Value registers(Json::arrayValue);
    for (int i = 0; i < 32; i++) {
        registers.append(read_register(i));
    }
    state["registers"] = registers;
    
    // Memory dumps
    state["instruction_memory"] = dump_instruction_memory();
    state["data_memory"] = dump_data_memory();
    
    // Simulation parameters
    state["clock_period_ns"] = clock_period_ns;
    state["step_mode"] = step_mode;
    
    return state;
}

void RV32ESimulator::export_state_to_file(const std::string& filename) {
    Json::Value state = export_state_to_json();
    
    std::ofstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Could not open file for writing: " + filename);
    }
    
    Json::StreamWriterBuilder builder;
    builder["indentation"] = "  ";
    std::unique_ptr<Json::StreamWriter> writer(builder.newStreamWriter());
    writer->write(state, &file);
    
    std::cout << "State exported to " << filename << std::endl;
}

bool RV32ESimulator::import_state_from_json(const Json::Value& state) {
    try {
        // Import registers
        if (state.isMember("registers") && state["registers"].isArray()) {
            const Json::Value& registers = state["registers"];
            for (int i = 0; i < 32 && i < (int)registers.size(); i++) {
                // Note: Registers are read-only in this implementation
                // This would need CPU support for register writes
            }
        }
        
        // Import memory
        if (state.isMember("data_memory") && state["data_memory"].isObject()) {
            const Json::Value& memory = state["data_memory"];
            for (const auto& member : memory.getMemberNames()) {
                uint32_t address = std::stoul(member, nullptr, 16);
                uint32_t value = memory[member].asUInt();
                write_data_memory(address, value);
            }
        }
        
        // Import simulation parameters
        if (state.isMember("clock_period_ns")) {
            set_clock_period(state["clock_period_ns"].asUInt());
        }
        
        if (state.isMember("step_mode")) {
            set_step_mode(state["step_mode"].asBool());
        }
        
        std::cout << "State imported successfully" << std::endl;
        return true;
    } catch (const std::exception& e) {
        std::cerr << "Error importing state: " << e.what() << std::endl;
        return false;
    }
}

bool RV32ESimulator::import_state_from_file(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Could not open file: " << filename << std::endl;
        return false;
    }
    
    Json::Value state;
    Json::CharReaderBuilder builder;
    std::string errors;
    
    if (!Json::parseFromStream(builder, file, &state, &errors)) {
        std::cerr << "Error parsing JSON: " << errors << std::endl;
        return false;
    }
    
    return import_state_from_json(state);
}

Json::Value RV32ESimulator::dump_instruction_memory() {
    Json::Value memory;
    for (int i = 0; i < 256; i++) {
        uint32_t value = dut->rootp->main__DOT__imem_internal[i];
        if (value != 0) {
            std::stringstream ss;
            ss << "0x" << std::hex << std::setw(8) << std::setfill('0') << (i * 4);
            memory[ss.str()] = value;
        }
    }
    return memory;
}

Json::Value RV32ESimulator::dump_data_memory() {
    Json::Value memory;
    for (int i = 0; i < 256; i++) {
        uint32_t value = dut->rootp->main__DOT__dmem_internal[i];
        if (value != 0) {
            std::stringstream ss;
            ss << "0x" << std::hex << std::setw(8) << std::setfill('0') << (i * 4);
            memory[ss.str()] = value;
        }
    }
    return memory;
}

Json::Value RV32ESimulator::dump_registers() {
    Json::Value registers;
    for (int i = 0; i < 32; i++) {
        std::stringstream ss;
        ss << "x" << i;
        registers[ss.str()] = read_register(i);
    }
    return registers;
}

void RV32ESimulator::advance_time(uint32_t time_step) {
    sim_time += time_step;
}

void RV32ESimulator::update_trace() {
    if (trace_enabled && tfp) {
        tfp->dump(sim_time);
    }
}

uint32_t RV32ESimulator::address_to_index(uint32_t address) {
    return (address >> 2) & 0xFF; // Divide by 4 and mask to 8 bits
}