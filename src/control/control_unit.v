`timescale 1ns / 1ps

module control_unit (
    input wire [6:0] opcode,    // Instruction opcode
    
    // EX stage control signals
    output reg [1:0] ALUOp,     // ALU operation type
    output reg ALUSrc,          // ALU source select (0=reg, 1=imm)
    
    // MEM stage control signals
    output reg Branch,          // Branch instruction
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
        Branch = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        
        case (opcode)
            // R-type instructions (add, sub, and, or, xor, sll, srl, sra, slt, sltu)
            7'b0110011: begin
                ALUOp = 2'b10;     // Use funct field for ALU control
                ALUSrc = 1'b0;      // Use register for ALU input B
                RegWrite = 1'b1;    // Enable register write
                // MEM stage signals default to 0
            end
            
            // I-type arithmetic (addi, slti, sltiu, xori, ori, andi, slli, srli, srai)
            7'b0010011: begin
                ALUOp = 2'b00;     // Addition for immediate
                ALUSrc = 1'b1;      // Use immediate for ALU input B
                RegWrite = 1'b1;    // Enable register write
            end
            
            // Load instructions (lw, lh, lb, lhu, lbu)
            7'b0000011: begin
                ALUOp = 2'b00;     // Addition for address calculation
                ALUSrc = 1'b1;      // Use immediate for address offset
                MemRead = 1'b1;     // Enable memory read
                RegWrite = 1'b1;    // Enable register write
                MemtoReg = 1'b1;    // Select memory data for WB
            end
            
            // Store instructions (sw, sh, sb)
            7'b0100011: begin
                ALUOp = 2'b00;     // Addition for address calculation
                ALUSrc = 1'b1;      // Use immediate for address offset
                MemWrite = 1'b1;    // Enable memory write
            end
            
            // Branch instructions (beq, bne, blt, bge, bltu, bgeu)
            7'b1100011: begin
                ALUOp = 2'b01;     // Subtraction for comparison
                ALUSrc = 1'b0;      // Use register for comparison
                Branch = 1'b1;      // This is a branch instruction
            end
            
            // LUI (Load Upper Immediate)
            7'b0110111: begin
                ALUOp = 2'b11;     // Pass immediate to output
                ALUSrc = 1'b1;      // Use immediate
                RegWrite = 1'b1;    // Enable register write
            end
            
            // AUIPC (Add Upper Immediate to PC)
            7'b0010111: begin
                ALUOp = 2'b00;     // Addition
                ALUSrc = 1'b1;      // Use immediate
                RegWrite = 1'b1;    // Enable register write
            end
            
            // JAL (Jump and Link)
            7'b1101111: begin
                ALUOp = 2'b00;     // Addition for PC+4
                ALUSrc = 1'b1;      // Use immediate for jump target
                RegWrite = 1'b1;    // Enable register write (PC+4 to rd)
                Branch = 1'b1;      // Treated as unconditional branch
            end
            
            // JALR (Jump and Link Register)
            7'b1100111: begin
                ALUOp = 2'b00;     // Addition
                ALUSrc = 1'b1;      // Use immediate
                RegWrite = 1'b1;    // Enable register write (PC+4 to rd)
                Branch = 1'b1;      // Treated as unconditional branch
            end
            
            // Default case (including FENCE, ECALL, EBREAK, etc.)
            default: begin
                // All signals default to 0
            end
        endcase
    end

endmodule