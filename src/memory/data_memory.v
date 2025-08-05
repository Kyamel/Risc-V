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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // Inicialização
    integer i;
    initial begin
        // Inicializa toda a memória com zeros
        for (i = 0; i < DEPTH; i = i + 1) begin
            memory[i] = 32'h0;
        end
        
        if (INIT_FILE != "none") begin
            $readmemh(INIT_FILE, memory);
        end
    end
    
    // CORREÇÃO: Lógica separada para leitura e escrita
    wire [ADDR_WIDTH-1:0] word_addr = mem_addr[ADDR_WIDTH+1:2]; // Endereço de palavra
    
    // Leitura combinacional (para compatibilidade com pipeline)
    always @(*) begin
        if (mem_read) begin
            read_data = memory[word_addr];
        end else begin
            read_data = 32'h0;
        end
    end
    
    // Escrita síncrona
    always @(posedge clk) begin
        if (mem_write) begin
            memory[word_addr] <= write_data;
            $display("MEM WRITE: addr=0x%08h, data=0x%08h", mem_addr, write_data);
        end
    end

endmodule