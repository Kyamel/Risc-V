`timescale 1ns / 1ps
module tb_hazard_detection;

    // --- Sinais de Entrada para o DUT ---
    reg [4:0] if_id_rs1_addr; // Endereço do operando 1 na instrução em ID
    reg [4:0] if_id_rs2_addr; // Endereço do operando 2 na instrução em ID
    reg [4:0] id_ex_rd_addr;  // Endereço de destino da instrução em EX
    reg       id_ex_mem_read; // Sinal que indica se a instrução em EX é um load

    // --- Sinal de Saída do DUT ---
    wire      stall;          // Sinal de stall gerado pelo DUT

    // --- Instanciação do Módulo sob Teste (DUT) ---
    hazard_detection dut (
        .if_id_rs1_addr(if_id_rs1_addr),
        .if_id_rs2_addr(if_id_rs2_addr),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_mem_read(id_ex_mem_read),
        .stall(stall)
    );

    // --- Task de Verificação ---
    // Compara o resultado obtido com o esperado e imprime o status.
    task check(string test_name, input expected_stall);
        #1; // Aguarda um pequeno instante para a lógica combinacional propagar
        if (stall !== expected_stall) begin
            $display("\033[1;31m[FAIL]\033[0m %s: Stall esperado era %b, mas foi %b.", test_name, expected_stall, stall);
        end else begin
            $display("\033[1;32m[PASS]\033[0m %s: Stall = %b, como esperado.", test_name, stall);
        end
    endtask

    // --- Sequência de Teste Principal ---
    initial begin
        $display("\n---- INICIANDO TESTE DA UNIDADE DE DETECÇÃO DE HAZARD ----\n");

        // --- Cenário 1: Sem Hazard (Instrução em EX não é um load) ---
        // EX: add r3, r1, r2  | ID: add r5, r4, r6
        id_ex_mem_read = 0;
        id_ex_rd_addr  = 5'd3;
        if_id_rs1_addr = 5'd4;
        if_id_rs2_addr = 5'd6;
        check("Sem Hazard (não é load)", 1'b0);

        // --- Cenário 2: Sem Hazard (Load, mas sem dependência de dados) ---
        // EX: lw r3, 0(r1) | ID: add r5, r4, r6
        id_ex_mem_read = 1;
        id_ex_rd_addr  = 5'd3; // EX escreve em r3
        if_id_rs1_addr = 5'd4; // ID lê de r4
        if_id_rs2_addr = 5'd6; // ID lê de r6
        check("Sem Hazard (load sem dependência)", 1'b0);

        // --- Cenário 3: Sem Hazard (Load para o registrador x0) ---
        // EX: lw x0, 0(r1) | ID: add r5, x0, r6
        // Escrever em x0 é um NOP, então não deve causar stall.
        id_ex_mem_read = 1;
        id_ex_rd_addr  = 5'd0; // EX escreve em x0
        if_id_rs1_addr = 5'd0; // ID lê de x0
        if_id_rs2_addr = 5'd6;
        check("Sem Hazard (load para x0)", 1'b0);

        // --- Cenário 4: HAZARD! (Dependência em rs1) ---
        // EX: lw r5, 0(r1) | ID: add r6, r5, r2
        id_ex_mem_read = 1;
        id_ex_rd_addr  = 5'd5; // EX escreve em r5
        if_id_rs1_addr = 5'd5; // ID lê de r5
        if_id_rs2_addr = 5'd2;
        check("HAZARD (dependência em rs1)", 1'b1);

        // --- Cenário 5: HAZARD! (Dependência em rs2) ---
        // EX: lw r5, 0(r1) | ID: add r6, r2, r5
        id_ex_mem_read = 1;
        id_ex_rd_addr  = 5'd5; // EX escreve em r5
        if_id_rs1_addr = 5'd2;
        if_id_rs2_addr = 5'd5; // ID lê de r5
        check("HAZARD (dependência em rs2)", 1'b1);

        // --- Cenário 6: HAZARD! (Dependência em rs1 e rs2) ---
        // EX: lw r5, 0(r1) | ID: add r6, r5, r5
        id_ex_mem_read = 1;
        id_ex_rd_addr  = 5'd5; // EX escreve em r5
        if_id_rs1_addr = 5'd5; // ID lê de r5
        if_id_rs2_addr = 5'd5; // ID lê de r5
        check("HAZARD (dependência em rs1 e rs2)", 1'b1);
        
        // --- Cenário 7: Sem Hazard (Dependência resolvida por forwarding) ---
        // Este testbench não testa o forwarding, mas é importante lembrar que
        // o hazard de load-use não pode ser totalmente resolvido por forwarding,
        // exigindo sempre um stall. O teste aqui apenas volta a um estado sem stall.
        id_ex_mem_read = 0;
        check("Retorno a estado sem stall", 1'b0);


        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule