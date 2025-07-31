module tb_if_stage;

    // --- Sinais de Interface ---
    // Entradas para o DUT
    reg clk = 0;
    reg reset;
    reg stall;
    reg flush;
    reg pc_src;
    reg [31:0] new_pc;
    
    // Interface de Memória (DUT -> Testbench)
    wire [31:0] imem_addr;
    wire imem_read;
    // Interface de Memória (Testbench -> DUT)
    reg [31:0] imem_data;
    
    // Saídas do DUT
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;

    // --- CORREÇÃO 1: Modelo de Memória de Instruções ---
    // Um array para simular a memória. Isso é muito mais realista
    // do que mudar imem_data manualmente a cada ciclo.
    reg [31:0] memory [0:4095];

    // Lógica combinacional para ler da memória simulada.
    // O DUT pede um endereço em `imem_addr`, e este bloco responde com o dado.
    // Usamos `imem_addr >> 2` porque a memória é endereçada por byte, mas armazenamos palavras (32 bits).
    always @(*) begin
        if (imem_read) begin
            imem_data = memory[imem_addr >> 2];
        end else begin
            imem_data = 32'hxxxxxxxx; // Em um ciclo sem leitura, o dado é irrelevante
        end
    end
    
    // Instância do DUT (Device Under Test)
    if_stage dut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .pc_src(pc_src),
        .new_pc(new_pc),
        .imem_addr(imem_addr),
        .imem_read(imem_read),
        .imem_data(imem_data),
        .if_id_pc(if_id_pc),
        .if_id_instruction(if_id_instruction),
        .if_id_valid(if_id_valid)
    );
    
    // Geração de Clock (100 MHz)
    always #5 clk = ~clk;
    
    // Tarefa de verificação para manter o código limpo
    task check;
        input string name;
        input [31:0] exp_pc;
        input [31:0] exp_instr;
        input exp_valid;
        input [31:0] exp_addr;
        input exp_read;
    begin
        #1; // Pequeno atraso para garantir que os sinais se propaguem antes da verificação
        if (if_id_pc !== exp_pc || if_id_instruction !== exp_instr || 
            if_id_valid !== exp_valid || imem_addr !== exp_addr || imem_read !== exp_read) begin
            $display("\033[31m[FAIL]\033[0m %s:", name);
            $display("  Esperado: PC=0x%h, Instr=0x%h, Valid=%b, Addr=0x%h, Read=%b",
                     exp_pc, exp_instr, exp_valid, exp_addr, exp_read);
            $display("  Obtido:   PC=0x%h, Instr=0x%h, Valid=%b, Addr=0x%h, Read=%b",
                     if_id_pc, if_id_instruction, if_id_valid, imem_addr, imem_read);
        end else begin
            $display("\033[32m[PASS]\033[0m %s", name);
        end
    end
    endtask
    
    // --- Sequência de Teste Principal ---
    initial begin
        $display("\n== Teste IF Stage ==");
        
        // --- CORREÇÃO 2: Carregar o programa na memória ANTES de começar ---
        memory[0] = 32'h00000013; // nop (addi x0, x0, 0)
        memory[1] = 32'h00100093; // addi x1, x0, 1
        memory[2] = 32'h00200113; // addi x2, x0, 2
        memory[3] = 32'h00300193; // addi x3, x0, 3
        memory[4] = 32'h00400213; // addi x4, x0, 4
        // Endereço do branch
        memory[1024] = 32'h10000237; // lui x4, 0x10000 @ 0x1000
        memory[1025] = 32'h00420213; // addi x4, x4, 4 @ 0x1004
        memory[1026] = 32'h00500293; // addi x5, x0, 5 @ 0x1008
        memory[1027] = 32'h00600313; // addi x6, x0, 6 @ 0x100C

        // --- Início dos Testes ---
        // 1. Reset
        reset = 1; stall = 0; flush = 0; pc_src = 0; new_pc = 32'd0;
        #10;
        check("Reset", 32'h0, 32'h00000013, 1'b0, 32'h0, 1'b1);
        
        // 2. Sai do Reset e busca a primeira instrução
        reset = 0;
        #10;
        check("Ciclo 1 - Fetch", 32'h0, 32'h00000013, 1'b1, 32'h4, 1'b1);
        
        // 3. Busca a segunda instrução
        #10;
        check("Ciclo 2 - PC+4", 32'h4, 32'h00100093, 1'b1, 32'h8, 1'b1);

        // 4. Ativa o Stall
        stall = 1;
        #10;
        // O PC para de avançar (imem_addr fica em 8).
        // O registrador IF/ID mantém o valor do ciclo anterior (PC=4, instr @ 4).
        // A leitura da memória é desativada (imem_read = 0).
        check("Stall - Congelamento", 32'h4, 32'h00100093, 1'b1, 32'h8, 1'b0);

        // 5. Desativa o Stall
        stall = 0;
        #10;
        // Agora o pipeline avança. O registrador IF/ID captura o que estava parado no PC (PC=8).
        // O PC avança para o próximo endereço (12).
        check("Sai do Stall", 32'h8, 32'h00200113, 1'b1, 32'hc, 1'b1);

        // 6. Teste de Branch (Desvio)
        pc_src = 1;
        flush = 1;
        new_pc = 32'h00001000;
        #10;
        // O PC é atualizado para 0x1000 (imem_addr = 0x1000).
        // O registrador IF/ID ainda captura a instrução que estava no fluxo antigo (PC=12).
        check("Branch - Desvio tomado", 32'h0, 32'h00000013, 1'b0, 32'h1000, 1'b1);

        // 7. Continua após o branch
        pc_src = 0;
        flush = 0;
        #10;
        // O pipeline agora está no novo endereço. IF/ID captura PC=0x1000.
        // O PC avança normalmente para 0x1004.
        check("Continua após branch", 32'h1000, 32'h10000237, 1'b1, 32'h1004, 1'b1);

        // 8. Teste de Flush
        flush = 1;
        #10;
        // O registrador IF/ID é limpo (PC=0, instr=NOP, valid=0).
        // O PC continua avançando a partir de onde estava (0x1004 -> 0x1008).
        check("Flush - Limpa pipeline", 32'h0, 32'h00000013, 1'b0, 32'h1008, 1'b1);
        
        flush = 0;
        #10;
        // O pipeline volta a operar. IF/ID captura o PC atual (0x1008).
        check("Continua após flush", 32'h1008, 32'h00500293, 1'b1, 32'h100c, 1'b1);

        $display("\n== Fim dos testes ==");
        $finish;
    end
endmodule