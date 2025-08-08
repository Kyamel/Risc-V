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

reg [31:0] pc_next = 0; // Program Counter
reg [31:0] pc_out ; // Output PC

pc_generator pc_gen (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

reg pc_branch_taken;
reg [31:0] pc_plus_4; // PC + 4
assign pc_plus_4 = pc_out + 4;
reg [31:0] pc_mux ; // MUX para o próximo PC
reg [31:0] ex_mem_adder_out; // Resultado do adder no estágio EX/MEM
assign pc_mux = (pc_branch_taken) ? ex_mem_adder_out : pc_plus_4;

// -----------------------
// Instruction Memory
// -----------------------

reg [INSTR_WIDTH-1:0] instruction; // Instrução buscada
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

reg [31:0] id_pc; // PC passado para o ID/EX
reg [INSTR_WIDTH-1:0] id_instr; // Instrução passada para o Intruction Parser

if_id if_id_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0), // TODO: Implementar controle de stall
    .flush(1'b0), // TODO: Implementar controle de flush
    .instr_in(instruction),
    .pc_in(pc_out),
    .instr_out(id_instr),
    .pc_out(id_pc)
);

// -----------------------
// Instruction Parser
// -----------------------

reg [6:0] opcode; // Opcode da instrução
reg [4:0] rs1, rs2, rd; // Registradores de origem
reg [2:0] funct3; // Função 3 da instrução
reg [6:0] funct7; // Função 7 da instrução

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

reg [31:0] imm_data; // Valor imediato extraído

immediate_data_extractor imm_extract (
    .instr(id_instr),
    .imm_data(imm_data)
);

// -----------------------
// Register File
// -----------------------

reg [4:0] wb_rd; // Registrador de destino para escrita MEM/WB
reg [31:0] wb_write_data; // Dado a ser escrito no registrador MEM/WB

reg [31:0] read_data_1; // Dado lido do registrador 1
reg [31:0] read_data_2; // Dado lido do registrador 2

reg [31:0] write_data_mux;  // WB MUX
reg [4:0] mem_wb_rd; // Registrador de destino do estágio MEM/WB

reg mem_wb_RegWrite; // Sinal de escrita no estágio ID/EX

register_file #(
    .WIDTH(32),
    .DEPTH(REG_COUNT)
) reg_file (
    .clk(clk),
    .rst(rst),

    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd), // WB stage
    .wd(write_data_mux), // WB stage
    .rw(mem_wb_RegWrite),  // AND from MEM stage

    .read_data_1(read_data_1),
    .read_data_2(read_data_2)
);

// -----------------------
// Control Unit
// -----------------------

reg [1:0] ALUOp; // Operação da ALU
reg ALUSrc; // Seleção da fonte da ALU
reg Branch; // Sinal de branch
reg Jump; // Sinal de jump
reg MemRead; // Sinal de leitura de memória
reg MemWrite; // Sinal de escrita de memória
reg RegWrite; // Sinal de escrita no registrador
reg MemtoReg; // Seleção de dados para escrita no registrador

// TODO: imm_src [1:0]
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

reg [31:0] id_ex_read_data_1; // Dado lido do registrador 1
reg [31:0] id_ex_read_data_2; // Dado lido do registrador 2
reg [31:0] id_ex_imm_data; // Dado imediato
reg [31:0] id_ex_pc; // PC atual
reg [4:0] id_ex_rs1; // Endereço do registrador rs1
reg [4:0] id_ex_rs2; // Endereço do registrador rs2
reg [4:0] id_ex_rd; // Endereço do registrador rd
reg [2:0] id_ex_funct3; // Função 3 da instrução
reg [6:0] id_ex_funct7; // Função 7 da instrução

reg id_ex_ALUSrc; // Controle do mux da ULA
reg [1:0] id_ex_ALUOp; // Controle da operação da ULA
reg id_ex_Branch; // Sinal de branch
reg id_ex_Jump; // Sinal de jump (JAL/JALR)
reg id_ex_MemRead; // Sinal de leitura de memória
reg id_ex_MemWrite; // Sinal de escrita em memória
reg id_ex_RegWrite; // Sinal de escrita no banco de registradores
reg id_ex_MemtoReg; // Controle do mux WB (memória ou ULA)

id_ex id_ex_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0), // TODO: Implementar controle de stall
    .flush(1'b0), // TODO: Implementar controle de flush

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
// Mux, Adder and Shift Left
// -----------------------

// branch PC
reg [31:0] shift_imm_data; // Dado imediato shiftado
assign shift_imm_data = id_ex_imm_data << 1; // Shift left para branch
reg [31:0] branch_adder; // Resultado do adder para branch
assign branch_adder = id_ex_pc + shift_imm_data; // PC + imediato shiftado
// -------------

// Forwarding Unit
// Detecta dependências de dados entre os estágios EX e MEM/WB
reg [1:0] forward_a;
reg [1:0] forward_b;
// TODO: ex_mem e wb_mem dependencies
reg [31:0] ex_mem_result; // Resultado da ULA no estágio EX/MEM
reg [4:0] ex_mem_rd; // Registrador de destino do estágio EX/MEM
reg ex_mem_MemWrite; // Sinal de escrita no estágio EX/MEM


// MEM/WB
reg mem_wb_MemtoReg;

forwarding_unit forward_unit (
    .EX_rs1(id_ex_rs1),
    .EX_rs2(id_ex_rs2),
    .MEM_rd(ex_mem_rd), // Registrador de destino do estágio MEM
    .WB_rd(mem_wb_rd), // Registrador de destino do estágio WB
    .MEM_RegWrite(ex_mem_MemWrite), // Sinal de escrita no estágio MEM
    .WB_RegWrite(mem_wb_RegWrite), // Sinal de escrita no estágio WB

    .ForwardA(forward_a),
    .ForwardB(forward_b)
);
// -----------------------

// MUX
reg [31:0] forward_mux_a; // MUX para dado A da ULA
reg [31:0] forward_mux_b; // MUX para dado B da ULA

always @(*) begin
    // Forward A (rs1)
    if (forward_a == 2'b00) begin
        forward_mux_a = id_ex_read_data_1;
    end else if (forward_a == 2'b01) begin
        forward_mux_a = wb_write_data; // Forward from WB
    end else if (forward_a == 2'b10) begin
        forward_mux_a = ex_mem_result; // Forward from MEM
    end else begin
        forward_mux_a = 32'b0; // Default case
    end

    if (forward_b == 2'b00) begin
        forward_mux_b = id_ex_read_data_2;
    end else if (forward_b == 2'b01) begin
        forward_mux_b = wb_write_data; // Forward from WB
    end else if (forward_b == 2'b10) begin
        forward_mux_b = ex_mem_result; // Forward from MEM
    end else begin
        forward_mux_b = 32'b0; // Default case
    end

end

reg [31:0] alu_a; // Dado A da ULA
reg [31:0] alu_b; // Dado B da ULA

assign alu_b = (id_ex_ALUSrc) ? id_ex_imm_data : forward_mux_b; // MUX para dado B da ULA 
assign alu_a = forward_mux_a;
// -----------------------

// -----------------------
// ALU Control
// -----------------------

reg [3:0] Operation;
alu_control alu_controler (
    .ALUOp(id_ex_ALUOp),
    .Funct({funct7[6:0], funct3[2:0]}),

    .Op(Operation)
);

// -----------------------
// ALU
// -----------------------

reg [31:0] alu_result;
reg alu_zero;
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

reg [31:0] ex_mem_alu_result;
reg ex_mem_alu_zero;
reg [31:0] ex_mem_write_data;

reg ex_mem_Branch;
reg ex_mem_Jump;
reg ex_mem_MemRead;
reg ex_mem_RegWrite;
reg ex_mem_MemtoReg;

// -----------------------
// EX/MEM Pipeline Register
// -----------------------

ex_mem ex_mem_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0), // TODO
    .flush(1'b0), // TODO
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
    .mem_adder_out(ex_mem_adder_out),
    // Control signals to MEM stage
    .mem_Branch(ex_mem_Branch),
    .mem_Jump(ex_mem_Jump),
    .mem_MemRead(ex_mem_MemRead),
    .mem_MemWrite(ex_mem_MemWrite),
    // Control signals to WB stage (passed through MEM stage)
    .mem_RegWrite(ex_mem_RegWrite),
    .mem_MemtoReg(ex_mem_MemtoReg)
);

// AND for RegWrite control
assign pc_branch_taken = ex_mem_alu_zero & ex_mem_RegWrite;

// -----------------------
// Data Memory
// -----------------------

reg [31:0] mem_read_data;
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

reg [31:0] mem_wb_read_data;
reg [31:0] mem_wb_result;


mem_wb mem_wb_reg (
    .clk(clk),
    .rst(rst),
    .stall(1'b0), // TODO
    .flush(1'b0), // TODO

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
assign write_data_mux = (mem_wb_RegWrite) ? mem_wb_read_data : ex_mem_alu_result;

endmodule