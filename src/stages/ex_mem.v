`timescale 1ns / 1ps

module ex_mem (
    input wire         clk,
    input wire         rst,
    input wire         stall,
    input wire         flush,

    // Control signals from EX stage (to be passed to MEM/WB stages)
    input wire         ex_Branch,          // To MEM stage for branch decision
    input wire         ex_MemRead,         // To MEM stage for memory read
    input wire         ex_MemWrite,        // To MEM stage for memory write
    input wire         ex_RegWrite,        // To WB stage for register write
    input wire         ex_MemtoReg,        // To WB stage for memory-to-register mux
    
    // Entradas do estágio EX
    input wire [31:0]  ex_adder_out,       // PC + (imm << 1) (vem do somador de branch)
    input wire [31:0]  ex_result,          // Resultado da ALU (vai para memória de dados)
    input wire         ex_alu_zero,          // Indica se o segundo operando da ALU é imediato
    input wire [4:0]   ex_rd,              // Registrador destino (vem de id_ex)
    input wire [31:0]  ex_read_data_2_mux, // Dado para escrita (vem do mux de forwarding)
    
    // Saídas para o estágio MEM
    output reg [31:0]  mem_addr,           // Endereço para memória de dados (ALU Result)
    output reg        mem_alu_zero, 
    output reg [31:0]  mem_write_data,     // Dado para escrita na memória
    output reg [4:0]   mem_rd,             // Registrador destino (para WB e forwarding)
    output reg [31:0]  mem_adder_out,      // PC + offset (para cálculo de branch)
    
    // Control signals to MEM stage
    output reg        mem_Branch,          // Branch control to MEM stage
    output reg        mem_MemRead,         // Memory read control to MEM stage
    output reg        mem_MemWrite,        // Memory write control to MEM stage
    
    // Control signals to WB stage (passed through MEM stage)
    output reg        mem_RegWrite,        // Register write control to WB stage
    output reg        mem_MemtoReg         // Memory-to-register mux control to WB stage
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Reset/flush: zera todos os registradores
            mem_addr       <= 32'b0;
            mem_write_data <= 32'b0;
            mem_rd         <= 5'b0;
            mem_adder_out  <= 32'b0;
            
            // Reset control signals
            mem_Branch     <= 1'b0;
            mem_MemRead    <= 1'b0;
            mem_MemWrite   <= 1'b0;
            mem_RegWrite   <= 1'b0;
            mem_MemtoReg   <= 1'b0;
        end
        else if (!stall) begin
            // Registra os valores normalmente
            mem_addr       <= ex_result;          // Resultado da ALU -> endereço de memória
            mem_write_data <= ex_read_data_2_mux; // Dado para escrita na memória
            mem_rd         <= ex_rd;              // Registrador destino
            mem_adder_out  <= ex_adder_out;      // PC + offset para branch
            mem_alu_zero   <= ex_alu_zero;        // Passa o sinal de zero da ALU
            
            // Pass control signals through pipeline
            mem_Branch     <= ex_Branch;
            mem_MemRead    <= ex_MemRead;
            mem_MemWrite   <= ex_MemWrite;
            mem_RegWrite   <= ex_RegWrite;
            mem_MemtoReg   <= ex_MemtoReg;
        end
        // Se stall, mantém os valores atuais
    end

endmodule