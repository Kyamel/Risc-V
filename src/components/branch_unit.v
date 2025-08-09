module branch_unit(
    input  wire        branch,        // sinal de controle: é branch?
    input  wire [2:0]  funct3,        // tipo de branch
    input  wire [31:0] rs1_val,       // valor do registrador rs1
    input  wire [31:0] rs2_val,       // valor do registrador rs2
    input  wire [31:0] pc,            // PC atual
    input  wire [31:0] imm,           // imediato já estendido
    output reg         branch_taken,  // 1 se deve tomar o branch
    output reg [31:0]  branch_target  // endereço destino
);

always @(*) begin
    branch_taken = 1'b0;
    branch_target = pc + imm;

    if (branch) begin
        case (funct3)
            3'b000: branch_taken = (rs1_val == rs2_val);                       // BEQ
            3'b001: branch_taken = (rs1_val != rs2_val);                       // BNE
            3'b100: branch_taken = ($signed(rs1_val) < $signed(rs2_val));      // BLT
            3'b101: branch_taken = ($signed(rs1_val) >= $signed(rs2_val));     // BGE
            3'b110: branch_taken = (rs1_val < rs2_val);                        // BLTU
            3'b111: branch_taken = (rs1_val >= rs2_val);                       // BGEU
            default: branch_taken = 1'b0;
        endcase
    end
end

endmodule
