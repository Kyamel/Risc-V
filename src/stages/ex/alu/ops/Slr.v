// Srl.v
// Módulo para operação Shift Right Logical (deslocamento lógico à direita)
// Desloca rs1 à direita pelo valor rs2[4:0]
module Srl (
    input  wire [31:0] rs1,
    input  wire [4:0]  rs2,     // Shift amount (5 bits)
    output wire [31:0] result
);

    assign result = rs1 >> rs2;

endmodule
