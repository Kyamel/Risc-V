`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,    // Instruction opcode

    // EX stage control signals
    output reg [1:0] ALUOp,     // ALU operation type
    output reg ALUSrc,          // ALU source B select (0=rs2, 1=imm)
    output reg ALUSrcA,         // ALU source A select (0=rs1, 1=PC) - AUIPC

    // EX stage: branches and jumps (resolved in EX)
    output reg Branch,          // Branch instruction
    output reg Jump,            // Jump instruction (JAL/JALR): rd = PC + 4
    output reg JumpReg,         // Jump target = (rs1 + imm) & ~1 (JALR); otherwise PC + imm

    // MEM stage control signals
    output reg MemRead,         // Memory read enable
    output reg MemWrite,        // Memory write enable

    // WB stage control signals
    output reg RegWrite,        // Register write enable
    output reg MemtoReg         // Data source select (0=ALU, 1=Mem)
);

    always @(*) begin
        // Default values
        ALUOp = 2'b00;
        ALUSrc = 1'b0;
        ALUSrcA = 1'b0;
        Branch = 1'b0;
        Jump = 1'b0;
        JumpReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;

        case (opcode)
            // R-type instructions (add, sub, and, or, xor, sll, srl, sra, slt, sltu)
            7'b0110011: begin
                ALUOp = 2'b10;      // Use funct field for ALU control
                ALUSrc = 1'b0;      // Use register for ALU input B
                RegWrite = 1'b1;    // Enable register write
            end

            // I-type arithmetic (addi, slti, sltiu, xori, ori, andi, slli, srli, srai)
            7'b0010011: begin
                ALUOp = 2'b11;      // I-type ALU operations
                ALUSrc = 1'b1;      // Use immediate for ALU input B
                RegWrite = 1'b1;    // Enable register write
            end

            // Load instructions (lw)
            7'b0000011: begin
                ALUOp = 2'b00;      // Addition for address calculation
                ALUSrc = 1'b1;      // Use immediate for address offset
                MemRead = 1'b1;     // Enable memory read
                RegWrite = 1'b1;    // Enable register write
                MemtoReg = 1'b1;    // Select memory data for WB
            end

            // Store instructions (sw)
            7'b0100011: begin
                ALUOp = 2'b00;      // Addition for address calculation
                ALUSrc = 1'b1;      // Use immediate for address offset
                MemWrite = 1'b1;    // Enable memory write
            end

            // Branch instructions (beq, bne, blt, bge, bltu, bgeu)
            // The comparison is done by branch_decision_unit, not by the ALU.
            7'b1100011: begin
                Branch = 1'b1;
            end

            // LUI: rd = 0 + imm (rs1 is x0: instr_parser zeroes rs1 for U-type)
            7'b0110111: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
            end

            // AUIPC: rd = PC + imm
            7'b0010111: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                ALUSrcA = 1'b1;
                RegWrite = 1'b1;
            end

            // JAL: rd = PC + 4; PC = PC + imm
            7'b1101111: begin
                Jump = 1'b1;
                RegWrite = 1'b1;
            end

            // JALR: rd = PC + 4; PC = (rs1 + imm) & ~1 (the sum is done by the ALU)
            7'b1100111: begin
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                Jump = 1'b1;
                JumpReg = 1'b1;
                RegWrite = 1'b1;
            end

            // Default case
            default: begin
                // All signals default to 0
            end
        endcase
    end

endmodule
