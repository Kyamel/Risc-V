module hazard_detection (
    // Sinais da instrução no estágio ID
    input wire [4:0] id_rs1_addr,
    input wire [4:0] id_rs2_addr,

    // Sinais da instrução no estágio EX (vindos do registrador ID/EX)
    input wire [4:0] ex_rd_addr,
    input wire       ex_memread, // Sinal de controle que indica uma instrução de load

    // Saída de aviso
    output wire      load_use_hazard
);

    // A condição de hazard de "load-use" ocorre se a instrução no estágio EX
    // é um load e seu registrador de destino é um dos fontes da instrução no estágio ID.
    assign load_use_hazard = ex_memread && (ex_rd_addr != 5'b0) &&
                           ((ex_rd_addr == id_rs1_addr) || (ex_rd_addr == id_rs2_addr));

endmodule