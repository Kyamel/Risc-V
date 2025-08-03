`timescale 1ns / 1ps

module rv32i_cpu #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_HEIGHT = 256,
    parameter INSTR_INIT_FILE = "compiler/program.hex",
    parameter REG_COUNT = 32
)(
    input  wire clk,
    input  wire rst,

    input wire stall,
    input wire flush,

    // Sinais para debug/visualização
    output wire [31:0] pc_current,
    output wire [INSTR_WIDTH-1:0] current_instruction,
    output wire [31:0] registers_debug [0:REG_COUNT-1],
    output wire [INSTR_WIDTH-1:0] instr_memory_debug [0:INSTR_HEIGHT-1],
    // TODO: data_memory_debug futuramente

    input wire [4:0] debug_reg_index,      // Índice do registrador a ser lido
    output wire [31:0] debug_reg_value    // Valor do registrador selecionado
);

    // --------------------------
    // PC -> PC + 4 -> mux -> PC
    // --------------------------

    wire [31:0] pc_plus_4;
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    assign pc_plus_4 = pc_out + 32'd4;

    // Mux de PC: por enquanto, sempre seleciona pc_plus_4
    assign pc_in = pc_plus_4;

    pc_generator pc_gen (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    assign pc_current = pc_out;

    // --------------------------
    // Instruction Memory
    // --------------------------

    wire [INSTR_WIDTH-1:0] instr;

    instruction_memory #(
        .WIDTH(INSTR_WIDTH),
        .HEIGHT(INSTR_HEIGHT),
        .INIT_FILE(INSTR_INIT_FILE)
    ) instr_mem (
        .instr_addr(pc_out),
        .instr(instr)
    );

    assign current_instruction = instr;

    // Expor ROM para debug
    assign instr_memory_debug = instr_mem.memory;

    // --------------------------
    // IF/ID Register
    // --------------------------

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

    // ---------------------------
    // Immediate Data Extraction
    // ---------------------------

    wire [31:0] immediate_data;

    immediate_data_extractor imm_extract (
        .instr(if_id_instr),
        .imm_data(immediate_data)
    );

    // --------------------------
    // Instruction Parser
    // --------------------------

    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;

    instr_parser parser (
        .instr(if_id_instr),
        
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
       // .funct3(funct3),
       // .funct7(funct7)
    );

    // --------------------------
    // Control Unit
    // --------------------------

    wire [1:0] ctrl_ALUOp;
    wire ctrl_ALUSrc;

    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ctrl_ALUOp),
        .ALUSrc(ctrl_ALUSrc)
        // Outros sinais de controle serão adicionados posteriormente
    );

    // --------------------------
    // Register File
    // --------------------------

    wire [31:0] reg_rs1;
    wire [31:0] reg_rs2;

    register_file #(
        .WIDTH(32),
        .DEPTH(REG_COUNT)
    ) regs (
        .clk(clk),
        .rst(rst),

        // Entradas
        .rs1(rs1),
        .rs2(rs2),
        .rd(5'b0),               // TODO: conectar com saída da EX/MEM futuramente
        .wd(32'b0),              // TODO: conectar com resultado da execução
        .reg_write(1'b0),        // TODO: gerado pela control unit
        
        // Portas de debug
        .debug_read_index(debug_reg_index),
        .debug_data_out(debug_reg_value),
        
        // Saídas de leitura
        .read_data_1(reg_rs1),
        .read_data_2(reg_rs2)
    );

    // --------------------------
    // ID/EX Pipeline Register
    // --------------------------

    wire [31:0] idex_pc;
    wire [31:0] idex_rs1_data;
    wire [31:0] idex_rs2_data;
    wire [31:0] idex_imm_data;
    wire [4:0] idex_rs1;
    wire [4:0] idex_rs2;
    wire [4:0] idex_rd;
    reg [1:0] idex_ALUOp; //TODO: deve ser reg ou wire? Deve ser controlado pelo estágio ID/EX?
    reg idex_ALUSrc;      //TODO: deve ser reg ou wire? Deve ser controlado pelo estágio ID/EX?

    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        
        // Entradas do estágio ID
        .id_read_data_1(reg_rs1),
        .id_read_data_2(reg_rs2),
        .id_imm_data(immediate_data),
        .id_pc_out(if_id_pc),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        
        // Saídas para o estágio EX
        .ex_read_data_1(idex_rs1_data),
        .ex_read_data_2(idex_rs2_data),
        .ex_imm_data(idex_imm_data),
        .ex_pc_out(idex_pc),
        .ex_rs1(idex_rs1),
        .ex_rs2(idex_rs2),
        .ex_rd(idex_rd)
    );

    // Registra os sinais de controle no pipeline ID/EX
    always @(posedge clk) begin
        if (rst || flush) begin
            idex_ALUOp <= 2'b0;
            idex_ALUSrc <= 1'b0;
        end
        else if (!stall) begin
            idex_ALUOp <= ctrl_ALUOp;
            idex_ALUSrc <= ctrl_ALUSrc;
        end
    end

    // --------------------------
    // ALU Control
    // --------------------------

    wire [3:0] alu_control_out;
    wire [9:0] funct = {funct7, funct3}; // Concatena funct7 e funct3

    alu_control alu_ctrl (
        .ALUOp(idex_ALUOp),
        .Funct(funct),
        .Op(alu_control_out)
    );

    // --------------------------
    // Forwarding Unit (Placeholder)
    // --------------------------
    // TODO: Implementar a forwarding unit
    wire [31:0] forward_mux1_out = idex_rs1_data; // Por enquanto, sem forwarding
    wire [31:0] forward_mux2_out = idex_rs2_data; // Por enquanto, sem forwarding

    // --------------------------
    // ALU Source Mux
    // --------------------------
    wire [31:0] alu_src_mux_out = idex_ALUSrc ? idex_imm_data : forward_mux2_out;

    // --------------------------
    // Branch Calculation
    // --------------------------
    wire [31:0] branch_target;
    wire [31:0] shifted_imm = idex_imm_data << 1; // Shift left 1 do imediato
    
    assign branch_target = idex_pc + shifted_imm; // PC + (imm << 1)

    // --------------------------
    // ALU
    // --------------------------
    wire [31:0] alu_result;
    wire alu_zero;

    alu main_alu (
        .a(forward_mux1_out),     // Entrada A com possível forwarding
        .b(alu_src_mux_out),      // Entrada B (reg ou immediate)
        .ALUOp(alu_control_out),  // Operação da ALU
        .Result(alu_result),      // Resultado da operação
        .Zero(alu_zero)           // Flag zero
    );

    // --------------------------
    // EX/MEM Pipeline Register (Placeholder)
    // --------------------------
    // TODO: Implementar o registrador EX/MEM
    // wire [31:0] exmem_alu_result = alu_result;
    // wire [31:0] exmem_branch_target = branch_target;
    // wire exmem_zero = alu_zero;
    // wire [4:0] exmem_rd = idex_rd;

endmodule