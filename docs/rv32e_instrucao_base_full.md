# Instruções da ISA RISC-V RV32E (Base RV32I)

| Nº | Instrução | Tipo | Descrição | Opcode | Funct3 | Funct7 |
|----|-----------|------|-----------|--------|--------|--------|
| 1 | LUI | U-type | Load Upper Immediate | `0110111` | `-` | `-` |
| 2 | AUIPC | U-type | Add Upper Immediate to PC | `0010111` | `-` | `-` |
| 3 | JAL | J-type | Jump and Link | `1101111` | `-` | `-` |
| 4 | JALR | I-type | Jump and Link Register | `1100111` | `000` | `-` |
| 5 | BEQ | B-type | Branch if Equal | `1100011` | `000` | `-` |
| 6 | BNE | B-type | Branch if Not Equal | `1100011` | `001` | `-` |
| 7 | BLT | B-type | Branch if Less Than | `1100011` | `100` | `-` |
| 8 | BGE | B-type | Branch if Greater or Equal | `1100011` | `101` | `-` |
| 9 | BLTU | B-type | Branch if Less Than Unsigned | `1100011` | `110` | `-` |
| 10 | BGEU | B-type | Branch if Greater or Equal Unsigned | `1100011` | `111` | `-` |
| 11 | LB | I-type | Load Byte | `0000011` | `000` | `-` |
| 12 | LH | I-type | Load Halfword | `0000011` | `001` | `-` |
| 13 | LW | I-type | Load Word | `0000011` | `010` | `-` |
| 14 | LBU | I-type | Load Byte Unsigned | `0000011` | `100` | `-` |
| 15 | LHU | I-type | Load Halfword Unsigned | `0000011` | `101` | `-` |
| 16 | SB | S-type | Store Byte | `0100011` | `000` | `-` |
| 17 | SH | S-type | Store Halfword | `0100011` | `001` | `-` |
| 18 | SW | S-type | Store Word | `0100011` | `010` | `-` |
| 19 | ADDI | I-type | Add Immediate | `0010011` | `000` | `-` |
| 20 | SLTI | I-type | Set Less Than Immediate | `0010011` | `010` | `-` |
| 21 | SLTIU | I-type | Set Less Than Immediate Unsigned | `0010011` | `011` | `-` |
| 22 | XORI | I-type | XOR Immediate | `0010011` | `100` | `-` |
| 23 | ORI | I-type | OR Immediate | `0010011` | `110` | `-` |
| 24 | ANDI | I-type | AND Immediate | `0010011` | `111` | `-` |
| 25 | SLLI | I-type | Shift Left Logical Immediate | `0010011` | `001` | `0000000` |
| 26 | SRLI | I-type | Shift Right Logical Immediate | `0010011` | `101` | `0000000` |
| 27 | SRAI | I-type | Shift Right Arithmetic Immediate | `0010011` | `101` | `0100000` |
| 28 | ADD | R-type | Add | `0110011` | `000` | `0000000` |
| 29 | SUB | R-type | Subtract | `0110011` | `000` | `0100000` |
| 30 | SLL | R-type | Shift Left Logical | `0110011` | `001` | `0000000` |
| 31 | SLT | R-type | Set Less Than | `0110011` | `010` | `0000000` |
| 32 | SLTU | R-type | Set Less Than Unsigned | `0110011` | `011` | `0000000` |
| 33 | XOR | R-type | XOR | `0110011` | `100` | `0000000` |
| 34 | SRL | R-type | Shift Right Logical | `0110011` | `101` | `0000000` |
| 35 | SRA | R-type | Shift Right Arithmetic | `0110011` | `101` | `0100000` |
| 36 | OR | R-type | OR | `0110011` | `110` | `0000000` |
| 37 | AND | R-type | AND | `0110011` | `111` | `0000000` |
| 38 | FENCE | I-type | Fence (memory ordering) | `0001111` | `000` | `-` |
| 39 | ECALL | I-type | Environment Call | `1110011` | `000` | `-` |
| 40 | EBREAK | I-type | Environment Break | `1110011` | `000` | `-` |