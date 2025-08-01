module immediate_generator (
    input wire [31:0] instr,
    output reg [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            // I-type (ADDI, LW, JALR)
            7'b0010011, 7'b0000011, 7'b1100111:
                imm_out = {{20{instr[31]}}, instr[31:20]};  // Sign-extended 12-bit
            
            // S-type (SW)
            7'b0100011:
                // S-type: imm[11:0] = {instr[31:25], instr[11:7]}
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // Sign-extended 12-bit
            
            // B-type (BEQ, BNE, etc.)
            //7'b1100011:
                // B-type: imm[12:1] = {instr[31], instr[7], instr[30:25], instr[11:8]}
                // The immediate is {imm[12], imm[10:5], imm[4:1], imm[11], 1'b0}
            //imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            7'b1100011:// B-type (branch)
                imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            
            
            // U-type (LUI, AUIPC)
            7'b0110111, 7'b0010111:
                imm_out = {instr[31:12], 12'b0};  // 20-bit upper immediate
            
            // J-type (JAL)
            7'b1101111:
                // J-type: imm[20:1] = {instr[31], instr[19:12], instr[20], instr[30:21]}
                // The immediate is {imm[20], imm[10:1], imm[11], imm[19:12], 1'b0}
                imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            
            default:
                imm_out = 32'b0;
        endcase
    end
endmodule
