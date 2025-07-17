module InstructionDecoder (
    input  [31:0] instr,
    output [6:0]  opcode,
    output [2:0]  funct3,
    output [6:0]  funct7,
    output [4:0]  rd,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output reg [31:0] imm,
    output reg [2:0]  instr_type // 3'b000 = R, 001 = I, 010 = S, 011 = B, 100 = U, 101 = J
);

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    always @(*) begin
        case (opcode)
            7'b0110011: instr_type = 3'b000; // R-type
            7'b0010011,
            7'b0000011,
            7'b1100111: instr_type = 3'b001; // I-type
            7'b0100011: instr_type = 3'b010; // S-type
            7'b1100011: instr_type = 3'b011; // B-type
            7'b0110111,
            7'b0010111: instr_type = 3'b100; // U-type
            7'b1101111: instr_type = 3'b101; // J-type
            default:    instr_type = 3'b111; // invalid
        endcase
    end

    always @(*) begin
        case (instr_type)
            3'b001: imm = {{20{instr[31]}}, instr[31:20]}; // I
            3'b010: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S
            3'b011: imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B
            3'b100: imm = {instr[31:12], 12'b0}; // U
            3'b101: imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J
            default: imm = 32'b0;
        endcase
    end

endmodule
