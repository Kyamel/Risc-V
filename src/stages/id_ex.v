`timescale 1ns / 1ps

module id_ex (
    input wire clk,
    input wire rst,
    input wire stall,                    // Hold the current values
    input wire flush,                    // Insert a bubble (all control signals = 0)

    // From ID
    input wire [31:0] id_read_data_1,    // rs1 value read from the register file
    input wire [31:0] id_read_data_2,    // rs2 value read from the register file
    input wire [31:0] id_imm_data,       // Sign-extended immediate
    input wire [31:0] id_pc_out,         // PC of the instruction
    input wire [4:0] id_rs1,             // rs1 index (for forwarding)
    input wire [4:0] id_rs2,             // rs2 index (for forwarding)
    input wire [4:0] id_rd,              // rd index
    input wire [2:0] id_funct3,
    input wire [6:0] id_funct7,

    // Control signals from the control unit
    input wire id_ALUSrc,                // ALU operand B: 0 = rs2, 1 = immediate
    input wire id_ALUSrcA,               // ALU operand A: 0 = rs1, 1 = PC (AUIPC)
    input wire [1:0] id_ALUOp,           // ALU operation class
    input wire id_Branch,                // Conditional branch
    input wire id_Jump,                  // JAL/JALR
    input wire id_JumpReg,               // Jump target is rs1 + imm (JALR)
    input wire id_MemRead,               // Data memory read
    input wire id_MemWrite,              // Data memory write
    input wire id_RegWrite,              // Register file write
    input wire id_MemtoReg,              // Write-back source: 0 = ALU, 1 = memory

    // To EX
    output reg [31:0] ex_read_data_1,
    output reg [31:0] ex_read_data_2,
    output reg [31:0] ex_imm_data,
    output reg [31:0] ex_pc_out,
    output reg [4:0] ex_rs1,
    output reg [4:0] ex_rs2,
    output reg [4:0] ex_rd,
    output reg [2:0] ex_funct3,
    output reg [6:0] ex_funct7,

    // Control signals for EX/MEM/WB
    output reg ex_ALUSrc,
    output reg ex_ALUSrcA,
    output reg [1:0] ex_ALUOp,
    output reg ex_Branch,
    output reg ex_Jump,
    output reg ex_JumpReg,
    output reg ex_MemRead,
    output reg ex_MemWrite,
    output reg ex_RegWrite,
    output reg ex_MemtoReg
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            ex_read_data_1 <= 32'b0;
            ex_read_data_2 <= 32'b0;
            ex_imm_data <= 32'b0;
            ex_pc_out <= 32'b0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rd <= 5'b0;
            ex_funct3 <= 3'b0;
            ex_funct7 <= 7'b0;

            ex_ALUSrc <= 1'b0;
            ex_ALUSrcA <= 1'b0;
            ex_ALUOp <= 2'b0;
            ex_Branch <= 1'b0;
            ex_Jump <= 1'b0;
            ex_JumpReg <= 1'b0;
            ex_MemRead <= 1'b0;
            ex_MemWrite <= 1'b0;
            ex_RegWrite <= 1'b0;
            ex_MemtoReg <= 1'b0;
        end
        else if (!stall) begin
            ex_read_data_1 <= id_read_data_1;
            ex_read_data_2 <= id_read_data_2;
            ex_imm_data <= id_imm_data;
            ex_pc_out <= id_pc_out;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_rd <= id_rd;
            ex_funct3 <= id_funct3;
            ex_funct7 <= id_funct7;

            ex_ALUSrc <= id_ALUSrc;
            ex_ALUSrcA <= id_ALUSrcA;
            ex_ALUOp <= id_ALUOp;
            ex_Branch <= id_Branch;
            ex_Jump <= id_Jump;
            ex_JumpReg <= id_JumpReg;
            ex_MemRead <= id_MemRead;
            ex_MemWrite <= id_MemWrite;
            ex_RegWrite <= id_RegWrite;
            ex_MemtoReg <= id_MemtoReg;
        end
        // On stall, keep the current values
    end

endmodule
