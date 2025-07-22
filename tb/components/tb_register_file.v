`timescale 1ns / 1ps

module tb_register_file();

    reg clk = 0;
    reg rst = 1;

    reg [3:0] rs1_addr, rs2_addr;
    wire [31:0] rs1_data, rs2_data;

    reg [3:0] rd_addr;
    reg [31:0] rd_data;
    reg rd_we;

    register_file uut (
        .clk(clk),
        .rst(rst),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rd_we(rd_we)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("=== Testando register_file ===");
        rst = 1;
        rd_we = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;

        #20;
        rst = 0;

        // Testa escrita e leitura
        // 1) Escreve valor em registrador 1
        rd_addr = 4'd1;
        rd_data = 32'hDEADBEEF;
        rd_we = 1;
        #10;

        rd_we = 0;
        #10;

        // Lê registradores 1 e 2
        rs1_addr = 4'd1;
        rs2_addr = 4'd2;
        #10;

        if (rs1_data === 32'hDEADBEEF) 
            $display("\033[32mPASS\033[0m: Leitura rs1 correto: %h", rs1_data);
        else
            $display("\033[31mFAIL\033[0m: Leitura rs1 errado: %h", rs1_data);

        if (rs2_data === 32'd0) 
            $display("\033[32mPASS\033[0m: Leitura rs2 correto (zero): %h", rs2_data);
        else
            $display("\033[31mFAIL\033[0m: Leitura rs2 errado: %h", rs2_data);

        // Testa que registrador 0 é sempre zero e não pode ser escrito
        rd_addr = 4'd0;
        rd_data = 32'hFFFFFFFF;
        rd_we = 1;
        #10;
        rd_we = 0;
        rs1_addr = 0;
        #10;
        if (rs1_data === 32'd0)
            $display("\033[32mPASS\033[0m: Registrador 0 é imutável e zero");
        else
            $display("\033[31mFAIL\033[0m: Registrador 0 alterado: %h", rs1_data);

        $display("Fim do teste");
        $finish;
    end

endmodule
