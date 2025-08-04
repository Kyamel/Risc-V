`timescale 1ns / 1ps
`include "alu_defines.vh"

module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] ALUOp,
    output reg [31:0] Result,
    output wire Zero
);

always @(*) begin
    case (ALUOp)
        `ALU_ADD:  Result = a + b;
        `ALU_SUB:  Result = a - b;
        `ALU_SLL:  Result = a << b[4:0];
        `ALU_SLT:  Result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        `ALU_SLTU: Result = (a < b) ? 32'd1 : 32'd0;
        `ALU_XOR:  Result = a ^ b;
        `ALU_SRL:  Result = a >> b[4:0];
        `ALU_SRA:  Result = $signed(a) >>> b[4:0];
        `ALU_OR:   Result = a | b;
        `ALU_AND:  Result = a & b;
        `ALU_LUI:  Result = b;
        default:   Result = 32'd0;
    endcase
end

assign Zero = (Result == 32'd0);

endmodule