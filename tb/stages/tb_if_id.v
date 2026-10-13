`timescale 1ns / 1ps

module tb_if_id();

    // Parameters
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz

    // Message colors (ANSI)
    parameter GREEN = "\033[0;32m";
    parameter RED   = "\033[0;31m";
    parameter NC    = "\033[0m"; // No Color

    // Signals
    reg clk;
    reg rst;
    reg stall;
    reg flush;
    reg [31:0] pc_in;
    reg [31:0] instr_in;
    wire [31:0] pc_out;
    wire [31:0] instr_out;

    // Device under test
    if_id uut (
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .pc_in(pc_in),
        .instr_in(instr_in),
        .pc_out(pc_out),
        .instr_out(instr_out)
    );

    // Clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Check task
    task automatic verify;
        input string test_name;
        input [31:0] observed;
        input [31:0] expected;
        begin
            if (observed === expected) begin
                $display("%s[PASS]%s %s: got 0x%h", GREEN, NC, test_name, observed);
            end else begin
                $display("%s[FAIL]%s %s: expected 0x%h, got 0x%h", RED, NC, 
                         test_name, expected, observed);
            end
        end
    endtask

    // Stimulus
    initial begin
        // Initial values
        clk = 0;
        rst = 0;
        stall = 0;
        flush = 0;
        pc_in = 32'h00000000;
        instr_in = 32'h00000000;

        // Test 1: asynchronous reset
        $display("\n=== Test 1: asynchronous reset ===");
        rst = 1;
        #(CLK_PERIOD);
        verify("Reset: pc_out", pc_out, 32'h0);
        verify("Reset: instr_out", instr_out, 32'h0);
        rst = 0;
        #(CLK_PERIOD);

        // Test 2: normal operation (no stall/flush)
        $display("\n=== Test 2: normal operation ===");
        pc_in = 32'h00400000;
        instr_in = 32'h00100093; // addi x1, x0, 1
        #(CLK_PERIOD);
        verify("Normal: pc_out", pc_out, pc_in);
        verify("Normal: instr_out", instr_out, instr_in);

        // Test 3: stall (keeps the previous values)
        $display("\n=== Test 3: stall ===");
        pc_in = 32'h00400004;
        instr_in = 32'h00200113; // addi x2, x0, 2
        stall = 1;
        #(CLK_PERIOD);
        verify("Stall: pc_out held", pc_out, 32'h00400000); // Previous value
        verify("Stall: instr_out held", instr_out, 32'h00100093);
        stall = 0;

        // Test 4: flush (clears the outputs)
        $display("\n=== Test 4: flush ===");
        pc_in = 32'h00400008;
        instr_in = 32'h00300193; // addi x3, x0, 3
        flush = 1;
        #(CLK_PERIOD);
        verify("Flush: pc_out", pc_out, 32'h0);
        verify("Flush: instr_out", instr_out, 32'h0);
        flush = 0;

        // Test 5: stall -> normal operation
        $display("\n=== Test 5: stall -> normal ===");
        stall = 1;
        pc_in = 32'h0040000C;
        instr_in = 32'h00400213; // addi x4, x0, 4
        #(CLK_PERIOD);
        stall = 0;
        pc_in = 32'h00400010;
        instr_in = 32'h00500293; // addi x5, x0, 5
        #(CLK_PERIOD);
        verify("Stall -> normal: pc_out updated", pc_out, pc_in);
        verify("Stall -> normal: instr_out updated", instr_out, instr_in);

        // Done
        $display("\n=== All tests done ===");
        $finish;
    end

    // Monitoramento opcional
    initial begin
        $monitor("Tempo: %t | pc_in=0x%h | instr_in=0x%h | pc_out=0x%h | instr_out=0x%h | stall=%b | flush=%b",
                 $time, pc_in, instr_in, pc_out, instr_out, stall, flush);
    end

endmodule