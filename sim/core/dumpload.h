#ifndef DUMPLOAD_H
#define DUMPLOAD_H

#include "../nlohmann/json.hpp"
#include <string>

class DumpLoad {
private:
    nlohmann::json state;

public:
    DumpLoad(const std::string& filename);
    
    // Visualization methods
    void printRegisters();
    void printInstructionMemory(uint32_t start_addr = 0, uint32_t count = 10);
    void printDataMemory(uint32_t start_addr = 0, uint32_t count = 10);
    
    // Getters
    const nlohmann::json& getRegisters() const;
    const nlohmann::json& getInstructionMemory() const;
    const nlohmann::json& getDataMemory() const;
    std::string getPC() const;
    std::string getCurrentInstruction() const;
};

#endif // DUMPLOAD_H