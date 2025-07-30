module rv32e_cpu (
    input wire clk,
    input wire rst,
    
    // Interface de memória de instruções
    output wire [31:0] imem_addr,
    input wire [31:0] imem_data,
    
    // Interface de memória de dados
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    input wire [31:0] dmem_rdata,
    output wire dmem_we,
    output wire [3:0] dmem_be,
    
    // Sinais de debug
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instruction,
    output wire pipeline_stall,
    output wire pipeline_flush
);
