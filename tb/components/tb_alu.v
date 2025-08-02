`timescale 1ns / 1ps

module tb_alu;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_control;
    
    // Outputs
    wire [31:0] result;
    wire zero;
    
    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );
    
    // Task para verificação com saída colorida
    task check(string name, input [31:0] got, input [31:0] expected);
        begin
            if (got !== expected) begin
                $display("\033[1;31m[FAIL]\033[0m %s: Esperado 0x%h, Obteve 0x%h", name, expected, got);
            end else begin
                $display("\033[1;32m[PASS]\033[0m %s: Valor 0x%h", name, got);
            end
        end
    endtask
    
    initial begin
        $display("\n===== TESTE DA UNIDADE LÓGICA ARITMÉTICA (ALU) =====\n");
        
        // Teste 1: ADD
        a = 32'h00000004;
        b = 32'h00000003;
        alu_control = 4'b0000; // ALU_ADD
        #10;
        check("ADD (4 + 3)", result, 32'h00000007);
        check("Zero flag ADD", zero, 1'b0);
        
        // Teste 2: SUB
        a = 32'h0000000A;
        b = 32'h00000003;
        alu_control = 4'b0001; // ALU_SUB
        #10;
        check("SUB (10 - 3)", result, 32'h00000007);
        check("Zero flag SUB", zero, 1'b0);
        
        // Teste 3: AND
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0010; // ALU_AND
        #10;
        check("AND (F0F0F0F0 & 0F0F0F0F)", result, 32'h00000000);
        check("Zero flag AND", zero, 1'b1);
        
        // Teste 4: OR
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        alu_control = 4'b0011; // ALU_OR
        #10;
        check("OR (F0F0F0F0 | 0F0F0F0F)", result, 32'hFFFFFFFF);
        check("Zero flag OR", zero, 1'b0);
        
        // Teste 5: XOR
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        alu_control = 4'b0100; // ALU_XOR
        #10;
        check("XOR (AAAA ^ 5555)", result, 32'hFFFFFFFF);
        check("Zero flag XOR", zero, 1'b0);
        
        // Teste 6: SLL (Shift Left Logical)
        a = 32'h00000001;
        b = 32'h00000004;
        alu_control = 4'b0101; // ALU_SLL
        #10;
        check("SLL (1 << 4)", result, 32'h00000010);
        check("Zero flag SLL", zero, 1'b0);
        
        // Teste 7: SRL (Shift Right Logical)
        a = 32'h80000000;
        b = 32'h00000004;
        alu_control = 4'b0110; // ALU_SRL
        #10;
        check("SRL (80000000 >> 4)", result, 32'h08000000);
        check("Zero flag SRL", zero, 1'b0);
        
        // Teste 8: SRA (Shift Right Arithmetic)
        a = 32'h80000000;
        b = 32'h00000004;
        alu_control = 4'b0111; // ALU_SRA
        #10;
        check("SRA (80000000 >>> 4)", result, 32'hF8000000);
        check("Zero flag SRA", zero, 1'b0);
        
        // Teste 9: SLT (Set Less Than - signed)
        a = 32'hFFFFFFFE; // -2
        b = 32'h00000001; // 1
        alu_control = 4'b1000; // ALU_SLT
        #10;
        check("SLT (-2 < 1)", result, 32'h00000001);
        check("Zero flag SLT", zero, 1'b0);
        
        // Teste 10: SLTU (Set Less Than - unsigned)
        a = 32'hFFFFFFFE; // 4294967294
        b = 32'h00000001; // 1
        alu_control = 4'b1001; // ALU_SLTU
        #10;
        check("SLTU (FFFFFFFE < 1)", result, 32'h00000000);
        check("Zero flag SLTU", zero, 1'b1);
        
        // Teste 11: LUI (Load Upper Immediate)
        a = 32'h12345678; // Não usado
        b = 32'h0000ABCD;
        alu_control = 4'b1010; // ALU_LUI
        #10;
        check("LUI (ABCD)", result, 32'h0000ABCD);
        check("Zero flag LUI", zero, 1'b0);
        
        // Teste 12: Operação inválida
        a = 32'h12345678;
        b = 32'h87654321;
        alu_control = 4'b1111; // Operação inválida
        #10;
        check("Operação inválida", result, 32'h00000000);
        
        $display("\n===== FIM DOS TESTES =====\n");
        $finish;
    end

endmodule