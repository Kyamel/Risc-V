module hazard_detection (
    // Endereços de registradores
    input wire [3:0] id_rs1, id_rs2,
    input wire [3:0] ex_rd, mem_rd, wb_rd,
    
    // Sinais de controle
    input wire ex_mem_read,
    input wire ex_reg_write, mem_reg_write, wb_reg_write,
    
    // Sinais de branch
    input wire branch_taken,
    input wire jump_taken,
    
    // Outputs
    output wire stall_if,
    output wire stall_id,
    output wire flush_id,
    output wire flush_ex,
    output wire pc_write_enable,
    output wire if_id_write_enable
);