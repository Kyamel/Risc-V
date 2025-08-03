`timescale 1ns / 1ps

module if_id (
    input wire         clk,
    input wire         rst,

    // Controle
    input wire         stall,
    input wire         flush,

    // Entradas do estágio IF
    input wire [31:0]  pc_in,      // PC atual vindo do IF
    input wire [31:0]  instr_in,   // Instrução da memória de instruções

    // Saídas para o estágio ID
    output reg [31:0]  pc_out,        // PC passado para o ID/EX
    output reg [31:0]  instr_out      // Instrução passada para os módulos de ID
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (flush) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else if (!stall) begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
        // Quando stall está ativo, mantemos os valores anteriores
    end

endmodule
