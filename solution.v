`timescale 1ns / 1ps
`include "alu_defines.vh"

// ============================================================================
// PROCESSADOR RISC-V PIPELINE COMPLETO E CORRIGIDO
// ============================================================================

module rv32i_cpu_pipeline #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_DEPTH = 1024,
    parameter INSTR_INIT_FILE = "program.hex",
    parameter DATA_DEPTH = 1024,
    parameter DATA_INIT_FILE = "none",
    parameter REG_COUNT = 32
)(
    input wire clk,
    input wire rst,
    
    // Debug outputs
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    input wire [4:0] debug_reg_addr,
    output wire [31:0] debug_reg_data,
    input wire [9:0] debug_mem_addr,
    output wire [31:0] debug_mem_data
);

// ============================================================================
// SINAIS DE CONTROLE DE HAZARD E FORWARDING
// ============================================================================

wire pc_write;
wire if_id_write;
wire control_hazard_stall;
wire [1:0] forward_a, forward_b;
wire flush_id_ex;

// ============================================================================
// IF STAGE (Instruction Fetch)
// ============================================================================

wire [31:0] pc_current;
wire [31:0] pc_next;
wire [31:0] pc_plus_4;
wire [31:0] instruction_if;

// PC + 4
assign pc_plus_4 = pc_current + 32'd4;

// PC Generator
pc_generator pc_gen (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_next),
    .pc_out(pc_current)
);

// Instruction Memory
instruction_memory #(
    .WIDTH(INSTR_WIDTH),
    .DEPTH(INSTR_DEPTH),
    .INIT_FILE(INSTR_INIT_FILE)
) imem (
    .instr_addr(pc_current),
    .instr(instruction_if)
);

// Debug outputs
assign debug_pc = pc_current;
assign debug_instruction = instruction_if;

// ============================================================================
// IF/ID PIPELINE REGISTER
// ============================================================================

wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;

if_id_pipeline_reg if_id_reg (
    .clk(clk),
    .rst(rst),
    .write_enable(if_id_write),
    .flush(flush_id_ex),
    .pc_in(pc_current),
    .instruction_in(instruction_if),
    .pc_out(if_id_pc),
    .instruction_out(if_id_instruction)
);

// ============================================================================
// ID STAGE (Instruction Decode)
// ============================================================================

// Instruction parsing
wire [6:0] opcode;
wire [4:0] rs1, rs2, rd;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = if_id_instruction[6:0];
assign rs1 = if_id_instruction[19:15];
assign rs2 = if_id_instruction[24:20];
assign rd = if_id_instruction[11:7];
assign funct3 = if_id_instruction[14:12];
assign funct7 = if_id_instruction[31:25];

// Immediate extraction
wire [31:0] immediate;
immediate_extractor imm_ext (
    .instruction(if_id_instruction),
    .immediate(immediate)
);

// Control unit
wire alu_src;
wire [1:0] alu_op;
wire branch, jump;
wire mem_read, mem_write;
wire reg_write, mem_to_reg;

control_unit ctrl (
    .opcode(opcode),
    .alu_src(alu_src),
    .alu_op(alu_op),
    .branch(branch),
    .jump(jump),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .reg_write(reg_write),
    .mem_to_reg(mem_to_reg)
);

// Register file
wire [31:0] reg_read_data_1, reg_read_data_2;
wire [31:0] wb_write_data;
wire [4:0] wb_write_reg;
wire wb_reg_write;

register_file #(
    .WIDTH(32),
    .DEPTH(REG_COUNT)
) regfile (
    .clk(clk),
    .rst(rst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(wb_write_reg),
    .wd(wb_write_data),
    .rw(wb_reg_write),
    .read_data_1(reg_read_data_1),
    .read_data_2(reg_read_data_2),
    .debug_read_index(debug_reg_addr),
    .debug_data_out(debug_reg_data)
);

// Hazard detection
wire [4:0] id_ex_rd;
wire id_ex_mem_read;

hazard_detection_unit hazard_unit (
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_rd(id_ex_rd),
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),
    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .stall(control_hazard_stall)
);

// ============================================================================
// ID/EX PIPELINE REGISTER
// ============================================================================

wire [31:0] id_ex_pc;
wire [31:0] id_ex_reg_data_1, id_ex_reg_data_2;
wire [31:0] id_ex_immediate;
wire [4:0] id_ex_rs1, id_ex_rs2;
wire [2:0] id_ex_funct3;
wire [6:0] id_ex_funct7;

// Control signals
wire id_ex_alu_src;
wire [1:0] id_ex_alu_op;
wire id_ex_branch, id_ex_jump;
wire id_ex_mem_write, id_ex_reg_write, id_ex_mem_to_reg;

id_ex_pipeline_reg id_ex_reg (
    .clk(clk),
    .rst(rst),
    .flush(flush_id_ex | control_hazard_stall),
    .pc_in(if_id_pc),
    .reg_data_1_in(reg_read_data_1),
    .reg_data_2_in(reg_read_data_2),
    .immediate_in(immediate),
    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),
    .funct3_in(funct3),
    .funct7_in(funct7),
    // Control signals
    .alu_src_in(control_hazard_stall ? 1'b0 : alu_src),
    .alu_op_in(control_hazard_stall ? 2'b0 : alu_op),
    .branch_in(control_hazard_stall ? 1'b0 : branch),
    .jump_in(control_hazard_stall ? 1'b0 : jump),
    .mem_read_in(control_hazard_stall ? 1'b0 : mem_read),
    .mem_write_in(control_hazard_stall ? 1'b0 : mem_write),
    .reg_write_in(control_hazard_stall ? 1'b0 : reg_write),
    .mem_to_reg_in(control_hazard_stall ? 1'b0 : mem_to_reg),
    // Outputs
    .pc_out(id_ex_pc),
    .reg_data_1_out(id_ex_reg_data_1),
    .reg_data_2_out(id_ex_reg_data_2),
    .immediate_out(id_ex_immediate),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),
    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7),
    .alu_src_out(id_ex_alu_src),
    .alu_op_out(id_ex_alu_op),
    .branch_out(id_ex_branch),
    .jump_out(id_ex_jump),
    .mem_read_out(id_ex_mem_read),
    .mem_write_out(id_ex_mem_write),
    .reg_write_out(id_ex_reg_write),
    .mem_to_reg_out(id_ex_mem_to_reg)
);

// ============================================================================
// EX STAGE (Execute)
// ============================================================================

// Forwarding unit
wire [4:0] ex_mem_rd, mem_wb_rd;
wire ex_mem_reg_write, mem_wb_reg_write;
wire [31:0] ex_mem_alu_result, mem_wb_result;

forwarding_unit fwd_unit (
    .EX_rs1(id_ex_rs1),
    .EX_rs2(id_ex_rs2),
    .MEM_rd(ex_mem_rd),
    .WB_rd(mem_wb_rd),
    .MEM_RegWrite(ex_mem_reg_write),
    .WB_RegWrite(mem_wb_reg_write),
    .ForwardA(forward_a),
    .ForwardB(forward_b)
);

// Forwarding muxes
wire [31:0] alu_input_a, alu_input_b;
wire [31:0] forwarded_reg_data_1, forwarded_reg_data_2;

assign forwarded_reg_data_1 = (forward_a == 2'b10) ? ex_mem_alu_result :
                               (forward_a == 2'b01) ? wb_write_data :
                               id_ex_reg_data_1;

assign forwarded_reg_data_2 = (forward_b == 2'b10) ? ex_mem_alu_result :
                               (forward_b == 2'b01) ? wb_write_data :
                               id_ex_reg_data_2;

assign alu_input_a = forwarded_reg_data_1;
assign alu_input_b = id_ex_alu_src ? id_ex_immediate : forwarded_reg_data_2;

// ALU control
wire [3:0] alu_control_signal;
alu_control alu_ctrl (
    .ALUOp(id_ex_alu_op),
    .Funct({id_ex_funct7, id_ex_funct3}),
    .Op(alu_control_signal)
);

// ALU
wire [31:0] alu_result;
wire alu_zero;
alu main_alu (
    .a(alu_input_a),
    .b(alu_input_b),
    .ALUOp(alu_control_signal),
    .Result(alu_result),
    .Zero(alu_zero)
);

// Branch/Jump target calculation
wire [31:0] branch_target;
assign branch_target = id_ex_pc + id_ex_immediate;

// Branch/Jump decision
wire branch_taken, jump_taken;
wire pc_src;

branch_decision_unit branch_unit (
    .branch_signal(id_ex_branch),
    .jump_signal(id_ex_jump),
    .funct3(id_ex_funct3),
    .rs1_data(forwarded_reg_data_1),
    .rs2_data(forwarded_reg_data_2),
    .branch_taken(branch_taken),
    .jump_taken(jump_taken)
);

assign pc_src = branch_taken | jump_taken;
assign flush_id_ex = pc_src;
assign pc_next = pc_src ? branch_target : pc_plus_4;

// ============================================================================
// EX/MEM PIPELINE REGISTER
// ============================================================================

wire [31:0] ex_mem_branch_target;
wire [31:0] ex_mem_mem_write_data;
wire ex_mem_branch, ex_mem_jump;
wire ex_mem_mem_read, ex_mem_mem_write, ex_mem_mem_to_reg;

ex_mem_pipeline_reg ex_mem_reg (
    .clk(clk),
    .rst(rst),
    .branch_target_in(branch_target),
    .alu_result_in(alu_result),
    .mem_write_data_in(forwarded_reg_data_2),
    .rd_in(id_ex_rd),
    // Control signals
    .branch_in(id_ex_branch),
    .jump_in(id_ex_jump),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .reg_write_in(id_ex_reg_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    // Outputs
    .branch_target_out(ex_mem_branch_target),
    .alu_result_out(ex_mem_alu_result),
    .mem_write_data_out(ex_mem_mem_write_data),
    .rd_out(ex_mem_rd),
    .branch_out(ex_mem_branch),
    .jump_out(ex_mem_jump),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .reg_write_out(ex_mem_reg_write),
    .mem_to_reg_out(ex_mem_mem_to_reg)
);

// ============================================================================
// MEM STAGE (Memory Access)
// ============================================================================

wire [31:0] mem_read_data;

data_memory #(
    .WIDTH(32),
    .DEPTH(DATA_DEPTH),
    .INIT_FILE(DATA_INIT_FILE)
) dmem (
    .clk(clk),
    .mem_addr(ex_mem_alu_result),
    .write_data(ex_mem_mem_write_data),
    .mem_write(ex_mem_mem_write),
    .mem_read(ex_mem_mem_read),
    .read_data(mem_read_data)
);

// Debug memory access
assign debug_mem_data = dmem.memory[debug_mem_addr];

// ============================================================================
// MEM/WB PIPELINE REGISTER
// ============================================================================

wire [31:0] mem_wb_mem_data, mem_wb_alu_result;
wire mem_wb_mem_to_reg;

mem_wb_pipeline_reg mem_wb_reg (
    .clk(clk),
    .rst(rst),
    .mem_data_in(mem_read_data),
    .alu_result_in(ex_mem_alu_result),
    .rd_in(ex_mem_rd),
    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),
    .mem_data_out(mem_wb_mem_data),
    .alu_result_out(mem_wb_alu_result),
    .rd_out(mem_wb_rd),
    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)
);

// ============================================================================
// WB STAGE (Write Back)
// ============================================================================

assign wb_write_data = mem_wb_mem_to_reg ? mem_wb_mem_data : mem_wb_alu_result;
assign wb_write_reg = mem_wb_rd;
assign wb_reg_write = mem_wb_reg_write;
assign mem_wb_result = wb_write_data; // For forwarding

endmodule

// ============================================================================
// MÓDULOS DE PIPELINE REGISTERS CORRIGIDOS
// ============================================================================

module if_id_pipeline_reg (
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire flush,
    input wire [31:0] pc_in,
    input wire [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);
    always @(posedge clk or posedge rst) begin
        if (rst | flush) begin
            pc_out <= 32'b0;
            instruction_out <= 32'b0;
        end else if (write_enable) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
    end
endmodule

module id_ex_pipeline_reg (
    input wire clk,
    input wire rst,
    input wire flush,
    input wire [31:0] pc_in,
    input wire [31:0] reg_data_1_in, reg_data_2_in,
    input wire [31:0] immediate_in,
    input wire [4:0] rs1_in, rs2_in, rd_in,
    input wire [2:0] funct3_in,
    input wire [6:0] funct7_in,
    input wire alu_src_in,
    input wire [1:0] alu_op_in,
    input wire branch_in, jump_in,
    input wire mem_read_in, mem_write_in,
    input wire reg_write_in, mem_to_reg_in,
    output reg [31:0] pc_out,
    output reg [31:0] reg_data_1_out, reg_data_2_out,
    output reg [31:0] immediate_out,
    output reg [4:0] rs1_out, rs2_out, rd_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,
    output reg alu_src_out,
    output reg [1:0] alu_op_out,
    output reg branch_out, jump_out,
    output reg mem_read_out, mem_write_out,
    output reg reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge rst) begin
        if (rst | flush) begin
            pc_out <= 32'b0;
            reg_data_1_out <= 32'b0;
            reg_data_2_out <= 32'b0;
            immediate_out <= 32'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;
            funct3_out <= 3'b0;
            funct7_out <= 7'b0;
            alu_src_out <= 1'b0;
            alu_op_out <= 2'b0;
            branch_out <= 1'b0;
            jump_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            reg_data_1_out <= reg_data_1_in;
            reg_data_2_out <= reg_data_2_in;
            immediate_out <= immediate_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            funct7_out <= funct7_in;
            alu_src_out <= alu_src_in;
            alu_op_out <= alu_op_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule

module ex_mem_pipeline_reg (
    input wire clk,
    input wire rst,
    input wire [31:0] branch_target_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] mem_write_data_in,
    input wire [4:0] rd_in,
    input wire branch_in, jump_in,
    input wire mem_read_in, mem_write_in,
    input wire reg_write_in, mem_to_reg_in,
    output reg [31:0] branch_target_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] mem_write_data_out,
    output reg [4:0] rd_out,
    output reg branch_out, jump_out,
    output reg mem_read_out, mem_write_out,
    output reg reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            branch_target_out <= 32'b0;
            alu_result_out <= 32'b0;
            mem_write_data_out <= 32'b0;
            rd_out <= 5'b0;
            branch_out <= 1'b0;
            jump_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            branch_target_out <= branch_target_in;
            alu_result_out <= alu_result_in;
            mem_write_data_out <= mem_write_data_in;
            rd_out <= rd_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule

module mem_wb_pipeline_reg (
    input wire clk,
    input wire rst,
    input wire [31:0] mem_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] rd_in,
    input wire reg_write_in, mem_to_reg_in,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out,
    output reg reg_write_out, mem_to_reg_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end else begin
            mem_data_out <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule

// ============================================================================
// MÓDULOS AUXILIARES CORRIGIDOS/NOVOS
// ============================================================================

module immediate_extractor (
    input wire [31:0] instruction,
    output reg [31:0] immediate
);
    always @(*) begin
        case (instruction[6:0])
            // I-type
            7'b0000011, 7'b0010011, 7'b1100111:
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            // S-type
            7'b0100011:
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            // B-type
            7'b1100011:
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            // U-type
            7'b0110111, 7'b0010111:
                immediate = {instruction[31:12], 12'b0};
            // J-type
            7'b1101111:
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default:
                immediate = 32'b0;
        endcase
    end
endmodule

module branch_decision_unit (
    input wire branch_signal,
    input wire jump_signal,
    input wire [2:0] funct3,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    output reg branch_taken,
    output wire jump_taken
);
    assign jump_taken = jump_signal;
    
    always @(*) begin
        if (branch_signal) begin
            case (funct3)
                3'b000: branch_taken = (rs1_data == rs2_data);                       // BEQ
                3'b001: branch_taken = (rs1_data != rs2_data);                       // BNE
                3'b100: branch_taken = ($signed(rs1_data) < $signed(rs2_data));      // BLT
                3'b101: branch_taken = ($signed(rs1_data) >= $signed(rs2_data));     // BGE
                3'b110: branch_taken = (rs1_data < rs2_data);                        // BLTU
                3'b111: branch_taken = (rs1_data >= rs2_data);                       // BGEU
                default: branch_taken = 1'b0;
            endcase
        end else begin
            branch_taken = 1'b0;
        end
    end
endmodule

module hazard_detection_unit (
    input wire id_ex_mem_read,
    input wire [4:0] id_ex_rd,
    input wire [4:0] if_id_rs1,
    input wire [4:0] if_id_rs2,
    output reg pc_write,
    output reg if_id_write,
    output reg stall
);
    always @(*) begin
        if (id_ex_mem_read && 
            ((id_ex_rd == if_id_rs1 && if_id_rs1 != 5'b0) || 
             (id_ex_rd == if_id_rs2 && if_id_rs2 != 5'b0))) begin
            pc_write = 1'b0;
            if_id_write = 1'b0;
            stall = 1'b1;
        end else begin
            pc_write = 1'b1;
            if_id_write = 1'b1;
            stall = 1'b0;
        end
    end
endmodule

// ============================================================================
// TESTBENCH PARA VERIFICAÇÃO
// ============================================================================

module tb_rv32i_pipeline;
    reg clk, rst;
    wire [31:0] debug_pc, debug_instruction;
    reg [4:0] debug_reg_addr = 5'b0;
    wire [31:0] debug_