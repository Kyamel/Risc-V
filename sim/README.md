# RV32E Processor Simulator

This directory contains a C++ interface for simulating the RV32E processor using Verilator. The simulator provides comprehensive debugging capabilities, JSON state export/import, and step-by-step execution control.

## Features

- **Interactive Command Line Interface**: Step-by-step debugging with real-time state inspection
- **JSON State Management**: Export and import processor state, registers, and memory
- **Flexible Clock Control**: Adjustable clock period and execution modes
- **Memory Access**: Direct read/write access to instruction and data memory  
- **VCD Tracing**: Generate waveform files for detailed analysis
- **Program Loading**: Load instruction sequences from hex files

## Prerequisites

### Dependencies
- Verilator (4.0 or later)
- libjsoncpp-dev
- build-essential (g++, make)

### Installation (Ubuntu/Debian)
```bash
cd sim
make install-deps
```

Or manually:
```bash
sudo apt update
sudo apt install -y verilator libjsoncpp-dev build-essential
```

## Building

```bash
cd sim
make
```

This will:
1. Check dependencies
2. Compile the Verilog design with Verilator
3. Build the C++ simulator interface
4. Create the executable in `obj_dir/rv32e_sim`

## Usage

### Running the Simulator

Basic execution:
```bash
make run
```

With VCD tracing:
```bash
make run-trace
```

Direct execution:
```bash
./obj_dir/rv32e_sim
```

With command line options:
```bash
./obj_dir/rv32e_sim --trace simulation.vcd
```

### Interactive Commands

Once running, you can use these commands:

#### Simulation Control
- `reset` - Reset the processor
- `step` - Execute one instruction (automatically enables step mode)
- `run <cycles>` - Run for specified number of cycles
- `auto` - Start continuous execution
- `stop` - Stop continuous execution

#### Configuration
- `set step` - Enable step-by-step mode
- `set auto` - Enable automatic execution mode
- `set clock <period_ns>` - Set clock period in nanoseconds

#### Memory and Program Loading
- `load <filename>` - Load instructions from hex file
- `write <addr> <value>` - Write value to data memory
- `read <addr>` - Read value from data memory
- `clear_mem` - Clear all data memory

#### State Inspection
- `show pc` - Display program counter
- `show inst` - Display current instruction
- `show reg [num]` - Display register(s)
- `show mem` - Display non-zero memory locations
- `show status` - Display complete processor status

#### JSON Export/Import
- `export <filename>` - Export complete state to JSON
- `import <filename>` - Import state from JSON

#### Other
- `help` - Show all available commands
- `quit` / `exit` - Exit simulator

### Example Session

```
sim> load sample_program.hex
Loading 13 instructions...
Instructions loaded successfully

sim> reset
Resetting processor...
Reset complete

sim> set step
Step mode enabled

sim> step
Step executed - PC: 0x00000000, Instruction: 0x00100093

sim> show reg 1
x1 = 0x00000001

sim> run 5
Running 5 cycles...
Completed 5 cycles

sim> show status
=== Processor Status ===
PC: 0x00000014
Instruction: 0x002092b3
Cycles: 11
Stalled: No
Flushed: No
======================

sim> export state_backup.json
State exported to state_backup.json

sim> quit
```

## File Formats

### Instruction Files (.hex)
Text files with one 32-bit instruction per line in hexadecimal format:
```
# Comments start with #
00100093  # addi x1, x0, 1
00200113  # addi x2, x0, 2
002081b3  # add x3, x1, x2
```

### JSON State Files
Complete processor state including:
- Program counter and current instruction
- All 32 registers
- Instruction and data memory contents
- Cycle count and status flags
- Simulation parameters

Example structure:
```json
{
  "pc": 20,
  "instruction": 34619059,
  "cycles": 11,
  "stalled": false,
  "flushed": false,
  "registers": [0, 1, 2, 3, ...],
  "instruction_memory": {
    "0x00000000": 1048723,
    "0x00000004": 2097427
  },
  "data_memory": {
    "0x00000000": 0
  },
  "clock_period_ns": 10,
  "step_mode": true
}
```

## Advanced Features

### VCD Tracing
When enabled with `--trace`, the simulator generates detailed waveform files that can be viewed with tools like GTKWave:
```bash
./obj_dir/rv32e_sim --trace debug.vcd
# ... run simulation ...
gtkwave debug.vcd
```

### Clock Control
The simulator supports precise timing control:
- Default clock period: 10ns (100MHz)
- Adjustable during simulation
- Step-by-step mode for instruction-level debugging
- Continuous mode with configurable speed

### Memory Layout
- **Instruction Memory**: 256 words (1KB), word-aligned
- **Data Memory**: 256 words (1KB), word-aligned  
- **Address Range**: 0x000-0x3FF for each memory
- **Access**: Byte-addressable with automatic word alignment

## Troubleshooting

### Build Issues

1. **Verilator not found**:
   ```bash
   sudo apt install verilator
   ```

2. **jsoncpp missing**:
   ```bash
   sudo apt install libjsoncpp-dev
   ```

3. **Verilog compilation errors**: Check that all source files exist and paths are correct:
   ```bash
   make show-sources
   ```

### Runtime Issues

1. **Simulation hangs**: Use Ctrl+C to stop, then `stop` command
2. **Memory access errors**: Check address ranges (0x000-0x3FF)
3. **Invalid instructions**: Verify hex file format and instruction encoding

### Performance

For better performance:
- Disable tracing when not needed
- Use higher clock periods for faster simulation  
- Compile with `-O3` optimization (edit Makefile)

## Architecture Integration

The simulator interfaces with the RV32E processor through:
- **Public Memory Arrays**: Direct access to instruction and data memory
- **Debug Signals**: PC, current instruction, stall/flush status  
- **Register File**: Read access to all 32 registers
- **Clock Control**: Step enable signal for precise execution control

This provides cycle-accurate simulation with full visibility into processor internals.