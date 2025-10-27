#!/bin/bash

echo "=== RV32E Simulator Demo ==="
echo "This demo showcases the features of the RV32E processor simulator"
echo ""

echo "1. Starting simulator and showing initial state..."
echo -e "show status\nquit" | ./obj_dir/rv32e_sim | grep -A10 "Processor Status"

echo ""
echo "2. Loading sample program and showing memory..."
echo -e "load sample_program.hex\nshow status\nquit" | ./obj_dir/rv32e_sim | tail -10

echo ""
echo "3. Running step-by-step execution..."
echo -e "load sample_program.hex\nstep\nstep\nstep\nshow reg 1 2 3\nquit" | ./obj_dir/rv32e_sim | tail -15

echo ""
echo "4. Exporting state to JSON..."
echo -e "load sample_program.hex\nrun 5\nexport demo_state.json\nquit" | ./obj_dir/rv32e_sim | tail -5

echo ""
echo "5. Generated JSON state:"
cat demo_state.json | head -15

echo ""
echo "=== Demo Complete ==="
echo "The simulator provides:"
echo "- Interactive command-line interface"
echo "- Step-by-step debugging"
echo "- JSON state export/import"
echo "- VCD waveform tracing"
echo "- Memory and register inspection"
echo "- Configurable clock speed"