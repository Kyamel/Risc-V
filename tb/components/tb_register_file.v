`timescale 1ns / 1ps

module tb_register_file();

    // Parameters
    parameter WIDTH = 32;
    parameter DEPTH = 32;
    parameter CLK_PERIOD = 10; // 10 ns = 100 MHz

    parameter GREEN = "\033[0;32m";
    parameter RED = "\033[0;31m";
    parameter NC = "\033[0m"; // No Color

    // Signals
    reg clk;
    reg rst;
    reg [4:0] rs1, rs2, rd;
    reg [WIDTH-1:0] wd;
    reg reg_write;
    wire [WIDTH-1:0] read_data_1, read_data_2;
    wire [WIDTH-1:0] debug_data_out;

    // Device under test
    register_file #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rw(reg_write),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .debug_data_out(debug_data_out)
    );

    // Clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Check task ([PASS]/[FAIL])
    task automatic verify;
        input string test_name;
        input [WIDTH-1:0] observed;
        input [WIDTH-1:0] expected;
        begin
            if (observed === expected) begin
                $display("%s[PASS]%s %s: got 0x%h", GREEN, NC,
                         test_name, observed);
            end else begin
                $display("%s[FAIL]%s %s: expected 0x%h, got 0x%h", RED, NC,
                         test_name, expected, observed);
            end
        end
    endtask

    // Stimulus
    initial begin
        clk = 0;
        rst = 1; // Ativa reset inicial
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        wd = 0;
        reg_write = 0;

        // Release reset after 2 clock cycles
        #(2*CLK_PERIOD);
        rst = 0;

        // Test 1: reset (every register must be 0)
        $display("\n=== Test 1: reset ===");
        for (int i = 1; i < DEPTH; i++) begin
            rs1 = i;
            #1; // Let the asynchronous read settle
            verify($sformatf("Reset of register x%0d", i), read_data_1, 0);
        end

        // Test 2: write and read x5
        $display("\n=== Test 2: write and read ===");
        reg_write = 1;
        rd = 5'd5;
        wd = 32'hDEADBEEF;
        #CLK_PERIOD; // Wait for the synchronous write

        rs1 = 5'd5;
        #1;
        verify("Write x5", read_data_1, wd);

        // Test 3: x0 is always zero (hardwired)
        $display("\n=== Test 3: x0 ===");
        rd = 5'd0;    // Try to write x0
        wd = 32'h12345678;
        #CLK_PERIOD;
        rs1 = 5'd0;
        #1;
        verify("Read x0 (hardwired)", read_data_1, 0);

        // Done
        $display("\n=== All tests done ===");
        $finish;
    end

    // Optional monitor (for debugging)
    initial begin
        $monitor("Tempo: %t | rs1=%0d (0x%h) | rs2=%0d (0x%h) | rd=%0d (wd=0x%h) | reg_write=%b",
                 $time, rs1, read_data_1, rs2, read_data_2, rd, wd, reg_write);
    end

endmodule