`timescale 1ns / 1ps

module tb_if_id();

    // Parâmetros
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz

    // Cores para mensagens (ANSI)
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m"; // No Color

    // Sinais
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    reg [31:0] pc_in;
    reg [31:0] instr_in;
    wire [31:0] pc_out;
    wire [31:0] instr_out;

    // Instância do DUT
    if_id uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_in),
        .instr_in(instr_in),
        .pc_out(pc_out),
        .instr_out(instr_out)
    );

    // Geração de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task para verificação padronizada
    task automatic verify;
        input string test_name;
        input [31:0] observed;
        input [31:0] expected;
        begin
            if (observed === expected) begin
                $display("%s[PASS]%s %s: Obtido = 0x%h", GREEN, NC, test_name, observed);
            end else begin
                $display("%s[FAIL]%s %s: Esperado = 0x%h, Obtido = 0x%h", RED, NC, 
                         test_name, expected, observed);
            end
        end
    endtask

    // Inicialização
    initial begin
        // Inicializa sinais
        clk = 0;
        rst = 0;
        stall = 0;
        flush = 0;
        pc_in = 32'h00000000;
        instr_in = 32'h00000000;

        // Teste 1: Reset assíncrono
        $display("\n=== Teste 1: Reset assíncrono ===");
        rst = 1;
        #(CLK_PERIOD);
        verify("Reset: pc_out", pc_out, 32'h0);
        verify("Reset: instr_out", instr_out, 32'h0);
        rst = 0;
        #(CLK_PERIOD);

        // Teste 2: Operação normal (sem stall/flush)
        $display("\n=== Teste 2: Operação normal ===");
        pc_in = 32'h00400000;
        instr_in = 32'h00100093; // addi x1, x0, 1
        #(CLK_PERIOD);
        verify("Operação normal: pc_out", pc_out, pc_in);
        verify("Operação normal: instr_out", instr_out, instr_in);

        // Teste 3: Stall (mantém valores anteriores)
        $display("\n=== Teste 3: Stall ===");
        pc_in = 32'h00400004;
        instr_in = 32'h00200113; // addi x2, x0, 2
        stall = 1;
        #(CLK_PERIOD);
        verify("Stall: pc_out mantido", pc_out, 32'h00400000); // Valor anterior
        verify("Stall: instr_out mantido", instr_out, 32'h00100093);
        stall = 0;

        // Teste 4: Flush (zera saídas)
        $display("\n=== Teste 4: Flush ===");
        pc_in = 32'h00400008;
        instr_in = 32'h00300193; // addi x3, x0, 3
        flush = 1;
        #(CLK_PERIOD);
        verify("Flush: pc_out", pc_out, 32'h0);
        verify("Flush: instr_out", instr_out, 32'h0);
        flush = 0;

        // Teste 5: Transição stall -> operação normal
        $display("\n=== Teste 5: Stall -> Operação normal ===");
        stall = 1;
        pc_in = 32'h0040000C;
        instr_in = 32'h00400213; // addi x4, x0, 4
        #(CLK_PERIOD);
        stall = 0;
        pc_in = 32'h00400010;
        instr_in = 32'h00500293; // addi x5, x0, 5
        #(CLK_PERIOD);
        verify("Stall -> Normal: pc_out atualizado", pc_out, pc_in);
        verify("Stall -> Normal: instr_out atualizado", instr_out, instr_in);

        // Finalização
        $display("\n=== Todos os testes concluídos ===");
        $finish;
    end

    // Monitoramento opcional
    initial begin
        $monitor("Tempo: %t | pc_in=0x%h | instr_in=0x%h | pc_out=0x%h | instr_out=0x%h | stall=%b | flush=%b",
                 $time, pc_in, instr_in, pc_out, instr_out, stall, flush);
    end

endmodule