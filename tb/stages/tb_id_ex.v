`timescale 1ns / 1ps

module tb_id_ex();

    reg clk, rst, stall, flush;
    reg [31:0] id_read_data_1, id_read_data_2, id_imm_data, id_pc_out;
    reg [4:0] id_rs1, id_rs2, id_rd;
    wire [31:0] ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out;
    wire [4:0] ex_rs1, ex_rs2, ex_rd;
    
    id_ex uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        
        // Entradas ID
        .id_read_data_1(id_read_data_1),
        .id_read_data_2(id_read_data_2),
        .id_imm_data(id_imm_data),
        .id_pc_out(id_pc_out),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),
        
        // Saídas EX
        .ex_read_data_1(ex_read_data_1),
        .ex_read_data_2(ex_read_data_2),
        .ex_imm_data(ex_imm_data),
        .ex_pc_out(ex_pc_out),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd)
    );
    
    // Geração de clock
    always #5 clk = ~clk;
    
    initial begin
        // Inicialização
        clk = 0;
        rst = 1;
        stall = 0;
        flush = 0;
        id_read_data_1 = 0;
        id_read_data_2 = 0;
        id_imm_data = 0;
        id_pc_out = 0;
        id_rs1 = 0;
        id_rs2 = 0;
        id_rd = 0;
        
        // Reset
        #10;
        rst = 0;
        
        // Teste 1: Dados normais
        $display("\nTeste 1: Dados normais");
        id_read_data_1 = 32'h12345678;
        id_read_data_2 = 32'h87654321;
        id_imm_data = 32'h00000FFF;
        id_pc_out = 32'h00400000;
        id_rs1 = 5'b00001;
        id_rs2 = 5'b00010;
        id_rd = 5'b00011;
        #10;
        
        // Verifica saídas
        $display("Entradas: rd1=%h, rd2=%h, imm=%h, pc=%h", 
                id_read_data_1, id_read_data_2, id_imm_data, id_pc_out);
        $display("Saídas:  rd1=%h, rd2=%h, imm=%h, pc=%h", 
                ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out);
        
        // Teste 2: Stall
        $display("\nTeste 2: Stall");
        id_read_data_1 = 32'hAAAAAAAA;
        id_read_data_2 = 32'hBBBBBBBB;
        stall = 1;
        #10;
        $display("Entradas mudaram, mas stall ativo. Saídas devem manter valores anteriores");
        $display("Saídas:  rd1=%h, rd2=%h, imm=%h, pc=%h", 
                ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out);
        
        // Teste 3: Flush
        $display("\nTeste 3: Flush");
        stall = 0;
        flush = 1;
        #10;
        $display("Flush ativo. Todas saídas devem ser zero");
        $display("Saídas:  rd1=%h, rd2=%h, imm=%h, pc=%h", 
                ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out);
        
        $finish;
    end

endmodule