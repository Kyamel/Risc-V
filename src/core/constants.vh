// constants.v - Definições de constantes para o processador RISC-V
`ifndef CONSTANTS_V
`define CONSTANTS_V

// Branch function codes (funct3)
`define BRANCH_EQ  3'b000  // BEQ
`define BRANCH_NE  3'b001  // BNE
`define BRANCH_LT  3'b100  // BLT
`define BRANCH_GE  3'b101  // BGE
`define BRANCH_LTU 3'b110  // BLTU
`define BRANCH_GEU 3'b111  // BGEU

// Control signals bit positions and width
`define CONTROL_SIGNALS_WIDTH 8

// Control signal bit positions
`define CTRL_ALU_SRC    0
`define CTRL_MEM_TO_REG 1
`define CTRL_REG_WRITE  2
`define CTRL_MEM_READ   3
`define CTRL_MEM_WRITE  4
`define CTRL_BRANCH     5
`define CTRL_JUMP       6
`define CTRL_ALU_OP_0   7  // ALUOp é 2 bits, então usa posições 7 e 8
`define CTRL_ALU_OP_1   8

// Opcodes RISC-V
`define OPCODE_R_TYPE   7'b0110011
`define OPCODE_I_TYPE   7'b0010011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111

`endif