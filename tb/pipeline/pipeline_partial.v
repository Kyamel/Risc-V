`timescale 1ns / 1ps

module pipeline_partial (
    input  wire clk,
    input  wire rst,
    input  wire stall,
    input  wire flush,
    
    // Debug outputs
    output wire [31:0] pc_current,
    output wire [31:0] current_instruction,
    output wire [31:0] alu_result_debug,
    output wire [31:0] reg_rs1_debug,
    output wire [31:0] reg_rs2_debug
);

    // --------------------------
    // PC Logic
    // --------------------------
    wire [31:0] pc_plus_4;
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    assign pc_plus_4 = pc_out + 32'd4;
    assign pc_in = pc_plus_4;  // Simple PC increment for now

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
    );

    // --------------------------
    // Control Unit (Simplified)
    // --------------------------
    wire [1:0] ctrl_ALUOp;
    wire ctrl_ALUSrc;

    control_unit ctrl_unit (
        .opcode(opcode),
        .ALUOp(ctrl_ALUOp),
        .ALUSrc(ctrl_ALUSrc)
    );

    // --------------------------
    // Register File
    // --------------------------
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
        .rd(5'b0),        // No writeback in this partial pipeline
        .wd(32'b0),       // No writeback data
        .reg_write(1'b0), // No register writes
        .read_data_1(reg_rs1),
        .read_data_2(reg_rs2)
    );

    assign reg_rs1_debug = reg_rs1;
    assign reg_rs2_debug = reg_rs2;

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
    reg [1:0] idex_ALUOp;
    reg idex_ALUSrc;

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
        .ex_read_data_1(idex_rs1_data),
        .ex_read_data_2(idex_rs2_data),
        .ex_imm_data(idex_imm_data),
        .ex_pc_out(idex_pc),
        .ex_rs1(idex_rs1),
        .ex_rs2(idex_rs2),
        .ex_rd(idex_rd)
    );

    // Control signals pipeline
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
    wire [9:0] funct = {funct7, funct3};

    alu_control alu_ctrl (
        .ALUOp(idex_ALUOp),
        .Funct(funct),
        .Op(alu_control_out)
    );

    // --------------------------
    // ALU Source Mux
    // --------------------------
    wire [31:0] alu_src_mux_out = idex_ALUSrc ? idex_imm_data : idex_rs2_data;

    // --------------------------
    // ALU
    // --------------------------
    wire [31:0] alu_result;
    wire alu_zero;

    alu main_alu (
        .a(idex_rs1_data),
        .b(alu_src_mux_out),
        .ALUOp(alu_control_out),
        .Result(alu_result),
        .Zero(alu_zero)
    );

    assign alu_result_debug = alu_result;

endmodule