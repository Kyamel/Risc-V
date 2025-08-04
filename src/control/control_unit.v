`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,    // Opcode vindo do instr_parser
    output reg [1:0] ALUOp,     // Sinal de controle para a ALU_Control
    output reg ALUSrc          // Seleção do mux da ULA (0: reg, 1: imm)
);

    always @(*) begin
        // Default values
        ALUOp = 2'b00;
        ALUSrc = 1'b0;
        
        case (opcode)
            // R-type
            7'b0110011: begin ALUOp = 2'b10; ALUSrc = 1'b0; end
            
            // I-type (ALU)
            7'b0010011: begin ALUOp = 2'b11; ALUSrc = 1'b1; end
            
            // Loads
            7'b0000011: begin ALUOp = 2'b00; ALUSrc = 1'b1; end
            
            // Stores
            7'b0100011: begin ALUOp = 2'b00; ALUSrc = 1'b1; end
            
            // Branches
            7'b1100011: begin ALUOp = 2'b01; ALUSrc = 1'b0; end
            
            // JAL
            7'b1101111: begin ALUOp = 2'b00; ALUSrc = 1'b1; end
            
            // JALR
            7'b1100111: begin ALUOp = 2'b00; ALUSrc = 1'b1; end
            
            // LUI/AUIPC
            7'b0110111, 7'b0010111: begin ALUOp = 2'b00; ALUSrc = 1'b1; end
            
            default: begin ALUOp = 2'b00; ALUSrc = 1'b0; end
        endcase
    end
endmodule