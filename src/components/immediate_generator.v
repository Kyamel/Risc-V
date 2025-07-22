// src/components/immediate_generator.v
module immediate_generator (
    input  [31:0] instr,
    output reg [31:0] imm_out
);

    wire [6:0] opcode;
    assign opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            // I-type (ADDI, LW, etc.)
            7'b0000011,  // LW
            7'b0010011,  // ADDI
            7'b1100111:  // JALR
                imm_out = {{20{instr[31]}}, instr[31:20]};

            // S-type (SW, etc.)
            7'b0100011:  // SW
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // B-type (BEQ, etc.)
            7'b1100011:  // BEQ
                imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            // U-type (LUI, AUIPC)
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
                imm_out = {instr[31:12], 12'b0};

            // J-type (JAL)
            7'b1101111:  // JAL
                imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

            default:
                imm_out = 32'b0;
        endcase
    end

endmodule
