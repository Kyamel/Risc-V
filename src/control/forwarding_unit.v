module forwarding_unit (
    // Endereços de registradores
    input wire [3:0] ex_rs1, ex_rs2,
    input wire [3:0] mem_rd, wb_rd,
    
    // Sinais de controle
    input wire mem_reg_write, wb_reg_write,
    
    // Outputs de seleção
    output wire [1:0] forward_a,  // 00: ID/EX, 01: MEM/WB, 10: EX/MEM
    output wire [1:0] forward_b
);