// ========== MÓDULO ALU ==========
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_control,
    output reg [31:0] result,
    output wire zero
);

// Definições das operações ALU
localparam [3:0] ALU_ADD  = 4'b0000;
localparam [3:0] ALU_SUB  = 4'b0001;
localparam [3:0] ALU_AND  = 4'b0010;
localparam [3:0] ALU_OR   = 4'b0011;
localparam [3:0] ALU_XOR  = 4'b0100;
localparam [3:0] ALU_SLL  = 4'b0101;
localparam [3:0] ALU_SRL  = 4'b0110;
localparam [3:0] ALU_SRA  = 4'b0111;
localparam [3:0] ALU_SLT  = 4'b1000;
localparam [3:0] ALU_SLTU = 4'b1001;
localparam [3:0] ALU_LUI  = 4'b1010;

always @(*) begin
    case (alu_control)
        ALU_ADD:  result = a + b;
        ALU_SUB:  result = a - b;
        ALU_AND:  result = a & b;
        ALU_OR:   result = a | b;
        ALU_XOR:  result = a ^ b;
        ALU_SLL:  result = a << b[4:0];     // Shift left logical
        ALU_SRL:  result = a >> b[4:0];     // Shift right logical
        ALU_SRA:  result = $signed(a) >>> b[4:0]; // Shift right arithmetic
        ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
        ALU_LUI:  result = b;               // Load Upper Immediate
        default:  result = 32'd0;
    endcase
end

assign zero = (result == 32'd0);

endmodule
