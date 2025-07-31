`timescale 1ns / 1ps

module tb_processor_load_program();

    // System signals
    reg clk;
    reg reset;

    // Instruction memory interface
    reg [31:0] imem_addr;
    wire [31:0] imem_data_out;
    reg imem_read_en;
    
    // Debug interface
    reg debug_en;
    reg [31:0] debug_addr;
    reg [31:0] debug_data_in;
    reg debug_write_en;
    wire [31:0] debug_data_out;

    // Register file interface
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [4:0] rd_addr;
    wire [31:0] rd_data;
    wire reg_write;
    
    // Debug registers output
    wire [31:0] debug_registers [0:31];

    // Instantiate instruction memory
    instruction_memory imem (
        .clk(clk),
        .reset(reset),
        .addr(imem_addr),
        .data_out(imem_data_out),
        .read_en(imem_read_en),
        .debug_en(debug_en),
        .debug_addr(debug_addr),
        .debug_data_in(debug_data_in),
        .debug_write_en(debug_write_en),
        .debug_data_out(debug_data_out)
    );

    // Instantiate register file
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .reg_write(reg_write),
        .debug_registers(debug_registers)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        reset = 1;
        imem_addr = 0;
        imem_read_en = 0;
        debug_en = 0;
        debug_addr = 0;
        debug_data_in = 0;
        debug_write_en = 0;
        
        // Apply reset
        #20;
        reset = 0;
        
        // Verify program was loaded
        $display("\n[TEST] Verifying program.hex was loaded into instruction memory");
        
        // Read first 16 instructions from memory
        for (integer i = 0; i < 16; i = i + 1) begin
            debug_en = 1;
            debug_addr = i * 4;
            #10;
            $display("  Addr %h: Instruction = %h", debug_addr, debug_data_out);
            debug_en = 0;
            #10;
        end
        
        // Display all register values
        $display("\n[TEST] Register contents after initialization:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("  x%0d: %h", i, debug_registers[i]);
        end
        
        // Simulation complete
        #100;
        $display("\n[TEST] Simulation complete");
        $finish;
    end

    // Monitor changes
    initial begin
        $display("Time\tPC\t\tInstruction");
        $monitor("%0t\t%h\t%h", $time, imem_addr, imem_data_out);
    end

endmodule