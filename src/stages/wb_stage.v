`timescale 1ns / 1ps
`include "constants.v"

module wb_stage (
    // Entradas do registro MEM/WB
    input wire [31:0] mem_wb_alu_result,
    input wire [31:0] mem_wb_mem_data,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals,
    
    // Saída para o banco de registradores
    output reg [31:0] wb_data
);

    // Extrair sinais de controle relevantes (usando macros com CTRL_)
    wire mem_to_reg = mem_wb_control_signals[`CTRL_MEM_TO_REG];
    wire reg_write = mem_wb_control_signals[`CTRL_REG_WRITE];

    // Lógica de seleção do dado para writeback
    always @(*) begin
        case (mem_to_reg)
            1'b0:    wb_data = mem_wb_alu_result;  // Resultado da ALU
            1'b1:    wb_data = mem_wb_mem_data;    // Dado lido da memória
            default: wb_data = 32'b0;
        endcase
    end

endmodule