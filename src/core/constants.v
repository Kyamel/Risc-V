// constants.v

// ========== Controle do Pipeline ==========
`define CONTROL_SIGNALS_WIDTH 20

// Bits de controle
`define CTRL_REG_WRITE    0
`define CTRL_MEM_TO_REG   1
`define CTRL_MEM_READ     2
`define CTRL_MEM_WRITE    3
`define CTRL_BRANCH       4
`define CTRL_JUMP         5
`define CTRL_ALU_SRC      6
`define CTRL_ALU_OP       10:7  // 4 bits para operação ALU
`define CTRL_IMM_TYPE     13:11 // Tipo de imediato
`define CTRL_PC_SRC       15:14 // Fonte do PC
`define CTRL_CSR_WRITE    16
`define CTRL_ECALL        17
`define CTRL_MRET         18
`define CTRL_ILLEGAL_INST 19
`define CTRL_MEM_WIDTH     14:12  // Usa os mesmos bits que funct3 para tamanho (LB/LH/LW/SB/SH/SW)
`define CTRL_MEM_UNSIGNED  15     // Bit que indica se é load unsigned (LBU/LHU)

// ========== Operações ALU ==========
`define ALU_ADD   4'b0000
`define ALU_SUB   4'b0001
`define ALU_SLL   4'b0010
`define ALU_SLT   4'b0011
`define ALU_SLTU  4'b0100
`define ALU_XOR   4'b0101
`define ALU_SRL   4'b0110
`define ALU_SRA   4'b0111
`define ALU_OR    4'b1000
`define ALU_AND   4'b1001

// ========== Tipos de Instruções ==========
`define OP_R_TYPE  7'b0110011
`define OP_I_TYPE  7'b0010011
`define OP_LOAD    7'b0000011
`define OP_STORE   7'b0100011
`define OP_BRANCH  7'b1100011
`define OP_JAL     7'b1101111
`define OP_JALR    7'b1100111
`define OP_LUI     7'b0110111
`define OP_AUIPC   7'b0010111
`define OP_SYSTEM  7'b1110011

// ========== Acesso à Memória ==========
`define MEM_BYTE     3'b000
`define MEM_HALF     3'b001
`define MEM_WORD     3'b010
`define MEM_UNSIGNED 1'b1

// ========== RV32E Específico ==========
`define REGISTER_COUNT    16
`define REG_ADDR_WIDTH    4  // Endereços de 4 bits (x0-x15)

// ========== Campos de Instrução ==========
`define FUNCT3     14:12
`define FUNCT7     31:25
`define RS1        19:15
`define RS2        24:20
`define RD         11:7
`define OPCODE     6:0
`define IMM_31_12  31:12  // Para U-type
`define IMM_11_0   11:0   // Para I-type

// ========== Branch Types ==========
`define BRANCH_EQ    3'b000  // BEQ
`define BRANCH_NE    3'b001  // BNE
`define BRANCH_LT    3'b100  // BLT
`define BRANCH_GE    3'b101  // BGE
`define BRANCH_LTU   3'b110  // BLTU
`define BRANCH_GEU   3'b111  // BGEU