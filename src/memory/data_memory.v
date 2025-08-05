`timescale 1ns / 1ps

module data_memory #(
    parameter WIDTH = 32,               // Largura de cada palavra (em bits)
    parameter DEPTH = 1024,             // Número de posições de memória
    parameter INIT_FILE = "none"        // Arquivo de inicialização (opcional)
) (
    input wire clk,                     // Sinal de clock
    
    input wire [WIDTH-1:0] mem_addr,    // Endereço de memória (vindo da ALU)
    input wire [WIDTH-1:0] write_data,  // Dado para escrita
    input wire mem_write,               // Sinal de escrita
    input wire mem_read,                // Sinal de leitura
    output reg [WIDTH-1:0] read_data    // Dado lido
);

    // Calcula a largura do endereço baseado na profundidade
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Memória principal
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // Inicialização da memória
    initial begin
        if (INIT_FILE != "none") begin
            $readmemh(INIT_FILE, memory);
        end
    end
    
    // Operações de memória
    always @(posedge clk) begin
        // Operação de leitura
        if (mem_read) begin
            read_data <= memory[mem_addr[ADDR_WIDTH-1:0]];
        end
        
        // Operação de escrita
        if (mem_write) begin
            memory[mem_addr[ADDR_WIDTH-1:0]] <= write_data;
        end
    end

endmodule