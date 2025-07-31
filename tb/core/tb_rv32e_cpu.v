`timescale 1ns / 1ps
`include "constants.v"

module tb_rv32e_cpu;

    // Parâmetros
    parameter CLK_PERIOD = 10; // 10ns = 100MHz

    // Sinais de clock e reset
    reg clk = 0;
    reg reset = 1;

    // Interface com memória de instruções
    wire [31:0] imem_addr;
    reg [31:0] imem_data;
    wire imem_read;

    // Interface com memória de dados
    wire [31:0] dmem_addr;
    reg [31:0] dmem_data_in = 0;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;

    // Sinais de debug
    wire [31:0] debug_pc;
    wire [31:0] debug_registers [0:15];
    wire [31:0] debug_instruction;
    wire debug_stall;
    wire debug_flush;

    // Instância da CPU
    rv32e_cpu cpu (
        .clk(clk),
        .reset(reset),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read),
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .debug_pc(debug_pc),
        .debug_registers(debug_registers),
        .debug_instruction(debug_instruction),
        .debug_stall(debug_stall),
        .debug_flush(debug_flush)
    );

    // Gerador de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Tarefa para carregar instrução na memória
    task load_instruction;
        input [31:0] addr;
        input [31:0] instr;
    begin
        // Simula memória de instruções
        if (imem_addr == addr) begin
            imem_data = instr;
        end
    end
    endtask

    // Monitoramento
    always @(posedge clk) begin
        $display("[%0t] PC = 0x%h, Instr = 0x%h", $time, debug_pc, debug_instruction);
        if (dmem_write) begin
            $display("[%0t] MEM Write @ 0x%h: 0x%h", $time, dmem_addr, dmem_data_out);
        end
    end

    // Teste de sequência de branch
    initial begin
        $display("Iniciando teste de branch...");
        $display("---------------------------");

        // Inicializa memória com instruções
        // Programa de teste:
        // 0x00: addi x1, x0, 5       # x1 = 5
        // 0x04: addi x2, x0, 10      # x2 = 10
        // 0x08: beq x1, x2, 16       # if (x1 == x2) branch para 0x18
        // 0x0C: addi x3, x0, 1       # x3 = 1 (não executado se branch taken)
        // 0x10: j 0x20               # jump para 0x20
        // 0x14: nop                  # 
        // 0x18: addi x4, x0, 2       # x4 = 2 (target do branch)
        // 0x1C: j 0x24               # jump para 0x24
        // 0x20: addi x5, x0, 3       # x5 = 3 (target do jump)
        // 0x24: nop                  # fim

        // Reset inicial
        #10 reset = 0;
        #10;

        // Carrega programa na memória
        load_instruction(32'h00, {12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011});  // addi x1, x0, 5
        load_instruction(32'h04, {12'd10, 5'd0, 3'b000, 5'd2, 7'b0010011}); // addi x2, x0, 10
        load_instruction(32'h08, {7'b0, 5'd2, 5'd1, 3'b000, 4'h4, 1'b0, 7'b1100011}); // beq x1, x2, 16
        load_instruction(32'h0C, {12'd1, 5'd0, 3'b000, 5'd3, 7'b0010011});  // addi x3, x0, 1
        load_instruction(32'h10, {12'd8, 8'd0, 1'b0, 11'd0, 7'b1101111});   // j 0x20
        load_instruction(32'h14, 32'h00000013);                             // nop
        load_instruction(32'h18, {12'd2, 5'd0, 3'b000, 5'd4, 7'b0010011});  // addi x4, x0, 2
        load_instruction(32'h1C, {12'd4, 8'd0, 1'b0, 11'd0, 7'b1101111});   // j 0x24
        load_instruction(32'h20, {12'd3, 5'd0, 3'b000, 5'd5, 7'b0010011});  // addi x5, x0, 3
        load_instruction(32'h24, 32'h00000013);                             // nop

        // Executa por 50 ciclos
        #500;

        // Verifica resultados
        $display("\nVerificando resultados:");
        $display("x1 = %0d (esperado: 5)", debug_registers[1]);
        $display("x2 = %0d (esperado: 10)", debug_registers[2]);
        $display("x3 = %0d (esperado: 0 - não deve executar)", debug_registers[3]);
        $display("x4 = %0d (esperado: 2 - branch taken)", debug_registers[4]);
        $display("x5 = %0d (esperado: 3 - jump taken)", debug_registers[5]);
        $display("PC final = 0x%h (esperado: 0x24)", debug_pc);

        $display("\nTeste concluído!");
        $finish;
    end

endmodule