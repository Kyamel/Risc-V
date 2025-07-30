
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




// TB MEM
`define MEM_READ 0
`define MEM_WRITE 1
`define MEM_WIDTH 4:2
`define MEM_UNSIGNED 5
`define MEM_BYTE 3'b000
`define MEM_HALF 3'b001
`define MEM_WORD 3'b010
`define CONTROL_SIGNALS_WIDTH 6

// TB WB
`define CONTROL_SIGNALS_WIDTH 6
`define MEM_TO_REG 2
`define REG_WRITE 3
