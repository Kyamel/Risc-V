`timescale 1ns / 1ps

module pc_generator (
    input wire clk,
    input wire reset,

    // Controle de desvio
    input wire stall,
    input wire flush,
    input wire [31:0] new_pc,

    // Saída
    output reg [31:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'h00000000;
        end else if (!stall) begin
            if (flush)
                pc_out <= new_pc;
            else
                pc_out <= pc_out + 4;
        end
        // Se houver stall, o PC se mantém
    end

endmodule
