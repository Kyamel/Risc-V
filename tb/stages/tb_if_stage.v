`timescale 1ns / 1ps

module tb_if_stage;

    // Entradas
    reg clk = 0;
    reg reset;
    reg stall;
    reg flush;
    reg pc_src;
    reg [31:0] new_pc;
    reg [31:0] imem_data;
    
    // Saídas
    wire [31:0] imem_addr;
    wire imem_read;
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;
    wire if_id_valid;
    
    // Instância do DUT
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
    
    // Clock de 10ns (50 MHz)
    always #5 clk = ~clk;
    
    // Monitoramento
    always @(posedge clk) begin
        $display("[%0t] PC=0x%h, Instr=0x%h, Valid=%b, Addr=0x%h, Read=%b",
                 $time, if_id_pc, if_id_instruction, if_id_valid, imem_addr, imem_read);
    end
    
    task check;
        input string name;
        input [31:0] exp_pc;
        input [31:0] exp_instr;
        input exp_valid;
        input [31:0] exp_addr;
        input exp_read;
    begin
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
   
    initial begin
        $display("\n== Teste IF Stage ==");
        
        // Inicialização
        reset = 1;
        stall = 0;
        flush = 0;
        pc_src = 0;
        new_pc = 32'h00000000;
        imem_data = 32'h00000013; // NOP
        
        #10; // 1 ciclo de clock
        
        // Teste 1: Reset
        check("Reset", 
            32'h00000000, 32'h00000013, 1'b0, 32'h00000000, 1'b1);
        
        reset = 0;
        #10;
        
        // Teste 2: Sequência normal (PC+4)
        imem_data = 32'h00100093; // addi x1, x0, 0
        check("Ciclo 1 - Fetch", 
            32'h00000000, 32'h00000013, 1'b1, 32'h00000004, 1'b1);
        
        #10;
        imem_data = 32'h00200113; // addi x2, x0, 2
        check("Ciclo 2 - PC+4", 
            32'h00000004, 32'h00100093, 1'b1, 32'h00000008, 1'b1);
        
        // Teste 3: Stall
        stall = 1;
        #10;
        check("Stall - Congelamento", 
            32'h00000008, 32'h00200113, 1'b1, 32'h00000008, 1'b0);
        
        stall = 0;
        #10;
        imem_data = 32'h00300193; // addi x3, x0, 3
        check("Sai do Stall", 
            32'h00000008, 32'h00200113, 1'b1, 32'h0000000c, 1'b1);
        
        // Teste 4: Branch (pc_src)
        pc_src = 1;
        new_pc = 32'h00001000;
        #10;
        imem_data = 32'h10000237; // lui x4, 0x10000
        check("Branch - Desvio tomado", 
            32'h0000000c, 32'h00300193, 1'b1, 32'h00001000, 1'b1);
        
        pc_src = 0;
        #10;
        imem_data = 32'h00420213; // addi x4, x4, 4
        check("Continua após branch", 
            32'h00001000, 32'h10000237, 1'b1, 32'h00001004, 1'b1);
        
        // Teste 5: Flush
        flush = 1;
        #10;
        check("Flush - Limpa pipeline", 
            32'h00000000, 32'h00000013, 1'b0, 32'h00001008, 1'b1);
        
        flush = 0;
        #10;
        imem_data = 32'h00500293; // addi x5, x0, 5
        check("Continua após flush", 
            32'h00001008, 32'h00500293, 1'b1, 32'h0000100c, 1'b1);

        // Teste 6: Stall após flush
        stall = 1;
        flush = 0;
        #10;
        check("Stall após flush", 
            32'h0000100c, 32'h00500293, 1'b1, 32'h0000100c, 1'b0);
        
        // Teste 7: Flush durante stall
        flush = 1;
        #10;
        check("Flush durante stall", 
            32'h00000000, 32'h00000013, 1'b0, 32'h0000100c, 1'b0);
        
        // Teste 8: Sai de stall e flush juntos
        stall = 0;
        flush = 0;
        #10;
        imem_data = 32'h00600313; // addi x6, x0, 6
        check("Sai de stall e flush", 
            32'h0000100c, 32'h00600313, 1'b1, 32'h00001010, 1'b1);

        $display("\n== Fim dos testes ==");
        $finish;
    end
endmodule