`timescale 1ns / 1ps
`include "constants.v"

module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32   // x0-x31
)(
    input wire clk,
    input wire reset,
    
    // Interface de leitura
    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    output reg [WIDTH-1:0] rs1_data,
    output reg [WIDTH-1:0] rs2_data,
    
    // Interface de escrita
    input wire [4:0] rd_addr,
    input wire [WIDTH-1:0] rd_data,
    input wire reg_write,
    
    // Debug
    output wire [WIDTH-1:0] debug_registers [0:DEPTH-1]
);

    // Banco de registradores (x0 não é armazenado, é hardwired para zero)
    reg [WIDTH-1:0] regs [1:DEPTH-1];

    // Conexão de debug
    assign debug_registers[0] = '0;  // x0 sempre zero
    generate
        for (genvar i = 1; i < DEPTH; i++) begin
            assign debug_registers[i] = regs[i];
        end
    endgenerate

    // Escrita síncrona
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset assíncrono
            for (int i = 1; i < DEPTH; i++) begin
                regs[i] <= '0;
            end
        end else if (reg_write && rd_addr != '0) begin
            regs[rd_addr] <= rd_data;  // Usa todos os 5 bits do endereço
        end
    end

    // Leitura combinacional com forwarding
    always @(*) begin
        // Forwarding condicional para rs1
        rs1_data = (rs1_addr == '0) ? '0 :
                  ((reg_write && (rs1_addr == rd_addr)) ? rd_data :
                  regs[rs1_addr]);

        // Forwarding condicional para rs2
        rs2_data = (rs2_addr == '0) ? '0 :
                  ((reg_write && (rs2_addr == rd_addr)) ? rd_data :
                  regs[rs2_addr]);
    end

endmodule