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