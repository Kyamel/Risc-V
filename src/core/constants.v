
// constants.v
`define CTRL_REG_WRITE    0
`define CTRL_MEM_TO_REG   1
`define CTRL_MEM_READ     2
`define CTRL_MEM_WRITE    3
`define CTRL_BRANCH       4
`define CTRL_JUMP         5
`define CTRL_ALU_SRC      6
`define CTRL_ALU_OP       [10:7]
`define CTRL_IMM_TYPE     [13:11]
`define CTRL_PC_SRC       [15:14]