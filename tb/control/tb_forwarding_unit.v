`timescale 1ns / 1ps

module tb_forwarding_unit;

    // --- Sinais de entrada para a unidade em teste (UUT) ---
    reg [4:0] id_ex_src1_addr;
    reg [4:0] id_ex_src2_addr;
    reg [4:0] ex_mem_dest_addr;
    reg       ex_mem_write_enable;
    reg [4:0] mem_wb_dest_addr;
    reg       mem_wb_write_enable;

    // --- Sinais de saída da unidade em teste (UUT) ---
    wire [1:0] operand1_forward;
    wire [1:0] operand2_forward;

    // --- Variáveis de verificação ---
    integer pass_count;
    integer fail_count;


    // Definições locais para códigos de forwarding
    localparam NO_FWD = 2'b00;
    localparam FWD_EX = 2'b01;
    localparam FWD_MEM = 2'b10;

    // Instanciação da Unidade Sob Teste
    forwarding_unit uut (
        .id_ex_src1_addr(id_ex_src1_addr),
        .id_ex_src2_addr(id_ex_src2_addr),
        .ex_mem_dest_addr(ex_mem_dest_addr),
        .ex_mem_write_enable(ex_mem_write_enable),
        .mem_wb_dest_addr(mem_wb_dest_addr),
        .mem_wb_write_enable(mem_wb_write_enable),
        .operand1_forward(operand1_forward),
        .operand2_forward(operand2_forward)
    );

    // Tarefa para verificar os resultados
    task check_result;
        input [1:0] expected_forward1;
        input [1:0] expected_forward2;
        input [8*40-1:0] test_case;
    begin
        #10; // Espera para estabilização
        if (operand1_forward === expected_forward1 && operand2_forward === expected_forward2) begin
            $display("\033[32m[PASS]\033[0m %s -> Fwd1=%b, Fwd2=%b", test_case, operand1_forward, operand2_forward);
            pass_count++;
        end else begin
            $display("\033[31m[FAIL]\033[0m %s -> Recebido: %b,%b | Esperado: %b,%b", 
                    test_case, operand1_forward, operand2_forward, expected_forward1, expected_forward2);
            fail_count++;
        end
    end
    endtask

    // Bloco principal de simulação
    initial begin
        $display("Iniciando teste da Forwarding Unit...");
        $display("-----------------------------------");
        pass_count = 0;
        fail_count = 0;

     

        // --- Caso 1: Sem hazards ---
        id_ex_src1_addr = 5'd1; id_ex_src2_addr = 5'd2;
        ex_mem_dest_addr = 5'd3; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd4; mem_wb_write_enable = 1'b1;
        check_result(NO_FWD, NO_FWD, "Sem hazards");

        // --- Caso 2: Hazard EX em operand1 ---
        id_ex_src1_addr = 5'd3; id_ex_src2_addr = 5'd1;
        ex_mem_dest_addr = 5'd3; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd5; mem_wb_write_enable = 1'b1;
        check_result(FWD_EX, NO_FWD, "Hazard EX em op1");

        // --- Caso 3: Hazard EX em operand2 ---
        id_ex_src1_addr = 5'd1; id_ex_src2_addr = 5'd3;
        ex_mem_dest_addr = 5'd3; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd5; mem_wb_write_enable = 1'b1;
        check_result(NO_FWD, FWD_EX, "Hazard EX em op2");

        // --- Caso 4: Hazard MEM em operand1 ---
        id_ex_src1_addr = 5'd4; id_ex_src2_addr = 5'd1;
        ex_mem_dest_addr = 5'd2; ex_mem_write_enable = 1'b0;
        mem_wb_dest_addr = 5'd4; mem_wb_write_enable = 1'b1;
        check_result(FWD_MEM, NO_FWD, "Hazard MEM em op1");

        // --- Caso 5: Hazard MEM em operand2 ---
        id_ex_src1_addr = 5'd1; id_ex_src2_addr = 5'd4;
        ex_mem_dest_addr = 5'd2; ex_mem_write_enable = 1'b0;
        mem_wb_dest_addr = 5'd4; mem_wb_write_enable = 1'b1;
        check_result(NO_FWD, FWD_MEM, "Hazard MEM em op2");

        // --- Caso 6: Prioridade EX sobre MEM ---
        id_ex_src1_addr = 5'd3; id_ex_src2_addr = 5'd1;
        ex_mem_dest_addr = 5'd3; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd3; mem_wb_write_enable = 1'b1;
        check_result(FWD_EX, NO_FWD, "Prioridade EX sobre MEM");

        // --- Caso 7: Registrador zero (x0) ---
        id_ex_src1_addr = 5'd0; id_ex_src2_addr = 5'd0;
        ex_mem_dest_addr = 5'd0; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd0; mem_wb_write_enable = 1'b1;
        check_result(NO_FWD, NO_FWD, "Registrador zero (x0)");

        // --- Caso 8: Write enable desativado ---
        id_ex_src1_addr = 5'd2; id_ex_src2_addr = 5'd3;
        ex_mem_dest_addr = 5'd2; ex_mem_write_enable = 1'b0;
        mem_wb_dest_addr = 5'd3; mem_wb_write_enable = 1'b0;
        check_result(NO_FWD, NO_FWD, "Write enable desativado");

        // --- Caso 9: Hazard em ambos operandos ---
        id_ex_src1_addr = 5'd3; id_ex_src2_addr = 5'd4;
        ex_mem_dest_addr = 5'd3; ex_mem_write_enable = 1'b1;
        mem_wb_dest_addr = 5'd4; mem_wb_write_enable = 1'b1;
        check_result(FWD_EX, FWD_MEM, "Hazard em ambos operandos");

        // Resultado final
        $display("\n-----------------------------------");
        $display("Resultados do Teste:");
        $display("Testes Passados: \033[32m%d\033[0m", pass_count);
        $display("Testes Falhados: \033[31m%d\033[0m", fail_count);
        $display("-----------------------------------");
        
        if (fail_count == 0) begin
            $display("\033[32mTodos os testes passaram com sucesso!\033[0m");
        end else begin
            $display("\033[31mAlguns testes falharam. Verifique os resultados.\033[0m");
        end
        
        $finish;
    end

endmodule