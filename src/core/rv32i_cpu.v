`timescale 1ns / 1ps
`include "constants.v"

module rv32i_cpu (
    input wire clk,
    input wire reset,
    
    // Debug signals
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    output wire debug_stall,
    output wire debug_flush,

    // Debug memory access
    output wire [31:0] debug_registers [0:31],  // RV32E tem 32 registradores
    output wire [31:0] debug_dmem_out,
    output wire [31:0] debug_imem_out
);

    // Pipeline stage registers
    // IF/ID
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
    // ID/EX 
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_instruction;
    wire [31:0] id_ex_rs1_data;
    wire [31:0] id_ex_rs2_data;
    wire [31:0] id_ex_immediate;
    wire [4:0] id_ex_rd_addr;
    wire [4:0] id_ex_rs1_addr;
    wire [4:0] id_ex_rs2_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals;
    wire id_ex_valid;
    
    // EX/MEM
    wire [31:0] ex_mem_pc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rs2_data;
    wire [4:0] ex_mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control_signals;
    wire ex_mem_valid;
    
    // MEM/WB
    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [4:0] mem_wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control_signals;
    wire mem_wb_valid;
    
    // Control signals
    wire stall;
    wire flush;
    wire [31:0] new_pc;
    wire pc_src;
    
    // Forwarding signals
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    
    // Register file connections
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [31:0] wb_data;

    // Memory interfaces
    wire [31:0] imem_addr;
    wire [31:0] imem_data;
    wire imem_read;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_in;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;

    // Instruction Memory
    instruction_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/program.hex")
    ) imem (
        .clk(clk),
        .reset(reset),
        .addr(imem_addr),
        .data_out(imem_data),
        .read_en(imem_read),
        .debug_addr(debug_pc),
        .debug_data_out(debug_imem_out)
    );

    // Data Memory
    data_memory #(
        .DEPTH(1024),
        .INIT_FILE("compiler/data.hex")
    ) dmem (
        .clk(clk),
        .reset(reset),
        .addr(dmem_addr),
        .data_in(dmem_data_out),
        .data_out(dmem_data_in),
        .read_en(dmem_read),
        .write_en(dmem_write),
        .byte_enable(dmem_byte_enable),
        .debug_addr(dmem_addr),
        .debug_data_out(debug_dmem_out)
    );

    // IF Stage
    if_stage instruction_fetch (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_src(pc_src),
        .new_pc(new_pc),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid)
    );
    
    // ID Stage
    id_stage instruction_decode (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_rd_data(wb_data),
        .mem_wb_reg_write(mem_wb_control_signals[`CTRL_REG_WRITE]),
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .id_ex_valid(id_ex_valid),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // EX Stage
    ex_stage execute (
        .clk(clk),
        .reset(reset),
        .id_ex_pc(id_ex_pc),
        .id_ex_instruction(id_ex_instruction),
        .id_ex_rs1_data(id_ex_rs1_data),
        .id_ex_rs2_data(id_ex_rs2_data),
        .id_ex_immediate(id_ex_immediate),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .id_ex_control_signals(id_ex_control_signals),
        .id_ex_valid(id_ex_valid),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .ex_mem_valid(ex_mem_valid),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .branch_taken(pc_src),  // Conectado diretamente ao pc_src
        .branch_target(new_pc)
    );
    
    // MEM Stage
    mem_stage memory_access (
        .clk(clk),
        .reset(reset),
        .ex_mem_pc(ex_mem_pc),
        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rs2_data(ex_mem_rs2_data),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_control_signals(ex_mem_control_signals),
        .ex_mem_valid(ex_mem_valid),
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .mem_wb_pc(mem_wb_pc),
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_control_signals(mem_wb_control_signals),
        .mem_wb_valid(mem_wb_valid)
    );
    
    // WB Stage
    assign wb_data = mem_wb_control_signals[`CTRL_MEM_TO_REG] ? mem_wb_mem_data : mem_wb_alu_result;
    
    // Control Unit
    control_unit control_unit (
        .instruction(if_id_instruction),
        .control_signals(id_ex_control_signals)  // Conectado diretamente ao ID/EX
    );
    
    // Hazard Detection
    hazard_detection hazard_detection (
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_mem_read(id_ex_control_signals[`CTRL_MEM_READ]),
        .if_id_rs1_addr(rs1_addr),
        .if_id_rs2_addr(rs2_addr),
        .stall(stall)
    );
    
    // Forwarding Unit
    forwarding_unit forwarding_unit (
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_reg_write(ex_mem_control_signals[`CTRL_REG_WRITE]),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_reg_write(mem_wb_control_signals[`CTRL_REG_WRITE]),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    
    // Debug connections
    assign debug_pc = if_id_pc;
    assign debug_instruction = if_id_instruction;
    assign debug_stall = stall;
    assign debug_flush = flush;
    
    // Register File (16 registers for RV32E)
    register_file #(
        .WIDTH(32),
        .DEPTH(32)  // RV32E usa apenas 16 registradores
    ) reg_file (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(mem_wb_rd_addr),
        .rd_data(wb_data),
        .reg_write(mem_wb_control_signals[`CTRL_REG_WRITE]),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .debug_registers(debug_registers)
    );

endmodule
