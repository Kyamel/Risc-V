`timescale 1ns / 1ps

module ex_mem (
    input wire         clk,
    input wire         rst,
    input wire         stall,
    input wire         flush,
    
    // Entradas do estágio EX
    input wire [31:0]  ex_adder_out,       // PC + (imm << 1) (vem do somador de branch)
    input wire [31:0]  ex_result,          // Resultado da ALU (vai para memória de dados)
    input wire [4:0]   ex_rd,              // Registrador destino (vem de id_ex)
    input wire [31:0]  ex_read_data_2_mux, // Dado para escrita (vem do mux de forwarding)
    
    // Saídas para o estágio MEM
    output reg [31:0]  mem_addr,           // Endereço para memória de dados (ALU  Result)
    output reg [31:0]  mem_write_data,     // Dado para escrita na memória
    output reg [4:0]   mem_rd,             // Registrador destino (para WB e forwarding)
    output reg [31:0]  mem_adder_out       // PC + offset (para cálculo de branch)
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset/flush: zera todos os registradores
            mem_addr       <= 32'b0;
            mem_write_data <= 32'b0;
            mem_rd         <= 5'b0;
            mem_adder_out  <= 32'b0;
        end
        else if (!stall) begin
            // Registra os valores normalmente
            mem_addr       <= ex_result;          // Resultado da ALU -> endereço de memória
            mem_write_data <= ex_read_data_2_mux; // Dado para escrita na memória
            mem_rd         <= ex_rd;             // Registrador destino
            mem_adder_out  <= ex_adder_out;      // PC + offset para branch
        end
        // Se stall, mantém os valores atuais
    end

endmodule