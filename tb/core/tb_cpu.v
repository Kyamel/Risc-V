`timescale 1ns / 1ps

module tb_cpu;

    // Parâmetros do testbench
    parameter CLK_PERIOD = 10; // 100MHz
    parameter NUM_CYCLES = 50; // Número de ciclos para simular
    
    // Sinais do DUT
    reg clk;
    reg rst;
    
    // Instanciar o CPU
    rv32i_cpu #(
        .INSTR_WIDTH(32),
        .INSTR_DEPTH(1024),
        .INSTR_INIT_FILE("compiler/program.hex"),
        .DATA_DEPTH(1024),
        .DATA_INIT_FILE("compiler/data.hex"),
        .REG_COUNT(32)
    ) dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Geração do clock
    always #(CLK_PERIOD/2) clk = ~clk;
    
    // Contador de ciclos
    integer cycle_count = 0;
    
    // Variáveis para formatação
    integer i;
    
    initial begin
        // Configurar arquivos de dump
        $dumpfile("build/wave/cpu_tb.vcd");
        $dumpvars(0, tb_cpu);     // Todos os sinais do testbench
        $dumpvars(1, dut);      // Sinais de topo do DUT
        //$dumpvars(2, dut.pc_out, dut.instruction); // Sinais específicos
        
        // Inicialização
        clk = 0;
        rst = 1;
        
        // Aplicar reset
        #(CLK_PERIOD * 2);
        rst = 0;
        
        $display("\n==========================================================");
        $display("           TESTBENCH PARA CPU RISC-V RV32I");
        $display("==========================================================\n");
        
        // Mostrar as primeiras 16 posições da memória de instruções
        $display("MEMÓRIA DE INSTRUÇÕES - Primeiras 16 posições:");
        $display("Addr  | Instrução (Hex) | Instrução (Bin)");
        $display("------|-----------------|--------------------------------");
        for (i = 0; i < 16; i = i + 1) begin
            $display("%04h  | %08h        | %032b", 
                    i*4, dut.instr_mem.memory[i], dut.instr_mem.memory[i]);
        end
        $display("\n");
        
        // Monitor de execução ciclo por ciclo
        $display("EXECUÇÃO CICLO POR CICLO:");
        $display("================================================================================");
        $display("Ciclo | PC   | IF Stage      | ID Stage           | EX Stage           | MEM Stage          | WB Stage");
        $display("------|------|---------------|--------------------|--------------------|--------------------|-----------");
        
        // Simular por NUM_CYCLES ciclos
        repeat(NUM_CYCLES) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
        end
        
        // Mostrar estado final dos registradores
        $display("\n\n==========================================================");
        $display("ESTADO FINAL DOS REGISTRADORES:");
        $display("==========================================================");
        $display("Reg | Hex Value  | Dec Value");
        $display("----|------------|----------");
        for (i = 0; i < 32; i = i + 1) begin
            begin // Mostrar apenas registradores não-zero
                $display("x%-2d | 0x%08h | %d", i, dut.reg_file.regs[i], dut.reg_file.regs[i]);
            end
        end
        
        // Mostrar as primeiras 16 posições da memória de dados
        $display("\n==========================================================");
        $display("MEMÓRIA DE DADOS - Primeiras 16 posições:");
        $display("==========================================================");
        $display("Addr | Hex Value  | Dec Value");
        $display("-----|------------|----------");
        for (i = 0; i < 16; i = i + 1) begin
            begin // Mostrar apenas posições não-zero
                $display("%04h | 0x%08h | %d", i*4, dut.data_mem.memory[i], dut.data_mem.memory[i]);
            end
        end
        
        $display("\n==========================================================");
        $display("SIMULAÇÃO COMPLETA!");
        $display("==========================================================\n");
        
        $finish;
    end
    
    

endmodule
