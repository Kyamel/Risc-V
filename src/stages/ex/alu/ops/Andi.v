// Andi.v
// Wrapper para operação AND com imediato
module Andi (
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    output wire [31:0] result
);

    And and_inst (
        .rs1(rs1),
        .rs2(imm),
        .result(result)
    );

endmodule
