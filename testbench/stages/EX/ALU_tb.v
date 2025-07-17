`timescale 1ns / 1ps

module ALU_tb;

    // Entradas
    reg [31:0] A, B;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    // Fios intermediários
    wire       ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControlOut;

    // Saídas da ALU
    wire [31:0] Result;
    wire        Zero;

    // Instancia a ControlUnit
    ControlUnit cu (
        .opcode(opcode),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // Instancia o ALUControl
    ALUControl alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControlOut(ALUControlOut)
    );

    // Instancia a ALU
    ALU alu (
        .A(A),
        .B(B),
        .ALUControlOut(ALUControlOut),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin
        $display("Testando instruções BEQ e BNE:");

        // ----- Teste BEQ (deve gerar Zero = 1) -----
        A = 32'd42;
        B = 32'd42;
        opcode = 7'b1100011;   // tipo B (branch)
        funct3 = 3'b000;       // BEQ
        funct7 = 7'b0000000;   // não relevante para BEQ

        #10;
        $display("BEQ A=B: A=%0d B=%0d -> Zero=%b, Result=%0d", A, B, Zero, Result);

        // ----- Teste BNE (deve gerar Zero = 0) -----
        A = 32'd42;
        B = 32'd13;
        opcode = 7'b1100011;   // tipo B (branch)
        funct3 = 3'b001;       // BNE
        funct7 = 7'b0000000;   // não relevante para BNE

        #10;
        $display("BNE A!=B: A=%0d B=%0d -> Zero=%b, Result=%0d", A, B, Zero, Result);

        $finish;
    end

endmodule
