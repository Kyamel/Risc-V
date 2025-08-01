`timescale 1ns / 1ps
`include "constants.v"

module control_unit (
    input wire [31:0] instruction,  // Instrução completa para extração de campos
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] control_signals
);

    // Extração dos campos da instrução
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    // Sinais internos de controle
    reg reg_write, mem_to_reg, mem_read, mem_write;
    reg branch, jump, alu_src;
    reg [3:0] alu_op;
    reg [2:0] imm_type;
    reg [1:0] pc_src;

    always @(*) begin
        // Valores padrão para todos os sinais
        reg_write = 0;
        mem_to_reg = 0;
        mem_read = 0;
        mem_write = 0;
        branch = 0;
        jump = 0;
        alu_src = 0;
        alu_op = `ALU_ADD;  // ADD por padrão
        imm_type = 3'b000;
        pc_src = 2'b00;

        // Decodificação baseada no opcode
        case (opcode)
            `OP_R_TYPE: begin  // Instruções tipo R
                reg_write = 1;
                alu_src = 0;
                // Determina operação ALU baseada em funct3 e funct7
                case (funct3)
                    3'b000: alu_op = funct7[5] ? `ALU_SUB : `ALU_ADD;
                    3'b001: alu_op = `ALU_SLL;
                    3'b010: alu_op = `ALU_SLT;
                    3'b011: alu_op = `ALU_SLTU;
                    3'b100: alu_op = `ALU_XOR;
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;
                    3'b110: alu_op = `ALU_OR;
                    3'b111: alu_op = `ALU_AND;
                endcase
            end
            
            `OP_I_TYPE: begin  // Instruções tipo I
                reg_write = 1;
                alu_src = 1;
                imm_type = 3'b000; // I-type
                case (funct3)
                    3'b000: alu_op = `ALU_ADD;  // ADDI
                    3'b001: alu_op = `ALU_SLL;  // SLLI
                    3'b010: alu_op = `ALU_SLT;  // SLTI
                    3'b011: alu_op = `ALU_SLTU; // SLTIU
                    3'b100: alu_op = `ALU_XOR;  // XORI
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL; // SRAI/SRLI
                    3'b110: alu_op = `ALU_OR;   // ORI
                    3'b111: alu_op = `ALU_AND;  // ANDI
                endcase
            end
            
            `OP_LOAD: begin  // Loads
                reg_write = 1;
                mem_to_reg = 1;
                mem_read = 1;
                alu_src = 1;
                alu_op = `ALU_ADD;
                imm_type = 3'b000; // I-type
            end
            
            `OP_STORE: begin  // Stores
                mem_write = 1;
                alu_src = 1;
                alu_op = `ALU_ADD;
                imm_type = 3'b001; // S-type
            end
            
            `OP_BRANCH: begin  // Branches
                branch = 1;
                alu_op = `ALU_SUB; // Para comparação
                imm_type = 3'b010; // B-type
            end
            
            `OP_JAL: begin  // Jump and Link
                jump = 1;
                reg_write = 1;
                pc_src = 2'b01; // Jump
                imm_type = 3'b011; // J-type
            end
            
            `OP_JALR: begin  // Jump and Link Register
                jump = 1;
                reg_write = 1;
                alu_src = 1;
                pc_src = 2'b10; // JALR
                imm_type = 3'b000; // I-type
            end
            
            `OP_LUI: begin  // Load Upper Immediate
                reg_write = 1;
                alu_src = 1;
                alu_op = 4'b1010; // Operação especial para LUI
                imm_type = 3'b100; // U-type
            end
            
            `OP_AUIPC: begin  // Add Upper Immediate to PC
                reg_write = 1;
                alu_src = 1;
                alu_op = `ALU_ADD;
                imm_type = 3'b100; // U-type
                pc_src = 2'b11; // PC + immediate
            end
            
            default: begin
                // Instrução não reconhecida (pode tratar como NOP ou gerar exceção)
            end
        endcase

        // Montagem do vetor de controle
        control_signals = 0;
        control_signals[`CTRL_REG_WRITE] = reg_write;
        control_signals[`CTRL_MEM_TO_REG] = mem_to_reg;
        control_signals[`CTRL_MEM_READ] = mem_read;
        control_signals[`CTRL_MEM_WRITE] = mem_write;
        control_signals[`CTRL_BRANCH] = branch;
        control_signals[`CTRL_JUMP] = jump;
        control_signals[`CTRL_ALU_SRC] = alu_src;
        control_signals[`CTRL_ALU_OP] = alu_op;
        control_signals[`CTRL_IMM_TYPE] = imm_type;
        control_signals[`CTRL_PC_SRC] = pc_src;
    end
endmodule
