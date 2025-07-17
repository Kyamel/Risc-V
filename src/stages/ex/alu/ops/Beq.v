// Beq.v
// Módulo que indica se rs1 == rs2 (branch taken) para instrução BEQ
module Beq (
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    output wire        branch_taken
);

    wire [31:0] xor_result;

    assign xor_result = rs1 ^ rs2;         // Bitwise XOR entre rs1 e rs2
    assign branch_taken = ~(|xor_result);  // OR reduzido negado: 1 se todos bits iguais

endmodule
