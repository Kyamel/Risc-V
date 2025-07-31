`timescale 1ns / 1ps

module tb_register_file();

    reg clk = 0;
    // CORREÇÃO 1: Nome da porta mudado de 'rst' para 'reset'
    reg reset = 1;

    // CORREÇÃO 2: Largura do endereço mudada de [3:0] para [4:0]
    reg [4:0] rs1_addr, rs2_addr;
    wire [31:0] rs1_data, rs2_data;

    // CORREÇÃO 2: Largura do endereço mudada de [3:0] para [4:0]
    reg [4:0] rd_addr;
    reg [31:0] rd_data;
    // CORREÇÃO 1: Nome da porta mudado de 'rd_we' para 'reg_write'
    reg reg_write;

    register_file uut (
        .clk(clk),
        // Conectando ao port 'reset'
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        // Conectando ao port 'reg_write'
        .reg_write(reg_write)
        // A porta de debug não precisa ser conectada no testbench
        // .debug_registers() 
    );

    // Geração de Clock
    always #5 clk = ~clk;

    initial begin
        $display("=== Testando register_file ===");
        reset = 1;
        reg_write = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;

        #20;
        reset = 0;

        // Testa escrita e leitura
        // 1) Escreve valor em registrador 1 (x1)
        rd_addr = 5'd1;
        rd_data = 32'hDEADBEEF;
        reg_write = 1;
        #10;

        reg_write = 0;
        #10;

        // Lê registradores 1 (x1) e 2 (x2)
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #10;

        if (rs1_data === 32'hDEADBEEF) 
            $display("\033[32m[PASS]\033[0m Leitura rs1 correto: %h", rs1_data);
        else
            $display("\033[31m[FAIL]\033[0m Leitura rs1 errado: %h", rs1_data);

        if (rs2_data === 32'd0) 
            $display("\033[32m[PASS]\033[0m Leitura rs2 correto (zero): %h", rs2_data);
        else
            $display("\033[31m[FAIL]\033[0m Leitura rs2 errado: %h", rs2_data);

        // Testa que registrador 0 (x0) é sempre zero e não pode ser escrito
        rd_addr = 5'd0;
        rd_data = 32'hFFFFFFFF;
        reg_write = 1;
        #10;
        reg_write = 0;
        rs1_addr = 0;
        #10;
        if (rs1_data === 32'd0)
            $display("\033[32m[PASS]\033[0m Registrador 0 é imutável e zero");
        else
            $display("\033[31m[FAIL]\033[0m Registrador 0 alterado: %h", rs1_data);

        $display("Fim do teste");
        $finish;
    end

endmodule