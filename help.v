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
    output wire [31:0] debug_registers [0:31],
    output wire [31:0] debug_dmem_out,
    output wire [31:0] debug_imem_out
);

    // ========== PIPELINE STAGE WIRES ==========
    
    // IF Stage
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] if_instruction;
    
    // IF/ID Pipeline Register
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
    // ID Stage  
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] immediate;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals;
    
    // ID/EX Pipeline Register
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rs1_data, id_ex_rs2_data;
    wire [31:0] id_ex_immediate;
    wire [4:0] id_ex_rd_addr, id_ex_rs1_addr, id_ex_rs2_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control;
    wire id_ex_valid;
    
    // EX Stage
    wire [31:0] alu_input_a, alu_input_b;
    wire [31:0] alu_result;
    wire alu_zero;
    wire branch_taken;
    wire [31:0] branch_target;
    
    // EX/MEM Pipeline Register  
    wire [31:0] ex_mem_pc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rs2_data;
    wire [4:0] ex_mem_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] ex_mem_control;
    wire ex_mem_valid;
    
    // MEM Stage
    wire [31:0] mem_read_data;
    
    // MEM/WB Pipeline Register
    wire [31:0] mem_wb_pc;
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [4:0] mem_wb_rd_addr;
    wire [`CONTROL_SIGNALS_WIDTH-1:0] mem_wb_control;
    wire mem_wb_valid;
    
    // WB Stage
    wire [31:0] wb_data;
    
    // ========== CONTROL SIGNALS ==========
    wire stall, flush;
    wire [1:0] forward_a, forward_b;
    
    // ========== MEMORY INTERFACES ==========
    wire [31:0] imem_addr, imem_data;
    wire imem_read;
    wire [31:0] dmem_addr, dmem_data_in, dmem_data_out;
    wire dmem_read, dmem_write;
    wire [3:0] dmem_byte_enable;

    // ========== MEMORY INSTANCES ==========
    
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

    // ========== REGISTER FILE ==========
    
    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) reg_file (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(mem_wb_rd_addr),
        .rd_data(wb_data),
        .reg_write(mem_wb_control[`CTRL_REG_WRITE] && mem_wb_valid),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .debug_registers(debug_registers)
    );

    // ========== PIPELINE STAGES ==========
    
    // IF Stage - Instruction Fetch
    if_stage_fixed if_stage (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read),
        .pc_out(pc_current),
        .instruction_out(if_instruction)
    );
    
    // IF/ID Pipeline Register
    if_id_register if_id_reg (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_current),
        .instruction_in(if_instruction),
        .valid_in(1'b1),
        .pc_out(if_id_pc),
        .instruction_out(if_id_instruction),
        .valid_out(if_id_valid)
    );
    
    // ID Stage - Instruction Decode  
    id_stage_fixed id_stage (
        .instruction(if_id_instruction),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .immediate(immediate),
        .control_signals(control_signals)
    );
    
    // ID/EX Pipeline Register
    id_ex_register id_ex_reg (
        .clk(clk),
        .reset(reset),
        .stall(1'b0), // EX stage doesn't stall
        .flush(flush),
        .pc_in(if_id_pc),
        .rs1_data_in(rs1_data),
        .rs2_data_in(rs2_data),
        .immediate_in(immediate),
        .rd_addr_in(rd_addr),
        .rs1_addr_in(rs1_addr),
        .rs2_addr_in(rs2_addr),
        .control_in(control_signals),
        .valid_in(if_id_valid && !stall),
        .pc_out(id_ex_pc),
        .rs1_data_out(id_ex_rs1_data),
        .rs2_data_out(id_ex_rs2_data),
        .immediate_out(id_ex_immediate),
        .rd_addr_out(id_ex_rd_addr),
        .rs1_addr_out(id_ex_rs1_addr),
        .rs2_addr_out(id_ex_rs2_addr),
        .control_out(id_ex_control),
        .valid_out(id_ex_valid)
    );
    
    // EX Stage - Execute
    ex_stage_fixed ex_stage (
        .pc(id_ex_pc),
        .rs1_data(id_ex_rs1_data),
        .rs2_data(id_ex_rs2_data),
        .immediate(id_ex_immediate),
        .control_signals(id_ex_control),
        .forward_a(forward_a),
        .forward_b(forward_b),
        .forward_data_ex(ex_mem_alu_result),
        .forward_data_mem(wb_data),
        .alu_result(alu_result),
        .alu_zero(alu_zero),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .alu_input_a(alu_input_a),
        .alu_input_b(alu_input_b)
    );
    
    // EX/MEM Pipeline Register
    ex_mem_register ex_mem_reg (
        .clk(clk),
        .reset(reset),
        .pc_in(id_ex_pc),
        .alu_result_in(alu_result),
        .rs2_data_in(alu_input_b), // Use forwarded data
        .rd_addr_in(id_ex_rd_addr),
        .control_in(id_ex_control),
        .valid_in(id_ex_valid),
        .pc_out(ex_mem_pc),
        .alu_result_out(ex_mem_alu_result),
        .rs2_data_out(ex_mem_rs2_data),
        .rd_addr_out(ex_mem_rd_addr),
        .control_out(ex_mem_control),
        .valid_out(ex_mem_valid)
    );
    
    // MEM Stage - Memory Access
    mem_stage_fixed mem_stage (
        .alu_result(ex_mem_alu_result),
        .rs2_data(ex_mem_rs2_data),
        .control_signals(ex_mem_control),
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .mem_read_data(mem_read_data)
    );
    
    // MEM/WB Pipeline Register
    mem_wb_register mem_wb_reg (
        .clk(clk),
        .reset(reset),
        .pc_in(ex_mem_pc),
        .alu_result_in(ex_mem_alu_result),
        .mem_data_in(mem_read_data),
        .rd_addr_in(ex_mem_rd_addr),
        .control_in(ex_mem_control),
        .valid_in(ex_mem_valid),
        .pc_out(mem_wb_pc),
        .alu_result_out(mem_wb_alu_result),
        .mem_data_out(mem_wb_mem_data),
        .rd_addr_out(mem_wb_rd_addr),
        .control_out(mem_wb_control),
        .valid_out(mem_wb_valid)
    );
    
    // WB Stage - Write Back
    assign wb_data = mem_wb_control[`CTRL_MEM_TO_REG] ? mem_wb_mem_data : mem_wb_alu_result;
    
    // ========== HAZARD DETECTION AND FORWARDING ==========
    
    hazard_detection hazard_unit (
        .if_id_rs1_addr(rs1_addr),
        .if_id_rs2_addr(rs2_addr),
        .id_ex_rd_addr(id_ex_rd_addr),
        .id_ex_mem_read(id_ex_control[`CTRL_MEM_READ]),
        .stall(stall)
    );
    
    forwarding_unit forward_unit (
        .id_ex_rs1_addr(id_ex_rs1_addr),
        .id_ex_rs2_addr(id_ex_rs2_addr),
        .ex_mem_rd_addr(ex_mem_rd_addr),
        .ex_mem_reg_write(ex_mem_control[`CTRL_REG_WRITE]),
        .mem_wb_rd_addr(mem_wb_rd_addr),
        .mem_wb_reg_write(mem_wb_control[`CTRL_REG_WRITE]),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    
    // Flush logic - branches cause pipeline flush
    assign flush = branch_taken;
    
    // ========== DEBUG OUTPUTS ==========
    assign debug_pc = if_id_pc;
    assign debug_instruction = if_id_instruction;
    assign debug_stall = stall;
    assign debug_flush = flush;

endmodule

// ========== SIMPLIFIED PIPELINE REGISTER MODULES ==========

module if_id_register (
    input wire clk, reset, stall, flush,
    input wire [31:0] pc_in, instruction_in,
    input wire valid_in,
    output reg [31:0] pc_out, instruction_out,
    output reg valid_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 32'h0;
            instruction_out <= 32'h00000013; // NOP
            valid_out <= 1'b0;
        end else if (!stall) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
            valid_out <= valid_in;
        end
    end
endmodule

module id_ex_register (
    input wire clk, reset, stall, flush,
    input wire [31:0] pc_in, rs1_data_in, rs2_data_in, immediate_in,
    input wire [4:0] rd_addr_in, rs1_addr_in, rs2_addr_in,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] control_in,
    input wire valid_in,
    output reg [31:0] pc_out, rs1_data_out, rs2_data_out, immediate_out,
    output reg [4:0] rd_addr_out, rs1_addr_out, rs2_addr_out,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] control_out,
    output reg valid_out
);
    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 32'h0;
            rs1_data_out <= 32'h0;
            rs2_data_out <= 32'h0;
            immediate_out <= 32'h0;
            rd_addr_out <= 5'h0;
            rs1_addr_out <= 5'h0;
            rs2_addr_out <= 5'h0;
            control_out <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else if (!stall) begin
            pc_out <= pc_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            immediate_out <= immediate_in;
            rd_addr_out <= rd_addr_in;
            rs1_addr_out <= rs1_addr_in;
            rs2_addr_out <= rs2_addr_in;
            control_out <= control_in;
            valid_out <= valid_in;
        end
    end
endmodule

// Similar pattern for ex_mem_register and mem_wb_register...

module if_stage_fixed (
    input wire clk, reset, stall, flush,
    input wire branch_taken,
    input wire [31:0] branch_target,
    output reg [31:0] imem_addr,
    input wire [31:0] imem_data,
    output wire imem_read,
    output wire [31:0] pc_out,
    output wire [31:0] instruction_out
);
    reg [31:0] pc_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'h0;
        else if (!stall) begin
            if (branch_taken)
                pc_reg <= branch_target;
            else
                pc_reg <= pc_reg + 4;
        end
    end
    
    assign imem_addr = pc_reg;
    assign imem_read = 1'b1;
    assign pc_out = pc_reg;
    assign instruction_out = imem_data;
endmodule

module id_stage_fixed (
    input wire [31:0] instruction,
    input wire [31:0] rs1_data, rs2_data,
    output wire [4:0] rs1_addr, rs2_addr, rd_addr,
    output wire [31:0] immediate,
    output wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals
);
    // Extract instruction fields
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20]; 
    assign rd_addr = instruction[11:7];
    
    // Control unit
    control_unit ctrl_unit (
        .instruction(instruction),
        .control_signals(control_signals)
    );
    
    // Immediate generator
    immediate_generator imm_gen (
        .instr(instruction),
        .imm_out(immediate)
    );
endmodule

module ex_stage_fixed (
    input wire [31:0] pc, rs1_data, rs2_data, immediate,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals,
    input wire [1:0] forward_a, forward_b,
    input wire [31:0] forward_data_ex, forward_data_mem,
    output wire [31:0] alu_result, alu_input_a, alu_input_b,
    output wire alu_zero, branch_taken,
    output wire [31:0] branch_target
);
    // Forwarding logic
    reg [31:0] forwarded_rs1, forwarded_rs2;
    always @(*) begin
        case (forward_a) 
            2'b00: forwarded_rs1 = rs1_data;
            2'b01: forwarded_rs1 = forward_data_ex;
            2'b10: forwarded_rs1 = forward_data_mem;
            default: forwarded_rs1 = rs1_data;
        endcase
        
        case (forward_b)
            2'b00: forwarded_rs2 = rs2_data;
            2'b01: forwarded_rs2 = forward_data_ex;
            2'b10: forwarded_rs2 = forward_data_mem;
            default: forwarded_rs2 = rs2_data;
        endcase
    end
    
    assign alu_input_a = forwarded_rs1;
    assign alu_input_b = control_signals[`CTRL_ALU_SRC] ? immediate : forwarded_rs2;
    
    // ALU
    alu alu_unit (
        .a(alu_input_a),
        .b(alu_input_b),
        .alu_control(control_signals[`CTRL_ALU_OP]),
        .result(alu_result),
        .zero(alu_zero)
    );
    
    // Branch logic (simplified)
    assign branch_taken = control_signals[`CTRL_BRANCH] && alu_zero; // Simple BEQ only
    assign branch_target = pc + immediate;
endmodule

module mem_stage_fixed (
    input wire [31:0] alu_result, rs2_data,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals,
    output wire [31:0] dmem_addr, dmem_data_out,
    input wire [31:0] dmem_data_in,
    output wire dmem_read, dmem_write,
    output wire [3:0] dmem_byte_enable,
    output wire [31:0] mem_read_data
);
    assign dmem_addr = alu_result;
    assign dmem_data_out = rs2_data;
    assign dmem_read = control_signals[`CTRL_MEM_READ];
    assign dmem_write = control_signals[`CTRL_MEM_WRITE];
    assign dmem_byte_enable = 4'b1111; // Word access only for now
    assign mem_read_data = dmem_data_in;
endmodule

// Add ex_mem_register and mem_wb_register following same pattern...
module ex_mem_register (
    input wire clk, reset,
    input wire [31:0] pc_in, alu_result_in, rs2_data_in,
    input wire [4:0] rd_addr_in,
    input wire [`CONTROL_SIGNALS_WIDTH-1:0] control_in,
    input wire valid_in,
    output reg [31:0] pc_out, alu_result_out, rs2_data_out,
    output reg [4:0] rd_addr_out,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] control_out,
    output reg valid_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'h0;
            alu_result_out <= 32'h0;
            rs2_data_out <= 32'h0;
            rd_addr_out <= 5'h0;
            control_out <= {`CONTROL_SIGNALS_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end else begin
            pc_out <= pc_in;
            alu_result_out <= alu_result_in;
            rs2_data_out <= rs2_data_in;
            rd_addr_out <= rd_addr_in;
            control_out <= control_in;
            valid_out <= valid_in;
        end
    end
endmodule

module mem_wb_register (
    input wire clk, reset,
    input wire [31:0] pc_in, alu_result_in, mem_data_in,
    input wire