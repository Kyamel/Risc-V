`include "constants.v"

module instruction_memory (
    input wire clk,
    input wire reset,
    
    // Interface com o estágio IF
    input wire [31:0] addr,
    output reg [31:0] data_out,
    input wire read_en,
    
    // Interface de depuração/carregamento
    input wire debug_en,
    input wire [31:0] debug_addr,
    input wire [31:0] debug_data_in,
    input wire debug_write_en,
    output wire [31:0] debug_data_out
);

    // Memória organizada como 1024 palavras de 32 bits (4KB)
    reg [31:0] mem [0:1023];
    
    // Inicialização da memória com NOPs (addi x0, x0, 0)
    integer i;
    initial begin
        // Primeiro inicializa tudo com NOPs
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP
        end
        
        // Depois carrega o programa (se em simulação)
`ifdef SIMULATION
        $readmemh("compiler/program.hex", mem);
`endif
    end

    // Leitura normal (pelo estágio IF)
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 32'h00000013; // Retorna NOP no reset
        end else if (read_en) begin
            // Alinhamento de endereço para palavras (addr[1:0] são ignorados)
            data_out <= mem[addr[31:2]];
        end
    end

    // Interface de depuração/carregamento (síncrona)
    assign debug_data_out = mem[debug_addr[31:2]];
    
    always @(posedge clk) begin
        if (debug_en && debug_write_en) begin
            mem[debug_addr[31:2]] <= debug_data_in;
        end
    end

endmodule