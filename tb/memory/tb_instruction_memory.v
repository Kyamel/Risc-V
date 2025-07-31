module tb_instruction_memory;

    // --- Sinais de Conexão com o DUT ---
    reg clk = 0;
    reg reset;
    reg [31:0] addr;
    wire [31:0] data_out;
    reg read_en;

    // --- Sinais da Interface de Debug ---
    reg debug_en;
    reg [31:0] debug_addr;
    reg [31:0] debug_data_in;
    reg debug_write_en;
    wire [31:0] debug_data_out;

    // Variável de iteração
    integer i;

    // --- Geração de Clock ---
    // Gera um clock com período de 10ns (100MHz)
    always #5 clk = ~clk;

    // --- Instanciação do Módulo sob Teste (DUT) ---
    instruction_memory dut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_out(data_out),
        .read_en(read_en),
        .debug_en(debug_en),
        .debug_addr(debug_addr),
        .debug_data_in(debug_data_in),
        .debug_write_en(debug_write_en),
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
        debug_en = 0;
        debug_write_en = 0;
        addr = 32'h0;
        debug_addr = 32'h0;
        debug_data_in = 32'h0;

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
        // 2. Escreve via interface de debug
        // -----------------------------------------------------------------
        debug_en = 1;
        debug_write_en = 1;
        debug_addr = 32'h00000020; // Endereço 0x20 (palavra 8)
        debug_data_in = 32'hCAFEBABE;
        #10; // Aguarda um ciclo para a escrita síncrona ocorrer

        // -----------------------------------------------------------------
        // 3. Lê instrução via porta normal no endereço modificado
        // -----------------------------------------------------------------
        addr = 32'h00000020;
        debug_write_en = 0; // Desliga a escrita para o próximo teste
        #10; // Aguarda um ciclo para a leitura ocorrer
        check("Leitura normal após escrita debug", data_out, 32'hCAFEBABE);

        // -----------------------------------------------------------------
        // 4. Lê via debug_data_out (leitura combinacional)
        // -----------------------------------------------------------------
        // Não precisa esperar, a leitura via debug é imediata (assign)
        check("Leitura via debug_data_out", debug_data_out, 32'hCAFEBABE);

        // -----------------------------------------------------------------
        // 5. Escrita sem debug_en = deve ser ignorada
        // -----------------------------------------------------------------
        debug_en = 0; // Desabilita a interface de debug
        debug_write_en = 1;
        debug_addr = 32'h00000030; // Endereço 0x30 (palavra 12)
        debug_data_in = 32'hDEADBEEF;
        #10; // Aguarda um ciclo

        addr = 32'h00000030;
        #10; // Aguarda um ciclo para a leitura
        // O valor deve ser o NOP original, pois a escrita foi ignorada
        check("Escrita ignorada sem debug_en", data_out, 32'h00000013);

        $display("\n---- FIM DOS TESTES ----\n");
        $finish;
    end

endmodule