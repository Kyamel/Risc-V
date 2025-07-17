// Addi.v
module Addi (
    input  wire [31:0] rs1,
    input  wire [31:0] imm,
    output wire [31:0] result
);
    wire [31:0] unused_rs2;  // Não usado

    // Instancia o Add "base"
    Add add_inst (
        .rs1(rs1),
        .rs2(imm),
        .result(result)
    );
endmodule
