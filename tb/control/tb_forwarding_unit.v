`timescale 1ns / 1ps

module tb_forwarding_unit;

    // --- Sinais de entrada para a unidade em teste (UUT) ---
    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] ex_mem_rd;
    reg       ex_mem_regwrite;
    reg [4:0] mem_wb_rd;
    reg       mem_wb_regwrite;

    // --- Sinais de saída da unidade em teste (UUT) ---
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // --- Variáveis de verificação ---
    integer pass_count;
    integer fail_count;

    // Instanciação da Unidade Sob Teste (Unit Under Test - UUT)
    forwarding_unit uut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_regwrite(ex_mem_regwrite),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_regwrite(mem_wb_regwrite),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // Tarefa para verificar os resultados e imprimir o status
    task check_result;
        input [1:0] expected_A;
        input [1:0] expected_B;
        input [8*40-1:0] case_name; // CORREÇÃO: Usando um vetor de reg em vez de 'string'
    begin
        #10; // Espera um pouco para os sinais se propagarem
        if (forward_a === expected_A && forward_b === expected_B) begin
            $display("\033[32m[PASS]\033[0m %s -> forward_a = %b, forward_b = %b", case_name, forward_a, forward_b);
            pass_count = pass_count + 1;
        end else begin
            $display("\033[31m[FAIL]\033[0m %s -> Recebido: a=%b, b=%b | Esperado: a=%b, b=%b", case_name, forward_a, forward_b, expected_A, expected_B);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // Bloco principal de simulação
    initial begin
        $display("Iniciando simulação da Forwarding Unit com verificação automática...");
        $display("--------------------------------------------------------------------");
        pass_count = 0;
        fail_count = 0;

        // --- Caso 1: Sem Hazard ---
        id_ex_rs1 = 5'd1; id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd4; ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd5; mem_wb_regwrite = 1'b1;
        check_result(2'b00, 2'b00, "Caso 1: Sem Hazard");

        // --- Caso 2: Hazard EX -> EX em rs1 ---
        id_ex_rs1 = 5'd2; id_ex_rs2 = 5'd1;
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd5; mem_wb_regwrite = 1'b1;
        check_result(2'b01, 2'b00, "Caso 2: Hazard EX em rs1");

        // --- Caso 3: Hazard EX -> EX em rs2 ---
        id_ex_rs1 = 5'd1; id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd5; mem_wb_regwrite = 1'b1;
        check_result(2'b00, 2'b01, "Caso 3: Hazard EX em rs2");

        // --- Caso 4: Hazard MEM -> EX em rs1 ---
        id_ex_rs1 = 5'd2; id_ex_rs2 = 5'd1;
        ex_mem_rd = 5'd4; ex_mem_regwrite = 1'b0; // Simula um nop ou instrução sem escrita
        mem_wb_rd = 5'd2; mem_wb_regwrite = 1'b1;
        check_result(2'b10, 2'b00, "Caso 4: Hazard MEM em rs1");
        
        // --- Caso 5: Hazard MEM -> EX em rs2 --- (NOVO TESTE)
        id_ex_rs1 = 5'd1; id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd4; ex_mem_regwrite = 1'b0; // Simula um nop ou instrução sem escrita
        mem_wb_rd = 5'd2; mem_wb_regwrite = 1'b1;
        check_result(2'b00, 2'b10, "Caso 5: Hazard MEM em rs2");

        // --- Caso 6: Prioridade do Hazard EX sobre o MEM ---
        id_ex_rs1 = 5'd2; id_ex_rs2 = 5'd1;
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd2; mem_wb_regwrite = 1'b1;
        check_result(2'b01, 2'b00, "Caso 6: Prioridade EX sobre MEM");

        // --- Caso 7: Hazard com registrador zero (x0) ---
        id_ex_rs1 = 5'd0; id_ex_rs2 = 5'd0;
        ex_mem_rd = 5'd0; ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd0; mem_wb_regwrite = 1'b1;
        check_result(2'b00, 2'b00, "Caso 7: Hazard com registrador zero (x0)");

        // --- Caso 8: Hazard com RegWrite desativado ---
        id_ex_rs1 = 5'd2; id_ex_rs2 = 5'd3;
        ex_mem_rd = 5'd2; ex_mem_regwrite = 1'b0;
        mem_wb_rd = 5'd3; mem_wb_regwrite = 1'b0;
        check_result(2'b00, 2'b00, "Caso 8: Hazard com RegWrite = 0");

        // --- Sumário Final ---
        $display("\n--------------------------------------------------------------------");
        $display("Simulacao concluida.");
        if (fail_count == 0) begin
            $display("\033[32mTodos os %0d testes passaram!\033[0m", pass_count);
        end else begin
            $display("\033[32mTestes Aprovados: %0d\033[0m", pass_count);
            $display("\033[31mTestes Reprovados: %0d\033[0m", fail_count);
        end
        $display("--------------------------------------------------------------------");
        $finish;
    end

endmodule