`timescale 1ns / 1ps
`include "constants.v"

module forwarding_unit (
    // Interface com estágio ID/EX
    input wire [4:0] id_ex_src1_addr,  // Endereço do operando fonte 1
    input wire [4:0] id_ex_src2_addr,  // Endereço do operando fonte 2
    
    // Interface com estágio EX/MEM
    input wire [4:0] ex_mem_dest_addr, // Endereço de destino em EX/MEM
    input wire ex_mem_write_enable,    // Sinal de escrita em EX/MEM
    
    // Interface com estágio MEM/WB
    input wire [4:0] mem_wb_dest_addr, // Endereço de destino em MEM/WB
    input wire mem_wb_write_enable,    // Sinal de escrita em MEM/WB
    
    // Sinais de controle de forwarding
    output reg [1:0] operand1_forward, // Seleção para operando 1
    output reg [1:0] operand2_forward  // Seleção para operando 2
);

    // Códigos de seleção para forwarding
    localparam NO_FORWARD = 2'b00;
    localparam FORWARD_FROM_EX = 2'b01;
    localparam FORWARD_FROM_MEM = 2'b10;

    always @(*) begin
        // Valores padrão - sem forwarding
        operand1_forward = NO_FORWARD;
        operand2_forward = NO_FORWARD;
        
        // ========== Lógica de forwarding para operando 1 ==========
        // Prioridade para forwarding do estágio EX/MEM (dado mais recente)
        if (ex_mem_write_enable && 
            (ex_mem_dest_addr != 5'b0) && 
            (ex_mem_dest_addr == id_ex_src1_addr)) begin
            operand1_forward = FORWARD_FROM_EX;
        end
        // Forwarding do estágio MEM/WB se aplicável
        else if (mem_wb_write_enable && 
                (mem_wb_dest_addr != 5'b0) && 
                (mem_wb_dest_addr == id_ex_src1_addr)) begin
            operand1_forward = FORWARD_FROM_MEM;
        end
        
        // ========== Lógica de forwarding para operando 2 ==========
        if (ex_mem_write_enable && 
            (ex_mem_dest_addr != 5'b0) && 
            (ex_mem_dest_addr == id_ex_src2_addr)) begin
            operand2_forward = FORWARD_FROM_EX;
        end
        else if (mem_wb_write_enable && 
                (mem_wb_dest_addr != 5'b0) && 
                (mem_wb_dest_addr == id_ex_src2_addr)) begin
            operand2_forward = FORWARD_FROM_MEM;
        end
    end

endmodule