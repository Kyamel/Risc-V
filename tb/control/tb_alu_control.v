`timescale 1ns / 1ps

module tb_alu_control();

    reg [1:0] ALUOp;
    reg [9:0] Funct;
    wire [3:0] Op;
    
    alu_control uut (
        .ALUOp(ALUOp),
        .Funct(Funct),
        .Op(Op)
    );
    
    initial begin
        $display("=== Teste do ALU Control ===");
        $display("ALUOp Funct   Op  Operação");
        
        // Teste loads/stores (ALUOp = 00)
        ALUOp = 2'b00;
        Funct = 10'bxxxxxxxxxx;
        #10;
        $display("%b     %b  %b  ADD", ALUOp, Funct, Op);
        
        // Teste branches (ALUOp = 01)
        ALUOp = 2'b01;
        Funct = 10'bxxxxxxxxxx;
        #10;
        $display("%b     %b  %b  SUB", ALUOp, Funct, Op);
        
        // Teste ADD/SUB
        ALUOp = 2'b10;
        Funct = 10'b0000000000; // ADD
        #10;
        $display("%b     %b  %b  ADD", ALUOp, Funct, Op);
        
        Funct = 10'b0100000000; // SUB
        #10;
        $display("%b     %b  %b  SUB", ALUOp, Funct, Op);
        
        // Teste outras operações
        ALUOp = 2'b10;
        Funct = 10'b0000000001; // SLL
        #10;
        $display("%b     %b  %b  SLL", ALUOp, Funct, Op);
        
        Funct = 10'b0000000101; // SRL
        #10;
        $display("%b     %b  %b  SRL", ALUOp, Funct, Op);
        
        Funct = 10'b0100000101; // SRA
        #10;
        $display("%b     %b  %b  SRA", ALUOp, Funct, Op);
        
        // Teste I-type (mesmas operações mas com ALUOp = 11)
        ALUOp = 2'b11;
        Funct = 10'b0000000110; // OR
        #10;
        $display("%b     %b  %b  OR", ALUOp, Funct, Op);
        
        $finish;
    end

endmodule