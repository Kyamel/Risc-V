# RV32E test scripts

## Requirements

- Lua 5.4
- LuaFileSystem (`lfs`), included in the Nix dev shell
- Icarus Verilog or Verilator
- `riscv32-none-elf-{as,ld,objcopy,objdump}`

## Run

Run from the **repository root** (where `src/`, `tb/` and `tests/programs/` live):

```sh
lua scripts/test.lua all
lua scripts/test.lua prog --sim=verilator --trace --wave
lua scripts/test.lua unit
lua scripts/assemble.lua tests/programs/evaluation.s output
```
