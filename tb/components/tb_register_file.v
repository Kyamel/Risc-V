`timescale 1ns / 1ps

module tb_register_file();

    // Parâmetros
    parameter WIDTH = 32;
    parameter DEPTH = 32;
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz

    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color

    // Sinais
    reg clk;
    reg rst;
    reg [4:0] rs1, rs2, rd;
    reg [WIDTH-1:0] wd;
    reg reg_write;
    wire [WIDTH-1:0] read_data_1, read_data_2;
    wire [WIDTH-1:0] debug_data_out;

    // Instância do DUT
    register_file #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .reg_write(reg_write),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .debug_data_out(debug_data_out)
    );

    // Geração de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task para verificação com cores (padrão [PASS]/[FAIL])
    task automatic verify;
        input string test_name;
        input [WIDTH-1:0] observed;
        input [WIDTH-1:0] expected;
        begin
            if (observed === expected) begin
                $display("%s[PASS]%s %s: Obtido = 0x%h", GREEN, NC,
                         test_name, observed);
            end else begin
                $display("%s[FAIL]%s %s: Esperado = 0x%h, Obtido = 0x%h", RED, NC,
                         test_name, expected, observed);
            end
        end
    endtask

    // Inicialização
    initial begin
        clk = 0;
        rst = 1; // Ativa reset inicial
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        wd = 0;
        reg_write = 0;

        // Desativa reset após 2 ciclos de clock
        #(2*CLK_PERIOD);
        rst = 0;

        // Teste 1: Verificação do Reset (todos os registradores exceto x0 devem ser 0)
        $display("\n=== Teste 1: Verificação do Reset ===");
        for (int i = 1; i < DEPTH; i++) begin
            rs1 = i;
            #1; // Delta cycle para leitura assíncrona
            verify($sformatf("Reset do registrador x%0d", i), read_data_1, 0);
        end

        // Teste 2: Escrita e leitura em x5
        $display("\n=== Teste 2: Escrita e Leitura ===");
        reg_write = 1;
        rd = 5'd5;
        wd = 32'hDEADBEEF;
        #CLK_PERIOD; // Espera escrita síncrona

        rs1 = 5'd5;
        #1;
        verify("Escrita em x5", read_data_1, wd);

        // Teste 3: x0 é sempre zero (hardwired)
        $display("\n=== Teste 3: Verificação de x0 ===");
        rd = 5'd0;    // Tentativa de escrita em x0
        wd = 32'h12345678;
        #CLK_PERIOD;
        rs1 = 5'd0;
        #1;
        verify("Leitura de x0 (hardwired)", read_data_1, 0);

        // Finalização
        $display("\n=== Todos os testes concluídos ===");
        $finish;
    end

    // Monitoramento opcional (para debug)
    initial begin
        $monitor("Tempo: %t | rs1=%0d (0x%h) | rs2=%0d (0x%h) | rd=%0d (wd=0x%h) | reg_write=%b",
                 $time, rs1, read_data_1, rs2, read_data_2, rd, wd, reg_write);
    end

endmodule