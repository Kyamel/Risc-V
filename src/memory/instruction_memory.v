`timescale 1ns / 1ps

module instruction_memory #(
    parameter DEPTH = 1024,         // Tamanho padrão: 1024 palavras (4 KB)
    parameter INIT_FILE = "compiler/program.hex"        // Arquivo de inicialização (opcional)
) (
    input  wire        clk,
    input  wire        reset,

    // Interface do Estágio IF
    input  wire [31:0] addr,
    output reg  [31:0] data_out,
    input  wire        read_en,

    // Debug
    input  wire [31:0] debug_addr,
    output wire [31:0] debug_data_out
);

    localparam NOP = 32'h00000013;  // addi x0, x0, 0

    // Memória principal
    reg [31:0] mem [0:DEPTH-1];

    // Leitura assíncrona (combinatória)
    always @(*) begin
        if (reset)
            data_out = NOP;
        else if (read_en) begin
            if (addr[31:2] < DEPTH)
                data_out = mem[addr[31:2]];  // Lê palavra alinhada (endereço >> 2)
            else
                data_out = NOP;             // Endereço inválido
        end else
            data_out = NOP;                  // Leitura desabilitada
    end

    // Debug (leitura assíncrona)
    assign debug_data_out = (debug_addr[31:2] < DEPTH) ? mem[debug_addr[31:2]] : NOP;

    // Inicialização da memória
    initial begin
        // Preenche com NOPs
        for (integer i = 0; i < DEPTH; i = i + 1)
            mem[i] = NOP;

        // Carrega conteúdo do arquivo (se especificado)
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, mem);
    end

endmodule