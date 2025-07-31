`timescale 1ns / 1ps
`include "constants.v"

module forwarding_unit (
    // Interface com estágio ID/EX
    input wire [4:0] id_ex_rs1_addr,  // Endereço do operando fonte 1
    input wire [4:0] id_ex_rs2_addr,  // Endereço do operando fonte 2
    
    // Interface com estágio EX/MEM
    input wire [4:0] ex_mem_rd_addr,  // Endereço de destino em EX/MEM
    input wire ex_mem_reg_write,      // Sinal de escrita em EX/MEM
    
    // Interface com estágio MEM/WB
    input wire [4:0] mem_wb_rd_addr,  // Endereço de destino em MEM/WB
    input wire mem_wb_reg_write,      // Sinal de escrita em MEM/WB
    
    // Sinais de controle de forwarding
    output reg [1:0] forward_a,       // Seleção para operando 1
    output reg [1:0] forward_b        // Seleção para operando 2
);

    // Códigos de seleção para forwarding
    localparam NO_FORWARD = 2'b00;
    localparam FORWARD_FROM_EX = 2'b01;
    localparam FORWARD_FROM_MEM = 2'b10;

    always @(*) begin
        // Valores padrão - sem forwarding
        forward_a = NO_FORWARD;
        forward_b = NO_FORWARD;
        
        // ========== Lógica de forwarding para operando 1 ==========
        // Prioridade para forwarding do estágio EX/MEM (dado mais recente)
        if (ex_mem_reg_write && 
            (ex_mem_rd_addr != 5'b0) && 
            (ex_mem_rd_addr == id_ex_rs1_addr)) begin
            forward_a = FORWARD_FROM_EX;
        end
        // Forwarding do estágio MEM/WB se aplicável
        else if (mem_wb_reg_write && 
                (mem_wb_rd_addr != 5'b0) && 
                (mem_wb_rd_addr == id_ex_rs1_addr)) begin
            forward_a = FORWARD_FROM_MEM;
        end
        
        // ========== Lógica de forwarding para operando 2 ==========
        if (ex_mem_reg_write && 
            (ex_mem_rd_addr != 5'b0) && 
            (ex_mem_rd_addr == id_ex_rs2_addr)) begin
            forward_b = FORWARD_FROM_EX;
        end
        else if (mem_wb_reg_write && 
                (mem_wb_rd_addr != 5'b0) && 
                (mem_wb_rd_addr == id_ex_rs2_addr)) begin
            forward_b = FORWARD_FROM_MEM;
        end
    end
endmodule
