`timescale 1ns / 1ps

module tb_hazard_detection;

    // --- Sinais de entrada para a unidade em teste (UUT) ---
    reg [4:0] id_rs1;
    reg [4:0] id_rs2;
    reg [4:0] ex_rd;
    reg       ex_memread;
    reg       pc_redirect;

    // --- Sinais de saída da unidade em teste (UUT) ---
    wire      pc_write_enable;
    wire      if_id_write_enable;
    wire      flush_ex;

    // --- Variáveis de verificação ---
    integer pass_count;
    integer fail_count;

    // Instanciação da Unidade Sob Teste (Unit Under Test - UUT)
    hazard_detection uut (
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .ex_rd(ex_rd),
        .ex_memread(ex_memread),
        .pc_redirect(pc_redirect),
        .pc_write_enable(pc_write_enable),
        .if_id_write_enable(if_id_write_enable),
        .flush_ex(flush_ex)
    );

    // Tarefa para verificar os resultados e imprimir o status
    task check_result;
        input expected_pc_write;
        input expected_if_id_write;
        input expected_flush;
        input [8*60-1:0] case_name;
    begin
        #10; // Espera um pouco para os sinais se propagarem
        if (pc_write_enable === expected_pc_write &&
            if_id_write_enable === expected_if_id_write &&
            flush_ex === expected_flush)
        begin
            $display("\033[32m[PASS]\033[0m %s", case_name);
            pass_count = pass_count + 1;
        end else begin
            $display("\033[31m[FAIL]\033[0m %s -> Recebido: PCWrite=%b, IFIDWrite=%b, Flush=%b | Esperado: PCWrite=%b, IFIDWrite=%b, Flush=%b",
                     case_name, pc_write_enable, if_id_write_enable, flush_ex, expected_pc_write, expected_if_id_write, expected_flush);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // Bloco principal de simulação
    initial begin
        $display("Iniciando simulação da Hazard Detection Unit...");
        $display("--------------------------------------------------------------------");
        pass_count = 0;
        fail_count = 0;

        // --- Caso 1: Operação Normal ---
        // Nenhuma dependência, nenhum desvio. O pipeline deve rodar normalmente.
        id_rs1 = 5'd1; id_rs2 = 5'd2;
        ex_rd = 5'd3; ex_memread = 1'b0; pc_redirect = 1'b0;
        check_result(1'b1, 1'b1, 1'b0, "Caso 1: Operacao Normal (sem hazards)");

        // --- Caso 2: Hazard de Load-Use em rs1 ---
        // lw x2, 0(x3)
        // add x4, x2, x1  <- Dependência em x2
        id_rs1 = 5'd2; id_rs2 = 5'd1;
        ex_rd = 5'd2; ex_memread = 1'b1; pc_redirect = 1'b0;
        check_result(1'b0, 1'b0, 1'b0, "Caso 2: Hazard de Load-Use (stall na dependencia de rs1)");

        // --- Caso 3: Hazard de Load-Use em rs2 ---
        // lw x2, 0(x3)
        // add x4, x1, x2  <- Dependência em x2
        id_rs1 = 5'd1; id_rs2 = 5'd2;
        ex_rd = 5'd2; ex_memread = 1'b1; pc_redirect = 1'b0;
        check_result(1'b0, 1'b0, 1'b0, "Caso 3: Hazard de Load-Use (stall na dependencia de rs2)");
        
        // --- Caso 4: Sem Hazard de Load-Use (escrita em x0) ---
        // lw x0, 0(x3)  <- Escrita em x0 não deve causar stall
        // add x4, x0, x1
        id_rs1 = 5'd0; id_rs2 = 5'd1;
        ex_rd = 5'd0; ex_memread = 1'b1; pc_redirect = 1'b0;
        check_result(1'b1, 1'b1, 1'b0, "Caso 4: Sem Hazard (load para x0 nao causa stall)");

        // --- Caso 5: Hazard de Controle (Branch/Jump Tomado) ---
        // Um desvio foi tomado, a instrução em EX deve ser limpa (flush).
        id_rs1 = 5'd1; id_rs2 = 5'd2;
        ex_rd = 5'd3; ex_memread = 1'b0; pc_redirect = 1'b1;
        check_result(1'b1, 1'b1, 1'b1, "Caso 5: Hazard de Controle (flush apos desvio)");
        
        // --- Caso 6: Load-Use tem prioridade sobre o Flush ---
        // Cenário improvável, mas testa a lógica 'if-else'. O stall deve acontecer.
        id_rs1 = 5'd2; id_rs2 = 5'd1;
        ex_rd = 5'd2; ex_memread = 1'b1; pc_redirect = 1'b1;
        check_result(1'b0, 1'b0, 1'b0, "Caso 6: Prioridade do Stall sobre o Flush");

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