// ex_stage.v - Execute Stage do Pipeline RV32E
// Responsável por: ALU operations, branch resolution, forwarding

module ex_stage (
    // Inputs do pipeline register ID/EX
    input wire [31:0] pc_in,
    input wire [31:0] rs1_data_in,
    input wire [31:0] rs2_data_in,
    input wire [31:0] immediate_in,
    input wire [3:0] rs1_addr,
    input wire [3:0] rs2_addr,
    input wire [3:0] rd_addr_in,
    
    // Sinais de controle vindos do ID
    input wire [15:0] control_signals,
    
    // Sinais de forwarding
    input wire [1:0] forward_a,
    input wire [1:0] forward_b,
    input wire [31:0] mem_forward_data,  // Dado do estágio MEM
    input wire [31:0] wb_forward_data,   // Dado do estágio WB
    
    // Outputs para o próximo estágio
    output wire [31:0] alu_result,
    output wire [31:0] branch_target,
    output wire branch_taken,
    output wire [31:0] rs2_data_out,
    output wire [3:0] rd_addr_out,
    output wire [31:0] pc_plus4_out,
    
    // Sinais de controle para próximos estágios
    output wire [7:0] control_signals_out
);

// Decodificação dos sinais de controle
wire reg_write = control_signals[0];
wire mem_to_reg = control_signals[1];
wire mem_read = control_signals[2];
wire mem_write = control_signals[3];
wire branch = control_signals[4];
wire jump = control_signals[5];
wire alu_src = control_signals[6];
wire [3:0] alu_op = control_signals[10:7];
wire [2:0] imm_type = control_signals[13:11];
wire [1:0] pc_src = control_signals[15:14];

// Sinais internos
wire [31:0] alu_input_a, alu_input_b;
reg [31:0] forwarded_rs1, forwarded_rs2;
wire alu_zero;
wire [31:0] pc_plus4;
wire [2:0] branch_type;
reg branch_condition_met;

// Cálculo de PC + 4
assign pc_plus4 = pc_in + 32'd4;

// ========== UNIDADE DE FORWARDING ==========
// Multiplexador para forwarding do rs1
always @(*) begin
    case (forward_a)
        2'b00: forwarded_rs1 = rs1_data_in;      // Sem forwarding
        2'b01: forwarded_rs1 = wb_forward_data;  // Forward do WB
        2'b10: forwarded_rs1 = mem_forward_data; // Forward do MEM
        default: forwarded_rs1 = rs1_data_in;
    endcase
end

// Multiplexador para forwarding do rs2
always @(*) begin
    case (forward_b)
        2'b00: forwarded_rs2 = rs2_data_in;      // Sem forwarding
        2'b01: forwarded_rs2 = wb_forward_data;  // Forward do WB
        2'b10: forwarded_rs2 = mem_forward_data; // Forward do MEM
        default: forwarded_rs2 = rs2_data_in;
    endcase
end

// ========== INPUTS DA ALU ==========
assign alu_input_a = forwarded_rs1;
assign alu_input_b = alu_src ? immediate_in : forwarded_rs2;

// ========== INSTÂNCIA DA ALU ==========
alu alu_unit (
    .a(alu_input_a),
    .b(alu_input_b),
    .alu_control(alu_op),
    .result(alu_result),
    .zero(alu_zero)
);

// ========== GERAÇÃO DE ENDEREÇO DE BRANCH ==========
assign branch_target = pc_in + immediate_in;

// ========== RESOLUÇÃO DE BRANCHES ==========
// Extração do tipo de branch dos bits de controle
assign branch_type = immediate_in[14:12]; // funct3 field para branches

// Lógica de resolução de branch
always @(*) begin
    branch_condition_met = 1'b0;
    
    if (branch) begin
        case (branch_type)
            3'b000: // BEQ
                branch_condition_met = (forwarded_rs1 == forwarded_rs2);
            3'b001: // BNE
                branch_condition_met = (forwarded_rs1 != forwarded_rs2);
            3'b100: // BLT
                branch_condition_met = ($signed(forwarded_rs1) < $signed(forwarded_rs2));
            3'b101: // BGE
                branch_condition_met = ($signed(forwarded_rs1) >= $signed(forwarded_rs2));
            3'b110: // BLTU
                branch_condition_met = (forwarded_rs1 < forwarded_rs2);
            3'b111: // BGEU
                branch_condition_met = (forwarded_rs1 >= forwarded_rs2);
            default:
                branch_condition_met = 1'b0;
        endcase
    end
end

// Branch taken final
assign branch_taken = branch_condition_met || jump;

// ========== OUTPUTS ==========
assign rs2_data_out = forwarded_rs2;
assign rd_addr_out = rd_addr_in;
assign pc_plus4_out = pc_plus4;

// Passagem dos sinais de controle para os próximos estágios
// Apenas os sinais necessários para MEM e WB
assign control_signals_out = {
    reg_write,      // [0] - Precisamos no WB
    mem_to_reg,     // [1] - Precisamos no WB
    mem_read,       // [2] - Precisamos no MEM
    mem_write,      // [3] - Precisamos no MEM
    4'b0000         // [7:4] - Reservado
};

endmodule


