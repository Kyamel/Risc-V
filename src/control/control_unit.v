// Unidade de Controle Principal para RV32E
module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg [15:0] control_signals
);

    // [15:13] - ALUOp
    // [12] - ALUSrc
    // [11] - MemtoReg
    // [10] - RegWrite
    // [9] - MemRead
    // [8] - MemWrite
    // [7] - Branch
    // [6] - Jump
    // [5:0] - outros sinais

    // Definições dos bits de controle (conforme constants.v)
    localparam CTRL_REG_WRITE  = 0;
    localparam CTRL_MEM_TO_REG = 1;
    localparam CTRL_MEM_READ   = 2;
    localparam CTRL_MEM_WRITE  = 3;
    localparam CTRL_BRANCH     = 4;
    localparam CTRL_JUMP       = 5;
    localparam CTRL_ALU_SRC    = 6;
    localparam CTRL_ALU_OP_MSB = 10;
    localparam CTRL_ALU_OP_LSB = 7;
    localparam CTRL_IMM_TYPE_MSB = 13;
    localparam CTRL_IMM_TYPE_LSB = 11;
    localparam CTRL_PC_SRC_MSB = 15;
    localparam CTRL_PC_SRC_LSB = 14;

    // Immediates types (só exemplo, você pode ajustar)
    localparam IMM_TYPE_I = 3'b000;
    localparam IMM_TYPE_S = 3'b001;
    localparam IMM_TYPE_B = 3'b010;
    localparam IMM_TYPE_U = 3'b011;
    localparam IMM_TYPE_J = 3'b100;

    // Opcode values RISC-V base (simplificado)
    localparam OPCODE_R_TYPE = 7'b0110011;
    localparam OPCODE_I_TYPE = 7'b0010011;
    localparam OPCODE_LOAD   = 7'b0000011;
    localparam OPCODE_STORE  = 7'b0100011;
    localparam OPCODE_BRANCH = 7'b1100011;
    localparam OPCODE_JAL    = 7'b1101111;
    localparam OPCODE_JALR   = 7'b1100111;
    localparam OPCODE_LUI    = 7'b0110111;

    reg [3:0] alu_op;
    reg reg_write, mem_to_reg, mem_read, mem_write;
    reg branch, jump, alu_src;
    reg [2:0] imm_type;
    reg [1:0] pc_src;

    always @(*) begin
        // Defaults
        reg_write = 0;
        mem_to_reg = 0;
        mem_read = 0;
        mem_write = 0;
        branch = 0;
        jump = 0;
        alu_src = 0;
        alu_op = 4'b0000;    // ADD por padrão
        imm_type = IMM_TYPE_I;
        pc_src = 2'b00;

        case (opcode)
            OPCODE_R_TYPE: begin
                reg_write = 1;
                alu_src = 0;  // Segundo operando vem do registrador
                alu_op = {funct7[5], funct3}; // Exemplo simplificado: alu_op = concat(funct7[5], funct3)
                imm_type = IMM_TYPE_I; // Não usado para R-type
            end
            OPCODE_I_TYPE: begin
                reg_write = 1;
                alu_src = 1;  // Segundo operando vem do imediato
                alu_op = {1'b0, funct3}; // alu_op sem bit de funct7
                imm_type = IMM_TYPE_I;
            end
            OPCODE_LOAD: begin
                reg_write = 1;
                mem_to_reg = 1;
                mem_read = 1;
                alu_src = 1;
                alu_op = 4'b0000; // ADD para cálculo de endereço
                imm_type = IMM_TYPE_I;
            end
            OPCODE_STORE: begin
                mem_write = 1;
                alu_src = 1;
                alu_op = 4'b0000; // ADD para cálculo de endereço
                imm_type = IMM_TYPE_S;
            end
            OPCODE_BRANCH: begin
                branch = 1;
                alu_src = 0;
                alu_op = 4'b0001; // SUB para comparação
                imm_type = IMM_TYPE_B;
            end
            OPCODE_JAL: begin
                jump = 1;
                reg_write = 1;
                alu_src = 0;
                alu_op = 4'b0000;
                imm_type = IMM_TYPE_J;
                pc_src = 2'b10; // PC + immediate (salto)
            end
            OPCODE_JALR: begin
                jump = 1;
                reg_write = 1;
                alu_src = 1;
                alu_op = 4'b0000;
                imm_type = IMM_TYPE_I;
                pc_src = 2'b11;
            end
            OPCODE_LUI: begin
                reg_write = 1;
                alu_src = 1;
                alu_op = 4'b1010; // LUI opcode da ALU
                imm_type = IMM_TYPE_U;
            end
            default: begin
                // NOP
            end
        endcase

        control_signals = 16'b0;
        control_signals[CTRL_REG_WRITE]  = reg_write;
        control_signals[CTRL_MEM_TO_REG] = mem_to_reg;
        control_signals[CTRL_MEM_READ]   = mem_read;
        control_signals[CTRL_MEM_WRITE]  = mem_write;
        control_signals[CTRL_BRANCH]     = branch;
        control_signals[CTRL_JUMP]       = jump;
        control_signals[CTRL_ALU_SRC]    = alu_src;
        control_signals[CTRL_ALU_OP_MSB:CTRL_ALU_OP_LSB] = alu_op;
        control_signals[CTRL_IMM_TYPE_MSB:CTRL_IMM_TYPE_LSB] = imm_type;
        control_signals[CTRL_PC_SRC_MSB:CTRL_PC_SRC_LSB] = pc_src;
    end
endmodule
