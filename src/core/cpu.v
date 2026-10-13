`timescale 1ns / 1ps
`include "alu_defines.vh"

// RV32E 5-stage pipeline (IF, ID, EX, MEM, WB).
//
// - RV32E: 16 registers (x0-x15). An instruction naming x16-x31 is reserved in
//   RV32E; with no trap support yet, it becomes a bubble (no effect) and
//   illegal_reg is raised while it is in ID.
// - Forwarding from EX/MEM and MEM/WB into EX; the register file returns the
//   value being written in the same cycle (WB -> ID).
// - Load-use hazard: 1 stall cycle (PC and IF/ID hold, bubble into ID/EX).
// - Branches and jumps are resolved in EX; when taken, the two younger
//   instructions (in IF/ID and ID/EX) are flushed.
module rv32e_cpu #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_DEPTH = 1024,
    parameter INSTR_INIT_FILE = "",
    parameter DATA_DEPTH = 1024,
    parameter DATA_INIT_FILE = "none",
    parameter REG_COUNT = 16
)(
    input wire clk,
    input wire rst
);

// =======================
// Stage 1: IF
// =======================

wire [31:0] pc_out;          // PC of the instruction in IF
wire [31:0] pc_next;
wire        redirect;        // Taken branch or jump in EX (driven in stage 3)
wire [31:0] redirect_target; // Branch/jump target (driven in stage 3)
wire        flush;           // Discard the two youngest instructions (IF/ID and ID/EX)
wire        stall;           // Load-use: hold PC and IF/ID, bubble into ID/EX

pc_generator pc_gen (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

// A redirect from EX has priority; on stall the PC holds.
// (redirect and stall never happen together: a stall needs a load in EX.)
assign pc_next = redirect ? redirect_target :
                 stall    ? pc_out :
                            pc_out + 32'd4;

assign flush = redirect;

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
// Stage 2: ID
// =======================

wire [31:0] id_pc;
wire [INSTR_WIDTH-1:0] id_instr;

if_id if_id_reg (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .flush(flush),
    .instr_in(instruction),
    .pc_in(pc_out),
    .instr_out(id_instr),
    .pc_out(id_pc)
);

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

wire [31:0] imm_data;

// Instruction names a register that does not exist (x16-x31 in RV32E).
// instr_parser already zeroes the fields an instruction format does not use.
wire illegal_reg = ({27'b0, rs1} >= REG_COUNT) ||
                   ({27'b0, rs2} >= REG_COUNT) ||
                   ({27'b0, rd}  >= REG_COUNT);

immediate_data_extractor imm_extract (
    .instr(id_instr),
    .imm_data(imm_data)
);

// Register file (written by WB)
wire [31:0] read_data_1;
wire [31:0] read_data_2;
wire [4:0]  mem_wb_rd;
wire        mem_wb_RegWrite;
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
    .read_data_2(read_data_2),
    .debug_read_index({$clog2(REG_COUNT){1'b0}}),
    .debug_data_out()
);

wire [1:0] ALUOp;
wire ALUSrc;
wire ALUSrcA;
wire Branch;
wire Jump;
wire JumpReg;
wire MemRead;
wire MemWrite;
wire RegWrite;
wire MemtoReg;

control_unit ctrl_unit (
    .opcode(opcode),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .ALUSrcA(ALUSrcA),
    .Branch(Branch),
    .Jump(Jump),
    .JumpReg(JumpReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg)
);

// =======================
// Stage 3: EX
// =======================

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
wire id_ex_ALUSrcA;
wire [1:0] id_ex_ALUOp;
wire id_ex_Branch;
wire id_ex_Jump;
wire id_ex_JumpReg;
wire id_ex_MemRead;
wire id_ex_MemWrite;
wire id_ex_RegWrite;
wire id_ex_MemtoReg;

// On stall the instruction stays in ID (IF/ID holds) and EX gets a bubble.
// An illegal instruction also turns into a bubble.
id_ex id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .flush(flush | stall | illegal_reg),
    .id_read_data_1(read_data_1),
    .id_read_data_2(read_data_2),
    .id_imm_data(imm_data),
    .id_pc_out(id_pc),
    .id_rs1(rs1),
    .id_rs2(rs2),
    .id_rd(rd),
    .id_funct3(funct3),
    .id_funct7(funct7),
    .id_ALUOp(ALUOp),
    .id_ALUSrc(ALUSrc),
    .id_ALUSrcA(ALUSrcA),
    .id_Branch(Branch),
    .id_Jump(Jump),
    .id_JumpReg(JumpReg),
    .id_MemRead(MemRead),
    .id_MemWrite(MemWrite),
    .id_RegWrite(RegWrite),
    .id_MemtoReg(MemtoReg),
    .ex_read_data_1(id_ex_read_data_1),
    .ex_read_data_2(id_ex_read_data_2),
    .ex_imm_data(id_ex_imm_data),
    .ex_pc_out(id_ex_pc),
    .ex_rs1(id_ex_rs1),
    .ex_rs2(id_ex_rs2),
    .ex_rd(id_ex_rd),
    .ex_funct3(id_ex_funct3),
    .ex_funct7(id_ex_funct7),
    .ex_ALUOp(id_ex_ALUOp),
    .ex_ALUSrc(id_ex_ALUSrc),
    .ex_ALUSrcA(id_ex_ALUSrcA),
    .ex_Branch(id_ex_Branch),
    .ex_Jump(id_ex_Jump),
    .ex_JumpReg(id_ex_JumpReg),
    .ex_MemRead(id_ex_MemRead),
    .ex_MemWrite(id_ex_MemWrite),
    .ex_RegWrite(id_ex_RegWrite),
    .ex_MemtoReg(id_ex_MemtoReg)
);

// Load-use hazard: the instruction in ID needs a register that the load in EX
// has not read from memory yet. Wait 1 cycle; the value then arrives through
// MEM/WB forwarding.
hazard_detection_unit hazard_detect (
    .id_ex_mem_read(id_ex_MemRead),
    .id_ex_rd(id_ex_rd),
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),
    .pc_write(),
    .if_id_write(),
    .stall(stall)
);

// Forwarding
wire [1:0]  forward_a;
wire [1:0]  forward_b;
wire [31:0] ex_mem_alu_result; // Result in MEM (EX/MEM forwarding source)
wire [4:0]  ex_mem_rd;
wire        ex_mem_RegWrite;

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

wire [31:0] forward_mux_a;
wire [31:0] forward_mux_b;

assign forward_mux_a = (forward_a == 2'b00) ? id_ex_read_data_1 :
                       (forward_a == 2'b01) ? write_data_mux :
                       (forward_a == 2'b10) ? ex_mem_alu_result : 32'b0;

assign forward_mux_b = (forward_b == 2'b00) ? id_ex_read_data_2 :
                       (forward_b == 2'b01) ? write_data_mux :
                       (forward_b == 2'b10) ? ex_mem_alu_result : 32'b0;

// ALU
wire [31:0] alu_a;
wire [31:0] alu_b;

assign alu_a = (id_ex_ALUSrcA) ? id_ex_pc : forward_mux_a;
assign alu_b = (id_ex_ALUSrc) ? id_ex_imm_data : forward_mux_b;

wire [3:0] Operation;
alu_control alu_controler (
    .ALUOp(id_ex_ALUOp),
    .Funct({id_ex_funct7[6:0], id_ex_funct3[2:0]}),
    .Op(Operation)
);

wire [31:0] alu_result;
wire alu_zero;
alu main_alu (
    .a(alu_a),
    .b(alu_b),
    .ALUOp(Operation),
    .Result(alu_result),
    .Zero(alu_zero)
);

// Branches and jumps
wire branch_taken;
branch_decision_unit branch_decision (
    .branch_signal(id_ex_Branch),
    .jump_signal(id_ex_Jump),
    .funct3(id_ex_funct3),
    .rs1_data(forward_mux_a),
    .rs2_data(forward_mux_b),
    .branch_taken(branch_taken),
    .jump_taken()
);

assign redirect = branch_taken | id_ex_Jump;
// JALR: (rs1 + imm) & ~1, the sum is done by the ALU. Branch/JAL: PC + imm.
assign redirect_target = (id_ex_JumpReg) ? (alu_result & ~32'd1) : (id_ex_pc + id_ex_imm_data);

// JAL/JALR write PC + 4 to rd; everything else writes the ALU result.
wire [31:0] ex_result;
assign ex_result = (id_ex_Jump) ? (id_ex_pc + 32'd4) : alu_result;

// =======================
// Stage 4: MEM
// =======================

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
    .ex_Branch(id_ex_Branch),
    .ex_Jump(id_ex_Jump),
    .ex_MemRead(id_ex_MemRead),
    .ex_MemWrite(id_ex_MemWrite),
    .ex_RegWrite(id_ex_RegWrite),
    .ex_MemtoReg(id_ex_MemtoReg),
    .ex_adder_out(redirect_target),
    .ex_result(ex_result),
    .ex_alu_zero(alu_zero),
    .ex_rd(id_ex_rd),
    .ex_read_data_2_mux(forward_mux_b),
    .mem_addr(ex_mem_alu_result),
    .mem_alu_zero(ex_mem_alu_zero),
    .mem_write_data(ex_mem_write_data),
    .mem_rd(ex_mem_rd),
    .mem_adder_out(),
    .mem_Branch(ex_mem_Branch),
    .mem_Jump(ex_mem_Jump),
    .mem_MemRead(ex_mem_MemRead),
    .mem_MemWrite(ex_mem_MemWrite),
    .mem_RegWrite(ex_mem_RegWrite),
    .mem_MemtoReg(ex_mem_MemtoReg)
);

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
// Stage 5: WB
// =======================

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

assign write_data_mux = (mem_wb_MemtoReg) ? mem_wb_read_data : mem_wb_result;

// =======================
// Debug
// =======================

// PC and instruction of each stage, for the trace/testbench only (no effect on
// the logic). IF and ID already exist (pc_out/instruction, id_pc/id_instr);
// these follow the same stall/flush as the pipeline registers above.
// instr == 0 is a bubble.
reg [31:0] dbg_ex_pc,  dbg_ex_instr;
reg [31:0] dbg_mem_pc, dbg_mem_instr;
reg [31:0] dbg_wb_pc,  dbg_wb_instr;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dbg_ex_pc  <= 32'b0; dbg_ex_instr  <= 32'b0;
        dbg_mem_pc <= 32'b0; dbg_mem_instr <= 32'b0;
        dbg_wb_pc  <= 32'b0; dbg_wb_instr  <= 32'b0;
    end else begin
        if (flush || stall || illegal_reg) begin
            dbg_ex_pc <= 32'b0; dbg_ex_instr <= 32'b0;
        end else begin
            dbg_ex_pc <= id_pc; dbg_ex_instr <= id_instr;
        end
        dbg_mem_pc <= dbg_ex_pc;  dbg_mem_instr <= dbg_ex_instr;
        dbg_wb_pc  <= dbg_mem_pc; dbg_wb_instr  <= dbg_mem_instr;
    end
end

endmodule
