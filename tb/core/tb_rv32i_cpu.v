`timescale 1ns / 1ps

module tb_rv32i_cpu;

    // Entradas
    reg clk = 0;
    reg reset;
    
    // Debug signals
    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire debug_stall;
    wire debug_flush;
    wire [31:0] debug_registers [0:31];
    wire [31:0] debug_dmem_out;
    wire [31:0] debug_imem_out;
    
    // Contador de ciclos
    integer cycle_count = 0;
    
    // Geração de clock (10ns período)
    always #5 clk = ~clk;
    
    // Instância da CPU
    rv32i_cpu dut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_stall(debug_stall),
        .debug_flush(debug_flush),
        .debug_registers(debug_registers),
        .debug_dmem_out(debug_dmem_out),
        .debug_imem_out(debug_imem_out)
    );
    
    // Task para mostrar conteúdo da memória
    task show_memory(input [31:0] start_addr, input [31:0] end_addr);
        integer i;
        begin
            $display("\nMemória de Dados [%h-%h]:", start_addr, end_addr);
            for (i = start_addr; i <= end_addr; i = i + 4) begin
                // Ajusta o endereço de debug para ler a memória
                force dut.dmem.debug_addr = i;
                #1; // Pequeno atraso para estabilização
                $display("mem[%h] = %h", i, debug_dmem_out);
                release dut.dmem.debug_addr;
            end
        end
    endtask
    
    // Task para mostrar registradores
    task show_registers;
        integer i;
        begin
            $display("\nRegistradores:");
            for (i = 0; i < 32; i = i + 1) begin
                $display("x%0d = %h", i, debug_registers[i]);
            end
        end
    endtask
    
    // Task para mostrar instruções
    task show_instructions(input [31:0] start_addr, input [31:0] end_addr);
        integer i;
        begin
            $display("\nMemória de Instruções [%h-%h]:", start_addr, end_addr);
            for (i = start_addr; i <= end_addr; i = i + 4) begin
                // Ajusta o endereço de debug para ler a memória
                force dut.imem.debug_addr = i;
                #1; // Pequeno atraso para estabilização
                $display("imem[%h] = %h", i, debug_imem_out);
                release dut.imem.debug_addr;
            end
        end
    endtask
    
    initial begin
        // Configuração do dump de formas de onda
        $dumpfile("cpu_waves.vcd");
        $dumpvars(0, tb_rv32i_cpu);
        
        // Inicialização
        reset = 1;
        #20;
        reset = 0;
        
        $display("Iniciando simulação da CPU por 32 ciclos...");
        
        // Execução por 32 ciclos
        while (cycle_count < 32) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;
            
            // Mostra informações a cada ciclo (opcional)
            $display("Ciclo %0d: PC=%h, Inst=%h", 
                    cycle_count, debug_pc, debug_instruction);
        end
        
        // Mostra resultados finais
        $display("\n=== RESULTADOS APÓS 32 CICLOS ===");
        
        // Mostra registradores
        show_registers();
        
        // Mostra memória de dados (primeiros 32 bytes)
        show_memory(32'h00000000, 32'h0000001F);
        
        // Mostra memória de instruções (primeiros 32 bytes)
        show_instructions(32'h00000000, 32'h0000001F);
        
        $display("\nSimulação concluída.");
        $finish;
    end

endmodule