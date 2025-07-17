// Lw.v
// Calcula o endereço para load/store: rs1 + offset (imediato)
module Lw (
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    output wire [31:0] address
);

    assign address = rs1 + imm;

endmodule
