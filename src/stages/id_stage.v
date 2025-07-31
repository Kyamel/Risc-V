`timescale 1ns / 1ps
`include "constants.v"

module id_stage (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire flush,
    input wire if_id_valid,
    
    // Entradas do registro IF/ID
    input wire [31:0] if_id_pc,
    input wire [31:0] if_id_instruction,
    
    // Interface com register file
    output wire [4:0] rs1_addr,  // 5 bits para compatibilidade
    output wire [4:0] rs2_addr,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
    
    // Interface de writeback
    input wire [4:0] mem_wb_rd_addr,
    input wire [31:0] mem_wb_rd_data,
    input wire mem_wb_reg_write,
    
    // Registro ID/EX
    output reg [31:0] id_ex_pc,
    output reg [31:0] id_ex_instruction,
    output reg [31:0] id_ex_rs1_data,
    output reg [31:0] id_ex_rs2_data,
    output reg [31:0] id_ex_immediate,
    output reg [4:0] id_ex_rd_addr,
    output reg [4:0] id_ex_rs1_addr,
    output reg [4:0] id_ex_rs2_addr,
    output reg [`CONTROL_SIGNALS_WIDTH-1:0] id_ex_control_signals,
    output reg id_ex_valid
);

    // Extração de campos da instrução (5 bits para compatibilidade)
    wire [4:0] rs1_addr_full = if_id_instruction[19:15];
    wire [4:0] rs2_addr_full = if_id_instruction[24:20];
    wire [4:0] rd_addr_full  = if_id_instruction[11:7];
    
    // Conexão dos sinais de controle
    wire [`CONTROL_SIGNALS_WIDTH-1:0] control_signals;
    wire [31:0] immediate;
    
    // Instanciação da unidade de controle
    control_unit ctrl_unit (
        .instruction(if_id_instruction),
        .control_signals(control_signals)
    );
    
    // Gerador de imediatos
    immediate_generator imm_gen (
        .instr(if_id_instruction),
        .imm_out(immediate)
    );
    
    // Bypass lógico completo (considera WB e estágio MEM)
    wire [31:0] rs1_data_bypassed = (mem_wb_reg_write && mem_wb_rd_addr == rs1_addr_full && rs1_addr_full != 0) 
                                  ? mem_wb_rd_data : rs1_data;
    
    wire [31:0] rs2_data_bypassed = (mem_wb_reg_write && mem_wb_rd_addr == rs2_addr_full && rs2_addr_full != 0) 
                                  ? mem_wb_rd_data : rs2_data;
    
    

    // Atribuição das saídas para register file
    assign rs1_addr = rs1_addr_full;
    assign rs2_addr = rs2_addr_full;
    
    // Registro ID/EX
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_ex_pc <= 0;
            id_ex_instruction <= 32'h00000013; // NOP
            id_ex_rs1_data <= 0;
            id_ex_rs2_data <= 0;
            id_ex_immediate <= 0;
            id_ex_rd_addr <= 0;
            id_ex_rs1_addr <= 0;
            id_ex_rs2_addr <= 0;
            id_ex_control_signals <= 0;
            id_ex_valid <= 0;
        end else if (flush) begin
            // Flush: insere NOP
            id_ex_pc <= 0;
            id_ex_instruction <= 32'h00000013;
            id_ex_rs1_data <= 0;
            id_ex_rs2_data <= 0;
            id_ex_immediate <= 0;
            id_ex_rd_addr <= 0;
            id_ex_rs1_addr <= 0;
            id_ex_rs2_addr <= 0;
            id_ex_control_signals <= 0;
            id_ex_valid <= 0;
        end else if (!stall) begin
            // Propagação normal
            id_ex_pc <= if_id_pc;
            id_ex_instruction <= if_id_instruction;
            id_ex_rs1_data <= rs1_data_bypassed;
            id_ex_rs2_data <= rs2_data_bypassed;
            id_ex_immediate <= immediate;
            id_ex_rd_addr <= rd_addr_full;
            id_ex_rs1_addr <= rs1_addr_full;
            id_ex_rs2_addr <= rs2_addr_full;
            id_ex_control_signals <= control_signals;
            id_ex_valid <= if_id_valid;
        end
        // Em caso de stall, mantém os valores atuais
    end
endmodule