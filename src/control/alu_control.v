`timescale 1ns / 1ps
`include "alu_defines.vh"

// ALUOp = 00: instruções de load/store → sempre ADD
// ALUOp = 01: instruções de branch → geralmente SUB, SLT, SLTU
// ALUOp = 10: R-type (funct7 + funct3 necessários)
// ALUOp = 11: I-type (funct3, e às vezes funct7)

module alu_control (
    input wire [1:0] ALUOp,     // Sinal da control unit
    input wire [9:0] Funct,      // {funct7[6:0], funct3[2:0]} da instrução
    output reg [3:0] Op          // Operação para a ALU

    // --------------------------
    // Conecte a esse modulo com:
    // wire [9:0] Funct = {if_id_instr[31:25], if_id_instr[14:12]};
    // --------------------------
);


always @(*) begin
    case (ALUOp)
        2'b00: Op = `ALU_ADD;  // Loads/Stores/AUIPC
        
        2'b01: begin      // Branches
            case (Funct[2:0])
                3'b000: Op = `ALU_SUB;   // BEQ/BNE
                3'b100,3'b101: Op = `ALU_SLT;  // BLT/BGE
                3'b110,3'b111: Op = `ALU_SLTU; // BLTU/BGEU
                default: Op = `ALU_SUB;
            endcase
        end
        
        2'b10: begin  // R-type
            case (Funct[2:0])
                3'b000: Op = (Funct[9]) ? `ALU_SUB : `ALU_ADD;
                3'b001: Op = `ALU_SLL;
                3'b010: Op = `ALU_SLT;
                3'b011: Op = `ALU_SLTU;
                3'b100: Op = `ALU_XOR;
                3'b101: Op = (Funct[9]) ? `ALU_SRA : `ALU_SRL;
                3'b110: Op = `ALU_OR;
                3'b111: Op = `ALU_AND;
                default: Op = `ALU_ADD;
            endcase
        end
        
        2'b11: begin  // I-type e LUI
            case (Funct[2:0])
                3'b000: Op = `ALU_ADD;    // ADDI
                3'b001: Op = `ALU_SLL;    // SLLI
                3'b010: Op = `ALU_SLT;    // SLTI
                3'b011: Op = `ALU_SLTU;   // SLTIU
                3'b100: Op = `ALU_XOR;    // XORI
                3'b101: Op = (Funct[9]) ? `ALU_SRA : `ALU_SRL; // SRAI/SRLI
                3'b110: Op = `ALU_OR;     // ORI
                3'b111: Op = `ALU_AND;    // ANDI
                default: Op = `ALU_ADD;
            endcase
        end
        
        default: Op = `ALU_ADD;
    endcase
end

endmodule