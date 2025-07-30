module if_stage (
    input wire clk,
    input wire reset,            // Padronizado para 'reset'
    input wire stall,            // Congelamento do pipeline
    input wire flush,            // Limpeza do pipeline
    input wire pc_src,           // Controle de desvio (antigo branch_taken)
    input wire [31:0] new_pc,    // Novo PC (antigo branch_target)
    
    // Interface com a memória de instruções
    output wire [31:0] imem_addr,
    output wire imem_read,
    input wire [31:0] imem_data,
    
    // Registro IF/ID
    output reg [31:0] if_id_pc,
    output reg [31:0] if_id_instruction,
    output reg if_id_valid
);

    reg [31:0] pc_reg;

    // Lógica de atualização do PC
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= 32'h00000000;  // Reset assíncrono
        end else if (!stall) begin
            pc_reg <= pc_src ? new_pc : pc_reg + 4;
        end
    end

    // Atribuição contínua para a memória
    assign imem_addr = pc_reg;
    assign imem_read = !stall;  // Só lê memória quando não está stallado

    // Estágio de registro IF/ID
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id_pc <= 32'h00000000;
            if_id_instruction <= 32'h00000000;  // NOP (0x00000013)
            if_id_valid <= 1'b0;
        end else if (flush) begin
            // Limpa o registro em caso de flush
            if_id_pc <= 32'h00000000;
            if_id_instruction <= 32'h00000013;  // NOP
            if_id_valid <= 1'b0;
        end else if (!stall) begin
            // Registro normal
            if_id_pc <= pc_reg;
            if_id_instruction <= imem_data;
            if_id_valid <= 1'b1;
        end
    end

endmodule