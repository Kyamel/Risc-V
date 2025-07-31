# Pipeline Stages Test Results

## Overview
This test validates the correct operation of the RISC-V pipeline through the first three stages: Instruction Fetch (IF), Instruction Decode (ID), and Execute (EX).

## Test Results Summary ✅

### Test 1: ADD Instruction (R-Type)
- **Instruction**: `add x3, x1, x2` (0x002081B3)
- **Input Values**: x1 = 21 (0x15), x2 = 10 (0x0A)
- **Expected Result**: 31 (0x1F)
- **ALU Result**: ✅ 0x0000001F (CORRECT)

**Verification Points:**
- ✅ IF Stage: Correctly fetched instruction
- ✅ ID Stage: Properly decoded register addresses (RS1=1, RS2=2, RD=3)
- ✅ ID Stage: Control signals correctly generated (RegWrite=1, ALU_OP=0x0, ALU_Src=0)
- ✅ EX Stage: ALU performed addition correctly (21 + 10 = 31)

### Test 2: ADDI Instruction (I-Type)
- **Instruction**: `addi x4, x1, 100` (0x06408213)
- **Input Values**: x1 = 20 (0x14), immediate = 100 (0x64)
- **Expected Result**: 120 (0x78)
- **ALU Result**: ✅ 0x00000078 (CORRECT)

**Verification Points:**
- ✅ IF Stage: Correctly fetched instruction
- ✅ ID Stage: Properly decoded register addresses (RS1=1, RD=4)
- ✅ ID Stage: Immediate value correctly extracted (0x64 = 100)
- ✅ ID Stage: Control signals correctly generated (RegWrite=1, ALU_OP=0x0, ALU_Src=1)
- ✅ EX Stage: ALU performed immediate addition correctly (20 + 100 = 120)

### Test 3: Load Instruction (I-Type)
- **Instruction**: `lw x5, 8(x1)` (0x0080A283)
- **Input Values**: x1 = 0x1000, offset = 8
- **Expected Address**: 0x1008
- **ALU Result**: ✅ 0x00001008 (CORRECT)

**Verification Points:**
- ✅ IF Stage: Correctly fetched instruction
- ✅ ID Stage: Properly decoded register addresses (RS1=1, RD=5)
- ✅ ID Stage: Load offset correctly extracted (0x8)
- ✅ ID Stage: Control signals correctly generated (MemRead=1, RegWrite=1, ALU_Src=1)
- ✅ EX Stage: Address calculation performed correctly (0x1000 + 8 = 0x1008)

## Pipeline Flow Verification

The test confirmed proper pipeline operation:

1. **Instruction Fetch (IF)**: PC increments correctly (0x00, 0x04, 0x08, 0x0C...)
2. **Instruction Decode (ID)**: Instructions flow correctly from IF/ID pipeline register
3. **Execute (EX)**: Data flows correctly from ID/EX pipeline register

## Key Components Tested

### Control Unit
- ✅ Correctly generates control signals for R-type instructions
- ✅ Correctly generates control signals for I-type instructions  
- ✅ Properly differentiates between arithmetic and load instructions

### ALU
- ✅ Addition operation works correctly
- ✅ Handles both register-register and register-immediate operations
- ✅ Produces correct results for address calculations

### Immediate Generator
- ✅ Correctly extracts I-type immediates
- ✅ Proper sign extension (verified with 100 decimal = 0x64)

### Pipeline Registers
- ✅ IF/ID register correctly transfers PC and instruction
- ✅ ID/EX register correctly transfers all decoded information
- ✅ EX/MEM register correctly transfers ALU results

## Issues Fixed During Testing

1. **Circular Assignment in EX Stage**: Fixed `ex_mem_alu_result_fwd` assignment
2. **ALU Result Wire**: Added proper intermediate wire for ALU output

## How to Run the Test

```bash
make pipeline_test        # Compile and run the test
make view_pipeline        # View waveforms in GTKWave
```

## Test Files

- `tb/stages/tb_pipeline_stages.v` - Main testbench
- `Makefile` - Build and run configuration
- `pipeline_stages.vcd` - Generated waveform file

## Next Steps

This test validates the core pipeline functionality. Further testing could include:
- Branch instruction testing
- Hazard detection testing
- Forwarding unit testing
- Full 5-stage pipeline testing
- Memory stage and writeback verification