`timescale 1ns / 1ps
`include "constants.v"

module tb_rv32e_cpu;

    // Parâmetros
    parameter CLK_PERIOD = 10; // 10ns = 100MHz

    // Sinais de clock e reset
    reg clk = 0;
    reg reset = 1;

    // --- Memória Simulada ---
    reg [31:0] instr_mem [0:1023];
    reg [31:0] data_mem [0:1023];

    // --- Interface com a CPU ---
    // Memória de Instruções
    wire [31:0] imem_addr;
    wire imem_read; // Sinal da CPU para a memória
    reg [31:0] imem_data; // Dado da memória para a CPU

    // Memória de Dados
    wire [31:0] dmem_addr;
    wire [31:0] dmem_data_out;
    wire dmem_read;
    wire dmem_write;
    wire [3:0] dmem_byte_enable;
    reg [31:0] dmem_data_in;

    // Sinais de Debug da CPU
    wire [31:0] debug_pc;
    wire [31:0] debug_registers [0:31]; 
    wire [31:0] debug_instruction;
    
    // Instância da CPU
    rv32e_cpu cpu (
        .clk(clk),
        .reset(reset),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .imem_read(imem_read), // Conectado para completude
        .dmem_addr(dmem_addr),
        .dmem_data_in(dmem_data_in),
        .dmem_data_out(dmem_data_out),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_byte_enable(dmem_byte_enable),
        .debug_pc(debug_pc),
        .debug_registers(debug_registers),
        .debug_instruction(debug_instruction)
        // .debug_stall(debug_stall), // Descomente se precisar
        // .debug_flush(debug_flush)  // Descomente se precisar
    );

    // Gerador de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // --- Lógica da Memória Simulada ---
    // Leitura da memória de instruções (combinacional)
    always @(*) begin
        imem_data = instr_mem[imem_addr >> 2];
    end

    // Leitura da memória de dados (combinacional)
    always @(*) begin
        dmem_data_in = data_mem[dmem_addr >> 2];
    end

    // Escrita na memória de dados (síncrona)
    always @(posedge clk) begin
        if (dmem_write) begin
            if (dmem_byte_enable[0]) data_mem[dmem_addr >> 2][7:0]   <= dmem_data_out[7:0];
            if (dmem_byte_enable[1]) data_mem[dmem_addr >> 2][15:8]  <= dmem_data_out[15:8];
            if (dmem_byte_enable[2]) data_mem[dmem_addr >> 2][23:16] <= dmem_data_out[23:16];
            if (dmem_byte_enable[3]) data_mem[dmem_addr >> 2][31:24] <= dmem_data_out[31:24];
        end
    end

    // --- Monitoramento e Log Detalhado ---
    always @(posedge clk) begin
        if (!reset) begin
            $display("[%0t] PC: 0x%h, Instr: 0x%h", $time, debug_pc, debug_instruction);
            if (dmem_write) begin
                $display("      MEM_WRITE -> Addr: 0x%h, Data: 0x%h, ByteEnable: %b", dmem_addr, dmem_data_out, dmem_byte_enable);
            end
        end
    end

    // --- Sequência de Teste Principal ---
    initial begin
        $display("========================================");
        $display("== Iniciando Teste da CPU RV32I ==");
        $display("========================================");

        // Carrega o programa na memória de instruções
        instr_mem[0] = 32'h00500093; // 0x00: addi x1, x0, 5
        instr_mem[1] = 32'h00A00113; // 0x04: addi x2, x0, 10
        instr_mem[2] = 32'h00208863; // 0x08: beq  x1, x2, +16 (target: 0x18)
        instr_mem[3] = 32'h00100193; // 0x0C: addi x3, x0, 1
        instr_mem[4] = 32'h0100006F; // 0x10: j    +16 (target: 0x20)
        instr_mem[5] = 32'h00000013; // 0x14: nop
        instr_mem[6] = 32'h00200213; // 0x18: addi x4, x0, 2
        instr_mem[7] = 32'h0080006F; // 0x1C: j    +8 (target: 0x24)
        instr_mem[8] = 32'h00300293; // 0x20: addi x5, x0, 3
        instr_mem[9] = 32'h00000013; // 0x24: nop (Fim do teste)

        // Adiciona log de carregamento da memória
        $display("\n--- Log de Carregamento da Memória de Instruções ---");
        for (integer i = 0; i < 10; i = i + 1) begin
            $display("Mem[0x%h]: 0x%h", i*4, instr_mem[i]);
        end
        $display("--------------------------------------------------\n");


        // Aplica o reset
        reset = 1;
        # (CLK_PERIOD * 2);
        reset = 0;

        // Espera até que o PC atinja o final do programa
        wait (debug_pc == 32'h28);
        # (CLK_PERIOD * 2); // Deixa alguns ciclos para o pipeline esvaziar

        // --- Verificação dos Resultados ---
        $display("\n========================================");
        $display("== Verificação dos Resultados Finais ==");
        $display("========================================");
        
        // Dump de todos os 32 registradores
        $display("\n--- Dump dos Registradores ---");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("x%0d: 0x%h (%0d)", i, debug_registers[i], debug_registers[i]);
        end

        // CORREÇÃO: Adicionado valor esperado nas mensagens de falha
        $display("\n--- Verificação de Valores Específicos ---");
        if (debug_registers[1] == 5) $display("[PASS] x1 = 5"); else $display("[FAIL] x1 = %0d (esperado: 5)", debug_registers[1]);
        if (debug_registers[2] == 10) $display("[PASS] x2 = 10"); else $display("[FAIL] x2 = %0d (esperado: 10)", debug_registers[2]);
        if (debug_registers[3] == 1) $display("[PASS] x3 = 1 (branch not taken)"); else $display("[FAIL] x3 = %0d (esperado: 1)", debug_registers[3]);
        // CORREÇÃO: O valor esperado para x4 é 0, pois o branch não é tomado.
        if (debug_registers[4] == 0) $display("[PASS] x4 = 0 (branch not taken)"); else $display("[FAIL] x4 = %0d (esperado: 0)", debug_registers[4]);
        if (debug_registers[5] == 3) $display("[PASS] x5 = 3 (jump taken)"); else $display("[FAIL] x5 = %0d (esperado: 3)", debug_registers[5]);
        
        $display("\nPC final: 0x%h", debug_pc);

        $display("\nTeste concluído!");
        $finish;
    end

endmodule