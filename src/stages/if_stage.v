`timescale 1ns / 1ps

module if_stage (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire flush,
    input wire pc_src,      // Sinal que indica um desvio (branch/jump)
    input wire [31:0] new_pc,     // O novo endereço de PC para o desvio
    
    // Interface com a memória de instruções
    output wire [31:0] imem_addr,
    output wire imem_read,
    input wire [31:0] imem_data,
    
    // Saídas para o registro IF/ID
    output reg [31:0] if_id_pc,
    output reg [31:0] if_id_instruction,
    output reg if_id_valid
);

    // --- Registrador de Estado ---
    reg [31:0] pc_reg;

    // --- LÓGICA COMBINACIONAL (Cálculo do Próximo Estado) ---

    // 1. Calcula o próximo valor do PC
    wire [31:0] pc_next;
    assign pc_next = pc_src ? new_pc : pc_reg + 4;

    // 2. Calcula os próximos valores para o registrador de pipeline IF/ID
    wire [31:0] if_id_pc_next;
    wire [31:0] if_id_instruction_next;
    wire        if_id_valid_next;

    // O próximo PC para o pipeline é sempre o PC do ciclo ATUAL.
    assign if_id_pc_next          = pc_reg;
    assign if_id_instruction_next = imem_data;
    assign if_id_valid_next       = 1'b1;


    // --- LÓGICA SEQUENCIAL (Atualização de Estado na Borda do Clock) ---

    // Bloco responsável APENAS por atualizar o registrador do PC.
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_reg <= 32'h0;
        else if (!stall)
            pc_reg <= pc_next;
    end

    // Bloco responsável APENAS por atualizar o registrador de pipeline IF/ID.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id_pc <= 32'h0;
            if_id_instruction <= 32'h13;
            if_id_valid <= 1'b0;
        end else if (flush) begin // O flush tem prioridade sobre a atualização normal.
            if_id_pc <= 32'h0;
            if_id_instruction <= 32'h13;
            if_id_valid <= 1'b0;
        end else if (!stall) begin
            if_id_pc <= if_id_pc_next;
            if_id_instruction <= if_id_instruction_next;
            if_id_valid <= if_id_valid_next;
        end
        // Se houver stall, os registradores mantêm seus valores (comportamento implícito).
    end


    // --- Saídas Combinacionais ---
    assign imem_addr = pc_reg;
    assign imem_read = !stall;

endmodule