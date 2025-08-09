`timescale 1ns / 1ps

module instruction_memory #(
    parameter WIDTH     = 32,          // Largura de cada instrução
    parameter DEPTH    = 256,           // Quantidade de instruções
    parameter INIT_FILE = ""           // Caminho do arquivo de inicialização (HEX)
)(
    input wire [31:0] instr_addr,      // Endereço da instrução (PC)

    output wire [WIDTH-1:0] instr      // Instrução buscada
);

    // Memória de instruções
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    // Leitura combinacional
    assign instr = memory[instr_addr[31:2]]; // addr >> 2

    // Inicialização opcional com arquivo
    initial begin
        if (INIT_FILE != "") begin
            $display("Loading instruction memory from %s", INIT_FILE);
            $readmemh(INIT_FILE, memory);
        end
    end

endmodule
