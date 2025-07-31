`timescale 1ns / 1ps

module tb_stall_controller;

    // --- Sinais de Entrada para o DUT ---
    reg load_use_hazard;
    reg branch_hazard;
    reg memory_busy;

    // --- Sinais de Saída do DUT ---
    wire pc_write_enable;
    wire if_id_write_enable;
    wire flush_ex;

    // --- Instanciação do Módulo sob Teste (DUT) ---
    stall_controller dut (
        .load_use_hazard(load_use_hazard),
        .branch_hazard(branch_hazard),
        .memory_busy(memory_busy),
        .pc_write_enable(pc_write_enable),
        .if_id_write_enable(if_id_write_enable),
        .flush_ex(flush_ex)
    );

    // --- Task de Verificação ---
    // Compara os resultados obtidos com os esperados.
    task check(
        input string test_name,
        input expected_pc_write,
        input expected_if_id_write,
        input expected_flush
    );
        #1; // Aguarda a propagação da lógica combinacional
        if (pc_write_enable !== expected_pc_write ||
            if_id_write_enable !== expected_if_id_write ||
            flush_ex !== expected_flush)
        begin
            $display("\033[1;31m[FAIL]\033[0m %s", test_name);
            $display("       Esperado: PC_EN=%b, IF_ID_EN=%b, FLUSH=%b", expected_pc_write, expected_if_id_write, expected_flush);
            $display("       Obtido:   PC_EN=%b, IF_ID_EN=%b, FLUSH=%b", pc_write_enable, if_id_write_enable, flush_ex);
        end else begin
            $display("\033[1;32m[PASS]\033[0m %s", test_name);
        end
    endtask

    // --- Sequência de Teste Principal ---
    initial begin
        $display("\n---- INICIANDO TESTE DO STALL CONTROLLER ----\n");

        // Cenário 1: Operação Normal (sem hazards)
        load_use_hazard = 1'b0;
        branch_hazard   = 1'b0;
        memory_busy     = 1'b0;
        check("Operação Normal", 1'b1, 1'b1, 1'b0);

        // Cenário 2: Hazard de Load-Use (deve causar STALL)
        load_use_hazard = 1'b1;
        branch_hazard   = 1'b0;
        memory_busy     = 1'b0;
        check("Hazard de Load-Use (Stall)", 1'b0, 1'b0, 1'b0);

        // Cenário 3: Hazard de Branch (deve causar FLUSH)
        load_use_hazard = 1'b0;
        branch_hazard   = 1'b1;
        memory_busy     = 1'b0;
        check("Hazard de Branch (Flush)", 1'b1, 1'b1, 1'b1);
        
        // Cenário 4: Memória Ocupada (deve causar STALL)
        load_use_hazard = 1'b0;
        branch_hazard   = 1'b0;
        memory_busy     = 1'b1;
        check("Memória Ocupada (Stall)", 1'b0, 1'b0, 1'b0);

        // Cenário 5: Teste de Prioridade (Load-Use > Branch)
        // Um stall de dados tem prioridade sobre um flush de controle.
        load_use_hazard = 1'b1;
        branch_hazard   = 1'b1;
        memory_busy     = 1'b0;
        check("Prioridade: Load-Use > Branch", 1'b0, 1'b0, 1'b0);
        
        // Cenário 6: Teste de Prioridade (Memória Ocupada > Branch)
        // Um stall de memória tem prioridade sobre um flush de controle.
        load_use_hazard = 1'b0;
        branch_hazard   = 1'b1;
        memory_busy     = 1'b1;
        check("Prioridade: Memória Ocupada > Branch", 1'b0, 1'b0, 1'b0);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule