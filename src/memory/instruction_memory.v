`timescale 1ns / 1ps

module instruction_memory #(
    parameter DEPTH = 1024,         // Tamanho em palavras (4KB)
    parameter INIT_FILE = ""        // Arquivo de inicialização
) (
    input  wire        clk,
    input  wire        reset,
    
    // Interface de leitura
    input  wire [31:0] addr,
    output reg  [31:0] data_out,
    input  wire        read_en,
    
    // Interface de debug
    input  wire [31:0] debug_addr,
    output reg  [31:0] debug_data_out  // Mudado para reg
);

    localparam NOP = 32'h00000013;  // addi x0, x0, 0

    // Memória principal
    reg [31:0] mem [0:DEPTH-1];

    // Leitura síncrona
    always @(posedge clk) begin
        if (reset) begin
            data_out <= NOP;
        end else if (read_en) begin
            data_out <= mem[addr[31:2]];
        end else begin
            data_out <= NOP;
        end
    end

    // Leitura assíncrona para debug
    always @(*) begin
        if (debug_addr[31:2] < DEPTH) begin
            debug_data_out = mem[debug_addr[31:2]];
        end else begin
            debug_data_out = NOP;
        end
    end

    // Inicialização da memória
    initial begin
        integer i;
        // Preenche com NOPs
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = NOP;
        end

        // Carrega conteúdo do arquivo se especificado
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
    end

endmodule
