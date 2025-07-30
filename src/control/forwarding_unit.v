module forwarding_unit (

    // Identificador do registrador vindo do estágio ID/EX
    input wire [4:0] id_ex_rs1,
    input wire [4:0] id_ex_rs2,

    // Identificador do registrador de destino e sinal de escrita vindo do estágio EX/MEM
    input wire [4:0] ex_mem_rd,
    input wire ex_mem_regwrite,
    
    // Identificador do registrador de destino e sinal de escrita vindo do estágio MEM/WB
    input wire [4:0] mem_wb_rd,
    input wire mem_wb_regwrite,
    
    // Outputs de seleção
    output wire [1:0] forward_a,  // 00: ID/EX, 01: MEM/WB, 10: EX/MEM
    output wire [1:0] forward_b
);