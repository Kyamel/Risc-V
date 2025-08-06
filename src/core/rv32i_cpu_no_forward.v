`timescale 1ns / 1ps

// Include ALU definitions
`include "alu_defines.vh"

module rv32i_cpu_no_forward #(
    parameter TEST_PROGRAM = "compiler/program.hex"
) (
    input wire clk,
    input wire rst,
    
    // Pipeline control signals
    input wire stall,
    input wire flush,
    
    // Debug signals for testbench
    input wire [$clog2(32)-1:0] debug_reg_index,
    output wire [31:0] debug_reg_data,
    input wire [$clog2(1024)-1:0] debug_mem_index,
    output wire [31:0] debug_mem_data,
    
    // Pipeline stage outputs for debugging
    output wire [31:0] pc_if_out,
    output wire [31:0] instruction_if_out,
    output wire [31:0] pc_id_out,
    output wire [31:0] instruction_id_out,
    
    // ID Stage debug outputs
    output wire [6:0] opcode_out,
    output wire [4:0] rs1_out,
    output wire [4:0] rs2_out,
    output wire [4:0] rd_out,
    output wire [2:0] funct3_out,
    output wire [6:0] funct7_out,
    output wire [31:0] imm_data_out,
    output wire [31:0] read_data_1_out,
    output wire [31:0] read_data_2_out,
    
    // Control signals debug outputs
    output wire [1:0] ALUOp_out,
    output wire ALUSrc_out,
    output wire Branch_out,
    output wire MemRead_out,
    output wire MemWrite_out,
    output wire RegWrite_out,
    output wire MemtoReg_out,
    
    // EX Stage debug outputs
    output wire [31:0] ex_read_data_1_out,
    output wire [31:0] ex_read_data_2_out,
    output wire [31:0] ex_imm_data_out,
    output wire [31:0] ex_pc_out_out,
    output wire [4:0] ex_rs1_out,
    output wire [4:0] ex_rs2_out,
    output wire [4:0] ex_rd_out,
    output wire ex_ALUSrc_out,
    output wire [1:0] ex_ALUOp_out,
    output wire ex_Branch_out,
    output wire ex_MemRead_out,
    output wire ex_MemWrite_out,
    output wire ex_RegWrite_out,
    output wire ex_MemtoReg_out,
    output wire [31:0] alu_result_out,
    output wire alu_zero_out,
    output wire [31:0] alu_b_input_out,
    output wire [3:0] ALUOperation_out,
    output wire [31:0] ex_adder_out_out,
    
    // MEM Stage debug outputs
    output wire [31:0] mem_addr_out,
    output wire [31:0] mem_write_data_out,
    output wire [4:0] mem_rd_out,
    output wire [31:0] mem_adder_out_out,
    output wire mem_Branch_out,
    output wire mem_MemRead_out,
    output wire mem_MemWrite_out,
    output wire mem_RegWrite_out,
    output wire mem_MemtoReg_out,
    output wire [31:0] mem_read_data_out,
    
    // WB Stage debug outputs
    output wire [31:0] wb_read_data_out,
    output wire [31:0] wb_result_out,
    output wire [4:0] wb_rd_out,
    output wire wb_RegWrite_out,
    output wire wb_MemtoReg_out,
    output wire [31:0] wb_write_data_out
);

    // Internal signals
    wire [31:0] pc_if;
    wire [31:0] instruction_if;
    wire [31:0] pc_id;
    wire [31:0] instruction_id;
    
    // ID Stage signals
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_data;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    
    // Control signals from control unit
    wire [1:0] ALUOp;
    wire ALUSrc;
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire RegWrite;
    wire MemtoReg;
    
    // ID/EX Pipeline regs
    wire [31:0] ex_read_data_1;
    wire [31:0] ex_read_data_2;
    wire [31:0] ex_imm_data;
    wire [31:0] ex_pc_out;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;
    wire ex_ALUSrc;
    wire [1:0] ex_ALUOp;
    wire ex_Branch;
    wire ex_MemRead;
    wire ex_MemWrite;
    wire ex_RegWrite;
    wire ex_MemtoReg;

    // EX Stage signals
    wire [31:0] alu_result; 
    wire alu_zero;
    wire [31:0] alu_b_input;
    wire [3:0] ALUOperation;
    wire [31:0] ex_adder_out;
    
    // EX/MEM Pipeline regs
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire [4:0] mem_rd;
    wire [31:0] mem_adder_out;
    wire mem_Branch;
    wire mem_MemRead;
    wire mem_MemWrite;
    wire mem_RegWrite;
    wire mem_MemtoReg;
    
    // MEM Stage signals
    wire [31:0] mem_read_data;
    
    // MEM/WB Pipeline regs
    wire [31:0] wb_read_data;
    wire [31:0] wb_result;
    wire [4:0] wb_rd;
    wire wb_RegWrite;
    wire wb_MemtoReg;
    
    // WB Stage signals
    wire [31:0] wb_write_data;


    // Novo cálculo do próximo PC
    wire [31:0] pc_next;
    wire mem_alu_zero;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire        branch_taken;
    wire [31:0] pc_plus_4_if;

    // ========== IF Stage ==========
    pc_generator pc_gen (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next), // Simple increment for testing (no branch logic yet)
        .pc_out(pc_if)
    );
    
    instruction_memory #(
        .INIT_FILE(TEST_PROGRAM)
    ) instr_mem (
        .instr_addr(pc_if),
        .instr(instruction_if)
    );

    assign pc_plus_4 = pc_if + 4;
    
    // ========== IF/ID Pipeline Register ==========
    if_id if_id_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_if),
        .instr_in(instruction_if),
        .pc_out(pc_id),
        .instr_out(instruction_id)
    );

    // Assign instruction fields for ALU control
    assign funct3 = instruction_id[14:12];
    assign funct7 = instruction_id[31:25];
    
    // ========== ID Stage ==========
    instr_parser parser (
        .instr(instruction_id),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );
    
    control_unit ctrl_unit (
        .opcode(opcode),
        // EX stage control signals
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        // MEM stage control signals
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        // WB stage control signals
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg)
    );
    
    immediate_data_extractor imm_extractor (
        .instr(instruction_id),
        .imm_data(imm_data)
    );
    
    register_file #(
        .WIDTH(32),
        .DEPTH(32)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),            // Write back from WB stage
        .wd(wb_write_data),    // Write data from WB stage
        .rw(wb_RegWrite),      // Write enable from WB stage
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .debug_read_index(debug_reg_index),
        .debug_data_out(debug_reg_data)
    );
    
    // ========== ID/EX Pipeline Register ==========
    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // ID stage inputs
        .id_read_data_1(read_data_1),
        .id_read_data_2(read_data_2),
        .id_imm_data(imm_data),
        .id_pc_out(pc_id),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .id_rd(rd),
        // Control signals
        .id_ALUSrc(ALUSrc),
        .id_ALUOp(ALUOp),
        .id_Branch(Branch),
        .id_MemRead(MemRead),
        .id_MemWrite(MemWrite),
        .id_RegWrite(RegWrite),
        .id_MemtoReg(MemtoReg),
        // EX stage outputs
        .ex_read_data_1(ex_read_data_1),
        .ex_read_data_2(ex_read_data_2),
        .ex_imm_data(ex_imm_data),
        .ex_pc_out(ex_pc_out),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        // Control signals to EX/MEM/WB
        .ex_ALUSrc(ex_ALUSrc),
        .ex_ALUOp(ex_ALUOp),
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg)
    );

    
    
    // ========== EX Stage ==========
    alu_control alu_ctrl (
        .ALUOp(ex_ALUOp),
        .Funct({funct7, funct3}),
        .Op(ALUOperation)
    );

    // ALU input selection
    assign alu_b_input = ex_ALUSrc ? ex_imm_data : ex_read_data_2;
    // Forwarding logic is not implemented yet, so we use ex_read_data_2 directly
    
    alu alu_unit (
        .a(ex_read_data_1),
        .b(alu_b_input),
        .ALUOp(ALUOperation),
        .Result(alu_result),
        .Zero(alu_zero)
    );

     // PC
    assign branch_target = ex_pc_out + (ex_imm_data << 1); 
    
    // ========== EX/MEM Pipeline Register ==========
    ex_mem ex_mem_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // Control signals from EX stage
        .ex_Branch(ex_Branch),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_RegWrite(ex_RegWrite),
        .ex_MemtoReg(ex_MemtoReg),
        // Data from EX stage
        .ex_adder_out(branch_target),
        .ex_result(alu_result),
        .ex_alu_zero(alu_zero),
        .ex_rd(ex_rd),
        .ex_read_data_2_mux(ex_read_data_2), // No forwarding yet
        // Outputs to MEM stage
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_adder_out(mem_adder_out),
        .mem_alu_zero(mem_alu_zero), // Pass through ALU zero flag
        // Control signals to MEM stage
        .mem_Branch(mem_Branch),
        .mem_MemRead(mem_MemRead),
        .mem_MemWrite(mem_MemWrite),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg)
    );

    // Decisão de branch (AND entre zero flag e sinal de branch)
    assign branch_taken = mem_alu_zero & mem_Branch; // Branch decision based on ALU zero flag and branch control signal
    
    // MUX para seleção do próximo PC
    assign pc_next = branch_taken ? mem_adder_out : pc_plus_4;

    // ========== MEM Stage ==========
    data_memory #(
        .WIDTH(32),
        .DEPTH(1024),
        .INIT_FILE("none")
    ) data_mem (
        .clk(clk),
        .mem_addr(mem_addr),
        .write_data(mem_write_data),
        .mem_write(mem_MemWrite),
        .mem_read(mem_MemRead),
        .read_data(mem_read_data)
    );
    
    // Debug access to data memory
    assign debug_mem_data = data_mem.memory[debug_mem_index];
    
    // ========== MEM/WB Pipeline Register ==========
    mem_wb mem_wb_reg (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        // Inputs from MEM stage
        .mem_read_data(mem_read_data),
        .mem_result(mem_addr), // ALU result passed through
        .mem_rd(mem_rd),
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg),
        // Outputs to WB stage
        .wb_read_data(wb_read_data),
        .wb_result(wb_result),
        .wb_rd(wb_rd),
        .wb_RegWrite(wb_RegWrite),
        .wb_MemtoReg(wb_MemtoReg)
    );
    
    // ========== WB Stage ==========
    // Write-back data selection
    assign wb_write_data = wb_MemtoReg ? wb_read_data : wb_result;
    
   
    
    // ========== Debug Output Assignments ==========
    assign pc_if_out = pc_if;
    assign instruction_if_out = instruction_if;
    assign pc_id_out = pc_id;
    assign instruction_id_out = instruction_id;
    
    assign opcode_out = opcode;
    assign rs1_out = rs1;
    assign rs2_out = rs2;
    assign rd_out = rd;
    assign funct3_out = funct3;
    assign funct7_out = funct7;
    assign imm_data_out = imm_data;
    assign read_data_1_out = read_data_1;
    assign read_data_2_out = read_data_2;
    
    assign ALUOp_out = ALUOp;
    assign ALUSrc_out = ALUSrc;
    assign Branch_out = Branch;
    assign MemRead_out = MemRead;
    assign MemWrite_out = MemWrite;
    assign RegWrite_out = RegWrite;
    assign MemtoReg_out = MemtoReg;
    
    assign ex_read_data_1_out = ex_read_data_1;
    assign ex_read_data_2_out = ex_read_data_2;
    assign ex_imm_data_out = ex_imm_data;
    assign ex_pc_out_out = ex_pc_out;
    assign ex_rs1_out = ex_rs1;
    assign ex_rs2_out = ex_rs2;
    assign ex_rd_out = ex_rd;
    assign ex_ALUSrc_out = ex_ALUSrc;
    assign ex_ALUOp_out = ex_ALUOp;
    assign ex_Branch_out = ex_Branch;
    assign ex_MemRead_out = ex_MemRead;
    assign ex_MemWrite_out = ex_MemWrite;
    assign ex_RegWrite_out = ex_RegWrite;
    assign ex_MemtoReg_out = ex_MemtoReg;
    assign alu_result_out = alu_result;
    assign alu_zero_out = alu_zero;
    assign alu_b_input_out = alu_b_input;
    assign ALUOperation_out = ALUOperation;
    assign ex_adder_out_out = ex_adder_out;
    
    assign mem_addr_out = mem_addr;
    assign mem_write_data_out = mem_write_data;
    assign mem_rd_out = mem_rd;
    assign mem_adder_out_out = mem_adder_out;
    assign mem_Branch_out = mem_Branch;
    assign mem_MemRead_out = mem_MemRead;
    assign mem_MemWrite_out = mem_MemWrite;
    assign mem_RegWrite_out = mem_RegWrite;
    assign mem_MemtoReg_out = mem_MemtoReg;
    assign mem_read_data_out = mem_read_data;
    
    assign wb_read_data_out = wb_read_data;
    assign wb_result_out = wb_result;
    assign wb_rd_out = wb_rd;
    assign wb_RegWrite_out = wb_RegWrite;
    assign wb_MemtoReg_out = wb_MemtoReg;
    assign wb_write_data_out = wb_write_data;

endmodule