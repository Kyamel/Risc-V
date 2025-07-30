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
    output wire [1:0] forward_a,
    output wire [1:0] forward_b
);

/*    * Valores dos sinais de controle 'forward_a' e 'forward_b':
    * 00: Sem adiantamento. A ULA usa o valor vindo do banco de registradores (estágio ID).
    * 01: Adiantar do estágio EX/MEM. A ULA usa o resultado da instrução que está no estágio EX/MEM.
    * 10: Adiantar do estágio MEM/WB. A ULA usa o resultado da instrução que está no estágio MEM/WB.
*/


always @(*) begin

    // ---- Lógica para o A (rs1) ----

    if(ex_mem_regwrite && (ex_mem_rd != 5'b00000) && (ex_mem_rd == id_ex_rs1))begin
        forward_a = 2'b01; // adianta o estágio ex/mem
    end

    else if (mem_wb_regwrite && (mem_wb_rd != 5'b00000) && (mem_wb_rd == id_ex_rs1))begin
        forward_a = 2'b10; // adianta o estágio mem/wb
    end
    else begin
        forward_a = 2'b00; // sem adiantamento
    end

    // ---- Lógica para o B (rs2) ----

        if(ex_mem_regwrite && (ex_mem_rd != 5'b00000) && (ex_mem_rd == id_ex_rs2))begin
        forward_b = 2'b01; // adianta o estágio ex/mem
    end

    else if (mem_wb_regwrite && (mem_wb_rd != 5'b00000) && (mem_wb_rd == id_ex_rs2))begin
        forward_b = 2'b10; // adianta o estágio mem/wb
    end
    else begin
        forward_b = 2'b00; // sem adiantamento
    end
    
end

