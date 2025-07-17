# Instruções da ISA RISC-V RV32E (Base RV32I) - prioridade de Implementação

|   Nº | Instrução   | Tipo   | Descrição                             |   Opcode |   Funct3 |   Funct7 |
|-----:|:------------|:-------|:--------------------------------------|---------:|---------:|---------:|
|    1 | add         | R-type | rs1 + rs2                             |  0110011 |      000 |  0000000 |
|    2 | addi        | I-type | rs1 + imediato                        |  0010011 |      000 |          |
|    3 | xor         | R-type | rs1 ^ rs2                             |  0110011 |      100 |  0000000 |
|    4 | sll         | R-type | Shift Left Logical (rs1 << rs2[4:0])  |  0110011 |      001 |  0000000 |
|    5 | lw          | I-type | Load word (rs1 + offset)              |  0000011 |      010 |          |
|    6 | sw          | S-type | Store word (rs1 + offset)             |  0100011 |      010 |          |
|    7 | bne         | B-type | Branch if rs1 != rs2                  |  1100011 |      001 |          |
|    8 | sub         | R-type | rs1 - rs2                             |  0110011 |      000 |  0100000 |
|    9 | and         | R-type | rs1 & rs2                             |  0110011 |      111 |  0000000 |
|   10 | or          | R-type | rs1 | rs2                             |  0110011 |      110 |  0000000 |
|   11 | andi        | I-type | rs1 & imediato                        |  0010011 |      111 |          |
|   12 | ori         | I-type | rs1 | imediato                        |  0010011 |      110 |          |
|   13 | jal         | J-type | Jump and link                         |  1101111 |          |          |
|   14 | jalr        | I-type | Jump and link register                |  1100111 |      000 |          |
|   15 | beq         | B-type | Branch if rs1 == rs2                  |  1100011 |      000 |          |
|   16 | srl         | R-type | Shift Right Logical (rs1 >> rs2[4:0]) |  0110011 |      101 |  0000000 |