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
        $display("Testando ALU completa:");

        // Teste ADD (ALUControlOut = 4'b0010)
        A = 10; B = 15;
        opcode = 7'b0110011;  // R-type
        funct3 = 3'b000;
        funct7 = 7'b0000000;  // ADD
        #10;
        $display("ADD: %0d + %0d = %0d", A, B, Result);

        // Teste SUB (ALUControlOut = 4'b0110)
        A = 20; B = 5;
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;  // SUB
        #10;
        $display("SUB: %0d - %0d = %0d", A, B, Result);

        // Teste AND (ALUControlOut = 4'b0000)
        A = 32'hFF00FF00; B = 32'h0F0F0F0F;
        opcode = 7'b0010011; // I-type (ANDI)
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        $display("AND: %h & %h = %h", A, B, Result);

        // Teste OR (ALUControlOut = 4'b0001)
        A = 32'hFF00FF00; B = 32'h0F0F0F0F;
        opcode = 7'b0010011; // I-type (ORI)
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        $display("OR: %h | %h = %h", A, B, Result);

        // Teste XOR (ALUControlOut = 4'b0011)
        A = 32'hFF00FF00; B = 32'h0F0F0F0F;
        opcode = 7'b0010011; // I-type (XORI)
        funct3 = 3'b100;
        funct7 = 7'b0000000;
        #10;
        $display("XOR: %h ^ %h = %h", A, B, Result);

        // Teste SLL (ALUControlOut = 4'b0100)
        A = 32'h00000001; B = 5;
        opcode = 7'b0010011; // I-type (SLLI)
        funct3 = 3'b001;
        funct7 = 7'b0000000;
        #10;
        $display("SLL: %h << %0d = %h", A, B[4:0], Result);

        // Teste SRL (ALUControlOut = 4'b0101)
        A = 32'h80000000; B = 31;
        opcode = 7'b0010011; // I-type (SRLI)
        funct3 = 3'b101;
        funct7 = 7'b0000000;
        #10;
        $display("SRL: %h >> %0d = %h", A, B[4:0], Result);

        $finish;
    end

endmodule
