`timescale 1ns / 1ps
`include "core/constants.v"

module ex_stage (
    input wire clk,
    input wire reset,
    
    // Entradas do registro ID/EX
    input wire [31:0] id_ex_pc,
    input wire [31:0] id_ex_instruction,
    input wire [31:0] id_ex_rs1_data,
    input wire [31:0] id_ex_rs2_data,
    input wire [31:0] id_ex_immediate,
    input wire [4:0] id_ex_rd_addr,
    input wire [4:0] id_ex_rs1_addr,
    input wire [4:0] id_ex_rs2_addr,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals,
    input wire id_ex_valid,
    
    // Sinais de forwarding
    input wire [1:0] forward_a,
    input wire [1:0] forward_b,
    input wire [31:0] mem_wb_alu_result,  // Dado do estágio MEM
    input wire [31:0] mem_wb_mem_data,    // Dado do estágio WB
    
    // Registro EX/MEM
    output reg [31:0] ex_mem_pc,
    output reg [31:0] ex_mem_alu_result,
    output reg [31:0] ex_mem_rs2_data,
    output reg [4:0] ex_mem_rd_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals,
    output reg ex_mem_valid,
    
    // Sinais para forwarding e branch
    output wire [31:0] ex_mem_alu_result_fwd, // Para forwarding
    output wire branch_taken,                 // Para estágio IF
    output wire [31:0] branch_target          // Para estágio IF
);

    // Decodificação dos sinais de controle
    wire reg_write = id_ex_control_signals[`CTRL_REG_WRITE];
    wire mem_to_reg = id_ex_control_signals[`CTRL_MEM_TO_REG];
    wire mem_read = id_ex_control_signals[`CTRL_MEM_READ];
    wire mem_write = id_ex_control_signals[`CTRL_MEM_WRITE];
    wire branch = id_ex_control_signals[`CTRL_BRANCH];
    wire jump = id_ex_control_signals[`CTRL_JUMP];
    wire alu_src = id_ex_control_signals[`CTRL_ALU_SRC];
    wire [3:0] alu_op = id_ex_control_signals[`CTRL_ALU_OP];
    
    // Sinais internos
    wire [31:0] alu_input_a, alu_input_b;
    reg [31:0] forwarded_rs1, forwarded_rs2;
    wire alu_zero;
    wire [31:0] pc_plus4 = id_ex_pc + 32'd4;
    wire [2:0] branch_type = id_ex_instruction[14:12]; // funct3
    reg branch_condition_met;

    // ========== UNIDADE DE FORWARDING ==========
    always @(*) begin
        // Forwarding para rs1
        case (forward_a)
            2'b00: forwarded_rs1 = id_ex_rs1_data;       // Sem forwarding
            2'b01: forwarded_rs1 = mem_wb_mem_data;      // Forward do WB
            2'b10: forwarded_rs1 = mem_wb_alu_result;    // Forward do MEM
            default: forwarded_rs1 = id_ex_rs1_data;
        endcase
        
        // Forwarding para rs2
        case (forward_b)
            2'b00: forwarded_rs2 = id_ex_rs2_data;       // Sem forwarding
            2'b01: forwarded_rs2 = mem_wb_mem_data;      // Forward do WB
            2'b10: forwarded_rs2 = mem_wb_alu_result;    // Forward do MEM
            default: forwarded_rs2 = id_ex_rs2_data;
        endcase
    end

    // ========== INPUTS DA ALU ==========
    assign alu_input_a = forwarded_rs1;
    assign alu_input_b = alu_src ? id_ex_immediate : forwarded_rs2;

    // ========== INSTÂNCIA DA ALU ==========
    wire [31:0] alu_result;
    alu alu_unit (
        .a(alu_input_a),
        .b(alu_input_b),
        .alu_control(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

    // ========== RESOLUÇÃO DE BRANCHES ==========
    always @(*) begin
        branch_condition_met = 1'b0;
        if (branch) begin
            case (branch_type)
                3'b000: branch_condition_met = (forwarded_rs1 == forwarded_rs2); // BEQ
                3'b001: branch_condition_met = (forwarded_rs1 != forwarded_rs2); // BNE
                3'b100: branch_condition_met = ($signed(forwarded_rs1) < $signed(forwarded_rs2)); // BLT
                3'b101: branch_condition_met = ($signed(forwarded_rs1) >= $signed(forwarded_rs2)); // BGE
                3'b110: branch_condition_met = (forwarded_rs1 < forwarded_rs2); // BLTU
                3'b111: branch_condition_met = (forwarded_rs1 >= forwarded_rs2); // BGEU
                default: branch_condition_met = 1'b0;
            endcase
        end
    end

    assign branch_taken = (branch_condition_met || jump);
    assign branch_target = id_ex_pc + id_ex_immediate;

    // ========== REGISTRO EX/MEM ==========
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_mem_pc <= 0;
            ex_mem_alu_result <= 0;
            ex_mem_rs2_data <= 0;
            ex_mem_rd_addr <= 0;
            ex_mem_control_signals <= 0;
            ex_mem_valid <= 0;
        end else begin
            ex_mem_pc <= id_ex_pc;
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data <= forwarded_rs2;
            ex_mem_rd_addr <= id_ex_rd_addr;
            ex_mem_control_signals <= id_ex_control_signals;
            ex_mem_valid <= id_ex_valid;
        end
    end

    // Conexão para forwarding
    assign ex_mem_alu_result_fwd = alu_result;

endmodule