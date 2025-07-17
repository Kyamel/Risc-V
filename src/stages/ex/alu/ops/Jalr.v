// Jalr.v
// Implementa JALR: Salta para (rs1 + imm) alinhado, salva PC+4 em rd

module Jalr (
    input  wire [31:0] pc,        // PC atual
    input  wire [31:0] rs1,       // Registrador base
    input  wire [31:0] imm,       // Offset imediato (sign-extend)
    output wire [31:0] jump_addr, // Endereço do salto: (rs1 + imm) & ~1
    output wire [31:0] link       // Valor a ser salvo em rd: pc + 4
);

    wire [31:0] addr_raw;

    assign addr_raw = rs1 + imm;
    assign jump_addr = {addr_raw[31:1], 1'b0}; // Clear bit 0 para alinhamento
    assign link = pc + 32'd4;

endmodule
