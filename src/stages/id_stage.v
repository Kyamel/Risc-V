`timescale 1ns / 1ps
`include "../core/constants.v"

module id_stage (
    input wire clk, rst,
    input wire [31:0] instruction,
    input wire [31:0] pc,
    
    // Interface com register file
    output wire [3:0] rs1_addr, rs2_addr,
    input wire [31:0] rs1_data, rs2_data,
    
    // Write back interface
    input wire [3:0] wb_rd_addr,
    input wire [31:0] wb_data,
    input wire wb_reg_write,
    
    // Outputs
    output wire [15:0] control_signals,
    output wire [31:0] immediate,
    output wire [3:0] rd_addr,
    output wire [31:0] rs1_data_out, rs2_data_out
);

    // Conexões internas
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    
    // Instanciação do control unit
    control_unit ctrl_unit (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .control_signals(control_signals)
    );
    
    // Instanciação do immediate generator
    immediate_generator imm_gen (
        .instr(instruction),
        .imm_out(immediate)
    );
    
    // Atribuição de endereços de registradores
    assign rs1_addr = instruction[19:16]; // rs1 para RV32E (4 bits)
    assign rs2_addr = instruction[23:20]; // rs2 para RV32E (4 bits)
    assign rd_addr = instruction[27:24];  // rd para RV32E (4 bits)
    
    // Bypass lógico para hazards de dados
    assign rs1_data_out = (wb_reg_write && (wb_rd_addr == rs1_addr) && (rs1_addr != 0)) 
                         ? wb_data : rs1_data;
    
    assign rs2_data_out = (wb_reg_write && (wb_rd_addr == rs2_addr) && (rs2_addr != 0)) 
                         ? wb_data : rs2_data;
    
    // Registros para pipeline (opcional, dependendo da implementação)
    reg [31:0] pc_reg;
    reg [31:0] instruction_reg;
    
    always @(posedge clk) begin
        if (rst) begin
            pc_reg <= 0;
            instruction_reg <= 0;
        end else begin
            pc_reg <= pc;
            instruction_reg <= instruction;
        end
    end

endmodule