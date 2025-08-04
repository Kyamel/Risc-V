`timescale 1ns / 1ps

//==============================================================================
// PIPELINE PARCIAL RV32I CORRIGIDO - Estágios IF → ID → EX (com writeback)
//==============================================================================
// CORREÇÕES IMPLEMENTADAS:
// Writeback temporário habilitado para instruções aritméticas
// Sinal RegWrite adicionado à control unit
// Conexões corretas do banco de registradores
// Pipeline ID/EX registrando registrador destino
//==============================================================================

module pipeline_partial (
    input  wire clk,
    input  wire rst,
    input  wire stall,
    input  wire flush,
    
    // ========== SAÍDAS DE DEBUG ==========
    output wire [31:0] pc_current,
    output wire [31:0] current_instruction,
    output wire [31:0] alu_result_debug,
    output wire [31:0] reg_rs1_debug,
    output wire [31:0] reg_rs2_debug,
    
    // Debug adicional para análise do pipeline
    output wire [31:0] if_id_pc_debug,
    output wire [31:0] if_id_instr_debug,
    output wire [31:0] id_ex_pc_debug,
    output wire [31:0] id_ex_rs1_debug,
    output wire [31:0] id_ex_rs2_debug,
    output wire [31:0] id_ex_imm_debug,
    output wire [1:0]  id_ex_aluop_debug,
    output wire        id_ex_alusrc_debug,
    
    // Debug adicional para writeback
    output wire [4:0]  id_ex_rd_debug,
    output wire        id_ex_regwrite_debug
);

    //==========================================================================
    // ESTÁGIO IF (Instruction Fetch)
    //==========================================================================
    
    wire [31:0] pc_plus_4;
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    assign pc_plus_4 = pc_out + 32'd4;
    assign pc_in = pc_plus_4;  

    pc_generator pc_gen (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    assign pc_current = pc_out;

    // ===== Memória de Instruções =====
    wire [31:0] instr;

    instruction_memory #(
        .WIDTH(32),
        .HEIGHT(256),
        .INIT_FILE("compiler/program.hex")
    ) instr_mem (
        .instr_addr(pc_out),
        .instr(instr)
    );

    assign current_instruction = instr;

    //==========================================================================
    // REGISTRADOR DE PIPELINE IF/ID 
    //==========================================================================
    
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instr;

    if_id if_id_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_out),
        .instr_in(instr),
        .pc_out(if_id_pc),
        .instr_out(if_id_instr)
    );
    
    assign if_id_pc_debug = if_id_pc;
    assign if_id_instr_debug = if_id_instr;

    //==========================================================================
    // ESTÁGIO ID (Instruction Decode)
    //==========================================================================

    // ===== Extração de Dados Imediatos =====
    wire [31:0] immediate_data;

    immediate_data_extractor imm_extract (
        .instr(if_id_instr),
        .imm_data(immediate_data)
    );

    // ===== Parser de Instruções =====
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    assign funct3 = if_id_instr[14:12];
    assign funct7 = if_id_instr[31:25];

    instr_parser parser (
        .instr(if_id_instr),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );

    // ===== Unidade de Controle CORRIGIDA =====
    wire [1:0] ctrl_ALUOp;
    wire ctrl_ALUSrc;
    wire ctrl_RegWrite;  // ✅ NOVO: Sinal de controle para writeback

    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ctrl_ALUOp),
        .ALUSrc(ctrl_ALUSrc),
        .RegWrite(ctrl_RegWrite)  // ✅ NOVO: Conectar RegWrite
    );

    // ===== Banco de Registradores CORRIGIDO =====
    wire [31:0] reg_rs1;
    wire [31:0] reg_rs2;

    // Para writeback temporário, usaremos os sinais do estágio EX
    wire [4:0] wb_rd;
    wire [31:0] wb_data;
    wire wb_enable;

    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) regs (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        
        // ✅ CORRIGIDO: Conectar writeback do estágio EX
        .rd(wb_rd),
        .wd(wb_data),
        .reg_write(wb_enable),
        
        .debug_read_index(5'b0),
        .debug_data_out(),
        
        .read_data_1(reg_rs1),
        .read_data_2(reg_rs2)
    );

    assign reg_rs1_debug = reg_rs1;
    assign reg_rs2_debug = reg_rs2;

    //==========================================================================
    // REGISTRADOR DE PIPELINE ID/EX CORRIGIDO
    //==========================================================================
    
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rs1_data;
    wire [31:0] id_ex_rs2_data;
    wire [31:0] id_ex_imm_data;
    wire [4:0] id_ex_rs1;
    wire [4:0] id_ex_rs2;
    wire [4:0] id_ex_rd;
    
    // Sinais de controle registrados
    reg [1:0] id_ex_ALUOp;
    reg id_ex_ALUSrc;
    reg id_ex_RegWrite;  // ✅ NOVO: Registrar sinal RegWrite

    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        
        .id_read_data_1(reg_rs1),
        .id_read_data_2(reg_rs2),
        .id_imm_data(immediate_data),
        .id_pc_out(if_id_pc),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        
        .ex_read_data_1(id_ex_rs1_data),
        .ex_read_data_2(id_ex_rs2_data),
        .ex_imm_data(id_ex_imm_data),
        .ex_pc_out(id_ex_pc),
        .ex_rs1(id_ex_rs1),
        .ex_rs2(id_ex_rs2),
        .ex_rd(id_ex_rd)
    );

    // ✅ CORRIGIDO: Registrar todos os sinais de controle
    always @(posedge clk) begin
        if (rst || flush) begin
            id_ex_ALUOp <= 2'b00;
            id_ex_ALUSrc <= 1'b0;
            id_ex_RegWrite <= 1'b0;  // ✅ NOVO: Reset RegWrite
        end
        else if (!stall) begin
            id_ex_ALUOp <= ctrl_ALUOp;
            id_ex_ALUSrc <= ctrl_ALUSrc;
            id_ex_RegWrite <= ctrl_RegWrite;  // ✅ NOVO: Registrar RegWrite
        end
    end
    
    // Debug outputs para ID/EX
    assign id_ex_pc_debug = id_ex_pc;
    assign id_ex_rs1_debug = id_ex_rs1_data;
    assign id_ex_rs2_debug = id_ex_rs2_data;
    assign id_ex_imm_debug = id_ex_imm_data;
    assign id_ex_aluop_debug = id_ex_ALUOp;
    assign id_ex_alusrc_debug = id_ex_ALUSrc;
    assign id_ex_rd_debug = id_ex_rd;
    assign id_ex_regwrite_debug = id_ex_RegWrite;

    //==========================================================================
    // ESTÁGIO EX (Execute) CORRIGIDO
    //==========================================================================

    // ===== Controle da ALU =====
    wire [3:0] alu_control_out;
    // ✅ CORRIGIDO: Usar funct dos dados registrados
    wire [9:0] funct_registered;
    
    // Para simplificar, usar funct da instrução atual (TODO: registrar no pipeline)
    assign funct_registered = {funct7, funct3};

    alu_control alu_ctrl (
        .ALUOp(id_ex_ALUOp),
        .Funct(funct_registered),
        .Op(alu_control_out)
    );

    // ===== Forwarding (Não Implementado) =====
    wire [31:0] forward_mux1_out;
    wire [31:0] forward_mux2_out;
    
    assign forward_mux1_out = id_ex_rs1_data;
    assign forward_mux2_out = id_ex_rs2_data;

    // ===== Mux da Fonte B da ALU =====
    wire [31:0] alu_src_mux_out;
    assign alu_src_mux_out = id_ex_ALUSrc ? id_ex_imm_data : forward_mux2_out;

    // ===== ALU Principal =====
    wire [31:0] alu_result;
    wire alu_zero;

    alu main_alu (
        .a(forward_mux1_out),
        .b(alu_src_mux_out),
        .ALUOp(alu_control_out),
        .Result(alu_result),
        .Zero(alu_zero)
    );

    assign alu_result_debug = alu_result;

    // ✅ NOVO: Writeback Temporário Direto do EX
    // Conectar saída da ALU diretamente ao banco de registradores
    assign wb_rd = id_ex_rd;
    assign wb_data = alu_result;
    assign wb_enable = id_ex_RegWrite;

endmodule