`timescale 1ns / 1ps
`include "constants.v"

module sim (
    input wire clk,              // Clock externo vindo do Verilator
    input wire reset,           // Reset externo
    input wire step,            // Pulso de step

    // Interfaces de memória
    input wire [31:0] imem_data,
    output wire [31:0] imem_addr,
    output wire imem_read_en,

    input wire [31:0] dmem_data_in,
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_data_out,
    output wire dmem_read_en,
    output wire dmem_write_en,
    output wire [3:0] dmem_byte_en,

    // Debug direto em C++
    output wire [31:0] registers [0:31],
    output wire [31:0] current_pc,
    output wire [31:0] current_instruction,
    output wire [4:0] current_rd,
    output wire [31:0] current_rd_value,
    output wire reg_write_enable
);

    // Geração de pulso de clock por step
    reg cpu_clk = 0;
    reg last_step = 0;

    always @(posedge clk) begin
        if (reset) begin
            cpu_clk <= 0;
            last_step <= 0;
        end else begin
            cpu_clk <= step && !last_step;
            last_step <= step;
        end
    end

    // Sinais internos do processador
    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire debug_stall;
    wire debug_flush;
    wire [31:0] debug_dmem_out;
    wire [31:0] debug_imem_out;

    // Instância do processador
    rv32i_cpu cpu (
        .clk(cpu_clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_stall(debug_stall),
        .debug_flush(debug_flush),
        .debug_registers(registers),
        .debug_dmem_out(debug_dmem_out),
        .debug_imem_out(debug_imem_out),


    );

    // Exposição dos sinais de debug externos
    assign current_pc = debug_pc;
    assign current_instruction = debug_instruction;

    assign current_rd = cpu.mem_wb_rd_addr;
    assign current_rd_value = cpu.mem_wb_control_signals[`CTRL_MEM_TO_REG] ?
                               cpu.mem_wb_mem_data :
                               cpu.mem_wb_alu_result;
    assign reg_write_enable = cpu.mem_wb_control_signals[`CTRL_REG_WRITE];

endmodule
