
`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite  // ✅ NOVO: Sinal RegWrite
);

    always @(*) begin
        case (opcode)
            // R-type instructions (add, sub, and, or, xor, sll, srl, sra, slt, sltu)
            7'b0110011: begin
                ALUOp = 2'b10;     // Use funct field for ALU control
                ALUSrc = 1'b0;     // Use register for ALU input B
                RegWrite = 1'b1;   // ✅ Enable register write
            end
            
            // I-type arithmetic (addi, slti, sltiu, xori, ori, andi, slli, srli, srai)
            7'b0010011: begin
                ALUOp = 2'b00;     // Addition for immediate
                ALUSrc = 1'b1;     // Use immediate for ALU input B
                RegWrite = 1'b1;   // ✅ Enable register write
            end
            
            // Load instructions
            7'b0000011: begin
                ALUOp = 2'b00;     // Addition for address calculation
                ALUSrc = 1'b1;     // Use immediate for address offset
                RegWrite = 1'b1;   // ✅ Enable register write (will need MEM stage)
            end
            
            // Store instructions
            7'b0100011: begin
                ALUOp = 2'b00;     // Addition for address calculation
                ALUSrc = 1'b1;     // Use immediate for address offset
                RegWrite = 1'b0;   // ✅ No register write for stores
            end
            
            // Branch instructions
            7'b1100011: begin
                ALUOp = 2'b01;     // Subtraction for comparison
                ALUSrc = 1'b0;     // Use register for comparison
                RegWrite = 1'b0;   // ✅ No register write for branches
            end
            
            // LUI (Load Upper Immediate)
            7'b0110111: begin
                ALUOp = 2'b11;     // Pass immediate to output
                ALUSrc = 1'b1;     // Use immediate
                RegWrite = 1'b1;   // ✅ Enable register write
            end
            
            // AUIPC (Add Upper Immediate to PC)
            7'b0010111: begin
                ALUOp = 2'b00;     // Addition
                ALUSrc = 1'b1;     // Use immediate
                RegWrite = 1'b1;   // ✅ Enable register write
            end
            
            // JAL (Jump and Link)
            7'b1101111: begin
                ALUOp = 2'b00;     // Addition for PC+4
                ALUSrc = 1'b1;     // Use immediate for jump target
                RegWrite = 1'b1;   // ✅ Enable register write (PC+4 to rd)
            end
            
            // JALR (Jump and Link Register)
            7'b1100111: begin
                ALUOp = 2'b00;     // Addition
                ALUSrc = 1'b1;     // Use immediate
                RegWrite = 1'b1;   // ✅ Enable register write (PC+4 to rd)
            end
            
            default: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;   // ✅ No register write for unknown instructions
            end
        endcase
    end

endmodule