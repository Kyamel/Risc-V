`timescale 1ns / 1ps

module id_ex (
    input wire clk,
    input wire rst,
    input wire stall,
    input wire flush,
    
    // Entradas do estágio ID
    input wire [31:0] id_read_data_1,    // Dado lido do registrador rs1
    input wire [31:0] id_read_data_2,    // Dado lido do registrador rs2
    input wire [31:0] id_imm_data,       // Valor imediato extendido
    input wire [31:0] id_pc_out,         // PC atual (antes do +4)
    input wire [4:0] id_rs1,             // Endereço do registrador rs1
    input wire [4:0] id_rs2,             // Endereço do registrador rs2
    input wire [4:0] id_rd,              // Endereço do registrador rd
    
    // Saídas para o estágio EX
    output reg [31:0] ex_read_data_1,    // Para entrada A da ULA
    output reg [31:0] ex_read_data_2,    // Para mux da entrada B da ULA
    output reg [31:0] ex_imm_data,       // Para mux da ULA e shift left
    output reg [31:0] ex_pc_out,         // PC para cálculo de branch
    output reg [4:0] ex_rs1,             // Endereço rs1 (para forwarding)
    output reg [4:0] ex_rs2,             // Endereço rs2 (para forwarding)
    output reg [4:0] ex_rd               // Endereço rd (para WB)
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset/flush: zera todos os registradores
            ex_read_data_1 <= 32'b0;
            ex_read_data_2 <= 32'b0;
            ex_imm_data <= 32'b0;
            ex_pc_out <= 32'b0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rd <= 5'b0;
        end
        else if (!stall) begin
            // Registra os valores normalmente
            ex_read_data_1 <= id_read_data_1;
            ex_read_data_2 <= id_read_data_2;
            ex_imm_data <= id_imm_data;
            ex_pc_out <= id_pc_out;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_rd <= id_rd;
        end
        // Se stall, mantém os valores atuais
    end

endmodule