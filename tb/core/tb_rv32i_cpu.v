`timescale 1ns / 1ps

module tb_rv32i_cpu();

    // Parâmetros
    parameter INSTR_WIDTH = 32;
    parameter INSTR_HEIGHT = 256;
    parameter CLK_PERIOD = 10; // 10ns = 100MHz

    // Sinais de clock e reset
    reg clk;
    reg rst;

    // Sinais de controle
    reg stall;
    reg flush;

    // Instância da CPU
    rv32i_cpu #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .INSTR_HEIGHT(INSTR_HEIGHT),
        .INSTR_INIT_FILE("program.mem") // Arquivo com instruções de teste
    ) uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .debug_reg_index(5'b0) // Não usado neste teste
    );

    // Geração de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Tarefa para exibir a memória de instruções
    task display_instruction_memory;
        integer i;
        begin
            $display("\n=== Memória de Instruções ===");
            $display("Endereço   Instrução");
            for (i = 0; i < INSTR_HEIGHT; i = i + 1) begin
                if (uut.instr_memory_debug[i] != 0) begin
                    $display("0x%08h: 0x%08h", i*4, uut.instr_memory_debug[i]);
                end
            end
        end
    endtask

    // Tarefa para exibir o estado da pipeline
    task display_pipeline_state;
        integer cycle;
        begin
            cycle = $time/CLK_PERIOD;
            $display("\n=== Ciclo %0d ===", cycle);
            $display("PC atual: 0x%08h", uut.pc_current);
            $display("IF: Instrução = 0x%08h", uut.current_instruction);
            
            // Estágio IF/ID
            if (cycle > 0) begin
                $display("\nIF/ID:");
                $display("PC: 0x%08h", uut.if_id_pc);
                $display("Instrução: 0x%08h", uut.if_id_instr);
            end
            
            // Estágio ID/EX
            if (cycle > 1) begin
                $display("\nID/EX:");
                $display("PC: 0x%08h", uut.idex_pc);
                $display("RS1: x%0d = 0x%08h", uut.idex_rs1, uut.idex_rs1_data);
                $display("RS2: x%0d = 0x%08h", uut.idex_rs2, uut.idex_rs2_data);
                $display("Imediato: 0x%08h", uut.idex_imm_data);
                $display("RD: x%0d", uut.idex_rd);
                $display("ALUOp: %b, ALUSrc: %b", uut.idex_ALUOp, uut.idex_ALUSrc);
            end
            
            // Estágio EX (ALU)
            if (cycle > 2) begin
                $display("\nEX:");
                $display("Entrada A: 0x%08h", uut.forward_mux1_out);
                $display("Entrada B: 0x%08h", uut.alu_src_mux_out);
                $display("Operação ALU: %b", uut.alu_control_out);
                $display("Resultado ALU: 0x%08h", uut.alu_result);
                $display("Zero Flag: %b", uut.alu_zero);
                $display("Branch Target: 0x%08h", uut.branch_target);
            end
        end
    endtask

    // Tarefa para exibir registradores
    task display_registers;
        integer i;
        begin
            $display("\n=== Estado dos Registradores ===");
            $display("x0: 0x%08h (hardwired zero)", uut.registers_debug[0]);
            for (i = 1; i < 32; i = i + 1) begin
                if (uut.registers_debug[i] != 0) begin
                    $display("x%0d: 0x%08h", i, uut.registers_debug[i]);
                end
            end
        end
    endtask

    // Inicialização
    initial begin
        // Inicializa arquivo de log
        $dumpfile("cpu_waveform.vcd");
        $dumpvars(0, tb_rv32i_cpu);
        
        // Inicializa sinais
        clk = 0;
        rst = 1;
        stall = 0;
        flush = 0;
        
        // Reset inicial
        #(CLK_PERIOD*2);
        rst = 0;
        
        // Exibe memória de instruções
        display_instruction_memory();
        
        // Executa por 15 ciclos
        $display("\nIniciando execução...");
        repeat (15) begin
            #CLK_PERIOD;
            display_pipeline_state();
        end
        
        // Exibe estado final dos registradores
        display_registers();
        
        // Finaliza
        $display("\n=== Final da Simulação ===");
        $finish;
    end

endmodule