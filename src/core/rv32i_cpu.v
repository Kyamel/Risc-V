`timescale 1ns / 1ps
`include "alu_defines.vh"

module rv32i_cpu #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_HEIGHT = 256,
    parameter INSTR_INIT_FILE = "compiler/program.hex",
    parameter DATA_HEIGHT = 1024,
    parameter DATA_INIT_FILE = "none",
    parameter REG_COUNT = 32
)(
    input  wire clk,
    input  wire rst,

    // Sinais para debug/visualização
    output wire [31:0] pc_current,
    output wire [INSTR_WIDTH-1:0] current_instruction,
    
    // Debug dos registradores
    input wire [4:0] debug_reg_index,
    output wire [31:0] debug_reg_value,
    
    // Debug da memória de dados
    input wire [9:0] debug_mem_index,
    output wire [31:0] debug_mem_value
);

    // ========================================================================
    // SINAIS INTERNOS
    // ========================================================================
    
    // Sinais de controle de pipeline
    wire hazard_stall;
    wire branch_flush;
    
    // ========================================================================
    // IF STAGE (Instruction Fetch)
    // ========================================================================
    
    wire [31:0] pc_if;              // PC atual
    wire [31:0] pc_plus_4;          // PC + 4
    wire [31:0] pc_next;            // Próximo PC (de branch/jump ou PC+4)
    wire [31:0] instruction_if;     // Instrução buscada
    
    // Cálculo do PC + 4
    assign pc_plus_4 = pc_if + 32'd4;
    
    // Gerador de PC
    pc_generator pc_gen (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next),
        .pc_out(pc_if)
    );
    
    // Memória de instruções
    instruction_memory #(
        .WIDTH(INSTR_WIDTH),
        .DEPTH(INSTR_HEIGHT),
        .INIT_FILE(INSTR_INIT_FILE)
    ) instr_mem (
        .instr_addr(pc_if),
        .instr(instruction_if)
    );
    
    // Debug outputs
    assign pc_current = pc_if;
    assign current_instruction = instruction_if;
    
    // ========================================================================
    // IF/ID PIPELINE REGISTER
    // ========================================================================
    
    wire [31:0] pc_id;
    wire [31:0] instruction_id;
    
    if_id if_id_reg (
        .clk(clk),
        .rst(rst),
        .stall(hazard_stall),
        .flush(branch_flush),
        .pc_in(pc_if),
        .instr_in(instruction_if),
        .pc_out(pc_id),
        .instr_out(instruction_id)
    );
    
    // ========================================================================
    // ID STAGE (Instruction Decode)
    // ========================================================================
    
    // Campos da instrução
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] immediate_data;
    
    // Dados lidos dos registradores
    wire [31:0] reg_data_1, reg_data_2;
    
    // Sinais de controle da control unit
    wire [1:0] ctrl_ALUOp;
    wire ctrl_ALUSrc, ctrl_Branch, ctrl_Jump;
    wire ctrl_MemRead, ctrl_MemWrite;
    wire ctrl_RegWrite, ctrl_MemtoReg;
    
    // Parser da instrução
    instr_parser parser (
        .instr(instruction_id),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );
    
    // Extrator de imediato
    immediate_data_extractor imm_extract (
        .instr(instruction_id),
        .imm_data(immediate_data)
    );
    
    // Unidade de controle
    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ctrl_ALUOp),
        .ALUSrc(ctrl_ALUSrc),
        .Branch(ctrl_Branch),
        .Jump(ctrl_Jump),
        .MemRead(ctrl_MemRead),
        .MemWrite(ctrl_MemWrite),
        .RegWrite(ctrl_RegWrite),
        .MemtoReg(ctrl_MemtoReg)
    );
    
    // Banco de registradores - conectado com sinais de write-back
    wire [31:0] wb_write_data;
    wire [4:0] wb_rd;
    wire wb_RegWrite;
    
    register_file #(
        .WIDTH(32),
        .DEPTH(REG_COUNT)
    ) regs (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),
        .wd(wb_write_data),
        .rw(wb_RegWrite),
        .read_data_1(reg_data_1),
        .read_data_2(reg_data_2),
        .debug_read_index(debug_reg_index),
        .debug_data_out(debug_reg_value)
    );
    
    // Detecção de hazards
    wire [4:0] ex_rd;
    wire ex_MemRead;
    
    hazard_detection hazard_detect (
        .if_id_rs1_addr(rs1),
        .if_id_rs2_addr(rs2),
        .id_ex_rd_addr(ex_rd),
        .id_ex_mem_read(ex_MemRead),
        .stall(hazard_stall)
    );
    
    // ========================================================================
    // ID/EX PIPELINE REGISTER
    // ========================================================================
    
    wire [31:0] ex_read_data_1, ex_read_data_2;
    wire [31:0] ex_imm_data, ex_pc;
    wire [4:0] ex_rs1, ex_rs2;
    wire [1:0] ex_ALUOp;
    wire ex_ALUSrc, ex_Branch, ex_Jump;
    wire ex_MemWrite, ex_RegWrite, ex_MemtoReg;
    
    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(hazard_stall), // ID/EX não stalla com hazard detection
        .flush(branch_flush),
        // Dados do ID
        .id_read_data_1(reg_data_1),
        .id_read_data_2(reg_data_2),
        .id_imm_data(immediate_data),
        .id_pc_out(pc_id),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        // Sinais de controle do ID
        .id_ALUSrc(ctrl_ALUSrc),
        .id_ALUOp(ctrl_ALUOp),
        .id_Branch(ctrl_Branch),
        .id_MemRead(ctrl_MemRead),
        .id_MemWrite(ctrl_MemWrite),
        .id_RegWrite(ctrl_RegWrite),
        .id_MemtoReg(ctrl_MemtoReg),
        // Saídas para EX
        .ex_read_data_1(ex_read_data_1),
        .ex_read_data_2(ex_read_data_2),
        .ex_imm_data(ex_imm_data),
        .ex_pc_out(ex_pc),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        // Sinais de controle para EX
        .ex_ALUSrc(ex_ALUSrc),
        .ex_ALUOp(ex_ALUOp),
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg)
    );
    
    // ========================================================================
    // EX STAGE (Execute)
    // ========================================================================
    
    // Sinais para forwarding
    wire [1:0] forward_A, forward_B;
    wire [31:0] forward_data_1, forward_data_2;
    wire [31:0] alu_input_a, alu_input_b;
    wire [31:0] alu_result;
    wire alu_zero;
    wire [3:0] alu_operation;
    
    // Sinais do MEM e WB para forwarding
    wire [4:0] mem_rd, wb_rd_forward;
    wire mem_RegWrite, wb_RegWrite_forward;
    wire [31:0] mem_alu_result, wb_write_data_forward;
    
    // Unidade de forwarding
    forwarding_unit forward_unit (
        .EX_rs1(ex_rs1),
        .EX_rs2(ex_rs2),
        .MEM_rd(mem_rd),
        .WB_rd(wb_rd_forward),
        .MEM_RegWrite(mem_RegWrite),
        .WB_RegWrite(wb_RegWrite_forward),
        .ForwardA(forward_A),
        .ForwardB(forward_B)
    );
    
    // Muxes de forwarding
    assign forward_data_1 = (forward_A == 2'b10) ? mem_alu_result :    // Forward do MEM
                           (forward_A == 2'b01) ? wb_write_data_forward : // Forward do WB
                           ex_read_data_1;                              // Sem forwarding
                           
    assign forward_data_2 = (forward_B == 2'b10) ? mem_alu_result :    // Forward do MEM
                           (forward_B == 2'b01) ? wb_write_data_forward : // Forward do WB
                           ex_read_data_2;                              // Sem forwarding
    
    // Entrada A da ALU (sempre do registrador com forwarding)
    assign alu_input_a = forward_data_1;
    
    // Entrada B da ALU (registrador ou imediato)
    assign alu_input_b = ex_ALUSrc ? ex_imm_data : forward_data_2;
    
    // Controle da ALU
    alu_control alu_ctrl (
        .ALUOp(ex_ALUOp),
        .Funct({funct7, funct3}), // Concatena funct7 e funct3
        .Op(alu_operation)
    );
    
    // ALU
    alu main_alu (
        .a(alu_input_a),
        .b(alu_input_b),
        .ALUOp(alu_operation),
        .Result(alu_result),
        .Zero(alu_zero)
    );
    
    // Cálculo do endereço de branch/jump
    wire [31:0] branch_target;
    assign branch_target = ex_pc + ex_imm_data;
    
    // ========================================================================
    // EX/MEM PIPELINE REGISTER
    // ========================================================================
    
    wire [31:0] mem_addr, mem_write_data, mem_branch_target;
    wire mem_alu_zero, mem_Branch, mem_Jump, mem_MemWrite, mem_MemtoReg;
    
    ex_mem ex_mem_reg (
        .clk(clk),
        .rst(rst),
        .stall(hazard_stall),
        .flush(branch_flush),
        // Sinais de controle do EX
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg),
        // Dados do EX
        .ex_adder_out(branch_target),
        .ex_result(alu_result),
        .ex_alu_zero(alu_zero),
        .ex_rd(ex_rd),
        .ex_read_data_2_mux(forward_data_2),
        // Saídas para MEM
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_adder_out(mem_branch_target),
        .mem_alu_zero(mem_alu_zero),
        // Sinais de controle para MEM
        .mem_Branch(mem_Branch),
        .mem_MemRead(ex_MemRead), // Precisa passar através do ex_mem
        .mem_MemWrite(mem_MemWrite),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg)
    );
    
    // Assign para forwarding
    assign mem_alu_result = mem_addr;
    
    // ========================================================================
    // MEM STAGE (Memory Access)
    // ========================================================================
    
    wire [31:0] mem_read_data;
    
    // Memória de dados
    data_memory #(
        .WIDTH(32),
        .DEPTH(DATA_HEIGHT),
        .INIT_FILE(DATA_INIT_FILE)
    ) data_mem (
        .clk(clk),
        .mem_addr(mem_addr),
        .write_data(mem_write_data),
        .mem_write(mem_MemWrite),
        .mem_read(ex_MemRead), // Sinal vem do pipeline register
        .read_data(mem_read_data)
    );
    
    // Debug da memória
    assign debug_mem_value = data_mem.memory[debug_mem_index];

    branch_unit branch_unit (
        .id_ex_pc(ex_pc),
        .id_ex_instruction(instruction_id),
        .id_ex_rs1_data(forward_data_1),
        .id_ex_rs2_data(forward_data_2),
        .id_ex_immediate(ex_imm_data),
        .id_ex_control_signals({mem_Branch, mem_Jump, mem_MemRead, mem_MemWrite, mem_RegWrite, mem_MemtoReg}),
        
        .pc_src(branch_taken_decision),
        .new_pc(mem_branch_target),
        .flush(branch_flush)
    );
    
    // Seleção do próximo PC
    assign pc_next = branch_taken_decision ? mem_branch_target : pc_plus_4;
    assign branch_flush = branch_taken_decision;

    
    // ========================================================================
    // MEM/WB PIPELINE REGISTER
    // ========================================================================
    
    wire [31:0] wb_read_data, wb_alu_result;
    wire wb_MemtoReg;
    
    mem_wb mem_wb_reg (
        .clk(clk),
        .rst(rst),
        .stall(hazard_stall),
        .flush(branch_flush),
        // Dados do MEM
        .mem_read_data(mem_read_data),
        .mem_result(mem_addr),
        .mem_rd(mem_rd),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg),
        // Saídas para WB
        .wb_read_data(wb_read_data),
        .wb_result(wb_alu_result),
        .wb_rd(wb_rd),
        .wb_RegWrite(wb_RegWrite),
        .wb_MemtoReg(wb_MemtoReg)
    );
    
    // Assigns para forwarding
    assign wb_rd_forward = wb_rd;
    assign wb_RegWrite_forward = wb_RegWrite;
    assign wb_write_data_forward = wb_write_data;
    
    // ========================================================================
    // WB STAGE (Write Back)
    // ========================================================================
    
    // Mux de write-back (memória ou ALU)
    assign wb_write_data = wb_MemtoReg ? wb_read_data : wb_alu_result;

endmodule