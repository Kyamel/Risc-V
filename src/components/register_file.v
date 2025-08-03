`timescale 1ns / 1ps

module register_file #(
    parameter WIDTH = 32,
    parameter DEPTH = 32
)(
    input wire                  clk,
    input wire                  rst,  // Opcional, não usado aqui

    // Entradas de leitura (do instr_parser)
    input wire [4:0]            rs1,
    input wire [4:0]            rs2,

    // Entrada de escrita (do estágio MEM/WB)
    input wire [4:0]            rd,
    input wire [WIDTH-1:0]      wd,
    input wire                  reg_write,

    // Saídas de leitura (para o ID/EX)
    output wire [WIDTH-1:0]     read_data_1,
    output wire [WIDTH-1:0]     read_data_2,

    // Debug (leitura de qualquer registrador por índice)
    input wire [$clog2(DEPTH)-1:0] debug_read_index,
    output wire [WIDTH-1:0]        debug_data_out
);

    // Registradores (x0 até x31)
    reg [WIDTH-1:0] regs [0:DEPTH-1];

    // Escrita síncrona
    always @(posedge clk) begin
        if (reg_write && rd != 5'd0) begin
            regs[rd] <= wd;
        end
    end

    // Leituras assíncronas
    assign read_data_1 = regs[rs1];
    assign read_data_2 = regs[rs2];

    // Leitura de registrador para debug
    assign debug_data_out = regs[debug_read_index];

endmodule
