`timescale 1ns / 1ps

module immediate_data_extractor (
    input wire [31:0] instr,      // Instrução vinda do estágio IF/ID
    output reg [31:0] imm_data     // Valor imediato extraído
);

    always @(*) begin
        case (instr[6:0])  // Baseado no opcode
            // I-Type
            7'b0000011, 7'b0010011:
                imm_data = {{20{instr[31]}}, instr[31:20]};

            // S-Type
            7'b0100011:
                imm_data = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // B-Type
            7'b1100011:
                imm_data = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            // U-Type
            7'b0110111, 7'b0010111:
                imm_data = {instr[31:12], 12'b0};

            // J-Type
            7'b1101111:
                imm_data = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

            default:
                imm_data = 32'b0;
        endcase
    end

endmodule
