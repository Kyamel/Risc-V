`timescale 1ns / 1ps

module mem_wb (
    input wire         clk,
    input wire         rst,
    input wire         stall,
    input wire         flush,

    // Entradas do estágio MEM
    input wire [31:0]  mem_read_data,     // Dado lido da memória (vem do data_memory)
    input wire [31:0]  mem_result,        // Resultado da ALU (vem do ex_mem)
    input wire [4:0]   mem_rd,            // Registrador destino (vem do ex_mem)
    input wire         mem_RegWrite,      // Sinal de escrita no banco de registradores
    input wire         mem_MemtoReg,      // Controle do mux WB

    // Saídas para o estágio WB
    output reg [31:0]  wb_read_data,      // Dado lido da memória (para o mux WB)
    output reg [31:0]  wb_result,         // Resultado da ALU (para o mux WB)
    output reg [4:0]   wb_rd,             // Registrador destino
    output reg         wb_RegWrite,       // Sinal de escrita no banco de registradores
    output reg         wb_MemtoReg        // Controle do mux WB
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset/flush: zera todos os registradores
            wb_read_data  <= 32'b0;
            wb_result     <= 32'b0;
            wb_rd        <= 5'b0;
            wb_RegWrite  <= 1'b0;
            wb_MemtoReg  <= 1'b0;
        end
        else if (!stall) begin
            // Registra os valores normalmente
            wb_read_data  <= mem_read_data;
            wb_result     <= mem_result;
            wb_rd        <= mem_rd;
            wb_RegWrite  <= mem_RegWrite;
            wb_MemtoReg  <= mem_MemtoReg;
        end
        // Se stall, mantém os valores atuais
    end

endmodule