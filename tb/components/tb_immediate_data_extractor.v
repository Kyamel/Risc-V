`timescale 1ns / 1ps

module tb_immediate_data_extractor();

    // Parâmetros para cores (ANSI escape codes)
    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color
    
    // Sinais
    reg [31:0] instr;
    wire [31:0] imm_data;
    
    // Instância do módulo testado
    immediate_data_extractor uut (
        .instr(instr),
        .imm_data(imm_data)
    );
    
    // Tarefa para verificar resultados
    task check_imm;
        input [31:0] expected;
        input [31:0] actual;
        input string test_name;
        begin
            if (actual === expected) begin
                $display("%s[PASS]%s %s: 0x%08h", GREEN, NC, test_name, actual);
            end else begin
                $display("%s[FAIL]%s %s: Expected 0x%08h, Got 0x%08h", RED, NC, test_name, expected, actual);
            end
        end
    endtask

    // Testes
    initial begin
        $display("\n=== Teste do Immediate Data Extractor ===\n");
        
        // Teste 1: ADDI positivo
        instr = 32'h07f10093; // ADDI x1, x2, 127
        #10;
        check_imm(32'h0000007f, imm_data, "ADDI positivo (I-type)");
        
        // Teste 2: ADDI negativo
        instr = 32'hfff10093; // ADDI x1, x2, -1
        #10;
        check_imm(32'hffffffff, imm_data, "ADDI negativo (I-type)");
        
        // Teste 3: ADDI zero
        instr = 32'h00010093; // ADDI x1, x2, 0
        #10;
        check_imm(32'h00000000, imm_data, "ADDI zero (I-type)");
        
        // Teste 4: SW offset 0
        instr = 32'h00322823; // SW x3, 0(x4)
        #10;
        check_imm(32'h00000000, imm_data, "SW offset 0 (S-type)");
        
        // Teste 5: SW offset -20
        instr = 32'hfe532e23; // SW x5, -20(x6)
        #10;
        check_imm(32'hffffffec, imm_data, "SW offset -20 (S-type)");

        // Teste 6: LW offset 8
        instr = 32'h00842383; // LW x3, 8(x4)
        #10;
        check_imm(32'h00000008, imm_data, "LW offset 8 (I-type)");

        // Teste 7: BEQ +8
        instr = 32'h00208463; // BEQ x1, x2, +8
        #10;
        check_imm(32'h00000008, imm_data, "BEQ +8 (B-type)");
        
        // Teste 8: BEQ -4
        instr = 32'hfe208ee3; // BEQ x1, x2, -4
        #10;
        check_imm(32'hfffffffc, imm_data, "BEQ -4 (B-type)");

        // Teste 9: LUI
        instr = 32'h123450b7; // LUI x1, 0x12345
        #10;
        check_imm(32'h12345000, imm_data, "LUI (U-type)");

        // Teste 10: JAL +0xABC
        instr = 32'h2bd000ef; // JAL x1, +0xABC
        #10;
        check_imm(32'h00000abc, imm_data, "JAL +0xABC (J-type)");
        
        $display("\n=== Fim dos Testes ===");
        $finish;
    end

endmodule