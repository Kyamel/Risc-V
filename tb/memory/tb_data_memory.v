`timescale 1ns / 1ps

module tb_data_memory();
    // Parameters
    parameter WIDTH = 32;
    parameter DEPTH = 1024;
    parameter TEST_FILE = "compiler/data.hex";
    
    // ANSI colors
    string GREEN = "\033[1;32m";
    string RED   = "\033[1;31m";
    string RESET = "\033[0m";

    // Module signals
    reg clk;
    reg [WIDTH-1:0] mem_addr;
    reg [WIDTH-1:0] write_data;
    reg mem_write;
    reg mem_read;
    wire [WIDTH-1:0] read_data;
    
    // Instantiate the module
    data_memory #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .INIT_FILE(TEST_FILE)
    ) uut (
        .clk(clk),
        .mem_addr(mem_addr),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        mem_addr = 0;
        write_data = 0;
        mem_write = 0;
        mem_read = 0;
        
        // Wait for memory initialization
        #10;
        
        // Test 1: Read from initialized memory
        mem_addr = 0;
        mem_read = 1;
        #10;
        if (read_data === 32'h00000000)
            $display("%s[PASS]%s Test 1: Read address 0 - Expected: 0x00000000, Got: 0x%h", GREEN, RESET, read_data);
        else
            $display("%s[FAIL]%s Test 1: Read address 0 - Expected: 0x00000000, Got: 0x%h", RED, RESET, read_data);
        
        // Test 2: Read from address 1
        mem_addr = 1;
        #10;
        if (read_data === 32'h11111111)
            $display("%s[PASS]%s Test 2: Read address 1 - Expected: 0x11111111, Got: 0x%h", GREEN, RESET, read_data);
        else
            $display("%s[FAIL]%s Test 2: Read address 1 - Expected: 0x11111111, Got: 0x%h", RED, RESET, read_data);
        
        // Test 3: Write operation
        mem_read = 0;
        mem_addr = 4;
        write_data = 32'hAAAAAAAA;
        mem_write = 1;
        #10;
        mem_write = 0;
        mem_read = 1;
        #10;
        if (read_data === 32'hAAAAAAAA)
            $display("%s[PASS]%s Test 3: Write and read address 4 - Expected: 0xAAAAAAAA, Got: 0x%h", GREEN, RESET, read_data);
        else
            $display("%s[FAIL]%s Test 3: Write and read address 4 - Expected: 0xAAAAAAAA, Got: 0x%h", RED, RESET, read_data);
        
        // Test 4: Address out of range (should wrap around)
        mem_addr = 1024;  // This should wrap to address 0
        #10;
        if (read_data === 32'h00000000)
            $display("%s[PASS]%s Test 4: Address wrapping - Expected: 0x00000000, Got: 0x%h", GREEN, RESET, read_data);
        else
            $display("%s[FAIL]%s Test 4: Address wrapping - Expected: 0x00000000, Got: 0x%h", RED, RESET, read_data);
        
        // Test 5: Simultaneous read and write (write should have priority)
        mem_addr = 5;
        write_data = 32'hBBBBBBBB;
        mem_write = 1;
        mem_read = 1;
        #10;
        if (read_data === 32'hBBBBBBBB)
            $display("%s[PASS]%s Test 5: Simultaneous read/write - Expected: 0xBBBBBBBB, Got: 0x%h", GREEN, RESET, read_data);
        else
            $display("%s[FAIL]%s Test 5: Simultaneous read/write - Expected: 0xBBBBBBBB, Got: 0x%h", RED, RESET, read_data);

        $finish;
    end
endmodule
