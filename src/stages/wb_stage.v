`include "constants.v"

module wb_stage (
    // Entradas do estágio MEM
    input wire [31:0] mem_alu_result,
    input wire [31:0] mem_mem_data,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_control_signals,
    
    // Saída para o banco de registradores
    output reg [31:0] wb_data
);

    // Extrair sinais de controle relevantes
    wire mem_to_reg = mem_control_signals[`MEM_TO_REG];
    wire reg_write = mem_control_signals[`REG_WRITE];

    always @(*) begin
        case (mem_to_reg)
            1'b0:    wb_data = mem_alu_result;  // Resultado da ALU
            1'b1:    wb_data = mem_mem_data;    // Dado lido da memória
            default: wb_data = 32'b0;
        endcase
    end

    // O sinal reg_write é passado diretamente para o banco de registradores
    // e não precisa de tratamento adicional neste módulo

endmodule