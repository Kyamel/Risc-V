`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,    // Opcode vindo do instr_parser
    output reg [1:0] ALUOp,     // Sinal de controle para a ALU_Control
    output reg ALUSrc          // Seleção do mux da ULA (0: reg, 1: imm)
);

    always @(*) begin
        // Valores padrão
        ALUOp = 2'b00;  // ADD para loads/stores
        ALUSrc = 1'b0;  // Registrador por padrão
        
        case (opcode)
            // Instruções tipo R (ADD, SUB, AND, OR, etc.)
            7'b0110011: begin
                ALUOp = 2'b10;  // Precisa olhar funct3/funct7
                ALUSrc = 1'b0;  // Usa registradores
            end
            
            // Loads (LW)
            7'b0000011: begin
                ALUOp = 2'b00;  // ADD para cálculo de endereço
                ALUSrc = 1'b1;  // Usa imediato
            end
            
            // Stores (SW)
            7'b0100011: begin
                ALUOp = 2'b00;  // ADD para cálculo de endereço
                ALUSrc = 1'b1;  // Usa imediato
            end
            
            // Operações imediatas (ADDI, ANDI, ORI, etc.)
            7'b0010011: begin
                ALUOp = 2'b11;  // Precisa olhar funct3
                ALUSrc = 1'b1;  // Usa imediato
            end
            
            // Branches (BEQ, BNE, etc.)
            7'b1100011: begin
                ALUOp = 2'b01;  // Subtração para comparação
                ALUSrc = 1'b0;  // Usa registradores
            end
            
            // Default mantém os valores padrão
            default: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b0;
            end
        endcase
    end

endmodule