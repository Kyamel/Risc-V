`timescale 1ns / 1ps

module tb_rv32i_cpu();

    // Parâmetros
    parameter INSTR_WIDTH = 32;
    parameter INSTR_HEIGHT = 256;
    parameter DATA_HEIGHT = 1024;
    parameter REG_COUNT = 32;
    
    // Sinais de clock e reset
    reg clk;
    reg rst;
    
    // Sinais de debug
    wire [31:0] pc_current;
    wire [INSTR_WIDTH-1:0] current_instruction;
    reg [4:0] debug_reg_index;
    wire [31:0] debug_reg_value;
    reg [9:0] debug_mem_index;
    wire [31:0] debug_mem_value;
    
    // Instância do CPU
    rv32i_cpu #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .INSTR_HEIGHT(INSTR_HEIGHT),
        .INSTR_INIT_FILE("compiler/program.hex"),
        .DATA_HEIGHT(DATA_HEIGHT),
        .REG_COUNT(REG_COUNT)
    ) cpu (
        .clk(clk),
        .rst(rst),
        .pc_current(pc_current),
        .current_instruction(current_instruction),
        .debug_reg_index(debug_reg_index),
        .debug_reg_value(debug_reg_value),
        .debug_mem_index(debug_mem_index),
        .debug_mem_value(debug_mem_value)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Tarefa para mostrar o conteúdo da memória
    task show_memory;
        input [9:0] start_addr;
        input [9:0] end_addr;
        input is_instr_mem;
        integer i;
    begin
        if (is_instr_mem) begin
            $display("\nConteúdo da Memória de Instruções [%0d:%0d]:", start_addr, end_addr);
            for (i = start_addr; i <= end_addr; i = i + 1) begin
                #1; // Espera um tempo para o valor ser atualizado
                $display("Mem[%0d] = %h", i, cpu.instr_mem.memory[i]);
            end
        end else begin
            $display("\nConteúdo da Memória de Dados [%0d:%0d]:", start_addr, end_addr);
            for (i = start_addr; i <= end_addr; i = i + 1) begin
                #1; // Espera um tempo para o valor ser atualizado
                $display("Data[%0d] = %h", i, cpu.data_mem.memory[i]);
            end
        end
    end
    endtask
    
    // Tarefa para mostrar os registradores
    task show_registers;
        input [4:0] start_reg;
        input [4:0] end_reg;
        integer i;
    begin
        $display("\nConteúdo dos Registradores [x%0d:x%0d]:", start_reg, end_reg);
        for (i = start_reg; i <= end_reg; i = i + 1) begin
            debug_reg_index = i;
            #1; // Espera um tempo para o valor ser atualizado
            $display("x%0d = %h", i, debug_reg_value);
        end
    end
    endtask
    
    // Tarefa para mostrar o estado do pipeline
    task show_pipeline_state;
        input [31:0] cycle;
    begin
        $display("\n=== Ciclo %0d ===", cycle);
        $display("PC: %h", pc_current);
        $display("Instrução: %h", current_instruction);
        // Aqui você pode adicionar mais informações sobre o estado do pipeline
        // como os valores nos registradores intermediários, sinais de controle, etc.
    end
    endtask
    
    // Procedimento de teste
    initial begin
        // Inicialização
        rst = 1;
        debug_reg_index = 0;
        debug_mem_index = 0;
        
        // Mostra memória de instruções inicial
        $display("=== TESTBENCH PARA RV32I CPU ===");
        show_memory(0, 15, 1); // Mostra 16 primeiras posições da memória de instruções
        
        // Reset
        #10;
        rst = 0;
        
        // Execução por 16 ciclos
        for (integer i = 0; i < 16; i = i + 1) begin
            show_pipeline_state(i);
            #10; // Avança um ciclo de clock
        end
        
        // Mostra estado final
        $display("\n=== ESTADO FINAL APÓS 16 CICLOS ===");
        show_registers(0, 31); // Mostra todos os registradores
        show_memory(0, 15, 0); // Mostra 16 primeiras posições da memória de dados
        
        // Finaliza a simulação
        $finish;
    end
    
    // Monitoramento de eventos importantes
    always @(posedge clk) begin
        if (cpu.branch_flush) begin
            $display("-> Branch tomado no ciclo %0d! PC atual: %h, Novo PC: %h", 
                    $time/10, pc_current, cpu.pc_next);
        end
    end

endmodule