`timescale 1ns / 1ps
`include "alu_defines.vh"

module rv32i_cpu #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_DEPTH = 1014,
    parameter INSTR_INIT_FILE = "compiler/program.hex",
    parameter DATA_DEPTH = 1024,
    parameter DATA_INIT_FILE = "none",
    parameter REG_COUNT = 32
)(
    input wire clk,
    input wire rst
);

// =======================
// Stage 1
// =======================

// -----------------------
// PC
// -----------------------

wire [31:0] pc_out; // Output PC
wire [31:0] pc_next; // Program Counter input
wire [31:0] branch_target; // Declare missing wire
wire flush;

pc_generator pc_gen (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

// Declare pc_branch_taken wire before using it
wire pc_branch_taken;

// PC next logic - FIXED
assign pc_next = (pc_branch_taken) ? branch_target : (pc_out + 4);
//assign pc_next = (jump)                     ? branch_target :
//                 (branch && pc_branch_taken)   ? branch_target :
//                                              (pc_out + 4);

assign flush = (pc_branch_taken);


// -----------------------
// Instruction Memory
// -----------------------

wire [INSTR_WIDTH-1:0] instruction;
instruction_memory #(
    .WIDTH(INSTR_WIDTH),
    .DEPTH(INSTR_DEPTH),
    .INIT_FILE(INSTR_INIT_FILE)
) instr_mem (
    .instr_addr(pc_out),
    .instr(instruction)
);

// =======================
// Stage 2
// =======================

// -----------------------
// IF/ID Pipeline Register
// -----------------------

wire [31:0] id_pc; 
wire [INSTR_WIDTH-1:0] id_instr; 

if_id if_id_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .flush(flush),
    .instr_in(instruction),
    .pc_in(pc_out),
    .instr_out(id_instr),
    .pc_out(id_pc)
);

// -----------------------
// Instruction Parser
// -----------------------

wire [6:0] opcode; 
wire [4:0] rs1, rs2, rd; 
wire [2:0] funct3; 
wire [6:0] funct7; 

instr_parser instr_parse (
    .instr(id_instr),
    .opcode(opcode),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7)
);

// ------------------------
// Immediate Data Extractor
// ------------------------

wire [31:0] imm_data; 

immediate_data_extractor imm_extract (
    .instr(id_instr),
    .imm_data(imm_data)
);

// -----------------------
// Register File
// -----------------------

wire [31:0] read_data_1; 
wire [31:0] read_data_2; 

// WB stage signals
wire [4:0] mem_wb_rd;
wire mem_wb_RegWrite;
wire [31:0] write_data_mux;

register_file #(
    .WIDTH(32),
    .DEPTH(REG_COUNT)
) reg_file (
    .clk(clk),
    .rst(rst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),
    .wd(write_data_mux),
    .rw(mem_wb_RegWrite),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2)
);

// -----------------------
// Control Unit
// -----------------------

wire [1:0] ALUOp; 
wire ALUSrc;
wire Branch;
wire Jump;
wire MemRead;
wire MemWrite;
wire RegWrite;
wire MemtoReg;

control_unit ctrl_unit (
    .opcode(opcode),
    // EX stage control signals
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    // MEM stage control signals
    .Branch(Branch),
    .Jump(Jump),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    // WB stage control signals
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg)
);

// =======================
// Stage 3
// =======================

// -----------------------
// ID/EX Pipeline Register
// -----------------------

wire [31:0] id_ex_read_data_1;
wire [31:0] id_ex_read_data_2;
wire [31:0] id_ex_imm_data;
wire [31:0] id_ex_pc;
wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;
wire [4:0] id_ex_rd;
wire [2:0] id_ex_funct3;
wire [6:0] id_ex_funct7;

wire id_ex_ALUSrc;
wire [1:0] id_ex_ALUOp;
wire id_ex_Branch;
wire id_ex_Jump;
wire id_ex_MemRead;
wire id_ex_MemWrite;
wire id_ex_RegWrite;
wire id_ex_MemtoReg;

id_ex id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .flush(flush),
    // Dados do ID
    .id_read_data_1(read_data_1),
    .id_read_data_2(read_data_2),
    .id_imm_data(imm_data),
    .id_pc_out(id_pc),
    .id_rs1(rs1),
    .id_rs2(rs2),
    .id_rd(rd),
    .id_funct3(funct3),
    .id_funct7(funct7),
    // Sinais de controle do ID
    .id_ALUOp(ALUOp),
    .id_ALUSrc(ALUSrc),
    .id_Branch(Branch),
    .id_Jump(Jump),
    .id_MemRead(MemRead),
    .id_MemWrite(MemWrite),
    .id_RegWrite(RegWrite),
    .id_MemtoReg(MemtoReg),
    // Saídas para o estágio EX
    .ex_read_data_1(id_ex_read_data_1),
    .ex_read_data_2(id_ex_read_data_2),
    .ex_imm_data(id_ex_imm_data),
    .ex_pc_out(id_ex_pc),
    .ex_rs1(id_ex_rs1),
    .ex_rs2(id_ex_rs2),
    .ex_rd(id_ex_rd),
    .ex_funct3(id_ex_funct3),
    .ex_funct7(id_ex_funct7),
    // Sinais de controle do EX
    .ex_ALUOp(id_ex_ALUOp),
    .ex_ALUSrc(id_ex_ALUSrc),
    .ex_Branch(id_ex_Branch),
    .ex_Jump(id_ex_Jump),
    .ex_MemRead(id_ex_MemRead),
    .ex_MemWrite(id_ex_MemWrite),
    .ex_RegWrite(id_ex_RegWrite),
    .ex_MemtoReg(id_ex_MemtoReg)
);

// -----------------------
// Branch Address Calculation
// -----------------------

wire [31:0] shift_imm_data;
assign shift_imm_data = id_ex_imm_data << 1;
wire [31:0] branch_adder;
assign branch_adder = id_ex_pc + shift_imm_data;

// -----------------------
// Forwarding Unit
// -----------------------

wire [1:0] forward_a;
wire [1:0] forward_b;

// EX/MEM stage signals
wire [31:0] ex_mem_result;
wire [4:0] ex_mem_rd;
wire ex_mem_RegWrite;

forwarding_unit forward_unit (
    .EX_rs1(id_ex_rs1),
    .EX_rs2(id_ex_rs2),
    .MEM_rd(ex_mem_rd),
    .WB_rd(mem_wb_rd),
    .MEM_RegWrite(ex_mem_RegWrite),
    .WB_RegWrite(mem_wb_RegWrite),
    .ForwardA(forward_a),
    .ForwardB(forward_b)
);

// -----------------------
// Forwarding MUXes
// -----------------------

wire [31:0] forward_mux_a;
wire [31:0] forward_mux_b;

assign forward_mux_a = (forward_a == 2'b00) ? id_ex_read_data_1 :
                       (forward_a == 2'b01) ? write_data_mux :
                       (forward_a == 2'b10) ? ex_mem_result : 32'b0;

assign forward_mux_b = (forward_b == 2'b00) ? id_ex_read_data_2 :
                       (forward_b == 2'b01) ? write_data_mux :
                       (forward_b == 2'b10) ? ex_mem_result : 32'b0;

// -----------------------
// ALU Input MUXes
// -----------------------

wire [31:0] alu_a;
wire [31:0] alu_b;

assign alu_a = forward_mux_a;
assign alu_b = (id_ex_ALUSrc) ? id_ex_imm_data : forward_mux_b;

// -----------------------
// ALU Control
// -----------------------

wire [3:0] Operation;
alu_control alu_controler (
    .ALUOp(id_ex_ALUOp),
    .Funct({id_ex_funct7[6:0], id_ex_funct3[2:0]}), // FIXED: use id_ex signals
    .Op(Operation)
);

// -----------------------
// ALU
// -----------------------

wire [31:0] alu_result;
wire alu_zero;
alu main_alu (
    .a(alu_a),
    .b(alu_b),
    .ALUOp(Operation),
    .Result(alu_result),
    .Zero(alu_zero)
);

// =======================
// Stage 4
// =======================

// -----------------------
// EX/MEM Pipeline Register
// -----------------------

wire [31:0] ex_mem_alu_result;
wire ex_mem_alu_zero;
wire [31:0] ex_mem_write_data;
wire ex_mem_Branch;
wire ex_mem_Jump;
wire ex_mem_MemRead;
wire ex_mem_MemWrite;
wire ex_mem_MemtoReg;

ex_mem ex_mem_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .flush(1'b0),
    // MEM stage control signals
    .ex_Branch(id_ex_Branch),
    .ex_Jump(id_ex_Jump),
    .ex_MemRead(id_ex_MemRead),
    .ex_MemWrite(id_ex_MemWrite),
    // WB stage control signals
    .ex_RegWrite(id_ex_RegWrite),
    .ex_MemtoReg(id_ex_MemtoReg),
    // Entradas do estágio EX
    .ex_adder_out(branch_adder),
    .ex_result(alu_result),
    .ex_alu_zero(alu_zero),
    .ex_rd(id_ex_rd),
    .ex_read_data_2_mux(forward_mux_b),
    // Saídas para o estágio MEM
    .mem_addr(ex_mem_alu_result),
    .mem_alu_zero(ex_mem_alu_zero),
    .mem_write_data(ex_mem_write_data),
    .mem_rd(ex_mem_rd),
    .mem_adder_out(branch_target),
    // Control signals to MEM stage
    .mem_Branch(ex_mem_Branch),
    .mem_Jump(ex_mem_Jump),
    .mem_MemRead(ex_mem_MemRead),
    .mem_MemWrite(ex_mem_MemWrite),
    // Control signals to WB stage
    .mem_RegWrite(ex_mem_RegWrite),
    .mem_MemtoReg(ex_mem_MemtoReg)
);

// Branch taken logic - FIXED
assign pc_branch_taken = ex_mem_Branch & ex_mem_alu_zero;

// -----------------------
// Data Memory
// -----------------------

wire [31:0] mem_read_data;
data_memory #(
    .WIDTH(32),
    .DEPTH(DATA_DEPTH),
    .INIT_FILE(DATA_INIT_FILE)
) data_mem (
    .clk(clk),
    .mem_addr(ex_mem_alu_result),
    .write_data(ex_mem_write_data),
    .mem_write(ex_mem_MemWrite),
    .mem_read(ex_mem_MemRead),
    .read_data(mem_read_data)
);

// =======================
// Stage 5
// =======================

// -----------------------
// MEM/WB pipeline stage
// -----------------------

wire [31:0] mem_wb_read_data;
wire [31:0] mem_wb_result;
wire mem_wb_MemtoReg;

mem_wb mem_wb_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .flush(1'b0),
    .mem_read_data(mem_read_data),
    .mem_result(ex_mem_alu_result),
    .mem_rd(ex_mem_rd),
    .mem_RegWrite(ex_mem_RegWrite),
    .mem_MemtoReg(ex_mem_MemtoReg),
    .wb_read_data(mem_wb_read_data),
    .wb_result(mem_wb_result),
    .wb_rd(mem_wb_rd),
    .wb_RegWrite(mem_wb_RegWrite),
    .wb_MemtoReg(mem_wb_MemtoReg)
);

// WB MUX
assign write_data_mux = (mem_wb_MemtoReg) ? mem_wb_read_data : mem_wb_result;

endmodule