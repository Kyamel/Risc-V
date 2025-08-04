`timescale 1ns / 1ps

module tb_id_ex();

    // Parameters
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz
    
    // ANSI color codes
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m"; // No Color

    // Signals
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    reg [31:0] id_read_data_1;
    reg [31:0] id_read_data_2;
    reg [31:0] id_imm_data;
    reg [31:0] id_pc_out;
    reg [4:0] id_rs1;
    reg [4:0] id_rs2;
    reg [4:0] id_rd;
    

    
    wire [31:0] ex_read_data_1;
    wire [31:0] ex_read_data_2;
    wire [31:0] ex_imm_data;
    wire [31:0] ex_pc_out;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;

    // Instantiate DUT
    id_ex uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .id_read_data_1(id_read_data_1),
        .id_read_data_2(id_read_data_2),
        .id_imm_data(id_imm_data),
        .id_pc_out(id_pc_out),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),
        .ex_read_data_1(ex_read_data_1),
        .ex_read_data_2(ex_read_data_2),
        .ex_imm_data(ex_imm_data),
        .ex_pc_out(ex_pc_out),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Verification task
    task automatic verify;
        input string test_name;
        input [31:0] observed;
        input [31:0] expected;
        begin
            if (observed === expected) begin
                $display("%s[PASS]%s %s: Obtido = 0x%h", GREEN, NC, test_name, observed);
            end else begin
                $display("%s[FAIL]%s %s: Esperado = 0x%h, Obtido = 0x%h", RED, NC, 
                         test_name, expected, observed);
            end
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        stall = 0;
        flush = 0;
        id_read_data_1 = 0;
        id_read_data_2 = 0;
        id_imm_data = 0;
        id_pc_out = 0;
        id_rs1 = 0;
        id_rs2 = 0;
        id_rd = 0;
        
        // Test 1: Reset
        $display("\n=== Teste 1: Reset ===");
        rst = 1;
        #(CLK_PERIOD);
        verify("Reset: ex_read_data_1", ex_read_data_1, 32'h0);
        verify("Reset: ex_read_data_2", ex_read_data_2, 32'h0);
        verify("Reset: ex_imm_data", ex_imm_data, 32'h0);
        verify("Reset: ex_pc_out", ex_pc_out, 32'h0);
        verify("Reset: ex_rs1", ex_rs1, 5'h0);
        verify("Reset: ex_rs2", ex_rs2, 5'h0);
        verify("Reset: ex_rd", ex_rd, 5'h0);
        rst = 0;
        #(CLK_PERIOD);

        // Test 2: Normal operation
        $display("\n=== Teste 2: Operação normal ===");
        id_read_data_1 = 32'h12345678;
        id_read_data_2 = 32'h9ABCDEF0;
        id_imm_data = 32'h00000FFF;
        id_pc_out = 32'h00400000;
        id_rs1 = 5'h01;
        id_rs2 = 5'h02;
        id_rd = 5'h03;
        #(CLK_PERIOD);
        verify("Normal: ex_read_data_1", ex_read_data_1, id_read_data_1);
        verify("Normal: ex_read_data_2", ex_read_data_2, id_read_data_2);
        verify("Normal: ex_imm_data", ex_imm_data, id_imm_data);
        verify("Normal: ex_pc_out", ex_pc_out, id_pc_out);
        verify("Normal: ex_rs1", ex_rs1, id_rs1);
        verify("Normal: ex_rs2", ex_rs2, id_rs2);
        verify("Normal: ex_rd", ex_rd, id_rd);

        // Test 3: Stall
        $display("\n=== Teste 3: Stall ===");
        stall = 1;
        id_read_data_1 = 32'h11111111;
        id_read_data_2 = 32'h22222222;
        id_imm_data = 32'h00001111;
        id_pc_out = 32'h00400004;
        id_rs1 = 5'h04;
        id_rs2 = 5'h05;
        id_rd = 5'h06;
        #(CLK_PERIOD);
        verify("Stall: ex_read_data_1 mantido", ex_read_data_1, 32'h12345678);
        verify("Stall: ex_read_data_2 mantido", ex_read_data_2, 32'h9ABCDEF0);
        verify("Stall: ex_imm_data mantido", ex_imm_data, 32'h00000FFF);
        verify("Stall: ex_pc_out mantido", ex_pc_out, 32'h00400000);
        verify("Stall: ex_rs1 mantido", ex_rs1, 5'h01);
        verify("Stall: ex_rs2 mantido", ex_rs2, 5'h02);
        verify("Stall: ex_rd mantido", ex_rd, 5'h03);
        stall = 0;

        // Test 4: Flush
        $display("\n=== Teste 4: Flush ===");
        flush = 1;
        #(CLK_PERIOD);
        verify("Flush: ex_read_data_1", ex_read_data_1, 32'h0);
        verify("Flush: ex_read_data_2", ex_read_data_2, 32'h0);
        verify("Flush: ex_imm_data", ex_imm_data, 32'h0);
        verify("Flush: ex_pc_out", ex_pc_out, 32'h0);
        verify("Flush: ex_rs1", ex_rs1, 5'h0);
        verify("Flush: ex_rs2", ex_rs2, 5'h0);
        verify("Flush: ex_rd", ex_rd, 5'h0);
        flush = 0;

        // Test 5: Transition from stall to normal
        $display("\n=== Teste 5: Stall -> Normal ===");
        stall = 1;
        id_read_data_1 = 32'hAAAAAAAA;
        id_read_data_2 = 32'hBBBBBBBB;
        id_imm_data = 32'h0000AAAA;
        id_pc_out = 32'h00400008;
        id_rs1 = 5'h07;
        id_rs2 = 5'h08;
        id_rd = 5'h09;
        #(CLK_PERIOD);
        stall = 0;
        id_read_data_1 = 32'hCCCCCCCC;
        id_read_data_2 = 32'hDDDDDDDD;
        id_imm_data = 32'h0000BBBB;
        id_pc_out = 32'h0040000C;
        id_rs1 = 5'h0A;
        id_rs2 = 5'h0B;
        id_rd = 5'h0C;
        #(CLK_PERIOD);
        verify("Stall->Normal: ex_read_data_1", ex_read_data_1, 32'hCCCCCCCC);
        verify("Stall->Normal: ex_read_data_2", ex_read_data_2, 32'hDDDDDDDD);
        verify("Stall->Normal: ex_imm_data", ex_imm_data, 32'h0000BBBB);
        verify("Stall->Normal: ex_pc_out", ex_pc_out, 32'h0040000C);
        verify("Stall->Normal: ex_rs1", ex_rs1, 5'h0A);
        verify("Stall->Normal: ex_rs2", ex_rs2, 5'h0B);
        verify("Stall->Normal: ex_rd", ex_rd, 5'h0C);

        // Final report
        $display("\n=== Todos os testes concluídos ===");
        $finish;
    end

    // Optional monitoring
    initial begin
        $monitor("Tempo: %t | ex_read_data_1=0x%h | ex_read_data_2=0x%h | ex_imm_data=0x%h | ex_pc_out=0x%h",
                 $time, ex_read_data_1, ex_read_data_2, ex_imm_data, ex_pc_out);
    end

endmodule