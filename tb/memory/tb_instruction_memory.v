`timescale 1ns / 1ps

module tb_instruction_memory;

    // --- Sinais de Conexão com o DUT ---
    reg clk = 0;
    reg reset;
    reg [31:0] addr;
    wire [31:0] data_out;
    reg read_en;

    // --- Sinais da Interface de Debug ---
    reg [31:0] debug_addr;
    wire [31:0] debug_data_out;

    // Variável de iteração
    integer i;

    // --- Geração de Clock ---
    // Gera um clock com período de 10ns (100MHz)
    always #5 clk = ~clk;

    // --- Instanciação do Módulo sob Teste (DUT) ---
    instruction_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/program.hex")
    ) dut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_out(data_out),
        .read_en(read_en),
        .debug_addr(debug_addr),
        .debug_data_out(debug_data_out)
    );

    // --- Task de Verificação ---
    // Compara um valor obtido com um valor esperado e imprime o resultado.
    task check(string name, input [31:0] got, input [31:0] expected);
        begin
            if (got !== expected) begin
                $display("\033[1;31m[FAIL]\033[0m %s: Esperado 0x%h, Obteve 0x%h", name, expected, got);
            end else begin
                $display("\033[1;32m[PASS]\033[0m %s: Valor 0x%h", name, got);
            end
        end
    endtask

    // --- Sequência de Teste Principal ---
    initial begin
        // Configuração do dump de formas de onda para depuração visual
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_instruction_memory);
        
        // Aguarda um pequeno instante para a memória ser inicializada pelo $readmemh
        #1; 
        
        $display("\n---- DUMP INICIAL DAS PRIMEIRAS INSTRUÇÕES ----");
        for (i = 0; i < 8; i = i + 1) begin
            // Acessa a memória interna do DUT para verificação (apenas em simulação)
            $display("mem[%0d] = %h", i, dut.mem[i]);
        end
        $display("-----------------------------------------------\n");

        $display("\n---- TESTE INSTRUCTION_MEMORY ----\n");

        // --- Estado Inicial dos Sinais ---
        reset = 1; // Inicia com o processador em reset
        read_en = 1; // Habilita a leitura para observar a saída
        addr = 32'h0;
        debug_addr = 32'h0;

        // Aguarda um ciclo de clock completo com o reset ativo
        #10;

        // -----------------------------------------------------------------
        // 1. Verifica se a saída é NOP *enquanto o reset está ativo*
        //    Esta é a correção principal. A verificação ocorre após o
        //    primeiro posedge do clock com reset=1.
        // -----------------------------------------------------------------
        check("Reset retorna NOP", data_out, 32'h00000013);
        
        // Libera o reset
        reset = 0;
        
        // Aguarda um ciclo de clock para a primeira leitura normal ocorrer
        #10;
        
        // -----------------------------------------------------------------
        // 1.1. Verifica a leitura normal do endereço 0 após o reset
        // -----------------------------------------------------------------
        check("Leitura normal de addr 0 pós-reset", data_out, dut.mem[0]);

        // -----------------------------------------------------------------
        // 2. Verifica leitura via porta normal em diferentes endereços
        // -----------------------------------------------------------------
        addr = 32'h00000004; // Endereço 0x04 (palavra 1)
        #10;
        check("Leitura de addr 4", data_out, dut.mem[1]);
        
        addr = 32'h00000008; // Endereço 0x08 (palavra 2)
        #10;
        check("Leitura de addr 8", data_out, dut.mem[2]);

        // -----------------------------------------------------------------
        // 3. Verifica leitura via debug_data_out (leitura combinacional)
        // -----------------------------------------------------------------
        debug_addr = 32'h0000000C; // Endereço 0x0C (palavra 3)
        // Não precisa esperar, a leitura via debug é imediata (assign)
        check("Leitura via debug_data_out addr C", debug_data_out, dut.mem[3]);
        
        debug_addr = 32'h00000010; // Endereço 0x10 (palavra 4)
        check("Leitura via debug_data_out addr 10", debug_data_out, dut.mem[4]);

        // -----------------------------------------------------------------
        // 4. Verifica comportamento quando read_en = 0
        // -----------------------------------------------------------------
        read_en = 0;
        addr = 32'h00000014; // Endereço 0x14 (palavra 5)
        #10;
        check("Saída NOP quando read_en=0", data_out, 32'h00000013);
        
        read_en = 1; // Reabilita leitura
        #10;
        check("Leitura reabilitada", data_out, dut.mem[5]);

        // -----------------------------------------------------------------
        // 5. Verifica endereço fora dos limites
        // -----------------------------------------------------------------
        addr = 32'h00001000; // Endereço 1024 (fora do range)
        #10;
        check("Endereço inválido retorna NOP", data_out, 32'h00000013);
        
        debug_addr = 32'h00001000;
        check("Endereço inválido debug retorna NOP", debug_data_out, 32'h00000013);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule