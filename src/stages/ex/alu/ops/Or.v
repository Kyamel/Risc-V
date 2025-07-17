// Or.v
// Módulo para operação OR bit a bit entre rs1 e rs2
module Or (
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    output wire [31:0] result
);

    assign result = rs1 | rs2;

endmodule
