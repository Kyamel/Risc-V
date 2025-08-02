`timescale 1ns / 1ps

module stall_controller (
    // --- Entradas de Eventos ---
    input wire load_use_hazard, 
    input wire branch_hazard,   
    input wire memory_busy,   

    // --- Saídas de Controle do Pipeline ---
    output reg pc_write_enable,   // 0 = Para o PC
    output reg if_id_write_enable,  // 0 = Para o registrador IF/ID
    output reg flush_ex           // 1 = Limpa o registrador ID/EX (insere uma bolha)
);

    always @(*) begin
        // A lógica de prioridade é importante. Stalls de memória e de dados
        // geralmente têm prioridade sobre flushes de controle.
        
        if (load_use_hazard || memory_busy) begin
            // **STALL**: Detectado um hazard de load-use OU a memória está ocupada.
            pc_write_enable   = 1'b0;
            if_id_write_enable = 1'b0;
            flush_ex          = 1'b0; // Não há flush, apenas stall
        end
        else if (branch_hazard) begin
            // **FLUSH**: Detectado um desvio. Limpa a instrução incorreta.
            pc_write_enable   = 1'b1;
            if_id_write_enable = 1'b1;
            flush_ex          = 1'b1;
        end
        else begin
            // **NORMAL**: Sem eventos, o pipeline opera normalmente.
            pc_write_enable   = 1'b1;
            if_id_write_enable = 1'b1;
            flush_ex          = 1'b0;
        end
    end

endmodule
