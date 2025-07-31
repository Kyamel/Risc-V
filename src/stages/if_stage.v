`timescale 1ns / 1ps

module if_stage (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire flush,
    input wire pc_src,         // Substitui o flush para controle de desvio
    input wire [31:0] new_pc,
    
    // Interface com a memória de instruções
    output wire [31:0] imem_addr,
    output wire imem_read,
    input wire [31:0] imem_data,
    
    // Registro IF/ID
    output reg [31:0] if_id_pc,
    output reg [31:0] if_id_instruction,
    output reg if_id_valid
);

    wire [31:0] pc_current;
    
    // Instância do pc_generator
    pc_generator pc_gen (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(pc_src),  // Usamos pc_src como flush para desvio
        .new_pc(new_pc),
        .pc_out(pc_current)
    );

    // Atribuição contínua para a memória
    assign imem_addr = pc_current;
    assign imem_read = !stall;

    // Estágio de registro IF/ID
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id_pc <= 32'h00000000;
            if_id_instruction <= 32'h00000013;  // NOP
            if_id_valid <= 1'b0;
        end else if (flush) begin
            // Limpa o registro em caso de flush
            if_id_pc <= 32'h00000000;
            if_id_instruction <= 32'h00000013;  // NOP
            if_id_valid <= 1'b0;
        end else if (!stall) begin
            // Registro normal
            if_id_pc <= pc_current;
            if_id_instruction <= imem_data;
            if_id_valid <= 1'b1;
        end
    end

endmodule