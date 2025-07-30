module hazard_detection (


    // Sinais da instrução no estágio ID
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    // Sinais da instrução no estágio EX (vindos do registrador ID/EX)
    input wire [4:0] ex_rd,
    input wire       ex_memread,

    // SINAL GENÉRICO: Verdadeiro se um branch for tomado OU se for uma instrução de jump (JAL, JALR)
    input wire       pc_redirect,

    // Sinais de Stall: param o pipeline por um ciclo
    output reg       pc_write_enable,   // 0 = Para o PC
    output reg       if_id_write_enable,  // 0 = Para o registrador IF/ID
    
    // Sinal de Flush: limpa uma instrução incorreta
    output reg       flush_ex           // 1 = Limpa o registrador ID/EX (insere uma bolha)
);

always @(*) begin

        // --- Condição de Hazard de Dados (Load-Use) ---
        // Ocorre se a instrução no estágio EX está lendo da memória (load) e seu
        // registrador de destino (ex_rd) é um dos fontes (id_rs1 ou id_rs2)
        // da instrução no estágio ID.
        wire load_use_hazard = ex_memread && (ex_rd != 5'b0) &&
                               ((ex_rd == id_rs1) || (ex_rd == id_rs2));

        // --- Lógica de Controle ---
        if (load_use_hazard) begin
            // **STALL**: Para o PC e o estágio IF/ID.
            pc_write_enable   = 1'b0;
            if_id_write_enable = 1'b0;
            flush_ex          = 1'b0; // Não há flush, apenas stall
        end
        else if (pc_redirect) begin
            // **FLUSH**: O desvio foi tomado. A instrução no estágio EX é inválida.
            pc_write_enable   = 1'b1; // Pipeline continua normalmente
            if_id_write_enable = 1'b1;
            flush_ex          = 1'b1; // Limpa a instrução errada que entrou em EX
        end
        else begin
            // **NORMAL**: Sem hazards, o pipeline opera normalmente.
            pc_write_enable   = 1'b1;
            if_id_write_enable = 1'b1;
            flush_ex          = 1'b0;
        end
    end
    
endmodule