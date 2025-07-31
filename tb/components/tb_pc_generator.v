module tb_pc_generator;

    // Sinais
    reg clk = 0;
    reg reset = 0;
    reg stall = 0;
    reg flush = 0;
    reg [31:0] new_pc = 0;
    wire [31:0] pc_out;

    // Instancia o DUT (Device Under Test)
    pc_generator uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .new_pc(new_pc),
        .pc_out(pc_out)
    );

    // Clock de 10ns (período 20ns)
    always #10 clk = ~clk;

    // Função auxiliar de verificação
    task assert_eq(input [31:0] actual, input [31:0] expected, input [255:0] msg);
        begin
            if (actual === expected)
                $display("\033[0;32m[PASS]\033[0m %s (pc_out = 0x%08h)", msg, actual);
            else
                $display("\033[0;31m[FAIL]\033[0m %s (pc_out = 0x%08h, expected = 0x%08h)", msg, actual, expected);
        end
    endtask

    initial begin
        $display("==== Iniciando Testbench pc_generator ====");
        
        // Monitoramento contínuo
        $monitor("At time %0t: pc_out = 0x%08h", $time, pc_out);

        // Teste 1: Reset
        reset = 1;
        #15; // Espera mais que meio ciclo
        assert_eq(pc_out, 32'h00000000, "Reset deve zerar o PC");
        reset = 0;
        
        // Teste 2: Avanço normal
        @(posedge clk); // Espera próximo clock
        #1; // Pequeno delay após borda de subida
        assert_eq(pc_out, 32'h00000004, "PC deve avancar +4 (1)");
        
        @(posedge clk);
        #1;
        assert_eq(pc_out, 32'h00000008, "PC deve avancar +4 (2)");

        // Teste 3: Stall
        stall = 1;
        @(posedge clk);
        #1;
        assert_eq(pc_out, 32'h00000008, "Stall ativado, PC deve manter");

        @(posedge clk);
        #1;
        assert_eq(pc_out, 32'h00000008, "Stall ainda ativado");
        stall = 0;

        // Teste 4: Flush
        flush = 1;
        new_pc = 32'h10000000;
        @(posedge clk);
        #1;
        flush = 0;
        assert_eq(pc_out, 32'h10000000, "Flush deve atualizar PC para new_pc");

        // Teste 5: Após flush
        @(posedge clk);
        #1;
        assert_eq(pc_out, 32'h10000004, "PC deve continuar apos flush");

        $display("==== Testbench finalizado ====");
        $finish;
    end

endmodule