`timescale 1ns / 1ps

module tb_ex_mem();

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
    reg [31:0] ex_adder_out;
    reg [31:0] ex_result;
    reg [4:0] ex_rd;
    reg [31:0] ex_read_data_2_mux;
    
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire [4:0] mem_rd;
    wire [31:0] mem_adder_out;

    // Instantiate DUT
    ex_mem uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .ex_adder_out(ex_adder_out),
        .ex_result(ex_result),
        .ex_rd(ex_rd),
        .ex_read_data_2_mux(ex_read_data_2_mux),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_rd(mem_rd),
        .mem_adder_out(mem_adder_out)
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
        ex_adder_out = 0;
        ex_result = 0;
        ex_rd = 0;
        ex_read_data_2_mux = 0;
        
        // Test 1: Reset
        $display("\n=== Teste 1: Reset ===");
        rst = 1;
        #(CLK_PERIOD);
        verify("Reset: mem_addr", mem_addr, 32'h0);
        verify("Reset: mem_write_data", mem_write_data, 32'h0);
        verify("Reset: mem_rd", mem_rd, 5'h0);
        verify("Reset: mem_adder_out", mem_adder_out, 32'h0);
        rst = 0;
        #(CLK_PERIOD);

        // Test 2: Normal operation
        $display("\n=== Teste 2: Operação normal ===");
        ex_adder_out = 32'h00400010;
        ex_result = 32'h10010000;
        ex_rd = 5'h07;
        ex_read_data_2_mux = 32'hA5A5A5A5;
        #(CLK_PERIOD);
        verify("Normal: mem_addr", mem_addr, ex_result);
        verify("Normal: mem_write_data", mem_write_data, ex_read_data_2_mux);
        verify("Normal: mem_rd", mem_rd, ex_rd);
        verify("Normal: mem_adder_out", mem_adder_out, ex_adder_out);

        // Test 3: Stall
        $display("\n=== Teste 3: Stall ===");
        stall = 1;
        ex_adder_out = 32'h00400014;
        ex_result = 32'h10010004;
        ex_rd = 5'h08;
        ex_read_data_2_mux = 32'hB6B6B6B6;
        #(CLK_PERIOD);
        verify("Stall: mem_addr mantido", mem_addr, 32'h10010000);
        verify("Stall: mem_write_data mantido", mem_write_data, 32'hA5A5A5A5);
        verify("Stall: mem_rd mantido", mem_rd, 5'h07);
        verify("Stall: mem_adder_out mantido", mem_adder_out, 32'h00400010);
        stall = 0;

        // Test 4: Flush
        $display("\n=== Teste 4: Flush ===");
        flush = 1;
        #(CLK_PERIOD);
        verify("Flush: mem_addr", mem_addr, 32'h0);
        verify("Flush: mem_write_data", mem_write_data, 32'h0);
        verify("Flush: mem_rd", mem_rd, 5'h0);
        verify("Flush: mem_adder_out", mem_adder_out, 32'h0);
        flush = 0;

        // Test 5: Transition from stall to normal
        $display("\n=== Teste 5: Stall -> Normal ===");
        stall = 1;
        ex_adder_out = 32'h00400018;
        ex_result = 32'h10010008;
        ex_rd = 5'h09;
        ex_read_data_2_mux = 32'hC7C7C7C7;
        #(CLK_PERIOD);
        stall = 0;
        ex_adder_out = 32'h0040001C;
        ex_result = 32'h1001000C;
        ex_rd = 5'h0A;
        ex_read_data_2_mux = 32'hD8D8D8D8;
        #(CLK_PERIOD);
        verify("Stall->Normal: mem_addr", mem_addr, ex_result);
        verify("Stall->Normal: mem_write_data", mem_write_data, ex_read_data_2_mux);
        verify("Stall->Normal: mem_rd", mem_rd, ex_rd);
        verify("Stall->Normal: mem_adder_out", mem_adder_out, ex_adder_out);

        // Final report
        $display("\n=== Todos os testes concluídos ===");
        $finish;
    end

    // Optional monitoring
    initial begin
        $monitor("Tempo: %t | mem_addr=0x%h | mem_write_data=0x%h | mem_rd=%0d | mem_adder_out=0x%h",
                 $time, mem_addr, mem_write_data, mem_rd, mem_adder_out);
    end

endmodule