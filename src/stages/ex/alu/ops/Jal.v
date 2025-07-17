// Jal.v
// Implementa JAL: PC + offset (relativo), salva PC+4 em rd

module Jal (
    input  wire [31:0] pc,       // PC atual
    input  wire [31:0] imm,      // Offset imediato (sign-extend)
    output wire [31:0] jump_addr,// Endereço do salto: pc + imm
    output wire [31:0] link      // Valor a ser salvo em rd: pc + 4
);

    assign jump_addr = pc + imm;
    assign link = pc + 32'd4;

endmodule
