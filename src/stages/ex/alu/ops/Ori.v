// Ori.v
// Wrapper para operação OR com imediato
module Ori (
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    output wire [31:0] result
);

    Or or_inst (
        .rs1(rs1),
        .rs2(imm),
        .result(result)
    );

endmodule
