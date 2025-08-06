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

    // Sinais de controle da control_unit
    input wire id_ALUSrc,                // Controle do mux da ULA
    input wire [1:0] id_ALUOp,           // Controle da operação da ULA
    input wire id_Branch,                // Sinal de branch
    input wire id_MemRead,               // Sinal de leitura de memória
    input wire id_MemWrite,              // Sinal de escrita em memória
    input wire id_RegWrite,              // Sinal de escrita no banco de registradores
    input wire id_MemtoReg,              // Controle do mux WB (memória ou ULA para registrador)

    // Saídas para o estágio EX
    output reg [31:0] ex_read_data_1,    // Para entrada A da ULA
    output reg [31:0] ex_read_data_2,    // Para mux da entrada B da ULA
    output reg [31:0] ex_imm_data,       // Para mux da ULA e shift left
    output reg [31:0] ex_pc_out,         // PC para cálculo de branch
    output reg [4:0] ex_rs1,             // Endereço rs1 (para forwarding)
    output reg [4:0] ex_rs2,             // Endereço rs2 (para forwarding)
    output reg [4:0] ex_rd,              // Endereço rd (para WB)

    // Sinais de controle para os estágios EX/MEM/WB
    output reg ex_ALUSrc,                // Sinal de controle ALUSrc
    output reg [1:0] ex_ALUOp,           // Sinal de controle ALUOp
    output reg ex_Branch,                // Para estágio MEM (controle de branch)
    output reg ex_MemRead,               // Para estágio MEM (leitura de memória)
    output reg ex_MemWrite,              // Para estágio MEM (escrita em memória)
    output reg ex_RegWrite,              // Para estágio WB (escrita em registrador)
    output reg ex_MemtoReg               // Para estágio WB (seleção de dado para registrador)
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
            
            // Zera todos os sinais de controle
            ex_ALUSrc <= 1'b0;
            ex_ALUOp <= 2'b0;
            ex_Branch <= 1'b0;
            ex_MemRead <= 1'b0;
            ex_MemWrite <= 1'b0;
            ex_RegWrite <= 1'b0;
            ex_MemtoReg <= 1'b0;
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
            
            // Passa os sinais de controle
            ex_ALUSrc <= id_ALUSrc;
            ex_ALUOp <= id_ALUOp;
            ex_Branch <= id_Branch;
            ex_MemRead <= id_MemRead;
            ex_MemWrite <= id_MemWrite;
            ex_RegWrite <= id_RegWrite;
            ex_MemtoReg <= id_MemtoReg;
        end
        // Se stall, mantém os valores atuais (não precisa de else explícito)
    end

endmodule