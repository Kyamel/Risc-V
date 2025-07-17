// Sw.v
// Calcula o endereço para store: rs1 + offset (imediato)
module Sw (
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    output wire [31:0] address
);

    assign address = rs1 + imm;

endmodule
