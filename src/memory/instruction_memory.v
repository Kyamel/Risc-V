module instruction_memory (
    input wire clk,
    input wire reset,

    // --- Interface com o Estágio de Busca de Instrução (IF) ---
    input wire [31:0] addr,         // Endereço da instrução a ser lida
    output reg [31:0] data_out,      // Instrução lida da memória
    input wire read_en,        // Habilita a leitura da memória

    // --- Interface de Depuração/Carregamento ---
    input wire        debug_en,       // Habilita o modo de depuração
    input wire [31:0] debug_addr,     // Endereço para acesso via debug
    input wire [31:0] debug_data_in,  // Dado a ser escrito via debug
    input wire        debug_write_en, // Habilita a escrita via debug
    output wire [31:0] debug_data_out  // Dado lido via debug
);

    // Instrução NOP (addi x0, x0, 0) definida localmente para evitar dependências.
    localparam NOP = 32'h00000013;

    // Memória de 4KB, organizada como 1024 palavras de 32 bits.
    // O tipo `reg` é usado para que possa ser escrita em blocos `initial` e `always`.
    reg [31:0] mem [0:1023];

    // --- Lógica de Leitura Principal (para o pipeline) ---
    // A leitura é síncrona para simular o comportamento de uma BRAM.
    always @(posedge clk) begin
        if (reset) begin
            // Durante o reset, a saída é forçada para NOP, garantindo um estado seguro.
            data_out <= NOP;
        end else if (read_en) begin
            // Quando a leitura é habilitada, busca a instrução no endereço especificado.
            // O endereço é alinhado para palavras (os 2 bits menos significativos são ignorados).
            data_out <= mem[addr[31:2]];
        end else begin
            // Se a leitura não estiver habilitada, a saída é mantida em NOP.
            // Isso evita a criação de um latch, mantendo a saída em um valor padrão conhecido.
            data_out <= NOP;
        end
    end

    // --- Lógica da Interface de Depuração ---
    // A leitura de debug é combinacional para permitir uma verificação rápida do estado da memória.
    assign debug_data_out = mem[debug_addr[31:2]];

    // A escrita de debug é síncrona para evitar problemas de timing.
    always @(posedge clk) begin
        if (debug_en && debug_write_en) begin
            mem[debug_addr[31:2]] <= debug_data_in;
        end
    end

    // --- Inicialização da Memória ---
    // Este bloco é executado apenas uma vez, no início dos tempos (tempo 0 da simulação).
    integer i;
    initial begin
        // 1. Primeiro, inicializa toda a memória com NOPs.
        //    Isso garante um estado padrão conhecido para a memória não utilizada
        //    e é o comportamento esperado para a síntese em hardware.
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = NOP;
        end

        // 2. Se a macro SIMULATION estiver definida (geralmente por flags do compilador),
        //    o conteúdo do arquivo .hex é carregado na memória. Ele sobrescreve os NOPs
        //    no início da memória com as instruções do programa.
        //    Colocar as duas operações no mesmo bloco `initial` garante a ordem sequencial
        //    e elimina a condição de corrida.
        `ifdef SIMULATION
            $readmemh("compiler/program.hex", mem);
        `endif
    end

endmodule