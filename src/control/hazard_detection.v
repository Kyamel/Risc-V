`timescale 1ns / 1ps
`include "core/constants.v"

module hazard_detection (
    // Sinais da instrução no estágio ID
    input wire [4:0] if_id_rs1_addr,  // Endereço do registrador fonte 1
    input wire [4:0] if_id_rs2_addr,  // Endereço do registrador fonte 2
    
    // Sinais da instrução no estágio EX (vindos do registrador ID/EX)
    input wire [4:0] id_ex_rd_addr,   // Endereço do registrador destino
    input wire id_ex_mem_read,        // Sinal CTRL_MEM_READ do estágio EX
    
    // Saída de controle
    output reg stall                  // Sinal de stall para o pipeline
);

    always @(*) begin
        // Hazard de load-use ocorre quando:
        // 1. Instrução em EX é um load (mem_read=1)
        // 2. O registrador destino não é x0
        // 3. O registrador destino é um dos operandos da instrução atual
        stall = id_ex_mem_read && 
               (id_ex_rd_addr != 5'b0) && 
               ((id_ex_rd_addr == if_id_rs1_addr) || (id_ex_rd_addr == if_id_rs2_addr));
    end

endmodule