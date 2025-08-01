#ifndef MEMDUMPER_H
#define MEMDUMPER_H

#include "../nlohmann/json.hpp"
#include "Vmain.h"
#include <string>

class MemDumper {
private:
    Vmain* top_;

    std::string toHex(uint32_t value);

public:
    explicit MemDumper(Vmain* top);
    nlohmann::json dumpAll();
    void saveToFile(const std::string& filename);
};

// Helper function
void dump_state_to_json(Vmain* top, const std::string& filename);

#endif // MEMDUMPER_H