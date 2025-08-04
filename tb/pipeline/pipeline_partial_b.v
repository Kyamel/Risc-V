`timescale 1ns / 1ps

//==============================================================================
// PIPELINE PARCIAL RV32I - Estágios IF → ID → EX
//==============================================================================
// Este módulo implementa os primeiros 3 estágios do pipeline RISC-V:
// - IF (Instruction Fetch): Busca da instrução na memória
// - ID (Instruction Decode): Decodificação e leitura dos registradores
// - EX (Execute): Execução na ALU
// 
// FUNCIONALIDADES IMPLEMENTADAS:
// ✓ Busca sequencial de instruções (PC = PC + 4)
// ✓ Decodificação completa de instruções RISC-V
// ✓ Extração de dados imediatos
// ✓ Geração de sinais de controle básicos
// ✓ Execução de operações aritméticas e lógicas na ALU
// ✓ Registradores de pipeline IF/ID e ID/EX
// 
// FUNCIONALIDADES NÃO IMPLEMENTADAS (para versões futuras):
// ⚠ Forwarding (marcado com TODO_FORWARDING)
// ⚠ Hazard Detection (marcado com TODO_HAZARD)
// ⚠ Branch/Jump (marcado com TODO_BRANCH)  
// ⚠ Memory Access - Load/Store (marcado com TODO_MEMORY)
// ⚠ Write Back completo (marcado com TODO_WRITEBACK)
// ⚠ Sinais de controle MEM/WB (marcado com TODO_CONTROL)
//==============================================================================

module pipeline_partial (
    input  wire clk,
    input  wire rst,
    input  wire stall,    // TODO_HAZARD: Conectar com hazard detection unit
    input  wire flush,    // TODO_BRANCH: Conectar com branch unit
    
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
    output wire        id_ex_alusrc_debug
);

    //==========================================================================
    // ESTÁGIO IF (Instruction Fetch)
    //==========================================================================
    
    // ===== Geração do PC =====
    wire [31:0] pc_plus_4;
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    assign pc_plus_4 = pc_out + 32'd4;
    
    // TODO_BRANCH: Implementar mux para seleção entre PC+4, branch target, jump target
    // Por enquanto, sempre incrementa PC sequencialmente
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
        .stall(stall),    // TODO_HAZARD: Conectar com hazard detection
        .flush(flush),    // TODO_BRANCH: Conectar com branch unit
        .pc_in(pc_out),
        .instr_in(instr),
        .pc_out(if_id_pc),
        .instr_out(if_id_instr)
    );
    
    // Debug outputs para IF/ID
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
    
    // Campos adicionais para ALU control
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

    // ===== Unidade de Controle =====
    wire [1:0] ctrl_ALUOp;
    wire ctrl_ALUSrc;
    // TODO_CONTROL: Adicionar mais sinais de controle:
    // wire ctrl_RegWrite;   // Para estágio WB
    // wire ctrl_MemRead;    // Para estágio MEM  
    // wire ctrl_MemWrite;   // Para estágio MEM
    // wire ctrl_MemToReg;   // Para estágio WB
    // wire ctrl_Branch;     // Para branch unit
    // wire ctrl_Jump;       // Para branch unit

    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ctrl_ALUOp),
        .ALUSrc(ctrl_ALUSrc)
        // TODO_CONTROL: Conectar sinais adicionais quando implementados
    );

    // ===== Banco de Registradores =====
    wire [31:0] reg_rs1;
    wire [31:0] reg_rs2;

    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) regs (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        
        // TODO_WRITEBACK: Conectar com saída do estágio WB
        .rd(5'b0),               // Por enquanto, sem writeback
        .wd(32'b0),              // Por enquanto, sem writeback  
        .reg_write(1'b0),        // Por enquanto, sem writeback
        
        // Debug (não usado neste módulo, mas disponível)
        .debug_read_index(5'b0),
        .debug_data_out(),
        
        .read_data_1(reg_rs1),
        .read_data_2(reg_rs2)
    );

    assign reg_rs1_debug = reg_rs1;
    assign reg_rs2_debug = reg_rs2;

    //==========================================================================
    // REGISTRADOR DE PIPELINE ID/EX
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
    // TODO_CONTROL: Adicionar mais sinais de controle no pipeline:
    // reg id_ex_RegWrite;
    // reg id_ex_MemRead;
    // reg id_ex_MemWrite; 
    // reg id_ex_MemToReg;
    // reg id_ex_Branch;
    // reg id_ex_Jump;

    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),    // TODO_HAZARD: Conectar com hazard detection
        .flush(flush),    // TODO_BRANCH: Conectar com branch unit
        
        // Entradas do estágio ID
        .id_read_data_1(reg_rs1),
        .id_read_data_2(reg_rs2),
        .id_imm_data(immediate_data),
        .id_pc_out(if_id_pc),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        
        // Saídas para o estágio EX
        .ex_read_data_1(id_ex_rs1_data),
        .ex_read_data_2(id_ex_rs2_data),
        .ex_imm_data(id_ex_imm_data),
        .ex_pc_out(id_ex_pc),
        .ex_rs1(id_ex_rs1),
        .ex_rs2(id_ex_rs2),
        .ex_rd(id_ex_rd)
    );

    // Registrar sinais de controle no pipeline ID/EX
    always @(posedge clk) begin
        if (rst || flush) begin
            id_ex_ALUOp <= 2'b00;
            id_ex_ALUSrc <= 1'b0;
            // TODO_CONTROL: Reset dos sinais adicionais
        end
        else if (!stall) begin
            id_ex_ALUOp <= ctrl_ALUOp;
            id_ex_ALUSrc <= ctrl_ALUSrc;
            // TODO_CONTROL: Registrar sinais adicionais
        end
        // Se stall, mantém valores atuais
    end
    
    // Debug outputs para ID/EX
    assign id_ex_pc_debug = id_ex_pc;
    assign id_ex_rs1_debug = id_ex_rs1_data;
    assign id_ex_rs2_debug = id_ex_rs2_data;
    assign id_ex_imm_debug = id_ex_imm_data;
    assign id_ex_aluop_debug = id_ex_ALUOp;
    assign id_ex_alusrc_debug = id_ex_ALUSrc;

    //==========================================================================
    // ESTÁGIO EX (Execute)
    //==========================================================================

    // ===== Controle da ALU =====
    wire [3:0] alu_control_out;
    wire [9:0] funct = {funct7, funct3};  // Concatenação para ALU control

    alu_control alu_ctrl (
        .ALUOp(id_ex_ALUOp),
        .Funct(funct),           // TODO: Usar funct dos dados registrados em ID/EX
        .Op(alu_control_out)
    );

    // ===== Forwarding (Não Implementado) =====
    // TODO_FORWARDING: Implementar forwarding unit
    wire [31:0] forward_mux1_out;
    wire [31:0] forward_mux2_out;
    
    // Por enquanto, sem forwarding - dados vêm diretamente do ID/EX
    assign forward_mux1_out = id_ex_rs1_data;
    assign forward_mux2_out = id_ex_rs2_data;
    
    /*
    TODO_FORWARDING: Quando implementar forwarding, substituir por:
    
    forwarding_unit fwd_unit (
        .id_ex_rs1_addr(id_ex_rs1),
        .id_ex_rs2_addr(id_ex_rs2), 
        .ex_mem_rd_addr(ex_mem_rd),       // Do estágio EX/MEM
        .ex_mem_reg_write(ex_mem_regwrite),
        .mem_wb_rd_addr(mem_wb_rd),       // Do estágio MEM/WB
        .mem_wb_reg_write(mem_wb_regwrite),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    
    // Muxes de forwarding
    assign forward_mux1_out = (forward_a == 2'b00) ? id_ex_rs1_data :
                             (forward_a == 2'b01) ? ex_mem_alu_result :
                             (forward_a == 2'b10) ? mem_wb_write_data : 
                             id_ex_rs1_data;
                             
    assign forward_mux2_out = (forward_b == 2'b00) ? id_ex_rs2_data :
                             (forward_b == 2'b01) ? ex_mem_alu_result :
                             (forward_b == 2'b10) ? mem_wb_write_data :
                             id_ex_rs2_data;
    */

    // ===== Mux da Fonte B da ALU =====
    wire [31:0] alu_src_mux_out;
    assign alu_src_mux_out = id_ex_ALUSrc ? id_ex_imm_data : forward_mux2_out;

    // ===== Cálculo de Branch Target (Não Usado Nesta Versão) =====
    // TODO_BRANCH: Implementar lógica de branch/jump
    wire [31:0] branch_target;
    assign branch_target = id_ex_pc + id_ex_imm_data;  // PC + immediate
    
    /*
    TODO_BRANCH: Implementar branch unit completa
    branch_unit branch_unit_inst (
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instr),  // Precisaria registrar a instrução
        .id_ex_rs1_data(forward_mux1_out),
        .id_ex_rs2_data(forward_mux2_out),
        .id_ex_immediate(id_ex_imm_data),
        .id_ex_control_signals(id_ex_control), // Precisaria dos sinais completos
        .pc_src(pc_src),
        .new_pc(new_pc),
        .flush(flush)
    );
    */

    // ===== ALU Principal =====
    wire [31:0] alu_result;
    wire alu_zero;

    alu main_alu (
        .a(forward_mux1_out),     // Operando A (com possível forwarding)
        .b(alu_src_mux_out),      // Operando B (registrador ou imediato)
        .ALUOp(alu_control_out),  // Operação da ALU
        .Result(alu_result),      // Resultado da operação
        .Zero(alu_zero)           // Flag zero (usado para branches)
    );

    assign alu_result_debug = alu_result;

    //==========================================================================
    // ESTÁGIOS NÃO IMPLEMENTADOS (Para Referência Futura)
    //==========================================================================
    
    /*
    TODO_MEMORY: Implementar estágio EX/MEM
    ex_mem ex_mem_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .ex_adder_out(branch_target),
        .ex_result(alu_result),
        .ex_rd(id_ex_rd),
        .ex_read_data_2_mux(forward_mux2_out),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_adder_out(mem_adder_out)
    );
    */
    
    /*
    TODO_MEMORY: Implementar memória de dados
    data_memory data_mem (
        .clk(clk),
        .reset(rst),
        .addr(mem_addr),
        .data_in(mem_write_data),
        .data_out(mem_read_data),
        .read_en(mem_read_en),
        .write_en(mem_write_en),
        .byte_enable(mem_byte_enable),
        .debug_addr(debug_addr),
        .debug_data_out(debug_data_out)
    );
    */
    
    /*
    TODO_WRITEBACK: Implementar estágio MEM/WB
    mem_wb mem_wb_reg (
        .clk(clk),
        .rst(rst), 
        .stall(stall),
        .flush(flush),
        .mem_alu_result(mem_alu_result),
        .mem_read_data(mem_read_data),
        .mem_rd(mem_rd),
        .wb_alu_result(wb_alu_result),
        .wb_read_data(wb_read_data),
        .wb_rd(wb_rd)
    );
    
    // Mux do Write Back
    assign write_back_data = mem_to_reg ? wb_read_data : wb_alu_result;
    */

endmodule