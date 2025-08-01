`timescale 1ns / 1ps
`include "constants.v"

module register_file #(
    parameter WIDTH = 32,  // Largura do registrador (32 bits)
    parameter DEPTH = 32   // Número de registradores (x0-x31)
)(
    input wire clk,
    input wire reset,
    
    // Interface de leitura
    input wire [4:0] rs1_addr,  // Endereço do registrador fonte 1
    input wire [4:0] rs2_addr,  // Endereço do registrador fonte 2
    output reg [31:0] rs1_data, // Dado do registrador 1
    output reg [31:0] rs2_data, // Dado do registrador 2
    
    // Interface de escrita
    input wire [4:0] rd_addr,   // Endereço do registrador destino
    input wire [31:0] rd_data,  // Dado a ser escrito
    input wire reg_write,       // Controle de escrita
    
    // Interface de debug
    output wire [31:0] debug_registers [0:DEPTH-1]
);

    // Banco de registradores (x0 é hardwired para zero)
    reg [31:0] regs [1:DEPTH-1];  // Índices 1 a 15 (x1-x15)

    // Conexão de debug - inclui x0 que sempre vale 0
    assign debug_registers[0] = 32'b0;
    generate
        for (genvar i = 1; i < DEPTH; i++) begin
            assign debug_registers[i] = regs[i];
        end
    endgenerate

    // Escrita síncrona
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset assíncrono - limpa todos os registradores
            for (int i = 1; i < DEPTH; i++) begin
                regs[i] <= 32'b0;
            end
        end else if (reg_write && (rd_addr != 5'b0)) begin
            // Escrita apenas se reg_write=1 e não for x0
            // Usa apenas os 4 LSBs para RV32E (ignora bit mais significativo)
            regs[rd_addr[3:0]] <= rd_data;
        end
    end

    // Leitura combinacional com forwarding
    always @(*) begin
        // Leitura rs1_data
        if (rs1_addr == 5'b0) begin
            rs1_data = 32'b0;  // x0 sempre vale 0
        end else if ((rs1_addr == rd_addr) && reg_write && (rd_addr != 5'b0)) begin
            rs1_data = rd_data;  // Forwarding do dado sendo escrito
        end else begin
            rs1_data = regs[rs1_addr[3:0]];  // Lê do banco de registradores
        end
        
        // Leitura rs2_data (mesma lógica)
        if (rs2_addr == 5'b0) begin
            rs2_data = 32'b0;
        end else if ((rs2_addr == rd_addr) && reg_write && (rd_addr != 5'b0)) begin
            rs2_data = rd_data;
        end else begin
            rs2_data = regs[rs2_addr[3:0]];
        end
    end

endmodule
