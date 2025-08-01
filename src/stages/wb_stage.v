`timescale 1ns / 1ps
`include "constants.v"

module wb_stage (
    // Entradas do registro MEM/WB
    input wire [31:0] mem_wb_alu_result,
    input wire [31:0] mem_wb_mem_data,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals,
    
    // Saída de dados para o banco de registradores
    output wire [31:0] wb_data
);

    // Extrair sinal de controle mem_to_reg
    wire mem_to_reg = mem_wb_control_signals[`CTRL_MEM_TO_REG];
    
    // Lógica de seleção do dado
    assign wb_data = mem_to_reg ? mem_wb_mem_data : mem_wb_alu_result;

endmodule
