`timescale 1ns / 1ps
`include "alu_defines.vh"

module rv32i_cpu #(
    parameter INSTR_WIDTH = 32,
    parameter INSTR_DEPTH = 256,
    parameter INSTR_INIT_FILE = "compiler/program.hex",
    parameter DATA_HEIGHT = 1024,
    parameter DATA_INIT_FILE = "none",
    parameter REG_COUNT = 32
)(
    input wire clk,
    input wire rst,
);

// =======================
// Stage 1
// =======================

// -----------------------
// PC
// -----------------------

reg pc_next [31:0]; // Program Counter
reg pc_out [31:0]; // Output PC

pc_generator pc_gen (
    .clk(clk),
    .rst(rst),
    .pc_in(pc_next),
    .pc_out(pc_out)
);

reg pc_plus_4 [31:0]; // PC + 4
assign pc_plus_4 = pc_out + 4;
reg pc_mux [31:0]; // MUX para o próximo PC
reg ex_mem_adder_out [31:0]; // Resultado do adder no estágio EX/MEM
assign pc_mux = (branch_taken) ? ex_mem_adder_out : pc_plus_4;

// -----------------------
// Instruction Memory
// -----------------------

reg instruction [INSTR_WIDTH-1:0]; // Instrução buscada
instruction_memory #(
    .WIDTH(INSTR_WIDTH),
    .DEPTH(INSTR_DEPTH),
    .INIT_FILE(INSTR_INIT_FILE)
) instr_mem (
    .instr_addr(pc_out),
    .inst(instruction)
);

// =======================
// Stage 2
// =======================

// -----------------------
// IF/ID Pipeline Register
// -----------------------

reg id_pc [31:0]; // PC passado para o ID/EX
reg id_instr [INSTR_WIDTH-1:0]; // Instrução passada para o Intruction Parser

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

reg [11:0] imm_data; // Valor imediato extraído

imm_extractor imm_extract (
    .instr(id_instr),
    .imm_data(imm_data)
);

// -----------------------
// Register File
// -----------------------

reg reg_write; // EX/MEM
reg wb_rd [4:0]; // Registrador de destino para escrita MEM/WB
reg wb_write_data [31:0]; // Dado a ser escrito no registrador MEM/WB

reg read_data_1 [31:0]; // Dado lido do registrador 1
reg read_data_2 [31:0]; // Dado lido do registrador 2

register_file #(
    .WIDTH(32),
    .DEPTH(REG_COUNT)
) reg_file (
    .clk(clk),
    .rst(rst),

    .rs1(rs1),
    .rs2(rs2),
    .rd(wb_rd), // TODO: Implementar controle de escrita
    .wd(wb_write_data), // TODO: Implementar controle de escrita
    .rw(reg_write), // TODO: Implementar controle de escrita

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

reg id_ex_read_data_1 [31:0]; // Dado lido do registrador 1
reg id_ex_read_data_2 [31:0]; // Dado lido do registrador 2
reg id_ex_imm_data [31:0]; // Dado imediato
reg id_ex_pc [31:0]; // PC atual
reg id_ex_rs1 [4:0]; // Endereço do registrador rs1
reg id_ex_rs2 [4:0]; // Endereço do registrador rs2
reg id_ex_rd [4:0]; // Endereço do registrador rd
reg id_ex_funct3 [2:0]; // Função 3 da instrução
reg id_ex_funct7 [6:0]; // Função 7 da instrução

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
    .id_pc(id_pc),
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
    .ex_pc(id_ex_pc),
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
reg shift_imm_data [31:0]; // Dado imediato shiftado
assign shift_imm_data = id_ex_imm_data << 1; // Shift left para branch
reg branch_adder [31:0]; // Resultado do adder para branch
assign branch_adder = id_ex_pc + shift_imm_data; // PC + imediato shiftado
// -------------

// Forwarding Unit
// Detecta dependências de dados entre os estágios EX e MEM/WB
reg forward_a [1:0];
reg forward_b [1:0];
// TODO: ex_mem e wb_mem dependencies
reg ex_mem_result [31:0]; // Resultado da ULA no estágio EX/MEM
reg ex_mem_rd [4:0]; // Registrador de destino do estágio EX/MEM
reg mem_wb_rd [4:0]; // Registrador de destino do estágio MEM/WB
reg ex_mem_MemWrite; // Sinal de escrita no estágio EX/MEM
reg id_ex_MemWrite; // Sinal de escrita no estágio ID/EX

forwarding_unit forward_unit (
    .EX_rs1(id_ex_rs1),
    .EX_rs2(id_ex_rs2),
    .MEM_rd(ex_mem_rd), // Registrador de destino do estágio MEM
    .WB_rd(mem_wb_rd), // Registrador de destino do estágio WB
    .MEM_RegWrite(ex_mem_MemWrite), // Sinal de escrita no estágio MEM
    .WB_RegWrite(id_ex_MemWrite), // Sinal de escrita no estágio WB

    .ForwardA(forward_a),
    .ForwardB(forward_b)
);
// -----------------------

// MUX
reg forward_mux_a [31:0]; // MUX para dado A da ULA
reg forward_mux_b [31:0]; // MUX para dado B da ULA

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

reg alu_a [31:0]; // Dado A da ULA
reg alu_b [31:0]; // Dado B da ULA

assign alu_b = (id_ex_ALUSrc) ? id_ex_imm_data : forward_mux_b; // MUX para dado B da ULA 
assign alu_a = forward_mux_a;
// -----------------------

// -----------------------
// ALU Control
// -----------------------

reg Operation [3:0];
alu_control alu_control (
    .ALUOp(ex_ALUOp),
    .Funct({funct7[6:0], funct3[2:0]}),

    .Op(Operation)
);

// -----------------------
// ALU
// -----------------------

reg alu_result [31:0];
reg alu_zero;
alu alu (
    .a(alu_a),
    .b(alu_b),
    .ALUOp(Operation),

    .Result(alu_result),
    .Zero(alu_zero)
);



// =======================
// Stage 4
// =======================

reg ex_mem_result [31:0];

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
    .ex_write_data(),
    .ex_rd(id_ex_rd),
    .ex_read_data_2_mux(forward_mux_b),

    // Saídas para o estágio MEM
    .mem_addr(),
    .mem

);
    // Saídas para o estágio MEM
    output reg [31:0]  mem_addr,           // Endereço para memória de dados (ALU Result)
    output reg        mem_alu_zero, 
    output reg [31:0]  mem_write_data,     // Dado para escrita na memória
    output reg [4:0]   mem_rd,             // Registrador destino (para WB e forwarding)
    output reg [31:0]  mem_adder_out,      // PC + offset (para cálculo de branch)
    
    // Control signals to MEM stage
    output reg        mem_Branch,          // Branch control to MEM stage
    output reg        mem_Jump,
    output reg        mem_MemRead,         // Memory read control to MEM stage
    output reg        mem_MemWrite,        // Memory write control to MEM stage
    
    // Control signals to WB stage (passed through MEM stage)
    output reg        mem_RegWrite,        // Register write control to WB stage
    output reg        mem_MemtoReg         // Memory-to-register mux control to WB stage
);
