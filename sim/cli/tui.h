#ifndef TUI_H
#define TUI_H

#include <string>
#include "../nlohmann/json.hpp"

class Tui {
public:
    static void printRegisters(const nlohmann::json& j);
    static void printMemory(const nlohmann::json& j, const std::string& mem_type, 
                          uint32_t start = 0, uint32_t count = 10);
    static void printPCAndInstruction(const nlohmann::json& j);
    static void view_state(const std::string& json_file);
};

#endif // TUI_H